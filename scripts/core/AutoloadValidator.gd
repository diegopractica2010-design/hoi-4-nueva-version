# scripts/core/AutoloadValidator.gd
extends RefCounted
class_name AutoloadValidator

static func validate_all() -> bool:
	var all_ok := true
	var names := [
		"GameData", "FactoryManager", "ProductionManager", "SupplyManager",
		"LeaderManager", "TimeManager", "DesignManager", "LeaderEventUI",
		"AgentManager", "NationalModifierManager", "NationalSpiritManager",
		"NationalIncomeManager", "TradeManager", "MapManager",
		"TechnologyManager", "SaveLoadManager", "VictoryConditions",
		"EventManager", "UnitMovementSystem", "BattleManager", "AIManager",
		"LocalizationSettings", "LanguageManager", "TranslationProvider", "Localization",
	]
	for n in names:
		var node := _get_autoload(n)
		if node == null:
			print("  [FAIL] Autoload %s not found at /root/%s" % [n, n])
			all_ok = false
		else:
			print("  [PASS] Autoload %s loaded" % n)
	print("✅ Autoload validation complete (%d checks)" % names.size())
	return all_ok

static func _get_autoload(name_path: String) -> Node:
	var tree := Engine.get_main_loop() as SceneTree
	if tree == null or tree.root == null:
		return null
	return tree.root.get_node_or_null(name_path)
