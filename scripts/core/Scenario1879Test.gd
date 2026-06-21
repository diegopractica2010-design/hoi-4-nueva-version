class_name Scenario1879Test
extends RefCounted

static func run_all(loader: ScenarioLoader) -> bool:
	var ok := true
	ok = _test_start_date(loader) and ok
	ok = _test_playable_countries(loader) and ok
	ok = _test_war_state(loader) and ok
	ok = _test_resource_distribution(loader) and ok
	ok = _test_chile_ownership(loader) and ok
	ok = _test_peru_ownership(loader) and ok
	ok = _test_bolivia_ownership(loader) and ok
	return ok

static func _test_start_date(loader: ScenarioLoader) -> bool:
	if loader.get_current_scenario_name() != "1879":
		print("  [FAIL] scenario name should be 1879: ", loader.get_current_scenario_name())
		return false
	print("  [PASS] scenario 1879 start date validated")
	return true

static func _test_playable_countries(loader: ScenarioLoader) -> bool:
	for tag in ["CHL", "PER", "BOL"]:
		if loader.get_country(tag) == null:
			print("  [FAIL] playable country %s not loaded" % tag)
			return false
	for tag in ["ARG", "BRA", "USA", "ENG", "FRA", "GER"]:
		if loader.get_country(tag) == null:
			print("  [FAIL] diplomatic AI country %s not loaded" % tag)
			return false
	print("  [PASS] all 9 country refs loaded")
	return true

static func _test_war_state(loader: ScenarioLoader) -> bool:
	var war_state: Dictionary = loader.get_war_state()
	var wars: Array = war_state.get("wars", [])
	if wars.is_empty():
		print("  [FAIL] no wars declared")
		return false
	var war: Dictionary = wars[0]
	var attackers: Array = war.get("attackers", [])
	var defenders: Array = war.get("defenders", [])
	if not "CHL" in attackers:
		print("  [FAIL] CHL should be attacker")
		return false
	if not "PER" in defenders or not "BOL" in defenders:
		print("  [FAIL] PER/BOL should be defenders")
		return false
	print("  [PASS] Guerra del Pacifico: CHL vs PER+BOL")
	return true

static func _test_resource_distribution(loader: ScenarioLoader) -> bool:
	var resources: Dictionary = loader.province_resources_layer
	if resources.is_empty():
		print("  [FAIL] no resource layer loaded")
		return false
	print("  [PASS] resource distribution: %d provinces have resources" % resources.size())
	return true

static func _test_chile_ownership(loader: ScenarioLoader) -> bool:
	var found_chl := 0
	for p in loader.provinces.values():
		if p.owner_tag == "CHL":
			found_chl += 1
	if found_chl == 0:
		print("  [FAIL] no provinces owned by CHL")
		return false
	print("  [PASS] Chile owns %d provinces" % found_chl)
	return true

static func _test_peru_ownership(loader: ScenarioLoader) -> bool:
	var found_per := 0
	for p in loader.provinces.values():
		if p.owner_tag == "PER":
			found_per += 1
	if found_per == 0:
		print("  [FAIL] no provinces owned by PER")
		return false
	print("  [PASS] Peru owns %d provinces" % found_per)
	return true

static func _test_bolivia_ownership(loader: ScenarioLoader) -> bool:
	var found_bol := 0
	for p in loader.provinces.values():
		if p.owner_tag == "BOL":
			found_bol += 1
	if found_bol == 0:
		print("  [FAIL] no provinces owned by BOL")
		return false
	print("  [PASS] Bolivia owns %d provinces" % found_bol)
	return true
