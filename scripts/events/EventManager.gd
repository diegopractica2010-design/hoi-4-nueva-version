extends Node

const Log = preload("res://scripts/core/Logger.gd")

# NOTA: NO declaramos `class_name EventManager` a proposito.
# Se registra como autoload "EventManager"; usar class_name homonimo provoca
# "Class 'EventManager' hides an autoload singleton" y el autoload NO carga
# (patron DT-02, igual que TimeManager/MapManager). Sigue accesible como `EventManager`.

signal event_triggered(event_data: Dictionary)
signal event_effect_applied(effect_type: String, target_tag: String)

var _events: Array = []
var _fired_events: Array = []
var _scenario_year: int = 1879


func _ready() -> void:
	if typeof(TimeManager) != TYPE_NIL:
		if not TimeManager.game_day_advanced.is_connected(_on_game_day_advanced):
			TimeManager.game_day_advanced.connect(_on_game_day_advanced)
	_load_all_events()


func _load_all_events() -> void:
	_events.clear()

	var dir := DirAccess.open("res://data/events/1879/")
	if dir == null:
		Log.warn("EventManager: data/events/1879/ not found")
		return

	dir.list_dir_begin()
	var fname := dir.get_next()
	while fname != "":
		if not dir.current_is_dir() and fname.ends_with(".json"):
			_load_event_file("res://data/events/1879/" + fname)
		fname = dir.get_next()
	dir.list_dir_end()

	Log.info("[EventManager] Loaded %d events" % _events.size(), "EventManager")


func _load_event_file(path: String) -> void:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		Log.warn("EventManager: Could not open %s" % path)
		return

	var json := JSON.new()
	var result := json.parse(file.get_as_text())
	file.close()

	if result != OK:
		Log.warn("EventManager: Failed to parse %s: %s" % [path, json.get_error_message()])
		return

	var data: Variant = json.get_data()
	if typeof(data) == TYPE_DICTIONARY:
		_events.append(data as Dictionary)
	elif typeof(data) == TYPE_ARRAY:
		for entry in data as Array:
			if typeof(entry) == TYPE_DICTIONARY:
				_events.append(entry as Dictionary)
			else:
				Log.warn("EventManager: Array entry in %s is not a Dictionary" % path)
	else:
		Log.warn("EventManager: Event file %s did not contain a Dictionary or Array" % path)
		return


func _on_game_day_advanced(year: int, month: int, day: int) -> void:
	_evaluate_all_events(year, month, day)


func _evaluate_all_events(year: int, month: int, day: int) -> void:
	for event_variant in _events:
		if typeof(event_variant) != TYPE_DICTIONARY:
			continue

		var event: Dictionary = event_variant as Dictionary
		var event_id := str(event.get("id", ""))
		if not bool(event.get("repeatable", false)) and event_id in _fired_events:
			continue

		var trigger_variant: Variant = event.get("trigger", {})
		if typeof(trigger_variant) != TYPE_DICTIONARY:
			continue
		if not _check_trigger(trigger_variant as Dictionary, year, month, day):
			continue
		if not _check_conditions(event.get("conditions", {}), year, month, day):
			continue
		_fire_event(event)


func _check_conditions(conditions: Dictionary, year: int, month: int, day: int) -> bool:
	if conditions.is_empty():
		return true
	if conditions.has("war_exists"):
		var pair: Array = conditions["war_exists"] as Array
		if pair.size() >= 2 and typeof(DiplomacyManager) != TYPE_NIL:
			if not DiplomacyManager.is_at_war(str(pair[0]), str(pair[1])):
				return false
	if conditions.has("owner"):
		var pair: Array = conditions["owner"] as Array
		if pair.size() >= 2 and typeof(MapManager) != TYPE_NIL:
			var tag := str(pair[0])
			var pid := int(pair[1])
			if MapManager.has_method("get_province_owner"):
				if MapManager.get_province_owner(pid) != tag:
					return false
	if conditions.has("peace"):
		var tag := str(conditions["peace"])
		if typeof(DiplomacyManager) != TYPE_NIL:
			if DiplomacyManager.is_nation_at_war(tag):
				return false
	return true


func _check_trigger(trigger: Dictionary, year: int, month: int, day: int) -> bool:
	var trigger_type := str(trigger.get("type", ""))

	match trigger_type:
		"date":
			return _check_date_trigger(str(trigger.get("date", "9999-12-31")), year, month, day)

		"province_owner":
			var province_id := int(trigger.get("province_id", -1))
			var required_owner := str(trigger.get("owner_tag", "")).strip_edges().to_upper()
			if typeof(MapManager) != TYPE_NIL and province_id > 0 and MapManager.has_method("get_province_owner"):
				return MapManager.get_province_owner(province_id) == required_owner
			return false

		"date_and_condition":
			var date_ok := _check_date_trigger(str(trigger.get("date", "9999-12-31")), year, month, day)
			var province_id := int(trigger.get("province_id", -1))
			if province_id > 0:
				var cond_ok := _check_trigger({
					"type": "province_owner",
					"province_id": province_id,
					"owner_tag": trigger.get("owner_tag", "")
				}, year, month, day)
				return date_ok and cond_ok
			return date_ok

		"relation":
			if typeof(DiplomacyManager) == TYPE_NIL:
				return false
			var from := str(trigger.get("from", "")).strip_edges().to_upper()
			var to := str(trigger.get("to", "")).strip_edges().to_upper()
			var comparison := str(trigger.get("comparison", ">="))
			var value := float(trigger.get("value", 0))
			var rel := float(DiplomacyManager.get_relation(from, to))
			match comparison:
				">=": return rel >= value
				"<=": return rel <= value
				">": return rel > value
				"<": return rel < value
				"==": return rel == value
				"!=": return rel != value
			return false

		_:
			return false


func _check_date_trigger(trigger_date: String, year: int, month: int, day: int) -> bool:
	var parts := trigger_date.split("-")
	if parts.size() != 3:
		return false

	var t_year := int(parts[0])
	var t_month := int(parts[1])
	var t_day := int(parts[2])

	return (
		year > t_year
		or (year == t_year and month > t_month)
		or (year == t_year and month == t_month and day >= t_day)
	)


func _fire_event(event: Dictionary) -> void:
	var event_id := str(event.get("id", "unknown"))
	if not bool(event.get("repeatable", false)) and not (event_id in _fired_events):
		_fired_events.append(event_id)

	Log.info("[EventManager] Firing event: %s" % event_id, "EventManager")
	event_triggered.emit(event)

	var effects: Array = event.get("effects", []) as Array
	for effect_variant in effects:
		if typeof(effect_variant) == TYPE_DICTIONARY:
			_apply_effect(effect_variant as Dictionary, event)


func _apply_effect(effect: Dictionary, event: Dictionary) -> void:
	var effect_type := str(effect.get("type", ""))

	match effect_type:
		"declare_war":
			var attacker := str(effect.get("attacker", "")).strip_edges().to_upper()
			var defender := str(effect.get("defender", "")).strip_edges().to_upper()
			if typeof(DiplomacyManager) != TYPE_NIL:
				DiplomacyManager.declare_war(attacker, defender)
			if typeof(LeaderManager) != TYPE_NIL and LeaderManager.has_method("set_country_at_war"):
				LeaderManager.set_country_at_war(attacker, true)
				LeaderManager.set_country_at_war(defender, true)
			Log.info("[EventManager] War declared: %s vs %s" % [attacker, defender], "EventManager")
			event_effect_applied.emit(effect_type, attacker)
			event_effect_applied.emit(effect_type, defender)

		"province_transfer":
			var pid := int(effect.get("province_id", -1))
			var to_tag := str(effect.get("to_tag", "")).strip_edges().to_upper()
			if typeof(MapManager) != TYPE_NIL and pid > 0 and MapManager.has_method("set_province_owner"):
				var old_owner := MapManager.get_province_owner(pid) if MapManager.has_method("get_province_owner") else ""
				MapManager.set_province_owner(pid, to_tag)
				if typeof(BattleManager) != TYPE_NIL:
					BattleManager.province_captured.emit(pid, to_tag, old_owner)
				event_effect_applied.emit(effect_type, to_tag)

		"add_national_spirit":
			var tag := str(effect.get("tag", "")).strip_edges().to_upper()
			var spirit_id := str(effect.get("spirit_id", ""))
			var modifiers: Dictionary = effect.get("modifiers", {}) as Dictionary
			var duration := int(effect.get("duration_months", 12))
			if typeof(NationalModifierManager) != TYPE_NIL:
				NationalModifierManager.apply_national_effect(tag, {
					"effect_id": "event_%s_%s" % [event.get("id", ""), spirit_id],
					"source": "event",
					"source_detail": str(event.get("name", event.get("id", ""))),
					"spirit_id": spirit_id,
					"modifiers": modifiers,
					"duration_months": duration,
					"remaining_months": duration,
					"is_debuff": _modifiers_are_debuff(modifiers)
				})
				event_effect_applied.emit(effect_type, tag)

		"damage_unit":
			var tag := str(effect.get("tag", "")).strip_edges().to_upper()
			var unit_id := str(effect.get("unit_id", ""))
			var damage := float(effect.get("damage_percent", 0.3))
			if typeof(LeaderManager) != TYPE_NIL:
				var formation := _find_formation(unit_id, tag, "fleet")
				if formation != null:
					formation.apply_damage(damage)
					Log.info("[EventManager] Unit damaged: %s %s by %.0f%% (strength now %.2f)" % [tag, unit_id, damage * 100.0, formation.strength], "EventManager")
			event_effect_applied.emit(effect_type, tag)

		"destroy_unit":
			var tag := str(effect.get("tag", "")).strip_edges().to_upper()
			var unit_id := str(effect.get("unit_id", ""))
			if typeof(LeaderManager) != TYPE_NIL:
				var formation := _find_formation(unit_id, tag, "fleet")
				if formation != null:
					formation.strength = 0.0
					LeaderManager.formations.erase(formation.formation_id)
					Log.info("[EventManager] Unit destroyed: %s %s" % [tag, unit_id], "EventManager")
			event_effect_applied.emit(effect_type, tag)

		"force_peace":
			var attacker := str(effect.get("attacker", "")).strip_edges().to_upper()
			var defender := str(effect.get("defender", "")).strip_edges().to_upper()
			if typeof(DiplomacyManager) != TYPE_NIL:
				DiplomacyManager.sign_peace(attacker, defender, attacker)
			if typeof(LeaderManager) != TYPE_NIL and LeaderManager.has_method("set_country_at_war"):
				LeaderManager.set_country_at_war(attacker, false)
				LeaderManager.set_country_at_war(defender, false)
			Log.info("[EventManager] Peace forced between %s and %s" % [attacker, defender], "EventManager")
			event_effect_applied.emit(effect_type, attacker)
			event_effect_applied.emit(effect_type, defender)

		"news_event":
			Log.info("[EventManager] News: %s" % str(effect.get("text", "")), "EventManager")
			event_effect_applied.emit(effect_type, "")

		"modifier":
			var target := str(effect.get("target", "")).strip_edges().to_upper()
			var key := str(effect.get("key", ""))
			var value := float(effect.get("value", 0.0))
			var duration := int(effect.get("duration_days", 180))
			if typeof(NationalModifierManager) != TYPE_NIL:
				NationalModifierManager.apply_national_effect(target, {
					"effect_id": "event_mod_%s_%s" % [event.get("id", ""), key],
					"source": "event",
					"source_detail": str(event.get("id", "")),
					"key": key,
					"value": value,
					"duration_days": duration,
					"modifiers": {key: value}
				})
				Log.info("[EventManager] Modifier applied: %s %s%+.1f for %dd" % [target, key, value, duration], "EventManager")
			event_effect_applied.emit(effect_type, target)

		"diplomacy":
			var action := str(effect.get("action", ""))
			var from := str(effect.get("from", "")).strip_edges().to_upper()
			var to := str(effect.get("to", "")).strip_edges().to_upper()
			if typeof(DiplomacyManager) != TYPE_NIL:
				match action:
					"form_alliance":
						DiplomacyManager.form_alliance(from, to)
						Log.info("[EventManager] Alliance formed: %s + %s" % [from, to], "EventManager")
					"declare_war":
						DiplomacyManager.declare_war(from, to)
						Log.info("[EventManager] War declared (diplomacy effect): %s vs %s" % [from, to], "EventManager")
					"sign_peace":
						DiplomacyManager.sign_peace(from, to, from)
						Log.info("[EventManager] Peace signed (diplomacy effect): %s + %s" % [from, to], "EventManager")
					_:
						Log.warn("[EventManager] Unknown diplomacy action: " + action)
			event_effect_applied.emit(effect_type, from)

		"peace":
			var from := str(effect.get("from", "")).strip_edges().to_upper()
			var to := str(effect.get("to", "")).strip_edges().to_upper()
			var winner := str(effect.get("winner", from)).strip_edges().to_upper()
			if typeof(DiplomacyManager) != TYPE_NIL:
				DiplomacyManager.sign_peace(from, to, winner)
				Log.info("[EventManager] Peace: %s defeats %s" % [winner, to if winner == from else from], "EventManager")
			if typeof(LeaderManager) != TYPE_NIL:
				for tag in [from, to]:
					if LeaderManager.has_method("set_country_at_war"):
						LeaderManager.set_country_at_war(tag, false)
			event_effect_applied.emit(effect_type, winner)

		_:
			Log.warn("[EventManager] Unknown effect type: " + effect_type)


func _modifiers_are_debuff(modifiers: Dictionary) -> bool:
	for key in modifiers.keys():
		if float(modifiers[key]) < 0.0:
			return true
	return false


## Busca una formación por ID exacto; si no la encuentra, busca por país y categoría.
func _find_formation(unit_id: String, country_tag: String, category: String) -> Formation:
	if typeof(LeaderManager) == TYPE_NIL:
		return null
	var formation := LeaderManager.get_formation(unit_id)
	if formation != null and formation.country_tag == country_tag:
		return formation
	for f in LeaderManager.get_formations_for_country(country_tag):
		if f.get_category() == category:
			return f
	return null


func get_save_data() -> Dictionary:
	return {
		"fired_events": _fired_events.duplicate()
	}


func load_save_data(data: Dictionary) -> void:
	_fired_events = (data.get("fired_events", []) as Array).duplicate()
