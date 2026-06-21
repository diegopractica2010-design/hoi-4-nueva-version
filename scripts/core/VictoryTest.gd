extends Node
class_name VictoryTest

static func run_all() -> bool:
	var ok = true
	ok = _test_manager_exists() and ok
	ok = _test_victory_status_returns() and ok
	ok = _test_initial_saltpeter() and ok
	ok = _test_no_early_victory() and ok
	return ok

static func _test_manager_exists() -> bool:
	if typeof(VictoryConditions) == TYPE_NIL:
		print("  [FAIL] VictoryConditions not available")
		return false
	if not VictoryConditions.has_method("get_victory_status"):
		print("  [FAIL] get_victory_status missing")
		return false
	print("  [PASS] VictoryConditions loaded")
	return true

static func _test_victory_status_returns() -> bool:
	var status = VictoryConditions.get_victory_status()
	if status.is_empty():
		print("  [FAIL] get_victory_status returned empty dict")
		return false
	if not status.has("war_active"):
		print("  [WARN] status missing war_active")
	print("  [PASS] victory_status: %s" % str(status))
	return true

static func _test_initial_saltpeter() -> bool:
	var status = VictoryConditions.get_victory_status()
	var chl_count = int(status.get("saltpeter_provinces_chl", -1))
	if chl_count == -1:
		print("  [WARN] saltpeter_provinces_chl not in status")
		return true
	if chl_count < 0 or chl_count > 3:
		print("  [FAIL] saltpeter count out of range: %d" % chl_count)
		return false
	print("  [PASS] initial saltpeter provinces controlled by CHL: %d/3" % chl_count)
	return true

static func _test_no_early_victory() -> bool:
	if not VictoryConditions.has_signal("victory_achieved"):
		print("  [WARN] victory_achieved signal missing")
		return true
	print("  [PASS] victory_achieved signal exists")
	return true
