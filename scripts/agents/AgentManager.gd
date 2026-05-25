# scripts/agents/AgentManager.gd
extends Node

## Core manager for the espionage and agent system (MVP).

signal agent_recruited(agent_id: String, country_tag: String)
signal agent_assigned_to_mission(agent_id: String, mission_id: String)
signal mission_completed(agent_id: String, mission_id: String, outcome: String)
signal agent_captured(agent_id: String, country_tag: String)
signal agent_killed(agent_id: String, country_tag: String)

const MISSIONS_PATH := "res://data/agents/mission_definitions.json"
const MAX_MISSION_HISTORY_PER_AGENT := 12
const MISSION_HISTORY_UI_LIMIT := 6
const RECENT_OPERATIONS_UI_LIMIT := 10

## MVP target list until diplomacy exposes valid operation theaters.
const DEFAULT_TARGET_COUNTRY_TAGS: Array[String] = [
	"USA", "GER", "ENG", "FRA", "SOV", "JAP", "ITA", "CHI",
]

var agents: Dictionary = {}                    # country_tag -> Array[Agent]
var mission_definitions: Dictionary = {}

var _current_year: int = 1936
var _agent_screen_cache: Dictionary = {}       # country_tag -> AgentScreenData


func _ready() -> void:
	_load_mission_definitions()
	print("AgentManager: Loaded %d mission definitions" % mission_definitions.size())

	if typeof(LeaderManager) != TYPE_NIL:
		LeaderManager.game_year_advanced.connect(_on_game_year_advanced)


func _on_game_year_advanced(year: int) -> void:
	set_current_year(year)
	_release_expired_compromised_agents()
	# Advance missions by 12 months per year for MVP
	advance_missions(12)


func _load_mission_definitions() -> void:
	if not FileAccess.file_exists(MISSIONS_PATH):
		push_error("AgentManager: Could not find mission definitions at %s" % MISSIONS_PATH)
		return

	var file := FileAccess.open(MISSIONS_PATH, FileAccess.READ)
	var json_text := file.get_as_text()
	file.close()

	var parsed := JSON.parse_string(json_text)
	if typeof(parsed) == TYPE_DICTIONARY:
		mission_definitions = parsed
	else:
		push_error("AgentManager: Failed to parse mission_definitions.json")


# === Core API ===

func get_agents_for_country(country_tag: String) -> Array[Agent]:
	var tag := country_tag.strip_edges().to_upper()
	return agents.get(tag, []) as Array[Agent]


func get_agent(agent_id: String) -> Agent:
	for country_agents in agents.values():
		for agent in country_agents as Array[Agent]:
			if agent.agent_id == agent_id:
				return agent
	return null


func recruit_agent(country_tag: String) -> Agent:
	var tag := country_tag.strip_edges().to_upper()
	var new_agent := AgentGenerator.generate_agent(tag, _current_year)

	if not agents.has(tag):
		agents[tag] = []

	(agents[tag] as Array).append(new_agent)
	invalidate_agent_cache(tag)
	agent_recruited.emit(new_agent.agent_id, tag)
	print("AgentManager: Recruited %s for %s" % [new_agent.name, tag])
	return new_agent


func assign_agent_to_mission(
	agent_id: String,
	mission_id: String,
	target_tag: String = "",
) -> bool:
	var agent := get_agent(agent_id)
	if agent == null or not agent.is_available():
		return false

	if not mission_definitions.has(mission_id):
		push_warning("AgentManager: Unknown mission '%s'" % mission_id)
		return false

	var mission: Dictionary = mission_definitions[mission_id]
	var skill_req: String = str(mission.get("skill_requirement", "intelligence"))
	var min_skill: int = int(mission.get("min_skill_level", 1))

	if agent.get_skill(skill_req) < min_skill:
		print("Agent %s does not meet the skill requirement for %s" % [agent.name, mission_id])
		return false

	var target := target_tag.strip_edges().to_upper()
	if target.is_empty() or target == agent.country_tag:
		push_warning("AgentManager: Invalid mission target '%s'" % target_tag)
		return false

	agent.assigned_target_tag = target
	agent.current_mission_id = mission_id
	agent.mission_progress = 0.0
	agent.status = "on_mission"

	invalidate_agent_cache(agent.country_tag)
	agent_assigned_to_mission.emit(agent_id, mission_id)
	print(
		"Agent %s assigned to %s against %s"
		% [agent.name, mission.get("name", mission_id), target]
	)
	return true


func advance_missions(months: int = 1) -> void:
	for country_tag in agents.keys():
		var country_agents: Array = agents[country_tag]
		for agent in country_agents as Array[Agent]:
			if not agent.is_on_mission():
				continue

			agent.mission_progress += float(months) / 12.0   # crude for now; missions use months

			if agent.mission_progress >= 1.0:
				_resolve_mission(agent)


func _resolve_mission(agent: Agent) -> void:
	var mission_id := agent.current_mission_id
	if not mission_definitions.has(mission_id):
		_reset_agent_after_mission(agent)
		return

	var mission: Dictionary = mission_definitions[mission_id]
	var success_chance := agent.get_success_chance_for_mission(mission)
	var roll := randf()

	var outcome := "failure"
	if roll < success_chance * 0.55:
		outcome = "success"
	elif roll < success_chance:
		outcome = "partial"

	# === Detection Risk ===
	var detection_chance := float(mission.get("detection_risk", 0.3))
	if outcome == "failure":
		detection_chance *= 1.6   # Failures are much riskier
	if outcome == "success":
		detection_chance *= 0.7

	var detected := randf() < detection_chance

	_apply_mission_outcome(agent, mission, outcome, detected)

	agent.total_missions_completed += 1
	if outcome in ["success", "partial"]:
		agent.successful_missions += 1
		agent.add_experience(90 if outcome == "success" else 45)

	mission_completed.emit(agent.agent_id, mission_id, outcome)

	# Handle post-mission agent state (risk & consequences)
	_handle_post_mission_risk(agent, detected, outcome)

	_append_mission_history(agent, mission_id, outcome, detected)

	_reset_agent_after_mission(agent)
	invalidate_agent_cache(agent.country_tag)


func _apply_mission_outcome(agent: Agent, mission: Dictionary, outcome: String, detected: bool = false) -> void:
	var outcomes: Dictionary = mission.get("outcomes", {})
	var result: Dictionary = outcomes.get(outcome, {})

	var mission_name: String = str(mission.get("name", mission.get("id")))
	var country := agent.country_tag

	# === Prestige (applied via NationalModifierManager when available) ===
	var prestige := int(result.get("prestige_gain", 0))
	if prestige != 0:
		if typeof(NationalModifierManager) != TYPE_NIL:
			NationalModifierManager.apply_influence_effect(
				country,
				prestige_change = float(prestige),
				duration_months = 24,  # Prestige effects linger longer
				source = "agent_mission"
			)
		else:
			# Fallback to legacy national_prestige tracking
			var current := float(national_prestige.get(country, 50.0))
			national_prestige[country] = current + prestige
			print("  -> %s gained +%d Prestige from %s (legacy tracking)" % [country, prestige, mission_name])

	# === Real Effect Application ===
	var effect := str(result.get("effect", ""))
	var magnitude := float(result.get("magnitude", 0.0))

	match effect:
		"production_delay", "supply_disruption":
			_apply_production_delay(country, magnitude)
		"stability_damage":
			_apply_stability_damage(country, magnitude)
		"research_progress":
			_apply_research_theft(country, magnitude)
		"long_term_tech_intel":
			_establish_long_term_intel(country, "technology")
		"temporary_intel_bonus":
			_apply_intel_bonus(country, magnitude)
		"enemy_agent_disruption":
			_apply_enemy_agent_disruption(country, magnitude)
		"enemy_intel_degradation":
			_degrade_enemy_intel(country, magnitude)
		"tech_theft_protection":
			_apply_tech_protection(country, magnitude)

	# Intelligence missions populate intel cache
	var intel_type := str(result.get("intel_type", ""))
	if intel_type != "":
		_record_intelligence(country, intel_type, outcome)

	print("Mission '%s' for %s resolved as %s (detected: %s)" % [mission_name, agent.name, outcome, detected])


func set_current_year(year: int) -> void:
	_current_year = year


func get_current_year() -> int:
	return _current_year


func get_available_agents(country_tag: String) -> Array[Agent]:
	var result: Array[Agent] = []
	for agent in get_agents_for_country(country_tag):
		if agent.is_available():
			result.append(agent)
	return result


func get_mission_definition(mission_id: String) -> Dictionary:
	return mission_definitions.get(mission_id, {}).duplicate(true)


func get_target_countries_for(country_tag: String) -> Array[String]:
	var owner := country_tag.strip_edges().to_upper()
	var targets: Array[String] = []
	for tag in DEFAULT_TARGET_COUNTRY_TAGS:
		if tag != owner:
			targets.append(tag)
	return targets


func get_mission_categories() -> Array[String]:
	var categories: Dictionary = {}
	for mission in mission_definitions.values():
		if typeof(mission) != TYPE_DICTIONARY:
			continue
		var cat := str((mission as Dictionary).get("category", "")).strip_edges().to_lower()
		if not cat.is_empty():
			categories[cat] = true
	var result: Array[String] = []
	for cat in categories.keys():
		result.append(str(cat))
	result.sort()
	return result


func get_eligible_missions_for_agent(
	agent_id: String,
	category_filter: String = "",
) -> Array[Dictionary]:
	var agent := get_agent(agent_id)
	if agent == null:
		return []

	var category_needle := category_filter.strip_edges().to_lower()
	var rows: Array[Dictionary] = []
	for mission_id in mission_definitions.keys():
		var mission: Dictionary = mission_definitions[mission_id] as Dictionary
		var mission_category := str(mission.get("category", "")).to_lower()
		if not category_needle.is_empty() and mission_category != category_needle:
			continue
		var skill_req := str(mission.get("skill_requirement", "intelligence"))
		var min_skill := int(mission.get("min_skill_level", 1))
		var agent_skill := agent.get_skill(skill_req)
		if agent_skill < min_skill:
			continue
		rows.append(_mission_row_for_agent(agent, str(mission_id), mission))

	rows.sort_custom(
		func(a: Dictionary, b: Dictionary) -> bool:
			var cat_cmp := str(a.get("category", "")).compare_to(str(b.get("category", "")))
			if cat_cmp != 0:
				return cat_cmp < 0
			return float(b.get("success_chance", 0.0)) < float(a.get("success_chance", 0.0))
	)
	return rows


func get_agent_screen_data(country_tag: String, use_cache: bool = true) -> AgentScreenData:
	var tag := country_tag.strip_edges().to_upper()
	if use_cache and _agent_screen_cache.has(tag):
		return _agent_screen_cache[tag] as AgentScreenData
	var data := _build_agent_screen_data(tag)
	_agent_screen_cache[tag] = data
	return data


func invalidate_agent_cache(country_tag: String = "") -> void:
	if country_tag.is_empty():
		_agent_screen_cache.clear()
	else:
		_agent_screen_cache.erase(country_tag.strip_edges().to_upper())


func get_agent_summary(agent_id: String) -> Dictionary:
	var agent := get_agent(agent_id)
	if agent == null:
		return {}
	return _agent_to_summary(agent)


func _build_agent_screen_data(country_tag: String) -> AgentScreenData:
	var data := AgentScreenData.new()
	data.country_tag = country_tag

	var summaries: Array[Dictionary] = []
	for agent in get_agents_for_country(country_tag):
		summaries.append(_agent_to_summary(agent))

	data.agents = summaries
	data.total_agents = summaries.size()
	for summary in summaries:
		var group := str(summary.get("status_group", ""))
		match group:
			"available":
				data.available_agents += 1
			"on_mission":
				data.on_mission_agents += 1
			"compromised":
				data.compromised_agents += 1
			"inactive":
				data.inactive_agents += 1

	data.target_countries = get_target_countries_for(country_tag)
	data.mission_categories = get_mission_categories()
	data.intel_reports = get_intel_reports(country_tag)
	data.recent_operations = get_recent_operations(country_tag, RECENT_OPERATIONS_UI_LIMIT)
	return data


func _agent_to_summary(agent: Agent) -> Dictionary:
	var mission_name := ""
	var mission_category := ""
	if not agent.current_mission_id.is_empty():
		var mission := get_mission_definition(agent.current_mission_id)
		mission_name = str(mission.get("name", agent.current_mission_id))
		mission_category = str(mission.get("category", ""))

	var history_slice: Array[Dictionary] = []
	var limit := mini(agent.mission_history.size(), MISSION_HISTORY_UI_LIMIT)
	for i in range(limit):
		var entry: Variant = agent.mission_history[i]
		if typeof(entry) == TYPE_DICTIONARY:
			history_slice.append((entry as Dictionary).duplicate())

	var summary := {
		"agent_id": agent.agent_id,
		"name": agent.name,
		"status": agent.status,
		"status_group": agent.get_status_group(),
		"status_detail": _format_agent_status_detail(agent),
		"level": agent.level,
		"experience": agent.experience,
		"intelligence": agent.intelligence,
		"sabotage": agent.sabotage,
		"influence": agent.influence,
		"technology": agent.technology,
		"counter_intelligence": agent.counter_intelligence,
		"skills_text": (
			"INT %d  SAB %d  INF %d  TECH %d"
			% [agent.intelligence, agent.sabotage, agent.influence, agent.technology]
		),
		"assigned_target_tag": agent.assigned_target_tag,
		"current_mission_id": agent.current_mission_id,
		"mission_name": mission_name,
		"mission_category": mission_category,
		"mission_progress": agent.mission_progress,
		"missions_completed": agent.total_missions_completed,
		"successful_missions": agent.successful_missions,
		"compromised_until_year": agent.compromised_until_year,
		"mission_history": history_slice,
		"can_assign_mission": agent.is_available(),
		"is_compromised": agent.status == "compromised",
		"is_inactive": agent.is_inactive(),
		"status_badge": _status_badge_for(agent),
		"recovery_years_remaining": _recovery_years_remaining(agent),
		"inactive_kind": agent.status if agent.is_inactive() else "",
	}

	if agent.is_on_mission() and not agent.current_mission_id.is_empty():
		var active_mission := get_mission_definition(agent.current_mission_id)
		summary["active_mission_impact"] = AgentMissionImpact.describe_mission_outcome(
			active_mission,
			"success",
		)

	return summary


func _mission_row_for_agent(agent: Agent, mission_id: String, mission: Dictionary) -> Dictionary:
	var skill_req := str(mission.get("skill_requirement", "intelligence"))
	var impact_preview := AgentMissionImpact.get_impact_preview(mission)
	return {
		"mission_id": mission_id,
		"name": str(mission.get("name", mission_id)),
		"category": str(mission.get("category", "")),
		"description": str(mission.get("description", "")),
		"duration_months": int(mission.get("duration_months", 3)),
		"detection_risk": float(mission.get("detection_risk", 0.3)),
		"skill_requirement": skill_req,
		"min_skill_level": int(mission.get("min_skill_level", 1)),
		"agent_skill": agent.get_skill(skill_req),
		"success_chance": agent.get_success_chance_for_mission(mission),
		"impact_preview": impact_preview,
		"impact_success": impact_preview.get("success", ""),
		"impact_partial": impact_preview.get("partial", ""),
		"impact_failure": impact_preview.get("failure", ""),
	}


func clear_all_agents() -> void:
	agents.clear()
	invalidate_agent_cache()
	print("AgentManager: All agents cleared.")


func _reset_agent_after_mission(agent: Agent) -> void:
	agent.assigned_target_tag = ""
	agent.current_mission_id = ""
	agent.mission_progress = 0.0
	if agent.status not in ["compromised", "captured", "killed"]:
		agent.status = "available"
	invalidate_agent_cache(agent.country_tag)


func _handle_post_mission_risk(agent: Agent, detected: bool, outcome: String) -> void:
	if not detected:
		return

	var country := agent.country_tag
	var roll := randf()

	if outcome == "success":
		# Even on success, high detection can compromise the agent
		if roll < 0.35:
			_set_agent_compromised(agent, 2)  # compromised for ~2 years
			print("  -> %s was compromised after a successful but detected mission." % agent.name)
		return

	# Failure or partial + detection
	if roll < 0.25:
		agent.status = "killed"
		print("  -> %s was killed during the mission." % agent.name)
		agent_killed.emit(agent.agent_id, country)
	elif roll < 0.55:
		agent.status = "captured"
		print("  -> %s was captured." % agent.name)
		agent_captured.emit(agent.agent_id, country)
	else:
		_set_agent_compromised(agent, 3)
		print("  -> %s returned compromised." % agent.name)


func _set_agent_compromised(agent: Agent, years: int) -> void:
	agent.status = "compromised"
	agent.compromised_until_year = _current_year + years
	agent.assigned_target_tag = ""
	agent.current_mission_id = ""
	agent.mission_progress = 0.0
	invalidate_agent_cache(agent.country_tag)


func _release_expired_compromised_agents() -> void:
	for country_agents in agents.values():
		for agent in country_agents as Array[Agent]:
			if agent.status != "compromised":
				continue
			if _current_year < agent.compromised_until_year:
				continue
			agent.status = "available"
			agent.compromised_until_year = 0
			invalidate_agent_cache(agent.country_tag)
			print("AgentManager: %s recovered from compromise." % agent.name)


func get_recent_operations(country_tag: String, limit: int = RECENT_OPERATIONS_UI_LIMIT) -> Array[Dictionary]:
	var tag := country_tag.strip_edges().to_upper()
	var ops: Array[Dictionary] = []

	for agent in get_agents_for_country(tag):
		if agent.is_on_mission():
			var mission := get_mission_definition(agent.current_mission_id)
			var progress_pct := int(agent.mission_progress * 100.0)
			ops.append({
				"sort_key": float(_current_year) + 0.99,
				"year": _current_year,
				"agent_name": agent.name,
				"mission_name": str(mission.get("name", agent.current_mission_id)),
				"target_tag": agent.assigned_target_tag,
				"outcome": "in_progress",
				"detected": false,
				"progress": agent.mission_progress,
				"status_line": "%d%% underway" % progress_pct,
				"impact_text": "If successful: %s"
				% AgentMissionImpact.describe_mission_outcome(mission, "success"),
				"agent_fate": "",
			})

		for entry_variant in agent.mission_history:
			if typeof(entry_variant) != TYPE_DICTIONARY:
				continue
			var entry := (entry_variant as Dictionary).duplicate()
			if not entry.has("agent_name"):
				entry["agent_name"] = agent.name
			entry["sort_key"] = float(entry.get("year", _current_year))
			ops.append(entry)

	ops.sort_custom(
		func(a: Dictionary, b: Dictionary) -> bool:
			return float(a.get("sort_key", 0.0)) > float(b.get("sort_key", 0.0))
	)

	var result: Array[Dictionary] = []
	for i in range(mini(ops.size(), limit)):
		result.append(ops[i])
	return result


func describe_mission_outcome(mission_id: String, outcome_key: String) -> String:
	return AgentMissionImpact.describe_mission_outcome(get_mission_definition(mission_id), outcome_key)


func _append_mission_history(
	agent: Agent,
	mission_id: String,
	outcome: String,
	detected: bool,
) -> void:
	var mission := get_mission_definition(mission_id)
	var target_tag := agent.assigned_target_tag
	var fate := _agent_fate_after_mission(agent)

	var entry := {
		"year": _current_year,
		"mission_id": mission_id,
		"mission_name": str(mission.get("name", mission_id)),
		"category": str(mission.get("category", "")),
		"target_tag": target_tag,
		"outcome": outcome,
		"detected": detected,
		"agent_name": agent.name,
		"impact_text": AgentMissionImpact.describe_mission_outcome(mission, outcome),
		"agent_fate": fate,
		"status_line": _format_history_status_line(outcome, detected, fate),
		"sort_key": float(_current_year),
	}
	agent.mission_history.insert(0, entry)
	while agent.mission_history.size() > MAX_MISSION_HISTORY_PER_AGENT:
		agent.mission_history.pop_back()
	invalidate_agent_cache(agent.country_tag)


func _agent_fate_after_mission(agent: Agent) -> String:
	match agent.status:
		"killed", "captured", "compromised":
			return agent.status
		_:
			return ""


func _format_history_status_line(outcome: String, detected: bool, fate: String) -> String:
	var parts: PackedStringArray = [outcome.capitalize()]
	if detected:
		parts.append("detected")
	match fate:
		"killed":
			parts.append("agent KIA")
		"captured":
			parts.append("agent captured")
		"compromised":
			parts.append("agent compromised")
	return " · ".join(parts)


func _status_badge_for(agent: Agent) -> String:
	match agent.get_status_group():
		"on_mission":
			return "DEPLOYED"
		"compromised":
			return "COMPROMISED"
		"inactive":
			if agent.status == "killed":
				return "KIA"
			if agent.status == "captured":
				return "CAPTURED"
			return "INACTIVE"
		_:
			return ""


func _recovery_years_remaining(agent: Agent) -> int:
	if agent.status != "compromised":
		return 0
	return maxi(0, agent.compromised_until_year - _current_year)


func _format_agent_status_detail(agent: Agent) -> String:
	match agent.status:
		"compromised":
			var years_left := _recovery_years_remaining(agent)
			if agent.compromised_until_year > _current_year:
				if years_left <= 1:
					return "Lying low — recovery expected %d" % agent.compromised_until_year
				return "Compromised — %d yrs until %d" % [years_left, agent.compromised_until_year]
			return "Compromised (clearing cover)"
		"on_mission":
			if not agent.assigned_target_tag.is_empty():
				var pct := int(agent.mission_progress * 100.0)
				return "Deployed in %s (%d%%)" % [agent.assigned_target_tag, pct]
			return "On active mission"
		"captured":
			return "Captured — network severed"
		"killed":
			return "KIA — out of operations"
		_:
			return agent.status.capitalize()


func get_intel_reports(country_tag: String) -> Array[Dictionary]:
	var intel := get_intel_for_country(country_tag)
	if intel.is_empty():
		return []

	var rows: Array[Dictionary] = []
	for intel_type in intel.keys():
		var value := int(intel.get(intel_type, 0))
		rows.append({
			"intel_type": str(intel_type),
			"label": str(intel_type).capitalize(),
			"value": value,
			"tier": _intel_tier_label(value),
		})
	rows.sort_custom(
		func(a: Dictionary, b: Dictionary) -> bool:
			return int(b.get("value", 0)) < int(a.get("value", 0))
	)
	return rows


func _intel_tier_label(value: int) -> String:
	if value <= 0:
		return "None"
	if value < 10:
		return "Low"
	if value < 20:
		return "Moderate"
	return "High"


# === Effect Application Helpers (MVP) ===

func _apply_production_delay(target_country: String, magnitude: float) -> void:
	print("  [EFFECT] %s suffers sabotage-induced production disruption (magnitude: %.2f)" % [target_country, magnitude])

	if typeof(FactoryManager) == TYPE_NIL:
		return

	# Find factories belonging to the target country and apply damage
	var damaged := 0
	var damage_amount := clampf(magnitude * 35.0, 10.0, 60.0)  # Scale to reasonable damage values

	for fid in FactoryManager.factories.keys():
		var factory = FactoryManager.get_factory(fid)
		if factory == null:
			continue
		if factory.owner_tag != target_country:
			continue
		if randf() < 0.35:  # Only damage some of the factories
			FactoryManager.apply_damage_to_factory(fid, damage_amount)
			damaged += 1
			if damaged >= 2:  # Limit impact per mission for MVP
				break

	if damaged > 0:
		print("    -> Damaged %d factories belonging to %s" % [damaged, target_country])


# Supply disruption now routes through the production delay handler for MVP simplicity.


func _apply_stability_damage(target_country: String, magnitude: float) -> void:
	if typeof(NationalModifierManager) != TYPE_NIL:
		NationalModifierManager.apply_influence_effect(
			target_country,
			stability_change = -magnitude,
			duration_months = 12,
			source = "agent_influence"
		)
	else:
		print("  [EFFECT] %s internal stability damaged by %.1f (Influence) — NationalModifierManager not available" % [target_country, magnitude])


func _apply_research_theft(actor_country: String, magnitude: float) -> void:
	print("  [EFFECT] %s stole %.0f research progress via technology mission" % [actor_country, magnitude])
	# Future: Give research progress to actor_country's tech tree


func _establish_long_term_intel(actor_country: String, domain: String) -> void:
	print("  [EFFECT] %s established long-term %s intelligence source" % [actor_country, domain])


func _apply_intel_bonus(actor_country: String, magnitude: float) -> void:
	print("  [EFFECT] %s gained temporary intelligence bonus (+%.0f)" % [actor_country, magnitude])


# Simple intelligence cache for future systems (Supply, Combat, Diplomacy)
var intel_cache: Dictionary = {}  # country_tag -> { "economic": value, "military": value, ... }

func _record_intelligence(country: String, intel_type: String, outcome: String) -> void:
	if not intel_cache.has(country):
		intel_cache[country] = {}

	var cache: Dictionary = intel_cache[country]
	var value := 10 if outcome == "success" else 4
	cache[intel_type] = int(cache.get(intel_type, 0)) + value

	print("  [INTEL] %s gained %d %s intelligence (total: %d)" % [
		country, value, intel_type, int(cache.get(intel_type, 0))
	])


func get_intel_for_country(country_tag: String, intel_type: String = "") -> Dictionary:
	var tag := country_tag.strip_edges().to_upper()
	if not intel_cache.has(tag):
		return {}
	if intel_type.is_empty():
		return intel_cache[tag].duplicate()
	return {intel_type: intel_cache[tag].get(intel_type, 0)}


## Returns a multiplier (e.g. 0.9 = 10% better intel) based on accumulated agent-gathered intelligence.
## Other systems (Supply, Combat) can call this.
func get_intelligence_modifier(country_tag: String, intel_type: String) -> float:
	var tag := country_tag.strip_edges().to_upper()
	var cache := intel_cache.get(tag, {}) as Dictionary
	var value := int(cache.get(intel_type, 0))

	if value <= 0:
		return 1.0

	# Soft cap: every 25 points of intel gives ~5% better information
	var bonus := minf(value / 500.0, 0.25)   # Max +25% bonus for MVP
	return 1.0 - bonus   # Lower number = better for the player (e.g. less enemy presence hidden)


## Consumes some intel (e.g. when used for a major operation).
func consume_intel(country_tag: String, intel_type: String, amount: int) -> bool:
	var tag := country_tag.strip_edges().to_upper()
	if not intel_cache.has(tag):
		return false

	var cache: Dictionary = intel_cache[tag]
	var current := int(cache.get(intel_type, 0))
	if current < amount:
		return false

	cache[intel_type] = current - amount
	return true


# === Counter-Intelligence Effect Helpers ===

func _apply_enemy_agent_disruption(target_country: String, magnitude: float) -> void:
	print("  [COUNTER-INTEL] %s had %d enemy agent networks disrupted" % [target_country, int(magnitude)])
	# Future: Could reduce active enemy agents or add temporary detection bonuses


func _degrade_enemy_intel(actor_country: String, magnitude: float) -> void:
	# This is an offensive counter-intel success — degrade the *enemy's* intel on us
	var enemies = []  # In a real game we'd have a list of relevant opponents
	# For MVP, just log a strong effect
	print("  [COUNTER-INTEL] %s successfully degraded enemy intelligence by %d" % [actor_country, int(magnitude)])


func _apply_tech_protection(actor_country: String, magnitude: float) -> void:
	print("  [COUNTER-INTEL] %s research facilities are now better protected against theft" % actor_country)