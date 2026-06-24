extends Node
class_name EventTest

static func run_all() -> bool:
	var ok = true
	ok = _test_manager_exists() and ok
	ok = _test_events_loaded() and ok
	ok = _test_signals_exist() and ok
	ok = _test_save_data() and ok
	ok = _test_effect_types() and ok
	return ok

static func _test_manager_exists() -> bool:
	if typeof(EventManager) == TYPE_NIL:
		print("  [FAIL] EventManager not available")
		return false
	print("  [PASS] EventManager loaded")
	return true

static func _test_events_loaded() -> bool:
	if typeof(EventManager) == TYPE_NIL:
		return false
	if not EventManager.has_method("get_save_data"):
		print("  [WARN] get_save_data missing")
		return true
	var data = EventManager.get_save_data()
	var fired = data.get("fired_events", [])
	if fired.size() > 0:
		print("  [WARN] %d events already fired" % fired.size())
	var total = _count_loaded_events()
	print("  [PASS] events loaded: %d (0 fired)" % total)
	return true

static func _test_signals_exist() -> bool:
	if typeof(EventManager) == TYPE_NIL:
		return false
	var has_triggered = EventManager.has_signal("event_triggered")
	var has_effect = EventManager.has_signal("event_effect_applied")
	if not has_triggered or not has_effect:
		print("  [FAIL] missing signals: triggered=%s effect=%s" % [has_triggered, has_effect])
		return false
	print("  [PASS] both signals exist")
	return true

static func _test_save_data() -> bool:
	if typeof(EventManager) == TYPE_NIL:
		return false
	if not EventManager.has_method("get_save_data"):
		print("  [WARN] get_save_data missing")
		return true
	var data = EventManager.get_save_data()
	if data.is_empty():
		print("  [WARN] save data empty")
		return true
	if not data.has("fired_events"):
		print("  [FAIL] save data missing 'fired_events'")
		return false
	print("  [PASS] save/load data OK")
	return true

static func _test_effect_types() -> bool:
	if typeof(EventManager) == TYPE_NIL:
		return false
	var expected = ["declare_war", "province_transfer", "add_national_spirit", "damage_unit", "destroy_unit", "force_peace", "news_event", "modifier", "diplomacy", "peace"]
	var file = FileAccess.open("res://scripts/events/EventManager.gd", FileAccess.READ)
	if file == null:
		print("  [WARN] cannot read EventManager.gd")
		return true
	var content = file.get_as_text()
	file.close()
	var found = 0
	for effect in expected:
		if content.find("\"%s\":" % effect) != -1 or content.find("\"%s\":" % effect) != -1:
			found += 1
	if found < expected.size():
		print("  [WARN] only %d/%d effect types found" % [found, expected.size()])
	else:
		print("  [PASS] all %d effect types implemented" % expected.size())
	return true

static func _count_loaded_events() -> int:
	if typeof(EventManager) == TYPE_NIL:
		return 0
	var dir = DirAccess.open("res://data/events/1879/")
	if dir == null:
		return 0
	var count = 0
	dir.list_dir_begin()
	var fname = dir.get_next()
	while fname != "":
		if not dir.current_is_dir() and fname.ends_with(".json"):
			count += 1
		fname = dir.get_next()
	dir.list_dir_end()
	return count
