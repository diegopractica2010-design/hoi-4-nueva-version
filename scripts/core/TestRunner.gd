# scripts/core/TestRunner.gd
extends Node

@onready var loader: ScenarioLoader = $ScenarioLoader
@onready var map_renderer: MapRenderer = $WorldMap
@onready var camera_controller: CameraController = $WorldMap/CameraInput


func _ready() -> void:
	print("=== Epochs of Ascendancy Test Starting ===")
	_run_production_line_tests()

	var success := loader.load_scenario("2026")

	if not success:
		print("Failed to load scenario.")
		return

	print("Scenario loaded. Initializing map renderer...")
	var map_data := loader.get_map_data()
	map_renderer.initialize(
		map_data.provinces,
		map_data.geometry,
		map_data.adjacency_system,
		map_data.countries,
	)

	if camera_controller and map_renderer.container:
		camera_controller.target = map_renderer.container

	if map_renderer and loader:
		var player_tag := "USA"
		if loader.get_country(player_tag) == null:
			for c in loader.countries.values():
				if c is Country:
					player_tag = (c as Country).tag
					break
		map_renderer.build_supply_network(loader.get_city_layer(), player_tag)
		var sm := get_node_or_null("/root/SupplyManager")
		if sm:
			sm.record_attrition("us_infantry_div_ww2", 120, {"m4_sherman_medium": 2.0})
			sm.advance_supply_day(1.0)
		print("Supply network ready (toggle overlay with L)")


func _run_production_line_tests() -> void:
	print("=== Production Line Tests ===")
	var passed := ProductionLineTest.run_all(GameData.design_data)
	print("✅ Production line tests passed" if passed else "❌ Production line tests failed")
