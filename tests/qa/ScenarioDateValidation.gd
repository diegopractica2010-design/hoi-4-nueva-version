extends SceneTree


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var loader_script := load("res://scripts/core/ScenarioLoader.gd") as Script
	if loader_script == null:
		push_error("SCENARIO_DATE_VALIDATION: cannot load ScenarioLoader script")
		quit(1)
		return
	var loader := loader_script.new() as Node
	var cases: Array[Dictionary] = [
		{"value": "", "expected": -1},
		{"value": "1879", "expected": -1},
		{"value": "1879-bad-01", "expected": -1},
		{"value": "1879-13-01", "expected": -1},
		{"value": "1879-02-30", "expected": -1},
		{"value": "2000-02-29", "expected": 2000},
		{"value": "1900-02-29", "expected": -1},
		{"value": "1879-02-14", "expected": 1879},
	]
	for test_case in cases:
		var actual := int(loader.call("_parse_scenario_start_year", {"start_date": test_case["value"]}))
		if actual != int(test_case["expected"]):
			push_error("SCENARIO_DATE_VALIDATION: %s expected %d got %d" % [test_case["value"], test_case["expected"], actual])
			loader.free()
			quit(1)
			return
	loader.free()
	print("SCENARIO_DATE_VALIDATION: PASS count=%d" % cases.size())
	quit(0)
