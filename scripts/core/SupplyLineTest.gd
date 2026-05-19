class_name SupplyLineTest
extends RefCounted


static func run_all(loader: ScenarioLoader) -> bool:
	var ok := true
	ok = _test_hubs_built(loader) and ok
	ok = _test_route_timing(loader) and ok
	ok = _test_reroute_longer(loader) and ok
	ok = _test_unit_supply_profile() and ok
	ok = _test_intel_from_forces(loader) and ok
	ok = _test_multimodal_routing(loader) and ok
	ok = _test_attrition_cargo() and ok
	return ok


static func _rules_and_adjacency(loader: ScenarioLoader) -> Array:
	var rules := SupplyRules.load_from_path()
	var adj := AdjacencySystem.new()
	adj.load_adjacency()
	adj.begin_bulk_registration()
	for p in loader.provinces.values():
		adj.register_province(p)
	adj.end_bulk_registration()
	return [rules, adj]


static func _test_hubs_built(loader: ScenarioLoader) -> bool:
	var parts: Array = _rules_and_adjacency(loader)
	var hubs := SupplyNetworkBuilder.build(
		loader.provinces, loader.countries, loader.get_city_layer(), [], parts[0],
	)
	var passed := hubs.size() > 10
	print(("  [PASS] supply hubs=%d" if passed else "  [FAIL] supply hubs=%d") % hubs.size())
	return passed


static func _province_tag(province: Province) -> String:
	if not province.controller_tag.is_empty():
		return province.controller_tag
	return province.owner_tag


static func _test_route_timing(loader: ScenarioLoader) -> bool:
	var parts: Array = _rules_and_adjacency(loader)
	var rules: SupplyRules = parts[0]
	var adj: AdjacencySystem = parts[1]
	var hubs := SupplyNetworkBuilder.build(
		loader.provinces, loader.countries, loader.get_city_layer(), [], rules,
	)
	var plan := SupplyRoutePlan.new()
	for pid_var in loader.provinces:
		var province: Province = loader.provinces[pid_var]
		var tag := _province_tag(province)
		if tag.is_empty():
			continue
		for neighbor_id in adj.get_neighbors(province.id):
			var neighbor: Province = loader.provinces.get(neighbor_id)
			if neighbor == null or _province_tag(neighbor) != tag:
				continue
			var candidate := SupplyPathfinder.find_route(
				province.id, neighbor_id, tag, loader.provinces, adj, hubs, rules,
			)
			if candidate.path_length() >= 2 and candidate.total_days > 0.0:
				plan = candidate
				break
		if plan.path_length() >= 2:
			break
	var passed := plan.total_days > 0.0 and plan.path_length() >= 2
	print(
		("  [PASS] route days=%.2f hops=%d" if passed else "  [FAIL] route days=%.2f hops=%d")
		% [plan.total_days, plan.path_length()],
	)
	return passed


static func _test_reroute_longer(loader: ScenarioLoader) -> bool:
	var parts: Array = _rules_and_adjacency(loader)
	var rules: SupplyRules = parts[0]
	var adj: AdjacencySystem = parts[1]
	var hubs := SupplyNetworkBuilder.build(
		loader.provinces, loader.countries, loader.get_city_layer(), [], rules,
	)
	var tag := ""
	var capital_id := -1
	for hub: ProvinceSupplyHub in hubs.values():
		if hub.has_kind(ProvinceSupplyHub.DepotKind.CAPITAL):
			capital_id = hub.province_id
			tag = hub.owner_tag
			break
	if capital_id < 0:
		print("  [SKIP] reroute test: no capital")
		return true
	var direct := SupplyRoutePlan.new()
	var via_id := -1
	for hid in hubs:
		if int(hid) == capital_id:
			continue
		var hub: ProvinceSupplyHub = hubs[hid]
		if hub.owner_tag != tag:
			continue
		var candidate := SupplyPathfinder.find_route(
			capital_id, int(hid), tag, loader.provinces, adj, hubs, rules,
		)
		if candidate.path_length() >= 3:
			direct = candidate
			via_id = int(candidate.province_path[candidate.province_path.size() / 2])
			break
	if direct.path_length() < 3:
		print("  [SKIP] reroute test: no multi-hop friendly route")
		return true
	var target: int = direct.target_province_id
	var detour := SupplyPathfinder.find_route(
		capital_id, target, tag, loader.provinces, adj, hubs, rules, [via_id],
	)
	var passed := detour.total_days >= direct.total_days and detour.path_length() >= 2
	print(
		("  [PASS] reroute direct=%.2f detour=%.2f" if passed else "  [FAIL] reroute direct=%.2f detour=%.2f")
		% [direct.total_days, detour.total_days],
	)
	return passed


static func _test_unit_supply_profile() -> bool:
	var rules := SupplyRules.load_from_path()
	var tpl: UnitTemplate = UnitTemplate.new()
	tpl.id = "test_tank"
	tpl.crew_required = 5
	tpl.base_stats = {"supply_need": 14.0, "fuel_consumption": 9.0}
	var req := UnitSupplyRequirements.from_template(tpl, rules)
	var stored: Dictionary = req.daily_consumption_cargo("stored_at_hub", rules)
	var combat: Dictionary = req.daily_consumption_cargo("combat", rules)
	var passed: bool = (
		float(stored.get("fuel", 0.0)) < float(combat.get("fuel", 0.0))
		and req.crew_replacement_cargo > 0.0
	)
	print("  [PASS] unit supply stored<combat" if passed else "  [FAIL] unit supply rates")
	return passed


static func _test_intel_from_forces(loader: ScenarioLoader) -> bool:
	var parts: Array = _rules_and_adjacency(loader)
	var rules: SupplyRules = parts[0]
	var registry := CombatPresenceRegistry.new()
	registry.add_air_presence(6, "RUS", 4.0)
	registry.add_land_presence(6, "RUS", 2.0)
	var manager_script: GDScript = load("res://scripts/supply/SupplyManager.gd")
	var manager: Node = manager_script.new()
	manager.rules = rules
	manager.provinces = loader.provinces
	manager.hubs = SupplyNetworkBuilder.build(
		loader.provinces, loader.countries, loader.get_city_layer(), [], rules,
	)
	manager.player_tag = "USA"
	SupplyIntelBridge.refresh_manager(manager, "USA", registry, loader.provinces, manager.hubs, rules)
	var presence: Dictionary = manager.get_enemy_presence().get(6, {})
	var passed: bool = float(presence.get("enemy_air_superiority", 0.0)) > 0.0
	print(("  [PASS] intel air threat %s" if passed else "  [FAIL] intel air threat %s") % str(presence))
	return passed


static func _test_multimodal_routing(loader: ScenarioLoader) -> bool:
	var parts: Array = _rules_and_adjacency(loader)
	var rules: SupplyRules = parts[0]
	var adj: AdjacencySystem = parts[1]
	var hubs := SupplyNetworkBuilder.build(
		loader.provinces, loader.countries, loader.get_city_layer(), [], rules,
	)
	var cargo := SupplyCargoProfile.general_supplies(3000.0)
	cargo.prefers_sea = true
	cargo.prefers_air = true
	var source := -1
	var target := -1
	for pid_var in loader.provinces:
		var p: Province = loader.provinces[pid_var]
		var tag := _province_tag(p)
		if tag.is_empty():
			continue
		for nid in adj.get_neighbors(p.id):
			var n: Province = loader.provinces.get(nid)
			if n != null and _province_tag(n) == tag:
				source = p.id
				target = nid
				break
		if source >= 0:
			break
	if source < 0:
		print("  [SKIP] multimodal routing")
		return true
	var plan := SupplyMultimodalRouter.find_best_route(
		source, target, _province_tag(loader.provinces[source]),
		loader.provinces, adj, hubs, rules, cargo,
	)
	var passed: bool = plan.path_length() >= 2 and not plan.routing_mode.is_empty()
	print(
		("  [PASS] multimodal mode=%s" if passed else "  [FAIL] multimodal mode=%s") % plan.routing_mode,
	)
	return passed


static func _test_attrition_cargo() -> bool:
	var rules := SupplyRules.load_from_path()
	var ledger := AttritionReplenishmentLedger.new()
	ledger.record_manpower_loss("us_infantry_div_ww2", 400)
	ledger.record_equipment_loss("m4_sherman_medium", 3.0)
	var summary: Dictionary = ledger.compute_replenishment_cargo(null, null, rules)
	var passed: bool = float(summary.get("total_tons", 0.0)) > 0.0
	print("  [PASS] attrition cargo=%.1f" % summary.get("total_tons", 0.0) if passed else "  [FAIL] attrition")
	return passed
