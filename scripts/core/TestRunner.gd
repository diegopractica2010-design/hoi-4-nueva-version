# scripts/core/TestRunner.gd
extends Node

@onready var loader: ScenarioLoader = $ScenarioLoader
@onready var map_renderer: MapRenderer = $WorldMap
@onready var camera_controller: CameraController = $WorldMap/CameraInput

var player_tag: String = "CHL"
var _qa_smoke_mode: bool = false
var _is_headless: bool = false
var _scene_validation_mode: bool = false


func _ready() -> void:
	_qa_smoke_mode = ("--qa-smoke" in OS.get_cmdline_user_args()
		or "--qa-smoke" in OS.get_cmdline_args()
		or "++qa-smoke" in OS.get_cmdline_args())
	_scene_validation_mode = ("--scene-validation" in OS.get_cmdline_user_args()
		or "--scene-validation" in OS.get_cmdline_args())
	_is_headless = DisplayServer.get_name() == "headless"
	print("=== Epochs of Ascendancy Test Starting ===")
	if _scene_validation_mode:
		print("SCENE_VALIDATION: TestRunner ready")
		return

	# Flujo de nueva partida: el jugador debe elegir nación antes de cargar el escenario.
	# Si todavía no hay selección, mostramos la pantalla de selección de nación y volvemos.
	# En headless sin --qa-smoke también se auto-asigna CHL para evitar UI inexistente.
	if typeof(GameData) != TYPE_NIL and GameData.selected_nation_tag.strip_edges().is_empty():
		if _qa_smoke_mode or _is_headless:
			GameData.selected_nation_tag = "CHL"
		else:
			print("No hay nación seleccionada — abriendo pantalla de selección.")
			call_deferred("_go_to_nation_select")
			return

	# Nación elegida en GameData (por defecto "CHL" si llegara vacía).
	player_tag = GameData.selected_nation_tag.strip_edges() if typeof(GameData) != TYPE_NIL else ""
	if player_tag.is_empty():
		player_tag = "CHL"

	var production_tests_passed := _run_production_line_tests()
	if _qa_smoke_mode and not production_tests_passed:
		push_error("QA_SMOKE: production characterization failed")
		get_tree().quit(1)
		return

	var AutoloadValidatorClass = load("res://scripts/core/AutoloadValidator.gd")
	var autoloads_ok = AutoloadValidatorClass.validate_all()
	if not autoloads_ok:
		push_error("QA_SMOKE: autoload validation failed")
		if _qa_smoke_mode:
			get_tree().quit(1)
			return

	var success := loader.load_scenario("1879")

	if not success:
		print("Failed to load scenario.")
		if _qa_smoke_mode:
			get_tree().quit(1)
		return

	_wire_factory_province_lookup()

	print("Scenario loaded. Initializing map renderer...")
	var map_data := loader.get_map_data()
	if _is_headless:
		print("Headless mode: skipping visual map renderer")
	else:
		map_renderer.initialize(
			map_data.provinces,
			map_data.geometry,
			map_data.adjacency_system,
			map_data.countries,
		)

	# Also feed MapManager so it is authoritative even in test runner flows
	var mm := get_node_or_null("/root/MapManager")
	if mm != null and mm.has_method("initialize_from_map_data"):
		mm.initialize_from_map_data(map_data)
	elif mm != null and mm.has_method("force_initialize"):
		mm.force_initialize(map_data.provinces, map_data.geometry, map_data.adjacency_system, map_data.countries)

	if not _is_headless and camera_controller and map_renderer.container:
		camera_controller.target = map_renderer.container

	player_tag = _resolve_player_tag()

	# Propagar la nación elegida al sistema de guardado (las partidas registran el bando correcto).
	if typeof(SaveLoadManager) != TYPE_NIL and SaveLoadManager.has_method("set_player_tag"):
		SaveLoadManager.set_player_tag(player_tag)
	if typeof(AIManager) != TYPE_NIL:
		AIManager.set_player_tag(player_tag)
	# Propagar también al sistema de movimiento de unidades.
	if typeof(UnitMovementSystem) != TYPE_NIL and UnitMovementSystem.has_method("set_player_tag"):
		UnitMovementSystem.set_player_tag(player_tag)

	if not _is_headless and map_renderer and loader:
		map_renderer.build_supply_network(loader.get_city_layer(), player_tag)
		print("Supply network ready (toggle overlay with L)")

	if mm != null and mm.has_method("has_province_data") and mm.has_province_data():
		print("✅ MapManager ready with %d provinces" % mm.get_province_count())

	_run_comprehensive_tests(loader, mm)

	if not _is_headless:
		_configure_top_info_bar(player_tag)
	if typeof(LeaderManager) != TYPE_NIL:
		LeaderManager.set_player_country_tag(player_tag)

	# Carga pendiente desde el menú de inicio ("Cargar partida"): aplica el estado guardado
	# encima del escenario recién montado, y luego limpia el slot.
	if typeof(SaveLoadManager) != TYPE_NIL and not SaveLoadManager.pending_load_slot.is_empty():
		var slot := SaveLoadManager.pending_load_slot
		SaveLoadManager.pending_load_slot = ""
		var ok := SaveLoadManager.load_game(slot)
		print("TestRunner: carga pendiente '%s' aplicada=%s" % [slot, ok])

	if _qa_smoke_mode:
		print("QA_SMOKE: PASS scenario=1879 player=%s provinces=%d" % [player_tag, loader.provinces.size()])
		get_tree().quit(0)


## Cambia a la pantalla de selección de nación (flujo de nueva partida).
func _go_to_nation_select() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/NationSelectScreen.tscn")


func _resolve_player_tag() -> String:
	var tag := player_tag
	if loader == null:
		return tag
	if loader.get_country(tag) != null:
		return tag
	for c in loader.countries.values():
		if c is Country:
			return (c as Country).tag
	return tag


func _configure_top_info_bar(player_tag: String) -> void:
	var top_bar := get_node_or_null("UILayer/TopInfoBar") as TopInfoBar
	if top_bar != null:
		top_bar.player_country_tag = player_tag


func _run_comprehensive_tests(loader: ScenarioLoader, mm: Node) -> void:
	var all_ok = true
	var SaveLoadCycleTestScript = load("res://tests/SaveLoadCycleTest.gd")
	var ScenarioComprehensiveTestScript = load("res://tests/ScenarioComprehensiveTest.gd")
	var MapComprehensiveTestScript = load("res://tests/MapComprehensiveTest.gd")
	var CombatComprehensiveTestScript = load("res://tests/CombatComprehensiveTest.gd")
	print("\n=== Save/Load Cycle Tests ===")
	all_ok = SaveLoadCycleTestScript.run_all() and all_ok
	print("\n=== Scenario Comprehensive Tests ===")
	all_ok = ScenarioComprehensiveTestScript.run_all(loader) and all_ok
	print("\n=== Map Comprehensive Tests ===")
	all_ok = MapComprehensiveTestScript.run_all(mm, loader) and all_ok
	print("\n=== Combat Comprehensive Tests ===")
	var bm = get_node_or_null("/root/BattleManager")
	all_ok = CombatComprehensiveTestScript.run_all(bm) and all_ok
	if all_ok:
		print("\n✅ All comprehensive tests passed")
	else:
		push_error("\n❌ Some comprehensive tests failed")
		if _qa_smoke_mode:
			get_tree().quit(1)

func _wire_factory_province_lookup() -> void:
	var fm := get_node_or_null("/root/FactoryManager")
	if fm == null or loader == null:
		return
	fm.set_province_lookup(func(province_id: int) -> Province:
		return loader.provinces.get(province_id) as Province
	)


func _run_production_line_tests() -> bool:
	print("=== Production Line Tests ===")
	var passed := ProductionLineTest.run_all(GameData.design_data)
	print("✅ Production line tests passed" if passed else "❌ Production line tests failed")
	return passed
