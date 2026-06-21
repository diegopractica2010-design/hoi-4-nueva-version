extends Node

static func run_all() -> bool:
	var ok = true
	ok = test_terrain_modifiers() and ok
	ok = test_weather() and ok
	ok = test_entrenchment() and ok
	ok = test_reinforcement() and ok
	ok = test_combined_modifiers() and ok
	if ok:
		print("✅ All combat expansion tests passed")
	else:
		push_error("❌ Some combat expansion tests failed")
	return ok

static func test_terrain_modifiers() -> bool:
	var ok = true
	var cem = CombatExpansionManager
	if cem.get_terrain_modifier("plains", true) == 1.0:
		print("  ✓ Plains defense = 1.0")
	else:
		push_error("CombatExpansionTest: plains defense expected 1.0")
		ok = false
	if cem.get_terrain_modifier("plains", false) == 1.0:
		print("  ✓ Plains attack = 1.0")
	else:
		push_error("CombatExpansionTest: plains attack expected 1.0")
		ok = false
	if cem.get_terrain_modifier("mountain", true) == 1.5:
		print("  ✓ Mountain defense = 1.5")
	else:
		push_error("CombatExpansionTest: mountain defense expected 1.5, got " + str(cem.get_terrain_modifier("mountain", true)))
		ok = false
	if cem.get_terrain_modifier("mountain", false) == 0.6:
		print("  ✓ Mountain attack = 0.6")
	else:
		push_error("CombatExpansionTest: mountain attack expected 0.6")
		ok = false
	if cem.get_terrain_modifier("jungle", true) == 1.4:
		print("  ✓ Jungle defense = 1.4")
	else:
		push_error("CombatExpansionTest: jungle defense expected 1.4")
		ok = false
	if cem.get_terrain_modifier("marsh", false) == 0.6:
		print("  ✓ Marsh attack = 0.6")
	else:
		push_error("CombatExpansionTest: marsh attack expected 0.6")
		ok = false
	print("✅ Terrain modifiers: ", "PASS" if ok else "FAIL")
	return ok

static func test_weather() -> bool:
	var ok = true
	var cem = CombatExpansionManager
	cem.set_weather("default", "clear")
	if cem.get_weather("default") == "clear":
		print("  ✓ Weather set/get = clear")
	else:
		push_error("CombatExpansionTest: expected clear")
		ok = false
	if cem.get_weather_modifier("default", false) == 1.0:
		print("  ✓ Clear weather attack modifier = 1.0")
	else:
		push_error("CombatExpansionTest: clear attack expected 1.0")
		ok = false
	cem.set_weather("default", "storm")
	if cem.get_weather_modifier("default", true) == 1.2:
		print("  ✓ Storm defense modifier = 1.2")
	else:
		push_error("CombatExpansionTest: storm defense expected 1.2, got " + str(cem.get_weather_modifier("default", true)))
		ok = false
	if cem.get_weather_modifier("default", false) == 0.6:
		print("  ✓ Storm attack modifier = 0.6")
	else:
		push_error("CombatExpansionTest: storm attack expected 0.6")
		ok = false
	cem.set_weather("default", "snow")
	if cem.get_weather_modifier("default", false) == 0.7:
		print("  ✓ Snow attack modifier = 0.7")
	else:
		push_error("CombatExpansionTest: snow attack expected 0.7")
		ok = false
	cem.set_weather("default", "clear")
	print("✅ Weather system: ", "PASS" if ok else "FAIL")
	return ok

static func test_entrenchment() -> bool:
	var ok = true
	var cem = CombatExpansionManager
	if cem.get_entrenchment_level("test_fid_1") == 0:
		print("  ✓ Default entrenchment = 0")
	else:
		push_error("CombatExpansionTest: expected 0")
		ok = false
	cem.set_entrenchment_level("test_fid_1", 3)
	if cem.get_entrenchment_level("test_fid_1") == 3:
		print("  ✓ Entrenchment set to 3")
	else:
		push_error("CombatExpansionTest: expected 3")
		ok = false
	cem.set_entrenchment_level("test_fid_1", 10)
	if cem.get_entrenchment_level("test_fid_1") == 5:
		print("  ✓ Entrenchment clamped to MAX (5)")
	else:
		push_error("CombatExpansionTest: expected 5, got " + str(cem.get_entrenchment_level("test_fid_1")))
		ok = false
	if cem.get_entrenchment_modifier("test_fid_1") == 1.25:
		print("  ✓ Entrenchment modifier at level 5 = 1.25")
	else:
		push_error("CombatExpansionTest: expected 1.25, got " + str(cem.get_entrenchment_modifier("test_fid_1")))
		ok = false
	cem.set_entrenchment_level("test_fid_1", 2)
	if cem.get_entrenchment_modifier("test_fid_1") == 1.10:
		print("  ✓ Entrenchment modifier at level 2 = 1.10")
	else:
		push_error("CombatExpansionTest: expected 1.10, got " + str(cem.get_entrenchment_modifier("test_fid_1")))
		ok = false
	cem.record_formation_moved("test_fid_1")
	if cem.get_entrenchment_level("test_fid_1") == 0:
		print("  ✓ Movement resets entrenchment to 0")
	else:
		push_error("CombatExpansionTest: movement should reset entrenchment")
		ok = false
	print("✅ Entrenchment system: ", "PASS" if ok else "FAIL")
	return ok

static func test_reinforcement() -> bool:
	var ok = true
	var cem = CombatExpansionManager
	if cem.get_reinforcement_queue_size("test_fid_r") == 0:
		print("  ✓ Default queue size = 0")
	else:
		push_error("CombatExpansionTest: expected 0")
		ok = false
	cem.queue_reinforcement("test_fid_r", 50.0, 14)
	if cem.get_reinforcement_queue_size("test_fid_r") == 1:
		print("  ✓ Reinforcement queued")
	else:
		push_error("CombatExpansionTest: expected 1")
		ok = false
	cem.queue_reinforcement("test_fid_r", 30.0, 7)
	if cem.get_reinforcement_queue_size("test_fid_r") == 2:
		print("  ✓ Second reinforcement queued")
	else:
		push_error("CombatExpansionTest: expected 2")
		ok = false
	cem.queue_reinforcement("test_fid_r", -10, -1)
	if cem.get_reinforcement_queue_size("test_fid_r") == 2:
		print("  ✓ Invalid reinforcement ignored")
	else:
		push_error("CombatExpansionTest: invalid should be ignored")
		ok = false
	print("✅ Reinforcement system: ", "PASS" if ok else "FAIL")
	return ok

static func test_combined_modifiers() -> bool:
	var ok = true
	var cem = CombatExpansionManager
	cem.set_weather("test_region", "clear")
	cem.set_entrenchment_level("test_fid_c", 3)
	var combined := cem.get_combined_terrain_weather_modifier("plains", "test_region", false)
	if absf(combined - 1.0) < 0.01:
		print("  ✓ Plains+clear attack = 1.0")
	else:
		push_error("CombatExpansionTest: expected 1.0, got " + str(combined))
		ok = false
	var effective := cem.get_effective_power_multiplier("mountain", "test_region", "test_fid_c", true, false, 0)
	var expected := 1.5 * 1.0 * 1.15 * 1.15
	if absf(effective - expected) < 0.01:
		print("  ✓ Mountain+clear+entrenchment(3) defense = " + str(effective))
	else:
		push_error("CombatExpansionTest: expected " + str(expected) + ", got " + str(effective))
		ok = false
	var with_fort := cem.get_effective_power_multiplier("plains", "test_region", "test_fid_c", true, true, 3)
	var expected_fort := 1.0 * 1.0 * 1.15 * 1.3 * 1.15
	if absf(with_fort - expected_fort) < 0.01:
		print("  ✓ Plains+clear+entrenchment(3)+fort(3) defense = " + str(with_fort))
	else:
		push_error("CombatExpansionTest: expected " + str(expected_fort) + ", got " + str(with_fort))
		ok = false
	print("✅ Combined modifiers: ", "PASS" if ok else "FAIL")
	return ok
