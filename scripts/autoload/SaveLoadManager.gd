# scripts/autoload/SaveLoadManager.gd
## Foundational Save / Load system for Epochs of Ascendancy.
##
## This is the first implementation (v1, pragmatic scope). It provides a working
## save/load loop for the most critical runtime state so that play sessions can
## be persisted and resumed. It is explicitly designed to be extended.
##
## === SAVE FORMAT (JSON, human-readable for debugging) ===
## Root dictionary:
## {
##   "save_version": 1,                    # Integer. Bump on breaking changes.
##   "metadata": {
##     "timestamp": "2026-05-18T14:30:00", # ISO-ish from Time.get_datetime_string_from_system
##     "scenario_id": "1936",              # Future: ScenarioLoader scenario identifier
##     "player_tag": "USA",
##     "play_time_seconds": 0              # Future: accumulated real play time
##   },
##   "time": {
##     "current_date": { "year": 1937, "month": 3, "day": 12, "date_string": "..." },
##     "scenario_start_date": "1936-01-01",
##     "paused": false,
##     "time_scale": 1.0
##   },
##   "technology": {
##     "country_state": { "USA": { "completed": {...}, "active": [...], ... }, ... }
##     # Mirrors TechnologyManager.country_state exactly for now.
##   },
##   "agents": {
##     "agents": { "USA": [ {agent dicts with @export + runtime fields}, ... ], ... },
##     "networks": { "123": { network dict }, ... }   # keyed by province_id string
##   },
##   "map": {
##     "provinces": [
##       { "id": 42, "owner_tag": "GER", "controller_tag": "GER",
##         "development_level": 5, "infrastructure": 8, ... }
##     ]
##   },
##   "supply": {
##     "depots": {
##       "42": { "stockpile": 1234.5, "throughput_capacity": 180.0, "sabotage_level": 0.25, ... }
##     }
##   },
##   "national_modifiers": {
##     "country_modifiers": { "GER": [ {effect dicts with remaining_months etc.}, ... ] }
##   },
##   "misc": {}   # Future expansion (production lines, leaders, etc.)
## }
##
## === EXTENSIBILITY CONTRACT (how other managers participate - REQUIRED READING) ===
## Any manager with runtime state worth persisting should implement:
##
##   func get_save_data() -> Dictionary:
##       return { "my_mutable_thing": my_state.duplicate(true), "version": 1, ... }
##
##   func apply_save_data(data: Dictionary) -> void:
##       if data.has("my_mutable_thing"):
##           my_state = data["my_mutable_thing"].duplicate(true)
##       # Rebuild any caches, re-emit signals so UI reacts, re-wire listeners if needed.
##       print("MyManager: state restored")
##
##   (optional) func clear_for_load() -> void:  # if you want SaveLoad to call a full reset first
##
## Then SaveLoadManager will automatically call them (see _gather_save_data and _apply).
## Put a comment in *your* file header describing exactly what your section contains.
##
## Example for a brand new manager "FooManager":
##   - Add the two funcs above.
##   - In SaveLoadManager _gather, it will be picked up if you also add a "foo" key
##     or let the manager put whatever it wants under a conventional key.
##   - Document the dict shape in FooManager.gd so future developers know what to expect.
##
## This pattern keeps SaveLoadManager small and delegates all per-system knowledge
## to the owning manager.
##
## Current implementation mixes direct access (for speed on core singletons) with the
## method pattern. All accesses are guarded.
##
## === LOAD BEHAVIOR ===
## - Assumes a compatible scenario is already loaded (Map/Supply hubs/provinces exist).
## - Performs targeted clears on mutable runtime state before applying.
## - Applies in a deliberate order: Time → Map provinces → Supply depots → NMM effects
##   → Technology → Agents (networks reference provinces + agents).
## - Existing signals (province_data_changed, research_state_changed, etc.) are used
##   so UI, overlays, and daily ticks react correctly after load.
## - Does NOT re-advance time or fire daily ticks during load (avoids double-processing).
##
## === WHAT IS SAVED (as of this expansion) ===
## - Time (date, start date, pause/scale)
## - Technology (full country research state + active progress)
## - Agents + Networks (full resources + daily effect trackers like last_daily_* and sabotage totals)
## - Map provinces (owner/controller, development, infrastructure - mutable gameplay fields)
## - Supply depots (stockpile, throughput, sabotage_level)
## - NationalModifierManager temporary effects (including daily agent sabotage debuffs with remaining duration)
## - Scenario metadata (scenario_id from ScenarioLoader for validation/future auto-reload)
## - Production (stance, national stockpiles/equipment, per-line progress/retooling/shortage state)
## - Factories (full Factory resources: damage, owner, retooling, assigned lines, efficiencies)
## - Leaders (full Leader resources + XP/status/assignments/traits, national positions, officer training assignments, pending retirements/replacements)
##
## === LIMITATIONS / WHAT IS NOT SAVED YET ===
## - Full combat/formation presence, routes, intel caches, attrition (will partially rebuild)
## - Most NationalSpirit / doctrine beyond Tech
## - UI caches, camera, selection state
## - Mod or highly transient data
## - Comprehensive migration for very old saves (basic stub exists)
##
## These can (and should) be added by implementing the two methods below on the manager.
##
## File location: user://saves/<slot>.json  (persistent, cross-session)
## Slots are simple names (quicksave, slot1, autosave_1937-03, etc.).
##
## Usage from code / debug:
##   SaveLoadManager.save_game("quicksave")
##   SaveLoadManager.load_game("quicksave")
##   var saves := SaveLoadManager.list_saves()
##
## The existing Save/Load buttons in TopInfoBar (RightContainer/MenuContainer) are
## already wired to call these (see TopInfoBar.gd integration).
##
## Authoring note: Keep this file relatively small. Heavy per-system logic belongs
## in the managers' get/apply methods.

extends Node

const SAVE_DIR := "user://saves/"
const SAVE_VERSION := 1
const DEFAULT_SLOT := "quicksave"

var _last_save_path: String = ""

func _ready() -> void:
	_ensure_save_dir()
	print("SaveLoadManager: Initialized (JSON format v%d, user://saves/)" % SAVE_VERSION)

	# Simple autosave on year boundary (pragmatic for testing/play sessions)
	if typeof(TimeManager) != TYPE_NIL:
		if not TimeManager.game_year_advanced.is_connected(_on_year_advanced_for_autosave):
			TimeManager.game_year_advanced.connect(_on_year_advanced_for_autosave)

func _on_year_advanced_for_autosave(_year: int) -> void:
	# Autosave to a fixed slot; keeps only the latest autosave for simplicity.
	var res := save_game_detailed("autosave")
	if res.get("ok", false):
		print("SaveLoadManager: Autosaved on year change -> autosave.json")
	else:
		push_warning("SaveLoadManager: Autosave failed: %s" % res.get("error", "unknown"))

func _ensure_save_dir() -> void:
	if not DirAccess.dir_exists_absolute(SAVE_DIR):
		var err := DirAccess.make_dir_recursive_absolute(SAVE_DIR)
		if err != OK:
			push_error("SaveLoadManager: Failed to create saves dir: %s" % SAVE_DIR)

func get_save_path(slot_name: String) -> String:
	var safe := slot_name.strip_edges().to_lower()
	safe = safe.replace(" ", "_").replace("/", "_").replace("\\", "_").replace(":", "_")
	if safe.is_empty():
		safe = DEFAULT_SLOT
	return SAVE_DIR + safe + ".json"

## Returns array of { "slot": "quicksave", "path": "...", "metadata": {...} } for UI lists.
func list_saves() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	var dir := DirAccess.open(SAVE_DIR)
	if dir == null:
		return result
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".json"):
			var full := SAVE_DIR + file_name
			var slot := file_name.get_basename()
			var meta := _peek_metadata(full)
			result.append({ "slot": slot, "path": full, "metadata": meta })
		file_name = dir.get_next()
	dir.list_dir_end()
	# Sort by timestamp desc if present
	result.sort_custom(func(a, b):
		var ta := str(a.get("metadata", {}).get("timestamp", ""))
		var tb := str(b.get("metadata", {}).get("timestamp", ""))
		return ta > tb
	)
	return result

func _peek_metadata(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return {}
	var text := f.get_as_text()
	f.close()
	var parsed: Variant = JSON.parse_string(text)
	if typeof(parsed) != TYPE_DICTIONARY:
		return {}
	var d: Dictionary = parsed
	return d.get("metadata", {}) as Dictionary

func save_game(slot_name: String = DEFAULT_SLOT) -> bool:
	var path := get_save_path(slot_name)
	var data := _gather_save_data()
	var json_text := JSON.stringify(data, "\t")   # Pretty for human debugging

	var f := FileAccess.open(path, FileAccess.WRITE)
	if f == null:
		push_error("SaveLoadManager: Cannot open %s for writing (error %s)" % [path, FileAccess.get_open_error()])
		return false
	f.store_string(json_text)
	f.close()

	_last_save_path = path
	print("SaveLoadManager: Game saved → %s (v%d, %d bytes)" % [path, SAVE_VERSION, json_text.length()])
	return true

func load_game(slot_name: String = DEFAULT_SLOT) -> bool:
	var path := get_save_path(slot_name)
	if not FileAccess.file_exists(path):
		push_error("SaveLoadManager: Save file not found: %s" % path)
		return false

	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		push_error("SaveLoadManager: Cannot open %s for reading" % path)
		return false
	var text := f.get_as_text()
	f.close()

	var parsed: Variant = JSON.parse_string(text)
	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("SaveLoadManager: Corrupt save file (root not a Dictionary)")
		return false

	var data: Dictionary = parsed
	var file_version := int(data.get("save_version", 0))
	if file_version > SAVE_VERSION:
		push_warning("SaveLoadManager: Save is v%d (current v%d). Best-effort load may drop fields." % [file_version, SAVE_VERSION])

	_apply_save_data(data)
	print("SaveLoadManager: Game loaded ← %s (v%d)" % [path, file_version])
	return true

## === INTERNAL GATHER / APPLY ===

func _gather_save_data() -> Dictionary:
	var data := {
		"save_version": SAVE_VERSION,
		"metadata": {
			"timestamp": Time.get_datetime_string_from_system(true),
			"scenario_id": "1936",   # TODO: pull from ScenarioLoader when it exposes an id
			"player_tag": "USA",     # TODO: central player / current country state
			"play_time_seconds": 0,  # Future
		},
		"time": {},
		"technology": {},
		"agents": {},
		"map": {},
		"supply": {},
		"national_modifiers": {},
		"misc": {},
	}

	# --- TimeManager (simple primitives) ---
	if typeof(TimeManager) != TYPE_NIL:
		data["time"] = {
			"current_date": TimeManager.get_current_date(),
			"scenario_start_date": TimeManager.get_scenario_start_date(),
			"paused": TimeManager.is_paused(),
			"time_scale": TimeManager.time_scale,
		}

	# --- TechnologyManager ---
	if typeof(TechnologyManager) != TYPE_NIL:
		if TechnologyManager.has_method("get_save_data"):
			data["technology"] = TechnologyManager.get_save_data()
		else:
			# Direct snapshot of the mutable per-country runtime state
			data["technology"] = {
				"country_state": TechnologyManager.country_state.duplicate(true)
			}

	# --- AgentManager (Resources require custom (de)serialization) ---
	if typeof(AgentManager) != TYPE_NIL:
		data["agents"] = _serialize_agent_state()

	# --- MapManager provinces (only mutable gameplay fields) ---
	if typeof(MapManager) != TYPE_NIL:
		data["map"] = _serialize_map_state()

	# --- SupplyManager depot runtime state (stock, sabotage, etc.) ---
	if typeof(SupplyManager) != TYPE_NIL:
		data["supply"] = _serialize_supply_state()

	# --- NationalModifierManager (temp effects, including daily sabotage debuffs) ---
	if typeof(NationalModifierManager) != TYPE_NIL:
		data["national_modifiers"] = {
			"country_modifiers": NationalModifierManager.country_modifiers.duplicate(true)
		}

	# --- Scenario metadata (for validation / future auto-reload) ---
	if typeof(ScenarioLoader) != TYPE_NIL and ScenarioLoader.has_method("get_current_scenario_name"):
		data["metadata"]["scenario_id"] = ScenarioLoader.get_current_scenario_name()
	elif typeof(ScenarioLoader) != TYPE_NIL:
		data["metadata"]["scenario_id"] = ScenarioLoader.current_scenario_name

	# --- Production + Factories (new in this expansion) ---
	if typeof(ProductionManager) != TYPE_NIL:
		if ProductionManager.has_method("get_save_data"):
			data["production"] = ProductionManager.get_save_data()
		else:
			data["production"] = {}  # fallback will be added if needed

	if typeof(FactoryManager) != TYPE_NIL:
		if FactoryManager.has_method("get_save_data"):
			data["factories"] = FactoryManager.get_save_data()
		else:
			data["factories"] = {}

	# --- Leaders (mutable runtime: assignments, XP/status, national positions, officer training) ---
	if typeof(LeaderManager) != TYPE_NIL:
		if LeaderManager.has_method("get_save_data"):
			data["leaders"] = LeaderManager.get_save_data()
		else:
			data["leaders"] = {}

	return data

func _apply_save_data(data: Dictionary) -> void:
	# Deliberate order matters because of cross-references and signal side-effects.

	# 1. Time (affects many yearly/monthly trackers)
	if data.has("time") and typeof(TimeManager) != TYPE_NIL:
		_apply_time_state(data["time"])

	# 2. Map provinces (owner/controller/dev/infra) — triggers province_data_changed
	if data.has("map") and typeof(MapManager) != TYPE_NIL:
		_apply_map_state(data["map"])

	# 3. Supply depots (stockpile, sabotage_level, throughput) — after hubs exist
	if data.has("supply") and typeof(SupplyManager) != TYPE_NIL:
		_apply_supply_state(data["supply"])

	# 4. National modifiers (daily agent sabotage effects etc.)
	if data.has("national_modifiers") and typeof(NationalModifierManager) != TYPE_NIL:
		_apply_national_modifier_state(data["national_modifiers"])

	# 5. Technology research state + unlocks
	if data.has("technology") and typeof(TechnologyManager) != TYPE_NIL:
		_apply_technology_state(data["technology"])

	# 6. Agents + Networks (reference provinces + lead agents)
	if data.has("agents") and typeof(AgentManager) != TYPE_NIL:
		_apply_agent_state(data["agents"])

	# 7. Leaders (before or after agents; positions reference leaders)
	if data.has("leaders") and typeof(LeaderManager) != TYPE_NIL:
		_apply_leader_state(data["leaders"])

	# 8. Production + Factories (factories feed lines; apply after map provinces)
	if data.has("factories") and typeof(FactoryManager) != TYPE_NIL:
		_apply_factory_state(data["factories"])
	if data.has("production") and typeof(ProductionManager) != TYPE_NIL:
		_apply_production_state(data["production"])

	# Future: after all core state, allow other managers to react
	# e.g. if typeof(ProductionManager) != TYPE_NIL and ProductionManager.has_method("on_game_loaded"):
	#     ProductionManager.on_game_loaded()

## --- Time ---

func _apply_time_state(t: Dictionary) -> void:
	if t.has("current_date"):
		var d: Dictionary = t["current_date"]
		TimeManager.current_year = int(d.get("year", 1936))
		TimeManager.current_month = int(d.get("month", 1))
		TimeManager.current_day = int(d.get("day", 1))
	if t.has("scenario_start_date"):
		TimeManager.scenario_start_date = str(t["scenario_start_date"])
	if t.has("paused"):
		TimeManager.set_paused(bool(t["paused"]))
	if t.has("time_scale"):
		TimeManager.set_time_scale(float(t.get("time_scale", 1.0)))
	# Do not fire game_day_advanced etc. here — we are restoring state, not simulating.

## --- Agents (most complex because of Resource instances) ---

func _serialize_agent_state() -> Dictionary:
	var out := { "agents": {}, "networks": {} }

	# Agents
	for ctag in AgentManager.agents.keys():
		var list: Array = []
		for a in (AgentManager.agents[ctag] as Array):
			if a is Agent:
				list.append(_agent_to_dict(a))
		out["agents"][ctag] = list

	# Networks
	for pid in AgentManager.networks.keys():
		var net: AgentNetwork = AgentManager.networks[pid]
		if net != null:
			out["networks"][str(pid)] = _network_to_dict(net)

	return out

func _agent_to_dict(a: Agent) -> Dictionary:
	# Use inst_to_dict for all @export fields, then add runtime non-exported ones
	var d: Dictionary = inst_to_dict(a)
	d["compromised_until_year"] = a.compromised_until_year
	d["assigned_province_id"] = a.assigned_province_id
	d["total_missions_completed"] = a.total_missions_completed
	d["successful_missions"] = a.successful_missions
	d["mission_history"] = (a.mission_history as Array).duplicate(true)
	d["traits"] = (a.traits as Array).duplicate()
	return d

func _dict_to_agent(d: Dictionary) -> Agent:
	var a := Agent.new()
	# Core identity / stats (@export + runtime)
	a.agent_id = str(d.get("agent_id", ""))
	a.name = str(d.get("name", ""))
	a.country_tag = str(d.get("country_tag", ""))
	a.level = int(d.get("level", 1))
	a.experience = int(d.get("experience", 0))
	a.intelligence = int(d.get("intelligence", 4))
	a.sabotage = int(d.get("sabotage", 4))
	a.influence = int(d.get("influence", 4))
	a.technology = int(d.get("technology", 4))
	a.counter_intelligence = int(d.get("counter_intelligence", 3))
	a.status = str(d.get("status", "available"))
	a.current_mission_id = str(d.get("current_mission_id", ""))
	a.mission_progress = float(d.get("mission_progress", 0.0))
	a.assigned_target_tag = str(d.get("assigned_target_tag", ""))
	a.assigned_target_tech_id = str(d.get("assigned_target_tech_id", ""))
	a.birth_year = int(d.get("birth_year", 1900))
	a.start_year = int(d.get("start_year", 1930))

	# Runtime
	a.compromised_until_year = int(d.get("compromised_until_year", 0))
	a.assigned_province_id = int(d.get("assigned_province_id", 0))
	a.total_missions_completed = int(d.get("total_missions_completed", 0))
	a.successful_missions = int(d.get("successful_missions", 0))
	a.mission_history = (d.get("mission_history", []) as Array).duplicate(true)
	a.traits = (d.get("traits", []) as Array).duplicate()

	return a

func _network_to_dict(net: AgentNetwork) -> Dictionary:
	var d: Dictionary = inst_to_dict(net)
	# Add runtime daily trackers
	d["total_intel_gathered"] = net.total_intel_gathered
	d["total_disruption_caused"] = net.total_disruption_caused
	d["last_daily_note"] = net.last_daily_note
	d["last_daily_effect"] = net.last_daily_effect
	d["last_daily_effect_scalar"] = net.last_daily_effect_scalar
	return d

func _dict_to_network(d: Dictionary) -> AgentNetwork:
	var net := AgentNetwork.new()
	net.network_id = str(d.get("network_id", ""))
	net.province_id = int(d.get("province_id", 0))
	net.controlling_country = str(d.get("controlling_country", ""))
	net.lead_agent_id = str(d.get("lead_agent_id", ""))
	net.strength = float(d.get("strength", 0.0))
	net.local_operatives = int(d.get("local_operatives", 0))
	net.focus = str(d.get("focus", "intelligence"))
	net.last_activity_month = int(d.get("last_activity_month", 0))
	net.detection_risk_accumulated = float(d.get("detection_risk_accumulated", 0.0))

	# Runtime
	net.total_intel_gathered = int(d.get("total_intel_gathered", 0))
	net.total_disruption_caused = float(d.get("total_disruption_caused", 0.0))
	net.last_daily_note = str(d.get("last_daily_note", ""))
	net.last_daily_effect = str(d.get("last_daily_effect", ""))
	net.last_daily_effect_scalar = float(d.get("last_daily_effect_scalar", 0.0))
	return net

func _apply_agent_state(a: Dictionary) -> void:
	# Clear existing runtime agent state
	AgentManager.agents.clear()
	AgentManager.networks.clear()
	AgentManager._agent_screen_cache.clear()

	# Restore agents
	var agents_by_country: Dictionary = a.get("agents", {}) as Dictionary
	for ctag in agents_by_country.keys():
		var arr: Array = []
		for entry in (agents_by_country[ctag] as Array):
			if typeof(entry) == TYPE_DICTIONARY:
				arr.append(_dict_to_agent(entry))
		AgentManager.agents[ctag] = arr

	# Restore networks
	var nets: Dictionary = a.get("networks", {}) as Dictionary
	for pid_str in nets.keys():
		var pid := int(pid_str)
		var entry: Dictionary = nets[pid_str] as Dictionary
		if typeof(entry) == TYPE_DICTIONARY:
			AgentManager.networks[pid] = _dict_to_network(entry)

	# Note: We do not re-emit every signal here; UI that cares can refresh on demand
	# or we can emit a single "agents_state_restored" if we add the signal later.
	print("SaveLoad: Restored %d agent countries + %d networks" % [agents_by_country.size(), nets.size()])

## --- Map (provinces) ---

func _serialize_map_state() -> Dictionary:
	var out := { "provinces": [] }
	if typeof(MapManager) == TYPE_NIL or not MapManager.has_method("get_all_provinces"):
		return out

	# Use the public query API (added/strengthened during Save/Load work)
	var provinces_dict: Dictionary = MapManager.get_all_provinces()
	for pid in provinces_dict.keys():
		var p: Province = provinces_dict[pid]
		if p == null:
			continue
		out["provinces"].append({
			"id": p.id,
			"owner_tag": p.owner_tag,
			"controller_tag": p.controller_tag,
			"development_level": p.development_level,
			"infrastructure": p.infrastructure,
			# Add more mutables (factories, resources, special_features deltas, cores, etc.) as they gain runtime mutation.
		})
	return out

func _apply_map_state(m: Dictionary) -> void:
	var list: Array = m.get("provinces", []) as Array
	for entry in list:
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		var e: Dictionary = entry
		var pid := int(e.get("id", -1))
		if pid < 0:
			continue

		# Use the public mutation helpers so signals fire and overlays react
		if e.has("owner_tag") or e.has("controller_tag"):
			var owner := str(e.get("owner_tag", ""))
			var ctrl := str(e.get("controller_tag", ""))
			MapManager.update_province_owner(pid, owner, ctrl)

		if e.has("development_level"):
			MapManager.update_province_development(pid, int(e["development_level"]))

		if e.has("infrastructure"):
			MapManager.update_province_infrastructure(pid, int(e["infrastructure"]))

	print("SaveLoad: Applied province state to %d provinces (signals emitted)" % list.size())

## --- Supply depots ---

func _serialize_supply_state() -> Dictionary:
	var out := { "depots": {} }
	if typeof(SupplyManager) == TYPE_NIL:
		return out

	for pid in SupplyManager.depot_states.keys():
		var depot: ProvinceDepotState = SupplyManager.depot_states[pid]
		if depot == null:
			continue
		out["depots"][str(pid)] = {
			"stockpile": depot.stockpile,
			"throughput_capacity": depot.throughput_capacity,
			"sabotage_level": depot.sabotage_level,
			# inbound/outbound are transient; usually not worth persisting
		}
	return out

func _apply_supply_state(s: Dictionary) -> void:
	var depots: Dictionary = s.get("depots", {}) as Dictionary
	var restored := 0
	for pid_str in depots.keys():
		var pid := int(pid_str)
		var entry: Dictionary = depots[pid_str] as Dictionary
		var depot: ProvinceDepotState = SupplyManager.depot_states.get(pid)
		if depot != null and typeof(entry) == TYPE_DICTIONARY:
			depot.stockpile = float(entry.get("stockpile", depot.stockpile))
			if entry.has("throughput_capacity"):
				depot.throughput_capacity = float(entry["throughput_capacity"])
			if entry.has("sabotage_level"):
				depot.sabotage_level = float(entry["sabotage_level"])
			restored += 1
	print("SaveLoad: Restored %d depot states (stock/sabotage/throughput)" % restored)

## --- NationalModifierManager ---

func _apply_national_modifier_state(n: Dictionary) -> void:
	if typeof(NationalModifierManager) == TYPE_NIL:
		return
	# Replace wholesale — tick_modifiers will continue decaying on next monthly tick
	NationalModifierManager.country_modifiers = (n.get("country_modifiers", {}) as Dictionary).duplicate(true)
	print("SaveLoad: National modifier effects restored")

## --- Technology ---

func _apply_technology_state(t: Dictionary) -> void:
	if typeof(TechnologyManager) == TYPE_NIL:
		return

	var cs: Dictionary = t.get("country_state", {}) as Dictionary
	if not cs.is_empty():
		TechnologyManager.country_state = cs.duplicate(true)

	# Rebuild any derived indices that depend on the restored state
	if TechnologyManager.has_method("_rebuild_unlock_indices"):
		TechnologyManager._rebuild_unlock_indices()

	# Let screens / UI that listen to research_state_changed refresh
	for tag in TechnologyManager.country_state.keys():
		if TechnologyManager.has_signal("research_state_changed"):
			TechnologyManager.research_state_changed.emit(str(tag))

	print("SaveLoad: Technology country_state restored for %d countries" % TechnologyManager.country_state.size())

## Convenience / debug helpers

func quicksave() -> bool:
	return save_game(DEFAULT_SLOT)

func quickload() -> bool:
	return load_game(DEFAULT_SLOT)

func get_last_save_path() -> String:
	return _last_save_path

## === New apply helpers for expanded state ===

func _apply_leader_state(l: Dictionary) -> void:
	if typeof(LeaderManager) != TYPE_NIL and LeaderManager.has_method("apply_save_data"):
		LeaderManager.apply_save_data(l)
		return
	# Fallback direct (if no method yet)
	print("SaveLoad: Leader state present but no apply_save_data on LeaderManager (direct apply limited)")

func _apply_factory_state(f: Dictionary) -> void:
	if typeof(FactoryManager) != TYPE_NIL and FactoryManager.has_method("apply_save_data"):
		FactoryManager.apply_save_data(f)
		return
	print("SaveLoad: Factory state present but no apply on FactoryManager")

func _apply_production_state(p: Dictionary) -> void:
	if typeof(ProductionManager) != TYPE_NIL and ProductionManager.has_method("apply_save_data"):
		ProductionManager.apply_save_data(p)
		return
	print("SaveLoad: Production state present but no apply on ProductionManager")

## === Robustness: version migration stub + improved error handling ===

## Called for old save versions to upgrade data in-place before _apply.
## Add cases here as SAVE_VERSION increases (e.g. key renames, default sections, data shape fixes).
func _migrate_save_data(data: Dictionary) -> void:
	var v := int(data.get("save_version", 0))
	if v >= SAVE_VERSION:
		return
	print("SaveLoad: Migrating save from v%d to v%d" % [v, SAVE_VERSION])

	# Example future migration:
	# if v < 2:
	#     if not data.has("production"):
	#         data["production"] = {}
	#     # rename keys etc.

	data["save_version"] = SAVE_VERSION  # mark as upgraded

## Enhanced save with better error object (for future UI).
func save_game_detailed(slot_name: String = DEFAULT_SLOT) -> Dictionary:
	var path := get_save_path(slot_name)
	var data := _gather_save_data()
	var json_text := JSON.stringify(data, "\t")

	var f := FileAccess.open(path, FileAccess.WRITE)
	if f == null:
		var err := FileAccess.get_open_error()
		var msg := "Cannot write save (error %d)" % err
		push_error("SaveLoadManager: %s -> %s" % [msg, path])
		return {"ok": false, "error": msg, "path": path, "code": err}

	f.store_string(json_text)
	f.close()
	_last_save_path = path
	return {"ok": true, "path": path, "bytes": json_text.length(), "version": SAVE_VERSION}

## Enhanced load with migration + feedback.
func load_game_detailed(slot_name: String = DEFAULT_SLOT) -> Dictionary:
	var path := get_save_path(slot_name)
	if not FileAccess.file_exists(path):
		return {"ok": false, "error": "File not found", "path": path}

	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return {"ok": false, "error": "Cannot open for read", "path": path}

	var text := f.get_as_text()
	f.close()

	var parsed: Variant = JSON.parse_string(text)
	if typeof(parsed) != TYPE_DICTIONARY:
		return {"ok": false, "error": "Corrupt JSON (not object)", "path": path}

	var data: Dictionary = parsed
	_migrate_save_data(data)  # upgrades in place if old

	var file_version := int(data.get("save_version", 0))
	if file_version > SAVE_VERSION:
		push_warning("SaveLoadManager: Save v%d > current v%d; best-effort only" % [file_version, SAVE_VERSION])

	_apply_save_data(data)
	return {"ok": true, "path": path, "version": file_version}

## === UX helpers (delete, rename) for save menu ===

func delete_save(slot_name: String) -> bool:
	var path := get_save_path(slot_name)
	if not FileAccess.file_exists(path):
		return false
	var err := DirAccess.remove_absolute(path)
	if err != OK:
		push_error("SaveLoadManager: Failed to delete %s (err %d)" % [path, err])
		return false
	print("SaveLoadManager: Deleted save %s" % slot_name)
	return true

func rename_save(old_slot: String, new_slot: String) -> bool:
	var old_path := get_save_path(old_slot)
	var new_path := get_save_path(new_slot)
	if not FileAccess.file_exists(old_path):
		return false
	if FileAccess.file_exists(new_path):
		push_warning("SaveLoadManager: Target name already exists: %s" % new_slot)
		return false

	var content := FileAccess.get_file_as_string(old_path)
	var f := FileAccess.open(new_path, FileAccess.WRITE)
	if f == null:
		return false
	f.store_string(content)
	f.close()

	DirAccess.remove_absolute(old_path)
	print("SaveLoadManager: Renamed %s -> %s" % [old_slot, new_slot])
	return true
