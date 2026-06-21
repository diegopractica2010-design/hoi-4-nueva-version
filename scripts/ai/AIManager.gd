extends Node

# NOTA: NO declaramos `class_name AIManager` a proposito.
# Se registra como autoload "AIManager"; usar class_name homonimo provoca
# "Class 'AIManager' hides an autoload singleton" y el autoload NO carga
# (patron DT-02). Sigue accesible globalmente como `AIManager`.

const ADJACENCY_PATH := "res://data/provinces/province_adjacency.json"
const SCENARIO_1879_TAG_ORDER: Array[String] = [
	"CHL", "PER", "BOL", "ARG", "BRA", "ENG", "GER", "FRA", "USA",
]

var ai_tags: Array[String] = []
var player_tag: String = "CHL"
var _days_since_last_eval: int = 0
var EVAL_INTERVAL_DAYS: int = 7

# --- Dificultad de la IA (Fácil / Normal / Difícil) ---
# Controla dos cosas: la FUERZA de la IA en combate (multiplicador que lee
# BattleManager y aplica solo a los bandos de la IA) y su AGRESIVIDAD (cada
# cuántos días evalúa y emite órdenes -> EVAL_INTERVAL_DAYS).
const DIFF_FACIL := 0
const DIFF_NORMAL := 1
const DIFF_DIFICIL := 2
const DIFFICULTY_FILE := "user://gameplay.cfg"
var difficulty: int = DIFF_NORMAL
var _adjacency: Dictionary = {}
var _war_state: Dictionary = {}
var _scenario_data: Dictionary = {}
var _triggered_events: Array = []


func _ready() -> void:
	_load_difficulty()
	_load_adjacency()
	_load_1879_scenario_state()
	_sync_player_tag()

	if typeof(TimeManager) != TYPE_NIL and TimeManager.has_signal("game_day_advanced"):
		if not TimeManager.game_day_advanced.is_connected(_on_game_day_advanced):
			TimeManager.game_day_advanced.connect(_on_game_day_advanced)

	var loader := get_node_or_null("/root/ScenarioLoader") as ScenarioLoader
	if loader != null and loader.has_signal("scenario_loaded"):
		if not loader.scenario_loaded.is_connected(_on_scenario_loaded):
			loader.scenario_loaded.connect(_on_scenario_loaded)
		if not str(loader.get("current_scenario_name")).is_empty():
			_initialize_ai_tags()
	else:
		_initialize_ai_tags()


func _initialize_ai_tags() -> void:
	ai_tags.clear()
	var tags := _scenario_country_tags()
	for raw_tag in tags:
		var tag := raw_tag.strip_edges().to_upper()
		if tag.is_empty() or tag == player_tag:
			continue
		if not ai_tags.has(tag):
			ai_tags.append(tag)


func set_player_tag(tag: String) -> void:
	var clean := tag.strip_edges().to_upper()
	if clean.is_empty():
		return
	player_tag = clean
	_initialize_ai_tags()


func set_difficulty(level: int) -> void:
	difficulty = clampi(level, DIFF_FACIL, DIFF_DIFICIL)
	_apply_difficulty()
	_save_difficulty()


func get_difficulty() -> int:
	return difficulty


func get_difficulty_name() -> String:
	match difficulty:
		DIFF_FACIL: return "Fácil"
		DIFF_DIFICIL: return "Difícil"
		_: return "Normal"


## Multiplicador de poder que BattleManager aplica SOLO a los bandos de la IA.
func get_ai_combat_multiplier() -> float:
	match difficulty:
		DIFF_FACIL: return 0.8
		DIFF_DIFICIL: return 1.25
		_: return 1.0


## Traduce la dificultad a la cadencia de evaluación (agresividad de la IA).
func _apply_difficulty() -> void:
	match difficulty:
		DIFF_FACIL: EVAL_INTERVAL_DAYS = 14
		DIFF_DIFICIL: EVAL_INTERVAL_DAYS = 3
		_: EVAL_INTERVAL_DAYS = 7


func _load_difficulty() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(DIFFICULTY_FILE) == OK:
		difficulty = clampi(int(cfg.get_value("ai", "difficulty", DIFF_NORMAL)), DIFF_FACIL, DIFF_DIFICIL)
	_apply_difficulty()


func _save_difficulty() -> void:
	var cfg := ConfigFile.new()
	cfg.load(DIFFICULTY_FILE)  # preserva otras claves si las hubiera
	cfg.set_value("ai", "difficulty", difficulty)
	cfg.save(DIFFICULTY_FILE)


func _on_game_day_advanced(_year: int, _month: int, _day: int) -> void:
	_days_since_last_eval += 1
	if _days_since_last_eval >= EVAL_INTERVAL_DAYS:
		_days_since_last_eval = 0
		_evaluate_all_ai()


func _evaluate_all_ai() -> void:
	for tag in ai_tags:
		if _is_active_belligerent(tag):
			_evaluate_nation_ai(tag)


func _is_active_belligerent(tag: String) -> bool:
	return tag.strip_edges().to_upper() in ["CHL", "PER", "BOL"]


func _evaluate_nation_ai(tag: String) -> void:
	var clean_tag := tag.strip_edges().to_upper()
	if clean_tag == "CHL":
		_check_historical_triggers(
			TimeManager.get_current_year() if typeof(TimeManager) != TYPE_NIL else 0,
			TimeManager.get_current_month() if typeof(TimeManager) != TYPE_NIL else 0,
			TimeManager.get_current_day() if typeof(TimeManager) != TYPE_NIL else 0
		)
	var formations = _get_ai_formations(tag)
	if formations.is_empty():
		return
	var objectives = _get_strategic_objectives(clean_tag)
	_issue_ai_orders(clean_tag, formations, objectives)


func _get_ai_formations(tag: String) -> Array:
	var result: Array = []
	if typeof(LeaderManager) == TYPE_NIL:
		return result
	var clean_tag := tag.strip_edges().to_upper()
	for formation in LeaderManager.get_formations_for_country(clean_tag):
		if formation == null:
			continue
		result.append({
			"id": formation.formation_id,
			"formation_id": formation.formation_id,
			"country_tag": formation.country_tag.strip_edges().to_upper(),
			"province_id": formation.province_id,
			"is_moving": formation.is_moving,
			"is_in_combat": formation.is_in_combat,
			"formation": formation,
		})
	return result


func _get_strategic_objectives(tag: String) -> Array:
	var clean_tag := tag.strip_edges().to_upper()
	match clean_tag:
		"CHL":
			return _first_unowned_objectives([841, 842, 843, 844, 71], "CHL", 2)
		"PER":
			if _has_chile_taken_saltpeter_province():
				return _first_owned_by_objectives([843, 842, 841], "CHL")
			return [844, 843, 71]
		"BOL":
			var objectives = []
			var antofagasta_owner = "BOL"
			if typeof(MapManager) != TYPE_NIL and MapManager.has_method("get_province_owner"):
				antofagasta_owner = MapManager.get_province_owner(841)
			if antofagasta_owner == "BOL":
				objectives.append(841)
			else:
				objectives.append(841)
			objectives.append(847)
			objectives.append(846)
			return objectives
		_:
			return []


func _issue_ai_orders(tag: String, formations: Array, objectives: Array) -> void:
	if objectives.is_empty() or typeof(UnitMovementSystem) == TYPE_NIL:
		return
	var clean_tag := tag.strip_edges().to_upper()
	for formation_data in formations:
		if typeof(formation_data) != TYPE_DICTIONARY:
			continue
		var data := formation_data as Dictionary
		if bool(data.get("is_moving", false)) or bool(data.get("is_in_combat", false)):
			continue
		var formation_id := _formation_id_from_data(data)
		var formation_province := int(data.get("province_id", -1))
		if formation_id.is_empty() or formation_province < 0:
			continue
		var target_province := _next_objective_for_formation(formation_province, objectives, clean_tag)
		if target_province < 0:
			continue
		if formation_province == target_province:
			continue

		var move_to := _find_best_move_toward(formation_province, target_province, tag)
		if _is_valid_ai_move(formation_id, formation_province, move_to, clean_tag):
			UnitMovementSystem.execute_move(formation_id, move_to)


func _find_best_move_toward(formation_province: int, target_province: int, tag: String) -> int:
	var adjacent = _adjacency.get(formation_province, [])
	if target_province in adjacent:
		return target_province

	var best_id := -1
	var best_distance := INF
	for adj_id_var in adjacent:
		var adj_id := int(adj_id_var)
		var owner := ""
		if typeof(MapManager) != TYPE_NIL and MapManager.has_method("get_province_owner"):
			owner = str(MapManager.get_province_owner(adj_id)).strip_edges().to_upper()
		if owner != tag and owner != "" and owner != "NEUTRAL":
			continue
		var distance := _province_graph_distance(adj_id, target_province)
		if distance >= 0 and float(distance) < best_distance:
			best_distance = float(distance)
			best_id = adj_id
	return best_id


func _check_historical_triggers(year: int, month: int, day: int) -> void:
	if year == 1879 and month == 2 and day >= 14:
		var antofagasta_owner := ""
		if typeof(MapManager) != TYPE_NIL and MapManager.has_method("get_province_owner"):
			antofagasta_owner = MapManager.get_province_owner(841)
		if antofagasta_owner != "CHL" and not _has_triggered("chl_attacks_antofagasta"):
			_mark_triggered("chl_attacks_antofagasta")
			var chl_formations = _get_ai_formations("CHL")
			for formation_data in chl_formations:
				if typeof(formation_data) != TYPE_DICTIONARY:
					continue
				var data := formation_data as Dictionary
				var formation_id := _formation_id_from_data(data)
				var from_province := int(data.get("province_id", -1))
				if _is_valid_ai_move(formation_id, from_province, 841, "CHL"):
					if typeof(UnitMovementSystem) != TYPE_NIL:
						UnitMovementSystem.execute_move(formation_id, 841)
					return


func _has_triggered(event_id: String) -> bool:
	return event_id in _triggered_events


func _mark_triggered(event_id: String) -> void:
	if not _has_triggered(event_id):
		_triggered_events.append(event_id)


func _is_at_war_with(tag_a: String, tag_b: String) -> bool:
	var a := tag_a.strip_edges().to_upper()
	var b := tag_b.strip_edges().to_upper()
	if a.is_empty() or b.is_empty():
		return false
	if _war_state.has(a):
		return b in (_war_state[a] as Array)

	var wars_1879 = {
		"CHL": ["PER", "BOL"],
		"PER": ["CHL"],
		"BOL": ["CHL"],
	}
	return b in wars_1879.get(a, [])


func _on_scenario_loaded() -> void:
	_load_1879_scenario_state()
	_sync_player_tag()
	_initialize_ai_tags()


func _sync_player_tag() -> void:
	if typeof(SaveLoadManager) != TYPE_NIL and "current_player_tag" in SaveLoadManager:
		var tag := str(SaveLoadManager.current_player_tag).strip_edges().to_upper()
		if not tag.is_empty():
			player_tag = tag


func _load_adjacency() -> void:
	_adjacency.clear()
	if not FileAccess.file_exists(ADJACENCY_PATH):
		push_warning("AIManager: adjacency file not found: %s" % ADJACENCY_PATH)
		return
	var file := FileAccess.open(ADJACENCY_PATH, FileAccess.READ)
	if file == null:
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	file.close()
	if typeof(parsed) != TYPE_DICTIONARY:
		push_warning("AIManager: invalid adjacency JSON: %s" % ADJACENCY_PATH)
		return
	var raw: Variant = (parsed as Dictionary).get("adjacency", {})
	if typeof(raw) != TYPE_DICTIONARY:
		return
	for key in (raw as Dictionary).keys():
		var pid := int(str(key))
		var neighbors: Array[int] = []
		var raw_neighbors: Variant = (raw as Dictionary)[key]
		if typeof(raw_neighbors) == TYPE_ARRAY:
			for neighbor in raw_neighbors as Array:
				neighbors.append(int(neighbor))
		_adjacency[pid] = neighbors


func _load_1879_scenario_state() -> void:
	_scenario_data.clear()
	_war_state.clear()
	var loader := get_node_or_null("/root/ScenarioLoader") as ScenarioLoader
	if loader != null:
		_parse_war_state(loader.get_war_state())
	else:
		push_warning("AIManager: ScenarioLoader not ready, war state unavailable")


func _parse_war_state(initial_war_state: Variant) -> void:
	if typeof(initial_war_state) != TYPE_DICTIONARY:
		return
	var wars: Variant = (initial_war_state as Dictionary).get("wars", [])
	if typeof(wars) != TYPE_ARRAY:
		return
	for war in wars as Array:
		if typeof(war) != TYPE_DICTIONARY:
			continue
		var attackers := _tag_array((war as Dictionary).get("attackers", []))
		var defenders := _tag_array((war as Dictionary).get("defenders", []))
		for attacker in attackers:
			for defender in defenders:
				_add_war_pair(attacker, defender)


func _add_war_pair(tag_a: String, tag_b: String) -> void:
	var a := tag_a.strip_edges().to_upper()
	var b := tag_b.strip_edges().to_upper()
	if a.is_empty() or b.is_empty():
		return
	if not _war_state.has(a):
		_war_state[a] = []
	if not _war_state.has(b):
		_war_state[b] = []
	if not (b in (_war_state[a] as Array)):
		(_war_state[a] as Array).append(b)
	if not (a in (_war_state[b] as Array)):
		(_war_state[b] as Array).append(a)


func _scenario_country_tags() -> Array[String]:
	var tags: Array[String] = []
	var loader := get_node_or_null("/root/ScenarioLoader") as ScenarioLoader
	if loader != null:
		for tag in loader.countries.keys():
			tags.append(str(tag).strip_edges().to_upper())
	if tags.is_empty():
		for key in ["country_colors", "national_stockpiles"]:
			var data: Variant = _scenario_data.get(key, {})
			if typeof(data) == TYPE_DICTIONARY:
				for tag in (data as Dictionary).keys():
					tags.append(str(tag).strip_edges().to_upper())

	var ordered: Array[String] = []
	for preferred_tag in SCENARIO_1879_TAG_ORDER:
		if tags.has(preferred_tag) and not ordered.has(preferred_tag):
			ordered.append(preferred_tag)
	for tag in tags:
		if not ordered.has(tag):
			ordered.append(tag)
	return ordered


func _tag_array(value: Variant) -> Array[String]:
	var result: Array[String] = []
	if typeof(value) != TYPE_ARRAY:
		return result
	for item in value as Array:
		var tag := str(item).strip_edges().to_upper()
		if not tag.is_empty():
			result.append(tag)
	return result


func _next_objective_for_formation(formation_province: int, objectives: Array, tag: String) -> int:
	for objective in objectives:
		var province_id := int(objective)
		if province_id < 0:
			continue
		if formation_province == province_id:
			return province_id
		if not _has_friendly_formation_in_province(tag, province_id):
			return province_id
	return -1


func _first_unowned_objectives(province_ids: Array[int], owner_tag: String, limit: int) -> Array:
	var result: Array = []
	var clean_owner := owner_tag.strip_edges().to_upper()
	for province_id in province_ids:
		if _province_owner(province_id) == clean_owner:
			continue
		result.append(province_id)
		if result.size() >= limit:
			break
	return result


func _first_owned_by_objectives(province_ids: Array[int], owner_tag: String) -> Array:
	var result: Array = []
	var clean_owner := owner_tag.strip_edges().to_upper()
	for province_id in province_ids:
		if _province_owner(province_id) == clean_owner:
			result.append(province_id)
	return result


func _has_chile_taken_saltpeter_province() -> bool:
	for province_id in [841, 842, 843]:
		if _province_owner(province_id) == "CHL":
			return true
	return false


func _province_owner(province_id: int) -> String:
	if typeof(MapManager) == TYPE_NIL or not MapManager.has_method("get_province_owner"):
		return ""
	return str(MapManager.get_province_owner(province_id)).strip_edges().to_upper()


func _is_valid_ai_move(
	formation_id: String,
	from_province: int,
	target_province: int,
	tag: String
) -> bool:
	var clean_tag := tag.strip_edges().to_upper()
	if formation_id.is_empty() or from_province < 0 or target_province < 0:
		return false
	if typeof(UnitMovementSystem) == TYPE_NIL:
		return false
	if not UnitMovementSystem.is_province_adjacent(from_province, target_province):
		return false
	if _has_friendly_formation_in_province(clean_tag, target_province):
		return false
	if clean_tag == "BOL" and not _is_bolivia_defensive_target(target_province):
		return false
	return true


func _is_bolivia_defensive_target(province_id: int) -> bool:
	if not (province_id in [841, 846, 847]):
		return false
	var owner := _province_owner(province_id)
	return owner == "BOL" or owner == "" or owner == "NEUTRAL"


func get_save_data() -> Dictionary:
	return {
		"triggered_events": _triggered_events.duplicate(),
		"days_since_last_eval": _days_since_last_eval,
		"player_tag": player_tag,
	}


func load_save_data(data: Dictionary) -> void:
	_triggered_events = (data.get("triggered_events", []) as Array).duplicate()
	_days_since_last_eval = int(data.get("days_since_last_eval", 0))
	player_tag = str(data.get("player_tag", "CHL")).strip_edges().to_upper()
	if player_tag.is_empty():
		player_tag = "CHL"
	_initialize_ai_tags()


func get_ai_status() -> String:
	var status = "=== AI STATUS ===\n"
	for tag in ai_tags:
		if _is_active_belligerent(tag):
			var formations = _get_ai_formations(tag)
			var objectives = _get_strategic_objectives(tag)
			status += "%s: %d formations, next objective: %s\n" % [
				tag,
				formations.size(),
				str(objectives[0]) if not objectives.is_empty() else "none"
			]
	return status


func _has_friendly_formation_in_province(tag: String, province_id: int) -> bool:
	if typeof(LeaderManager) == TYPE_NIL:
		return false
	var clean_tag := tag.strip_edges().to_upper()
	for formation in LeaderManager.get_formations_for_country(clean_tag):
		if formation != null and formation.province_id == province_id:
			return true
	return false


func _formation_id_from_data(data: Dictionary) -> String:
	var formation_id := str(data.get("id", ""))
	if formation_id.is_empty():
		formation_id = str(data.get("formation_id", ""))
	return formation_id


func _province_graph_distance(start_province: int, target_province: int) -> int:
	if start_province == target_province:
		return 0
	if not _adjacency.has(start_province) or not _adjacency.has(target_province):
		return -1

	var visited := {start_province: true}
	var frontier: Array[int] = [start_province]
	var distance := 0
	while not frontier.is_empty():
		distance += 1
		var next_frontier: Array[int] = []
		for province_id in frontier:
			for neighbor_var in _adjacency.get(province_id, []):
				var neighbor := int(neighbor_var)
				if visited.has(neighbor):
					continue
				if neighbor == target_province:
					return distance
				visited[neighbor] = true
				next_frontier.append(neighbor)
		frontier = next_frontier
	return -1
