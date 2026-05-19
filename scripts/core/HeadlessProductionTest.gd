extends SceneTree

## Standalone production-line test entry (no main scene). Run after editor import once:
##   godot4 --headless --path . -s res://scripts/core/HeadlessProductionTest.gd


func _init() -> void:
	var design_data: DesignDataLoader = DesignDataLoader.new()
	design_data.load_all()
	var passed: bool = ProductionLineTest.run_all(design_data)
	print("Production line tests: ", "PASS" if passed else "FAIL")
	quit(0 if passed else 1)
