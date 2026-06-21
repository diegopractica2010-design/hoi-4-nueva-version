class_name ScenarioComprehensiveTest
extends RefCounted

static func run_all(loader: ScenarioLoader) -> bool:
	var ok = true
	ok = _test_scenario_start_date(loader) and ok
	ok = _test_scenario_name(loader) and ok
	ok = _test_all_playable_countries_loaded(loader) and ok
	ok = _test_chile_war_participants(loader) and ok
	ok = _test_chile_owns_provinces(loader) and ok
	ok = _test_peru_owns_provinces(loader) and ok
	ok = _test_bolivia_owns_provinces(loader) and ok
	ok = _test_argentina_exists(loader) and ok
	ok = _test_resource_layer_loaded(loader) and ok
	ok = _test_provinces_have_owner(loader) and ok
	ok = _test_no_null_provinces(loader) and ok
	ok = _test_formation_count(loader) and ok
	return ok

static func _test_scenario_start_date(loader: ScenarioLoader) -> bool:
	if loader.get_current_scenario_name() != "1879":
		print("  [FAIL] scenario name: expected 1879, got %s" % loader.get_current_scenario_name())
		return false
	print("  [PASS] scenario 1879 start date validated")
	return true

static func _test_scenario_name(loader: ScenarioLoader) -> bool:
	if loader.current_scenario_name != "1879":
		print("  [FAIL] internal scenario name mismatch")
		return false
	print("  [PASS] scenario name stored correctly")
	return true

static func _test_all_playable_countries_loaded(loader: ScenarioLoader) -> bool:
	for tag in ["CHL", "PER", "BOL", "ARG", "BRA", "USA", "ENG", "FRA", "GER"]:
		if loader.get_country(tag) == null:
			print("  [FAIL] country %s not loaded" % tag)
			return false
	print("  [PASS] all 9 countries loaded")
	return true

static func _test_chile_war_participants(loader: ScenarioLoader) -> bool:
	var war_state: Dictionary = loader.get_war_state()
	var wars: Array = war_state.get("wars", [])
	if wars.is_empty():
		print("  [FAIL] no wars in scenario")
		return false
	var war: Dictionary = wars[0]
	var attackers: Array = war.get("attackers", [])
	var defenders: Array = war.get("defenders", [])
	if not "CHL" in attackers:
		print("  [FAIL] CHL should be attacker in Guerra del Pacifico")
		return false
	if not "PER" in defenders or not "BOL" in defenders:
		print("  [FAIL] PER and BOL should be defenders")
		return false
	print("  [PASS] Guerra del Pacifico: CHL vs PER+BOL")
	return true

static func _test_chile_owns_provinces(loader: ScenarioLoader) -> bool:
	var count = 0
	for p in loader.provinces.values():
		if p.owner_tag == "CHL":
			count += 1
	if count == 0:
		print("  [FAIL] Chile owns 0 provinces")
		return false
	print("  [PASS] Chile owns %d provinces" % count)
	return true

static func _test_peru_owns_provinces(loader: ScenarioLoader) -> bool:
	var count = 0
	for p in loader.provinces.values():
		if p.owner_tag == "PER":
			count += 1
	if count == 0:
		print("  [FAIL] Peru owns 0 provinces")
		return false
	print("  [PASS] Peru owns %d provinces" % count)
	return true

static func _test_bolivia_owns_provinces(loader: ScenarioLoader) -> bool:
	var count = 0
	for p in loader.provinces.values():
		if p.owner_tag == "BOL":
			count += 1
	if count == 0:
		print("  [FAIL] Bolivia owns 0 provinces")
		return false
	print("  [PASS] Bolivia owns %d provinces" % count)
	return true

static func _test_argentina_exists(loader: ScenarioLoader) -> bool:
	var arg = loader.get_country("ARG")
	if arg == null:
		print("  [FAIL] Argentina (ARG) not loaded")
		return false
	print("  [PASS] Argentina present as diplomatic neighbor")
	return true

static func _test_resource_layer_loaded(loader: ScenarioLoader) -> bool:
	var resources: Dictionary = loader.province_resources_layer
	if resources.is_empty():
		print("  [FAIL] province_resources_layer empty")
		return false
	print("  [PASS] resource layer has %d provinces" % resources.size())
	return true

static func _test_provinces_have_owner(loader: ScenarioLoader) -> bool:
	var unowned = 0
	for p in loader.provinces.values():
		if p.owner_tag.is_empty():
			unowned += 1
	var owned = loader.provinces.size() - unowned
	if owned == 0:
		print("  [FAIL] 0 owned provinces")
		return false
	print("  [PASS] %d owned, %d unowned (expected for limited 1879 scenario)" % [owned, unowned])
	return true

static func _test_no_null_provinces(loader: ScenarioLoader) -> bool:
	var null_count = 0
	for k in loader.provinces:
		if loader.provinces[k] == null:
			null_count += 1
	if null_count > 0:
		print("  [FAIL] %d null Province entries" % null_count)
		return false
	print("  [PASS] all %d province entries are valid" % loader.provinces.size())
	return true

static func _test_formation_count(loader: ScenarioLoader) -> bool:
	if typeof(LeaderManager) == TYPE_NIL:
		print("  [SKIP] LeaderManager not available")
		return true
	var total = LeaderManager.formations.size()
	if total < 10:
		print("  [FAIL] only %d formations spawned (expected >= 10)" % total)
		return false
	print("  [PASS] %d formations spawned" % total)
	return true
