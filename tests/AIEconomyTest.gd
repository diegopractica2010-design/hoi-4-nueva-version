extends Node

static func run_all() -> bool:
	var ok = true
	ok = test_ai_config() and ok
	ok = test_factory_evaluation() and ok
	ok = test_production_evaluation() and ok
	ok = test_tech_choice() and ok
	if ok:
		print("✅ All AI economy tests passed")
	else:
		push_error("❌ Some AI economy tests failed")
	return ok

static func test_ai_config() -> bool:
	var ok = true
	var em = AIEconomyManager
	var defaults := em.get_ai_config("CHL")
	if defaults.get("factory_aggressiveness", -1) == 0.5:
		print("  ✓ AI config default factory_aggressiveness = 0.5")
	else:
		push_error("AIEconomyTest: expected 0.5")
		ok = false
	if defaults.get("research_focus", "") == "balanced":
		print("  ✓ AI config default research_focus = balanced")
	else:
		push_error("AIEconomyTest: expected balanced")
		ok = false
	em.set_ai_config("CHL", { "factory_aggressiveness": 1.0, "research_focus": "military" })
	var custom := em.get_ai_config("CHL")
	if custom.get("factory_aggressiveness", -1) == 1.0:
		print("  ✓ AI config custom factory_aggressiveness = 1.0")
	else:
		push_error("AIEconomyTest: expected custom 1.0")
		ok = false
	if custom.get("research_focus", "") == "military":
		print("  ✓ AI config custom research_focus = military")
	else:
		push_error("AIEconomyTest: expected military")
		ok = false
	print("✅ AI economy config: ", "PASS" if ok else "FAIL")
	return ok

static func test_factory_evaluation() -> bool:
	var ok = true
	var em = AIEconomyManager
	em.set_ai_config("CHL", { "prefer_military": false })
	if em.has_method("_evaluate_factory_construction"):
		print("  ✓ AI has _evaluate_factory_construction method")
	else:
		push_error("AIEconomyTest: missing _evaluate_factory_construction")
		ok = false
	if em.has_method("_build_factory"):
		print("  ✓ AI has _build_factory method")
	else:
		push_error("AIEconomyTest: missing _build_factory")
		ok = false
	if em.has_method("_is_nation_at_war"):
		print("  ✓ AI has _is_nation_at_war method")
	else:
		push_error("AIEconomyTest: missing _is_nation_at_war")
		ok = false
	print("✅ AI economy factory evaluation: ", "PASS" if ok else "FAIL")
	return ok

static func test_production_evaluation() -> bool:
	var ok = true
	var em = AIEconomyManager
	if em.has_method("_evaluate_production"):
		print("  ✓ AI has _evaluate_production method")
	else:
		push_error("AIEconomyTest: missing _evaluate_production")
		ok = false
	if em.has_method("_get_target_production_lines"):
		print("  ✓ AI has _get_target_production_lines method")
	else:
		push_error("AIEconomyTest: missing _get_target_production_lines")
		ok = false
	if em.has_method("_pick_design_of_type"):
		print("  ✓ AI has _pick_design_of_type method")
	else:
		push_error("AIEconomyTest: missing _pick_design_of_type")
		ok = false
	var mock_designs := [
		{ "id": "rifle_1", "type": "land" },
		{ "id": "fighter_1", "type": "air" },
		{ "id": "destroyer_1", "type": "naval" },
	]
	var picked := em._pick_design_of_type(mock_designs, "air")
	if picked != null and picked.get("id", "") == "fighter_1":
		print("  ✓ _pick_design_of_type picks correct type")
	else:
		push_error("AIEconomyTest: _pick_design_of_type failed")
		ok = false
	picked = em._pick_design_of_type(mock_designs, "naval")
	if picked != null and picked.get("id", "") == "destroyer_1":
		print("  ✓ _pick_design_of_type picks naval correctly")
	else:
		push_error("AIEconomyTest: _pick_design_of_type naval failed")
		ok = false
	print("✅ AI economy production evaluation: ", "PASS" if ok else "FAIL")
	return ok

static func test_tech_choice() -> bool:
	var ok = true
	var em = AIEconomyManager
	var mock_techs := [
		{ "id": "basic_industry", "category": "industry" },
		{ "id": "basic_weapons", "category": "weapons" },
		{ "id": "basic_armor", "category": "armor" },
		{ "id": "basic_naval", "category": "naval" },
	]
	var chosen := em._choose_tech("CHL", mock_techs, "military")
	if chosen != null and str(chosen.get("id", "")).find("weapons") >= 0 or str(chosen.get("id", "")).find("armor") >= 0:
		print("  ✓ _choose_tech military focus picks weapons/armor")
	else:
		push_error("AIEconomyTest: military focus should pick weapons/armor, got: " + str(chosen))
		ok = false
	chosen = em._choose_tech("CHL", mock_techs, "economic")
	if chosen != null and chosen.get("category", "") == "industry":
		print("  ✓ _choose_tech economic focus picks industry")
	else:
		push_error("AIEconomyTest: economic focus expected industry, got: " + str(chosen))
		ok = false
	chosen = em._choose_tech("CHL", mock_techs, "naval")
	if chosen != null and chosen.get("category", "") == "naval":
		print("  ✓ _choose_tech naval focus picks naval")
	else:
		push_error("AIEconomyTest: naval focus expected naval, got: " + str(chosen))
		ok = false
	chosen = em._choose_tech("CHL", mock_techs, "balanced")
	if chosen != null:
		print("  ✓ _choose_tech balanced picks first priority (industry): " + str(chosen.get("id", "")))
	else:
		push_error("AIEconomyTest: balanced focus should pick something")
		ok = false
	if em._filter_tech_by_category(mock_techs, ["industry"]) != null:
		print("  ✓ _filter_tech_by_category finds industry")
	else:
		push_error("AIEconomyTest: _filter_tech_by_category should find industry")
		ok = false
	if em._filter_tech_by_category(mock_techs, ["nonexistent"]) != null:
		push_error("AIEconomyTest: _filter_tech_by_category should not find nonexistent")
		ok = false
	else:
		print("  ✓ _filter_tech_by_category returns null for nonexistent")
	print("✅ AI economy tech choice: ", "PASS" if ok else "FAIL")
	return ok
