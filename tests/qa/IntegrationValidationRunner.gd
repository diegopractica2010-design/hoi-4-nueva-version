extends Node

func _ready() -> void:
	print("=== Integration Validation (Phase 7) ===")
	
	if typeof(GameData) != TYPE_NIL and GameData.selected_nation_tag.strip_edges().is_empty():
		GameData.selected_nation_tag = "CHL"
	
	var ScenarioLoaderClass = load("res://scripts/core/ScenarioLoader.gd")
	var loader = ScenarioLoaderClass.new()
	var success = loader.load_scenario("1879")
	if not success:
		push_error("Failed to load scenario.")
		get_tree().quit(1)
		return
	
	if typeof(SaveLoadManager) != TYPE_NIL and SaveLoadManager.has_method("set_player_tag"):
		SaveLoadManager.set_player_tag("CHL")
	if typeof(AIManager) != TYPE_NIL:
		AIManager.set_player_tag("CHL")
	if typeof(LeaderManager) != TYPE_NIL:
		LeaderManager.set_player_country_tag("CHL")
	
	var IntegrationValidation = load("res://tests/qa/IntegrationValidation.gd")
	var all_ok = IntegrationValidation.run_all()
	
	if all_ok:
		print("\n✅ ALL INTEGRATIONS PASSED")
	else:
		push_error("\n❌ Some integrations failed")
	
	get_tree().quit(0 if all_ok else 1)
