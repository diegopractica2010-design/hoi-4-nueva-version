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

	_wire_factory_province_lookup()

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

	_add_production_screen_test_button(player_tag)


func _add_production_screen_test_button(default_country_tag: String) -> void:
	var layer := CanvasLayer.new()
	layer.name = "UITestLayer"
	add_child(layer)

	var btn := Button.new()
	btn.text = "Production"
	btn.position = Vector2(16, 16)
	btn.pressed.connect(func() -> void:
		_open_production_assignment_screen(default_country_tag)
	)
	layer.add_child(btn)


func _open_production_assignment_screen(country_tag: String) -> void:
	var existing := get_tree().root.get_node_or_null("ProductionAssignmentScreen")
	if existing != null:
		existing.queue_free()

	var scene: PackedScene = load("res://scenes/ui/ProductionAssignmentScreen.tscn")
	if scene == null:
		push_warning("ProductionAssignmentScreen.tscn not found")
		return

	var screen: ProductionAssignmentScreen = scene.instantiate() as ProductionAssignmentScreen
	if screen == null:
		return
	screen.country_tag = country_tag
	screen.name = "ProductionAssignmentScreen"
	get_tree().root.add_child(screen)


func _wire_factory_province_lookup() -> void:
	var fm := get_node_or_null("/root/FactoryManager") as FactoryManager
	if fm == null or loader == null:
		return
	fm.set_province_lookup(func(province_id: int) -> Province:
		return loader.provinces.get(province_id) as Province
	)


func _run_production_line_tests() -> void:
	print("=== Production Line Tests ===")
	var passed := ProductionLineTest.run_all(GameData.design_data)
	print("✅ Production line tests passed" if passed else "❌ Production line tests failed")
