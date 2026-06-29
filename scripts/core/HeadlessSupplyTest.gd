extends SceneTree


func _init() -> void:
	var loader = load("res://scripts/core/ScenarioLoader.gd").new()
	loader.load_base_provinces()
	loader.load_scenario("1879")
	var test_script: GDScript = load("res://tests/SupplyLineTest.gd")
	var passed: bool = test_script.call("run_all", loader)
	print("Supply line tests: ", "PASS" if passed else "FAIL")
	quit(0 if passed else 1)
