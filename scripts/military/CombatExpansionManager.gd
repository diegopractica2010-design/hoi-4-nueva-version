extends Node

const Logger = preload("res://scripts/core/Logger.gd")

signal weather_changed(region: String, weather: String)
signal entrenchment_changed(formation_id: String, new_level: int)

var _weather_state: Dictionary = {}
var _entrenchment_state: Dictionary = {}
var _reinforcement_queue: Dictionary = {}
var _days_since_last_eval: int = 0
var WEATHER_CHANGE_INTERVAL: int = 30
var REINFORCEMENT_INTERVAL: int = 7
var ENTRENCHMENT_INTERVAL: int = 3

const TERRAIN_MODIFIERS := {
	"plains":     { "attack": 1.0,  "defense": 1.0 },
	"grassland":  { "attack": 1.0,  "defense": 1.0 },
	"forest":     { "attack": 0.8,  "defense": 1.3 },
	"woods":      { "attack": 0.8,  "defense": 1.3 },
	"hills":      { "attack": 0.85, "defense": 1.2 },
	"mountain":   { "attack": 0.6,  "defense": 1.5 },
	"mountains":  { "attack": 0.6,  "defense": 1.5 },
	"alpine":     { "attack": 0.5,  "defense": 1.6 },
	"urban":      { "attack": 0.7,  "defense": 1.4 },
	"city":       { "attack": 0.7,  "defense": 1.4 },
	"town":       { "attack": 0.7,  "defense": 1.4 },
	"desert":     { "attack": 1.1,  "defense": 0.8 },
	"arid":       { "attack": 1.1,  "defense": 0.8 },
	"marsh":      { "attack": 0.6,  "defense": 1.2 },
	"swamp":      { "attack": 0.5,  "defense": 1.3 },
	"wetland":    { "attack": 0.6,  "defense": 1.2 },
	"jungle":     { "attack": 0.55, "defense": 1.4 },
}

const WEATHER_TYPES := ["clear", "rain", "snow", "storm", "fog", "heatwave"]
const WEATHER_MODIFIERS := {
	"clear":    { "attack": 1.0,  "defense": 1.0 },
	"rain":     { "attack": 0.9,  "defense": 1.1 },
	"snow":     { "attack": 0.7,  "defense": 1.15 },
	"storm":    { "attack": 0.6,  "defense": 1.2 },
	"fog":      { "attack": 0.85, "defense": 1.05 },
	"heatwave": { "attack": 0.8,  "defense": 0.9 },
}

const MAX_ENTRENCHMENT_LEVEL: int = 5
const ENTRENCHMENT_DAYS_PER_LEVEL: int = 7

func _ready() -> void:
	Logger.info("CombatExpansionManager initialized", "CombatExpansionManager")
	if typeof(TimeManager) != TYPE_NIL and TimeManager.has_signal("game_day_advanced"):
		if not TimeManager.game_day_advanced.is_connected(_on_game_day_advanced):
			TimeManager.game_day_advanced.connect(_on_game_day_advanced)

func _on_game_day_advanced(_year: int, _month: int, _day: int) -> void:
	_days_since_last_eval += 1
	if _days_since_last_eval % ENTRENCHMENT_INTERVAL == 0:
		_advance_entrenchment()
	if _days_since_last_eval % WEATHER_CHANGE_INTERVAL == 0:
		_roll_weather_changes()
	if _days_since_last_eval % REINFORCEMENT_INTERVAL == 0:
		_process_reinforcements()

func get_terrain_modifier(terrain_type: String, is_defender: bool) -> float:
	var clean := terrain_type.strip_edges().to_lower()
	var mods := TERRAIN_MODIFIERS.get(clean, { "attack": 1.0, "defense": 1.0 })
	if is_defender:
		return mods.get("defense", 1.0)
	return mods.get("attack", 1.0)

func get_weather(region: String = "default") -> String:
	return _weather_state.get(region, "clear")

func set_weather(region: String, weather: String) -> void:
	if weather not in WEATHER_MODIFIERS:
		return
	_weather_state[region] = weather
	weather_changed.emit(region, weather)

func get_weather_modifier(region: String, is_defender: bool) -> float:
	var w := get_weather(region)
	var mods := WEATHER_MODIFIERS.get(w, { "attack": 1.0, "defense": 1.0 })
	if is_defender:
		return mods.get("defense", 1.0)
	return mods.get("attack", 1.0)

func _roll_weather_changes() -> void:
	var rng := randi() % 100
	var new_weather := "clear"
	if rng < 30:
		new_weather = "clear"
	elif rng < 50:
		new_weather = "rain"
	elif rng < 65:
		new_weather = "fog"
	elif rng < 75:
		new_weather = "storm"
	elif rng < 88:
		new_weather = "heatwave"
	else:
		new_weather = "snow"
	for region in _weather_state.keys():
		if randi() % 100 < 40:
			_weather_state[region] = new_weather
			weather_changed.emit(region, new_weather)
	if _weather_state.is_empty():
		_weather_state["default"] = new_weather
		weather_changed.emit("default", new_weather)

func get_entrenchment_level(formation_id: String) -> int:
	return _entrenchment_state.get(formation_id, 0)

func set_entrenchment_level(formation_id: String, level: int) -> void:
	var clamped := clampi(level, 0, MAX_ENTRENCHMENT_LEVEL)
	_entrenchment_state[formation_id] = clamped
	entrenchment_changed.emit(formation_id, clamped)

func record_formation_moved(formation_id: String) -> void:
	_entrenchment_state.erase(formation_id)

func _advance_entrenchment() -> void:
	if typeof(LeaderManager) == TYPE_NIL:
		return
	for fid in LeaderManager.formations:
		var f: Formation = LeaderManager.formations[fid]
		if f == null or f.is_moving or f.is_in_combat:
			if f != null:
				_entrenchment_state.erase(f.formation_id)
			continue
		var current := _entrenchment_state.get(f.formation_id, 0)
		if current < MAX_ENTRENCHMENT_LEVEL:
			_entrenchment_state[f.formation_id] = current + 1
			entrenchment_changed.emit(f.formation_id, current + 1)

func get_entrenchment_modifier(formation_id: String) -> float:
	var level := get_entrenchment_level(formation_id)
	return 1.0 + level * 0.05

func queue_reinforcement(formation_id: String, amount: float, delay_days: int) -> void:
	if amount <= 0 or delay_days < 0:
		return
	if not _reinforcement_queue.has(formation_id):
		_reinforcement_queue[formation_id] = []
	_reinforcement_queue[formation_id].append({
		"amount": amount,
		"delay": delay_days,
		"elapsed": 0,
	})

func _process_reinforcements() -> void:
	var to_remove: Array = []
	for formation_id in _reinforcement_queue:
		var queue = _reinforcement_queue[formation_id]
		var remaining: Array = []
		for entry in queue:
			entry.elapsed += REINFORCEMENT_INTERVAL
			if entry.elapsed >= entry.delay:
				_apply_reinforcement(formation_id, entry.amount)
			else:
				remaining.append(entry)
		if remaining.is_empty():
			to_remove.append(formation_id)
		else:
			_reinforcement_queue[formation_id] = remaining
	for fid in to_remove:
		_reinforcement_queue.erase(fid)

func _apply_reinforcement(formation_id: String, amount: float) -> void:
	if typeof(UnitMovementSystem) == TYPE_NIL:
		return
	if UnitMovementSystem.has_method("reinforce_formation"):
		UnitMovementSystem.reinforce_formation(formation_id, amount)
	Logger.info("Reinforcement applied to " + formation_id + ": +" + str(amount), "CombatExpansionManager")

func get_reinforcement_queue_size(formation_id: String) -> int:
	return _reinforcement_queue.get(formation_id, []).size()

func get_combined_terrain_weather_modifier(terrain: String, region: String, is_defender: bool) -> float:
	var t := get_terrain_modifier(terrain, is_defender)
	var w := get_weather_modifier(region, is_defender)
	return t * w

func get_effective_power_multiplier(terrain: String, region: String, formation_id: String, is_defender: bool, has_fort: bool, fort_level: int) -> float:
	var base := get_terrain_modifier(terrain, is_defender)
	var weather := get_weather_modifier(region, is_defender)
	var entrenchment := 1.0
	if is_defender:
		entrenchment = get_entrenchment_modifier(formation_id)
		base = base * 1.15
		if has_fort:
			base *= 1.0 + 0.1 * fort_level
	return base * weather * entrenchment

func get_weather_status() -> String:
	var status := "=== WEATHER STATUS ===\n"
	for region in _weather_state:
		status += region + ": " + _weather_state[region] + "\n"
	return status

func get_entrenchment_status() -> String:
	var status := "=== ENTRENCHMENT STATUS ===\n"
	for fid in _entrenchment_state:
		status += fid + ": level " + str(_entrenchment_state[fid]) + "\n"
	return status

func get_save_data() -> Dictionary:
	return {
		"weather": _weather_state.duplicate(),
		"entrenchment": _entrenchment_state.duplicate(),
		"reinforcement_queue": _reinforcement_queue.duplicate(true),
		"days_since_last_eval": _days_since_last_eval,
	}

func load_save_data(data: Dictionary) -> void:
	_weather_state = (data.get("weather", {}) as Dictionary).duplicate()
	_entrenchment_state = (data.get("entrenchment", {}) as Dictionary).duplicate()
	_reinforcement_queue = (data.get("reinforcement_queue", {}) as Dictionary).duplicate(true)
	_days_since_last_eval = int(data.get("days_since_last_eval", 0))
