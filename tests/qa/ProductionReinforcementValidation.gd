extends SceneTree


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var tests_script := load("res://scripts/core/ProductionLineTest.gd") as Script
	if tests_script == null:
		push_error("PRODUCTION_REINFORCEMENT_VALIDATION: cannot load tests")
		quit(1)
		return
	var stockpile_ok := bool(tests_script.call("_test_national_equipment_stockpile"))
	var priority_ok := bool(tests_script.call("_test_priority_reinforcement"))
	if not stockpile_ok or not priority_ok:
		push_error("PRODUCTION_REINFORCEMENT_VALIDATION: failed")
		quit(1)
		return
	print("PRODUCTION_REINFORCEMENT_VALIDATION: PASS")
	quit(0)
