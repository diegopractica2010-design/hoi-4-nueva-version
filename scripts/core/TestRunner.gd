# scripts/core/TestRunner.gd
extends Node

@onready var loader: ScenarioLoader = $ScenarioLoader
@onready var map_renderer = $WorldMap
@onready var camera_controller: CameraController = $WorldMap/CameraInput


func _ready() -> void:
	print("=== Epochs of Ascendancy Test Starting ===")

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
