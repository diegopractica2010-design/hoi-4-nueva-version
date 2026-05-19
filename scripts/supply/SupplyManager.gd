extends Node

## National supply: depots, multimodal routes, intel-driven interdiction, attrition cargo.

signal network_rebuilt(hub_count: int)
signal route_updated(route_id: String, plan: SupplyRoutePlan)
signal overlay_toggled(visible: bool)
signal depot_stock_changed(province_id: int, stockpile: float)

var rules: SupplyRules = null
var hubs: Dictionary = {}
var depot_states: Dictionary = {}
var provinces: Dictionary = {}
var adjacency: AdjacencySystem = null
var player_tag: String = "USA"

var player_depot_province_ids: Array[int] = []
var force_registry: CombatPresenceRegistry = CombatPresenceRegistry.new()
var attrition_ledger: AttritionReplenishmentLedger = AttritionReplenishmentLedger.new()
var division_templates: DivisionTemplateLoader = DivisionTemplateLoader.new()

var _countries: Dictionary = {}
var _city_layer: Dictionary = {}
var _routes: Dictionary = {}
var _default_routes: Dictionary = {}
var overlay_visible: bool = false
var routing_mode_override: String = ""
var active_cargo: SupplyCargoProfile = null

var _pending_waypoints: Array[int] = []
var _reroute_source_id: int = -1
var _reroute_target_id: int = -1
var _selected_province_id: int = -1


func _ready() -> void:
	rules = SupplyRules.load_from_path()
	division_templates.load_all()
	active_cargo = SupplyCargoProfile.general_supplies(500.0)


func build_network(
	p_provinces: Dictionary,
	p_countries: Dictionary,
	city_layer: Dictionary,
	p_adjacency: AdjacencySystem,
	tag: String = "",
) -> void:
	provinces = p_provinces
	_countries = p_countries
	_city_layer = city_layer
	adjacency = p_adjacency
	if not tag.is_empty():
		player_tag = tag
	hubs = SupplyNetworkBuilder.build(
		provinces, p_countries, city_layer, player_depot_province_ids, rules,
	)
	_init_depot_states()
	refresh_intel_from_forces()
	_rebuild_default_routes()
	network_rebuilt.emit(hubs.size())


func _init_depot_states() -> void:
	depot_states.clear()
	for pid_var in hubs:
		var hub: ProvinceSupplyHub = hubs[pid_var]
		var throughput_rules := rules.get_block("throughput")
		var state := ProvinceDepotState.new(hub.province_id, hub.storage_capacity)
		state.throughput_capacity = hub.storage_capacity * float(
			throughput_rules.get("capacity_fraction_per_day", 0.15),
		)
		state.stockpile = hub.storage_capacity * float(throughput_rules.get("initial_fill_ratio", 0.65))
		depot_states[hub.province_id] = state


func get_depot_state(province_id: int) -> ProvinceDepotState:
	return depot_states.get(province_id)


func get_capital_hub_id() -> int:
	for hub: ProvinceSupplyHub in hubs.values():
		if hub.owner_tag == player_tag and hub.has_kind(ProvinceSupplyHub.DepotKind.CAPITAL):
			return hub.province_id
	return -1


func set_player_depot(province_id: int, enabled: bool) -> void:
	if enabled and province_id not in player_depot_province_ids:
		player_depot_province_ids.append(province_id)
	elif not enabled and province_id in player_depot_province_ids:
		player_depot_province_ids.erase(province_id)
	if not provinces.is_empty():
		build_network(provinces, _countries, _city_layer, adjacency, player_tag)


func set_selected_province(province_id: int) -> void:
	_selected_province_id = province_id


func get_selected_province_id() -> int:
	return _selected_province_id


func set_routing_mode(mode: String) -> void:
	routing_mode_override = mode


func set_active_cargo_from_template(template: UnitTemplate) -> void:
	active_cargo = SupplyCargoProfile.from_template(template, rules)


func set_active_cargo_tons(tons: float) -> void:
	active_cargo = SupplyCargoProfile.general_supplies(tons)


func register_unit_presence(
	province_id: int,
	owner_tag: String,
	template: UnitTemplate,
	count: float = 1.0,
) -> void:
	force_registry.add_unit(province_id, owner_tag, template, count)


func register_force_report(province_id: int, report: ProvinceForceReport) -> void:
	force_registry.set_report(province_id, report)


func clear_force_registry() -> void:
	force_registry.clear()


func refresh_intel_from_forces() -> void:
	SupplyIntelBridge.refresh_manager(self, player_tag, force_registry, provinces, hubs, rules)


func set_enemy_presence(province_id: int, presence: Dictionary) -> void:
	var store: Dictionary = get_meta("enemy_presence") if has_meta("enemy_presence") else {}
	store[province_id] = presence
	set_meta("enemy_presence", store)


func get_enemy_presence() -> Dictionary:
	return get_meta("enemy_presence") if has_meta("enemy_presence") else {}


func record_attrition(division_id: String, manpower_lost: int, equipment_losses: Dictionary = {}) -> void:
	attrition_ledger.record_manpower_loss(division_id, manpower_lost)
	for tpl_id in equipment_losses:
		attrition_ledger.record_equipment_loss(str(tpl_id), float(equipment_losses[tpl_id]))


func get_attrition_cargo_summary() -> Dictionary:
	var design_data: DesignDataLoader = null
	var gd := get_node_or_null("/root/GameData")
	if gd != null and "design_data" in gd:
		design_data = gd.design_data
	return attrition_ledger.compute_replenishment_cargo(division_templates, design_data, rules)


func advance_supply_day(days: float = 1.0) -> void:
	if days <= 0.0:
		return
	var attrition := get_attrition_cargo_summary()
	var attrition_tons := float(attrition.get("total_tons", 0.0)) * days
	for key in _routes:
		var plan: SupplyRoutePlan = _routes[key]
		if plan == null or plan.path_length() < 2:
			continue
		var src: ProvinceDepotState = depot_states.get(plan.source_province_id)
		var dst: ProvinceDepotState = depot_states.get(plan.target_province_id)
		if src == null or dst == null:
			continue
		var ship_tons := plan.cargo_tons_per_day * days
		if ship_tons <= 0.0:
			ship_tons = src.throughput_capacity * days * 0.25
		ship_tons += attrition_tons / maxf(float(_routes.size()), 1.0)
		var pulled := src.pull_outflow(ship_tons)
		var overflow := dst.apply_inflow(pulled * (1.0 - plan.interdiction_chance))
		if overflow > 0.0 and src != null:
			src.apply_inflow(overflow * 0.5)
		depot_stock_changed.emit(dst.province_id, dst.stockpile)


func begin_player_reroute(source_province_id: int, target_province_id: int) -> void:
	_reroute_source_id = source_province_id
	_reroute_target_id = target_province_id
	_pending_waypoints.clear()


func set_reroute_target(province_id: int) -> void:
	_reroute_target_id = province_id


func add_reroute_waypoint(province_id: int) -> void:
	if province_id not in _pending_waypoints:
		_pending_waypoints.append(province_id)
	set_reroute_target(province_id)


func clear_reroute_waypoints() -> void:
	_pending_waypoints.clear()


func preview_player_route() -> SupplyRoutePlan:
	return _plan_route(_reroute_source_id, _reroute_target_id, _pending_waypoints, true)


func commit_player_route(route_key: String = "") -> SupplyRoutePlan:
	var plan := preview_player_route()
	if plan.path_length() < 2:
		return plan
	var key := route_key if not route_key.is_empty() else "%d_%d" % [_reroute_source_id, _reroute_target_id]
	var baseline: SupplyRoutePlan = _default_routes.get(key)
	if baseline != null:
		plan.baseline_days = baseline.total_days
		plan.extra_days_from_reroute = plan.total_days - baseline.total_days
	plan.route_id = key
	plan.is_player_override = true
	_routes[key] = plan
	route_updated.emit(key, plan)
	return plan


func get_route(route_key: String) -> SupplyRoutePlan:
	return _routes.get(route_key)


func get_all_routes() -> Array:
	return _routes.values()


func get_depot_menu_lines(limit: int = 6) -> PackedStringArray:
	var lines := PackedStringArray()
	var ranked: Array = []
	for pid_var in depot_states:
		var state: ProvinceDepotState = depot_states[pid_var]
		ranked.append([state.stockpile, state.province_id, state])
	ranked.sort_custom(func(a, b): return a[0] > b[0])
	for i in mini(ranked.size(), limit):
		var row: Array = ranked[i]
		var s: ProvinceDepotState = row[2]
		lines.append(
			"P%d: %.0f/%.0f t (%.0f t/day)" % [
				s.province_id, s.stockpile, s.storage_capacity, s.throughput_capacity,
			],
		)
	return lines


func toggle_overlay() -> void:
	overlay_visible = not overlay_visible
	overlay_toggled.emit(overlay_visible)


func seed_demo_enemy_forces(sample_tags: Array[String] = []) -> void:
	force_registry.clear()
	if sample_tags.is_empty():
		sample_tags = ["RUS", "CHN", "IRN", "PRK"]
	var border_candidates: Array[int] = []
	for pid_var in provinces:
		var province: Province = provinces[pid_var]
		if _ctrl(province) != player_tag:
			continue
		for adj_id in province.adjacencies:
			var adj: Province = provinces.get(adj_id)
			if adj != null and _ctrl(adj) != player_tag and not _ctrl(adj).is_empty():
				border_candidates.append(province.id)
				break
	var tag_i := 0
	for pid in border_candidates.slice(0, mini(border_candidates.size(), 12)):
		var enemy_tag: String = sample_tags[tag_i % sample_tags.size()]
		tag_i += 1
		force_registry.add_air_presence(pid, enemy_tag, 1.2 + float(tag_i) * 0.15)
		force_registry.add_land_presence(pid, enemy_tag, 0.8)
		var hub: ProvinceSupplyHub = hubs.get(pid)
		if hub != null and hub.port_level > 0:
			force_registry.add_naval_presence(pid, enemy_tag, 1.5, true)
	refresh_intel_from_forces()


func _plan_route(
	source_id: int,
	target_id: int,
	waypoints: Array[int],
	player_override: bool,
) -> SupplyRoutePlan:
	var cargo := active_cargo if active_cargo != null else SupplyCargoProfile.general_supplies(500.0)
	var plan := SupplyMultimodalRouter.find_best_route(
		source_id, target_id, player_tag, provinces, adjacency, hubs, rules,
		cargo, waypoints, routing_mode_override,
	)
	plan.is_player_override = player_override
	var enemy_presence: Dictionary = get_enemy_presence()
	var inter := SupplyInterdictionEstimator.estimate(
		plan.province_path, provinces, hubs, player_tag, rules, enemy_presence,
	)
	plan.interdiction_chance = float(inter.get("chance", 0.0))
	plan.interdiction_breakdown = inter.get("breakdown", {})
	var attrition := get_attrition_cargo_summary()
	plan.cargo_tons_per_day = maxf(plan.cargo_tons_per_day, float(attrition.get("total_tons", 0.0)))
	return plan


func _rebuild_default_routes() -> void:
	_default_routes.clear()
	_routes.clear()
	var source := get_capital_hub_id()
	if source < 0:
		return
	var targets: Array[int] = []
	for hub: ProvinceSupplyHub in hubs.values():
		if hub.owner_tag == player_tag and hub.province_id != source:
			targets.append(hub.province_id)
	targets.sort()
	var max_routes := mini(targets.size(), 24)
	for i in range(max_routes):
		var target := targets[i]
		var key := "%d_%d" % [source, target]
		var plan := _plan_route(source, target, [], false)
		plan.route_id = key
		plan.baseline_days = plan.total_days
		_default_routes[key] = plan
		_routes[key] = plan


func _ctrl(province: Province) -> String:
	if not province.controller_tag.is_empty():
		return province.controller_tag
	return province.owner_tag
