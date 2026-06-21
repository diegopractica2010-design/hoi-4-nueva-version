extends Node

static func run_all() -> bool:
	var ok = true
	ok = test_diplomacy_ai() and ok
	ok = test_espionage_ai() and ok
	ok = test_supply_ai() and ok
	ok = test_strategic_ai() and ok
	ok = test_personality() and ok
	if ok:
		print("✅ All advanced AI tests passed")
	else:
		push_error("❌ Some advanced AI tests failed")
	return ok

static func test_diplomacy_ai() -> bool:
	var ok = true
	var aai = AdvancedAIManager
	if aai.has_method("_evaluate_alliances"):
		print("  ✓ AI has alliance evaluation")
	else:
		push_error("AdvancedAITest: missing alliance evaluation")
		ok = false
	if aai.has_method("_evaluate_war_declarations"):
		print("  ✓ AI has war declaration evaluation")
	else:
		push_error("AdvancedAITest: missing war declaration evaluation")
		ok = false
	if aai.has_method("_get_potential_alliance_partners"):
		print("  ✓ AI has alliance partner search")
	else:
		push_error("AdvancedAITest: missing alliance partner search")
		ok = false
	if aai.has_method("_get_potential_war_targets"):
		print("  ✓ AI has war target search")
	else:
		push_error("AdvancedAITest: missing war target search")
		ok = false
	var person := aai.get_ai_personality("TEST")
	if person.get("aggressiveness", -1) == 0.5 and person.get("alliance_tendency", -1) == 0.5:
		print("  ✓ AI personality defaults correct")
	else:
		push_error("AdvancedAITest: personality defaults wrong")
		ok = false
	print("✅ AI diplomacy: ", "PASS" if ok else "FAIL")
	return ok

static func test_espionage_ai() -> bool:
	var ok = true
	var aai = AdvancedAIManager
	if aai.has_method("_choose_spy_mission"):
		print("  ✓ AI has spy mission selection")
	else:
		push_error("AdvancedAITest: missing spy mission selection")
		ok = false
	if aai.has_method("_get_enemy_tags"):
		print("  ✓ AI has enemy tag detection")
	else:
		push_error("AdvancedAITest: missing enemy tag detection")
		ok = false
	if aai.get_spy_network_level("CHL", "PER") == 0.0:
		print("  ✓ Spy network level defaults to 0")
	else:
		push_error("AdvancedAITest: expected 0 spy network")
		ok = false
	aai._run_spy_mission("CHL", "PER", "gather_intel")
	if aai.get_spy_network_level("CHL", "PER") == 0.1:
		print("  ✓ Spy mission increases network level to 0.1")
	else:
		push_error("AdvancedAITest: expected 0.1, got " + str(aai.get_spy_network_level("CHL", "PER")))
		ok = false
	var mission := aai._choose_spy_mission("CHL", "PER")
	var valid_missions := ["gather_intel", "sabotage_supply", "counter_intel", "diplomatic_pressure"]
	if mission in valid_missions:
		print("  ✓ Chosen mission '" + mission + "' is valid")
	else:
		push_error("AdvancedAITest: invalid mission '" + mission + "'")
		ok = false
	print("✅ AI espionage: ", "PASS" if ok else "FAIL")
	return ok

static func test_supply_ai() -> bool:
	var ok = true
	var aai = AdvancedAIManager
	if aai.has_method("_evaluate_nation_supply"):
		print("  ✓ AI has supply evaluation")
	else:
		push_error("AdvancedAITest: missing supply evaluation")
		ok = false
	if aai.has_method("get_supply_health"):
		print("  ✓ AI has supply health query")
	else:
		push_error("AdvancedAITest: missing supply health query")
		ok = false
	if aai.get_supply_health("CHL") >= 0.0:
		print("  ✓ Supply health returns valid value")
	else:
		push_error("AdvancedAITest: supply health should be >= 0")
		ok = false
	print("✅ AI supply: ", "PASS" if ok else "FAIL")
	return ok

static func test_strategic_ai() -> bool:
	var ok = true
	var aai = AdvancedAIManager
	if aai.has_method("_determine_strategic_goals"):
		print("  ✓ AI has strategic goal determination")
	else:
		push_error("AdvancedAITest: missing strategic goal determination")
		ok = false
	if aai.has_method("get_primary_goal"):
		print("  ✓ AI has primary goal query")
	else:
		push_error("AdvancedAITest: missing primary goal query")
		ok = false
	var goals := aai._determine_strategic_goals("CHL")
	if typeof(goals) == TYPE_ARRAY:
		print("  ✓ Strategic goals is array: " + str(goals.size()) + " goals")
	else:
		push_error("AdvancedAITest: goals should be array")
		ok = false
	var primary := aai.get_primary_goal("CHL")
	if primary != "":
		print("  ✓ Primary goal: " + primary)
	else:
		push_error("AdvancedAITest: should have a primary goal")
		ok = false
	print("✅ AI strategic: ", "PASS" if ok else "FAIL")
	return ok

static func test_personality() -> bool:
	var ok = true
	var aai = AdvancedAIManager
	aai.set_ai_personality("CHL", { "aggressiveness": 0.9, "alliance_tendency": 0.1 })
	var person := aai.get_ai_personality("CHL")
	if person.get("aggressiveness", -1) == 0.9:
		print("  ✓ Personality aggressiveness = 0.9")
	else:
		push_error("AdvancedAITest: expected 0.9")
		ok = false
	if person.get("alliance_tendency", -1) == 0.1:
		print("  ✓ Personality alliance_tendency = 0.1")
	else:
		push_error("AdvancedAITest: expected 0.1")
		ok = false
	if person.get("trust_bias", -999) == 0.0:
		print("  ✓ Personality trust_bias default = 0.0")
	else:
		push_error("AdvancedAITest: expected default 0.0")
		ok = false
	print("✅ AI personality: ", "PASS" if ok else "FAIL")
	return ok
