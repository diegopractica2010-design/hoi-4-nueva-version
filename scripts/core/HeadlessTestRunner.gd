extends Node

@onready var loader: ScenarioLoader = $ScenarioLoader

var _qa_smoke_mode: bool = false


func _ready() -> void:
	_qa_smoke_mode = ("--qa-smoke" in OS.get_cmdline_user_args()
		or "--qa-smoke" in OS.get_cmdline_args()
		or "++qa-smoke" in OS.get_cmdline_args())
	print("=== Headless Test Runner ===")

	if typeof(GameData) != TYPE_NIL and GameData.selected_nation_tag.strip_edges().is_empty():
		GameData.selected_nation_tag = "CHL"

	var AutoloadValidatorClass = load("res://scripts/core/AutoloadValidator.gd")
	var autoloads_ok = AutoloadValidatorClass.validate_all()
	if not autoloads_ok:
		push_error("Autoload validation failed")
		if _qa_smoke_mode:
			get_tree().quit(1)
		return

	var success = loader.load_scenario("1879")
	if not success:
		print("Failed to load scenario.")
		if _qa_smoke_mode:
			get_tree().quit(1)
		return

	if typeof(SaveLoadManager) != TYPE_NIL and SaveLoadManager.has_method("set_player_tag"):
		SaveLoadManager.set_player_tag("CHL")
	if typeof(AIManager) != TYPE_NIL:
		AIManager.set_player_tag("CHL")
	if typeof(LeaderManager) != TYPE_NIL:
		LeaderManager.set_player_country_tag("CHL")

	var all_ok = true
	var SaveLoadCycleTestScript = load("res://scripts/core/SaveLoadCycleTest.gd")
	var ScenarioComprehensiveTestScript = load("res://scripts/core/ScenarioComprehensiveTest.gd")
	var CombatComprehensiveTestScript = load("res://scripts/core/CombatComprehensiveTest.gd")
	var LeaderTestScript = load("res://scripts/core/LeaderTest.gd")
	var AgentTestScript = load("res://scripts/core/AgentTest.gd")
	var VictoryTestScript = load("res://scripts/core/VictoryTest.gd")
	var EconomyTestScript = load("res://scripts/core/EconomyTest.gd")
	var LocalizationTestScript = load("res://scripts/core/LocalizationTest.gd")
	var AITestScript = load("res://scripts/core/AITest.gd")
	var EventTestScript = load("res://scripts/core/EventTest.gd")
	var MapComprehensiveTestScript = load("res://scripts/core/MapComprehensiveTest.gd")

	print("\n=== Save/Load Cycle Tests ===")
	all_ok = SaveLoadCycleTestScript.run_all() and all_ok

	print("\n=== Scenario Comprehensive Tests ===")
	all_ok = ScenarioComprehensiveTestScript.run_all(loader) and all_ok

	print("\n=== Combat Comprehensive Tests ===")
	var bm = get_node_or_null("/root/BattleManager")
	all_ok = CombatComprehensiveTestScript.run_all(bm) and all_ok

	print("\n=== Leader Tests (Phase 3) ===")
	all_ok = LeaderTestScript.run_all() and all_ok

	print("\n=== Agent Tests (Phase 3) ===")
	all_ok = AgentTestScript.run_all() and all_ok

	print("\n=== Victory Tests (Phase 3) ===")
	all_ok = VictoryTestScript.run_all() and all_ok

	print("\n=== Economy Tests (Phase 3) ===")
	all_ok = EconomyTestScript.run_all() and all_ok

	print("\n=== Localization Tests (Phase 3) ===")
	all_ok = LocalizationTestScript.run_all() and all_ok

	print("\n=== AI Tests (Phase 4) ===")
	all_ok = AITestScript.run_all() and all_ok

	print("\n=== Event Tests (Phase 4) ===")
	all_ok = EventTestScript.run_all() and all_ok

	print("\n=== Map Comprehensive Tests (Phase 4) ===")
	var mm = get_node_or_null("/root/MapManager")
	all_ok = MapComprehensiveTestScript.run_all(mm, loader) and all_ok

	print("\n=== Risk Validation (Phase 2) ===")
	var RiskValidatorClass = load("res://scripts/qa/RiskValidator.gd")
	var risks_ok = RiskValidatorClass.validate_all()

	if all_ok:
		print("\n✅ All headless tests passed")
	else:
		push_error("\n❌ Some headless tests failed")
		if _qa_smoke_mode:
			get_tree().quit(1)

	if risks_ok:
		print("✅ Risk validation passed")
	else:
		push_warning("⚠️  Risk validation flagged issues (non-blocking)")

	if _qa_smoke_mode:
		print("✅ QA_SMOKE: all tests passed")
		get_tree().quit(0)
