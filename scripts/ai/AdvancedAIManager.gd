extends Node

const Log = preload("res://scripts/core/Logger.gd")

var _days_since_last_eval: int = 0
var DIPLOMACY_EVAL_INTERVAL: int = 30
var ESPIONAGE_EVAL_INTERVAL: int = 60
var SUPPLY_EVAL_INTERVAL: int = 14
var STRATEGIC_EVAL_INTERVAL: int = 90

var _ai_personalities: Dictionary = {}
var _spy_networks: Dictionary = {}
var _strategic_goals: Dictionary = {}

signal ai_declared_war(tag: String, target: String, reason: String)
signal ai_formed_alliance(tag: String, partner: String)
signal ai_spy_mission(tag: String, target: String, mission_type: String)
signal ai_supply_crisis(tag: String, severity: float)

func _ready() -> void:
	Log.info("AdvancedAIManager initialized", "AdvancedAIManager")
	if typeof(TimeManager) != TYPE_NIL and TimeManager.has_signal("game_day_advanced"):
		if not TimeManager.game_day_advanced.is_connected(_on_game_day_advanced):
			TimeManager.game_day_advanced.connect(_on_game_day_advanced)

func _on_game_day_advanced(_year: int, _month: int, _day: int) -> void:
	_days_since_last_eval += 1
	if _days_since_last_eval % DIPLOMACY_EVAL_INTERVAL == 0:
		_evaluate_all_diplomacy()
	if _days_since_last_eval % ESPIONAGE_EVAL_INTERVAL == 0:
		_evaluate_all_espionage()
	if _days_since_last_eval % SUPPLY_EVAL_INTERVAL == 0:
		_evaluate_all_supply()
	if _days_since_last_eval % STRATEGIC_EVAL_INTERVAL == 0:
		_evaluate_all_strategic()

func _get_ai_tags() -> Array[String]:
	if typeof(AIManager) != TYPE_NIL:
		return AIManager.ai_tags
	return []

func _get_player_tag() -> String:
	if typeof(AIManager) != TYPE_NIL:
		return AIManager.player_tag
	return "CHL"

# ===== DIPLOMACY AI =====

func set_ai_personality(tag: String, personality: Dictionary) -> void:
	_ai_personalities[tag] = personality

func get_ai_personality(tag: String) -> Dictionary:
	if _ai_personalities.has(tag):
		return _ai_personalities[tag]
	var defaults := {
		"aggressiveness": 0.5,
		"alliance_tendency": 0.5,
		"trust_bias": 0.0,
		"opportunism": 0.5,
	}
	_ai_personalities[tag] = defaults
	return defaults

func _evaluate_all_diplomacy() -> void:
	if typeof(DiplomacyManager) == TYPE_NIL:
		return
	for tag in _get_ai_tags():
		_evaluate_nation_diplomacy(tag)

func _evaluate_nation_diplomacy(tag: String) -> void:
	var person := get_ai_personality(tag)
	_evaluate_alliances(tag, person)
	_evaluate_war_declarations(tag, person)
	_evaluate_guarantees(tag, person)

func _evaluate_alliances(tag: String, person: Dictionary) -> void:
	if typeof(DiplomacyManager) == TYPE_NIL:
		return
	if randf() > person.get("alliance_tendency", 0.5):
		return
	var targets := _get_potential_alliance_partners(tag)
	if targets.is_empty():
		return
	var best := targets[0]
	var rel := DiplomacyManager.get_relation(tag, best)
	if rel >= 50 and not DiplomacyManager.has_alliance(tag, best):
		DiplomacyManager.form_alliance(tag, best)
		ai_formed_alliance.emit(tag, best)
		Log.info("AI Diplomacy: " + tag + " formed alliance with " + best, "AdvancedAIManager")

func _get_potential_alliance_partners(tag: String) -> Array[String]:
	if typeof(DiplomacyManager) == TYPE_NIL or typeof(GameData) == TYPE_NIL or GameData.world == null:
		return []
	var candidates: Array[String] = []
	for other_tag in GameData.world.tags:
		if other_tag == tag or other_tag == _get_player_tag():
			continue
		if DiplomacyManager.is_at_war(tag, other_tag) or DiplomacyManager.has_alliance(tag, other_tag):
			continue
		var rel := DiplomacyManager.get_relation(tag, other_tag)
		if rel > 20:
			candidates.append(other_tag)
	candidates.sort_custom(func(a, b): return DiplomacyManager.get_relation(tag, a) > DiplomacyManager.get_relation(tag, b))
	return candidates

func _evaluate_war_declarations(tag: String, person: Dictionary) -> void:
	if typeof(DiplomacyManager) == TYPE_NIL:
		return
	if randf() > person.get("aggressiveness", 0.5):
		return
	if DiplomacyManager.get_wars_for(tag).size() > 0:
		return
	var targets := _get_potential_war_targets(tag)
	if targets.is_empty():
		return
	var target := targets[0]
	var rel := DiplomacyManager.get_relation(tag, target)
	if rel < -50:
		DiplomacyManager.declare_war(tag, target)
		ai_declared_war.emit(tag, target, "low_relation")
		Log.info("AI Diplomacy: " + tag + " declared war on " + target, "AdvancedAIManager")

func _get_potential_war_targets(tag: String) -> Array[String]:
	if typeof(DiplomacyManager) == TYPE_NIL or typeof(GameData) == TYPE_NIL or GameData.world == null:
		return []
	var targets: Array[String] = []
	for other_tag in GameData.world.tags:
		if other_tag == tag or DiplomacyManager.is_at_war(tag, other_tag):
			continue
		if DiplomacyManager.has_alliance(tag, other_tag):
			continue
		var rel := DiplomacyManager.get_relation(tag, other_tag)
		if rel < -20:
			targets.append(other_tag)
	targets.sort_custom(func(a, b): return DiplomacyManager.get_relation(tag, a) < DiplomacyManager.get_relation(tag, b))
	return targets

func _evaluate_guarantees(tag: String, person: Dictionary) -> void:
	if typeof(DiplomacyManager) == TYPE_NIL:
		return
	if randf() > person.get("opportunism", 0.5) * 0.5:
		return
	for other_tag in _get_potential_guarantee_targets(tag):
		var rel := DiplomacyManager.get_relation(tag, other_tag)
		if rel >= 40 and not DiplomacyManager.has_guarantee(tag, other_tag):
			DiplomacyManager.give_guarantee(tag, other_tag)

func _get_potential_guarantee_targets(tag: String) -> Array[String]:
	var candidates: Array[String] = []
	if typeof(GameData) == TYPE_NIL or GameData.world == null:
		return candidates
	for other_tag in GameData.world.tags:
		if other_tag == tag or DiplomacyManager.is_at_war(tag, other_tag):
			continue
		candidates.append(other_tag)
	return candidates

# ===== ESPIONAGE AI =====

func _evaluate_all_espionage() -> void:
	for tag in _get_ai_tags():
		_evaluate_nation_espionage(tag)

func _evaluate_nation_espionage(tag: String) -> void:
	var enemies := _get_enemy_tags(tag)
	if enemies.is_empty():
		return
	var target := enemies[0]
	var mission := _choose_spy_mission(tag, target)
	if mission != "":
		_run_spy_mission(tag, target, mission)

func _get_enemy_tags(tag: String) -> Array[String]:
	var enemies: Array[String] = []
	if typeof(DiplomacyManager) == TYPE_NIL:
		return enemies
	for war in DiplomacyManager.get_wars_for(tag):
		if war.attacker == tag:
			enemies.append(war.defender)
		else:
			enemies.append(war.attacker)
	if enemies.is_empty() and typeof(GameData) != TYPE_NIL and GameData.world != null:
		for other_tag in GameData.world.tags:
			if other_tag != tag and DiplomacyManager.get_relation(tag, other_tag) < -30:
				enemies.append(other_tag)
	return enemies

func _choose_spy_mission(tag: String, target: String) -> String:
	var missions := ["gather_intel", "sabotage_supply", "counter_intel", "diplomatic_pressure"]
	return missions[randi() % missions.size()]

func _run_spy_mission(tag: String, target: String, mission_type: String) -> void:
	if not _spy_networks.has(tag):
		_spy_networks[tag] = {}
	if not _spy_networks[tag].has(target):
		_spy_networks[tag][target] = 0.0
	_spy_networks[tag][target] += 0.1
	ai_spy_mission.emit(tag, target, mission_type)
	Log.info("AI Espionage: " + tag + " running " + mission_type + " on " + target, "AdvancedAIManager")

func get_spy_network_level(tag: String, target: String) -> float:
	return _spy_networks.get(tag, {}).get(target, 0.0)

# ===== SUPPLY AI =====

func _evaluate_all_supply() -> void:
	for tag in _get_ai_tags():
		_evaluate_nation_supply(tag)

func _evaluate_nation_supply(tag: String) -> void:
	if typeof(SupplyManager) == TYPE_NIL:
		return
	if SupplyManager.has_method("get_supply_status"):
		var status: Dictionary = SupplyManager.get_supply_status(tag)
		if status.get("crisis", false):
			ai_supply_crisis.emit(tag, status.get("severity", 0.5))
			Log.warn("AI Supply crisis for " + tag, "AdvancedAIManager")
		_optimize_supply_routes(tag, status)

func _optimize_supply_routes(tag: String, status: Dictionary) -> void:
	if typeof(SupplyManager) == TYPE_NIL:
		return
	var defficits: Array = status.get("deficits", [])
	if defficits.is_empty():
		return
	if SupplyManager.has_method("reroute_supply"):
		for deficit in defficits:
			SupplyManager.reroute_supply(tag, deficit)

func get_supply_health(tag: String) -> float:
	if typeof(SupplyManager) == TYPE_NIL:
		return 1.0
	if not SupplyManager.has_method("get_supply_status"):
		return 1.0
	var status: Dictionary = SupplyManager.get_supply_status(tag)
	return status.get("health", 1.0)

# ===== STRATEGIC AI =====

func _evaluate_all_strategic() -> void:
	for tag in _get_ai_tags():
		_evaluate_nation_strategic(tag)

func _evaluate_nation_strategic(tag: String) -> void:
	var goals := _determine_strategic_goals(tag)
	_strategic_goals[tag] = goals
	Log.info("AI Strategic: " + tag + " goals: " + str(goals), "AdvancedAIManager")

func _determine_strategic_goals(tag: String) -> Array[Dictionary]:
	var goals: Array[Dictionary] = []
	if typeof(DiplomacyManager) == TYPE_NIL:
		return goals
	var at_war := DiplomacyManager.get_wars_for(tag).size() > 0
	var enemies := _get_enemy_tags(tag)
	var allies := DiplomacyManager.get_allies(tag)
	if at_war:
		goals.append({ "type": "win_war", "priority": 1.0, "target": enemies[0] if not enemies.is_empty() else "" })
	elif enemies.is_empty():
		goals.append({ "type": "build_power", "priority": 0.8, "target": "" })
	if allies.is_empty() and not at_war:
		goals.append({ "type": "find_ally", "priority": 0.6, "target": "" })
	if get_supply_health(tag) < 0.5:
		goals.append({ "type": "fix_supply", "priority": 0.9, "target": "" })
	return goals

func get_strategic_goals(tag: String) -> Array:
	return _strategic_goals.get(tag, [])

func get_primary_goal(tag: String) -> String:
	var goals := get_strategic_goals(tag)
	if goals.is_empty():
		return "idle"
	var sorted := goals.duplicate()
	sorted.sort_custom(func(a, b): return a.get("priority", 0) > b.get("priority", 0))
	return sorted[0].get("type", "idle") if sorted.size() > 0 else "idle"

func get_overall_ai_status(tag: String) -> String:
	var status := "=== ADVANCED AI STATUS (" + tag + ") ===\n"
	status += "Personality: " + str(get_ai_personality(tag)) + "\n"
	status += "Primary goal: " + get_primary_goal(tag) + "\n"
	status += "Spy networks: " + str(_spy_networks.get(tag, {})) + "\n"
	status += "Supply health: " + str(get_supply_health(tag)) + "\n"
	return status

func get_save_data() -> Dictionary:
	return {
		"days_since_last_eval": _days_since_last_eval,
		"ai_personalities": _ai_personalities.duplicate(true),
		"spy_networks": _spy_networks.duplicate(true),
		"strategic_goals": _strategic_goals.duplicate(true),
	}

func load_save_data(data: Dictionary) -> void:
	_days_since_last_eval = int(data.get("days_since_last_eval", 0))
	_ai_personalities = (data.get("ai_personalities", {}) as Dictionary).duplicate(true)
	_spy_networks = (data.get("spy_networks", {}) as Dictionary).duplicate(true)
	_strategic_goals = (data.get("strategic_goals", {}) as Dictionary).duplicate(true)
