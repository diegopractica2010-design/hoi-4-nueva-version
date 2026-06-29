extends SceneTree


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var tests_script := load("res://tests/ProductionLineTest.gd") as Script
	if tests_script == null:
		push_error("INFANTRY_GENERATION_VALIDATION: cannot load tests")
		quit(1)
		return
	var game_data := root.get_node_or_null("GameData")
	if game_data == null:
		push_error("INFANTRY_GENERATION_VALIDATION: GameData autoload unavailable")
		quit(1)
		return
	var passed := bool(tests_script.call("_test_infantry_equipment_stats", game_data.get("design_data")))
	if not passed:
		push_error("INFANTRY_GENERATION_VALIDATION: failed")
		quit(1)
		return
	print("INFANTRY_GENERATION_VALIDATION: PASS")
	quit(0)
