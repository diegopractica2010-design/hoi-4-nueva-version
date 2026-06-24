extends Node

## Phase 9 evidence runner. This intentionally drives the live autoloads and a loaded
## 1879 scenario; it does not treat method/file existence as gameplay validation.

var _loader: ScenarioLoader
var _results: Dictionary = {}
var _battle_result: Dictionary = {}


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	print("PHASE9|BEGIN|engine=%s" % Engine.get_version_info().get("string", "unknown"))
	_loader = ScenarioLoader.new()
	_loader.name = "ScenarioLoader"
	get_tree().root.add_child(_loader)
	_loader.load_base_provinces()
	var scenario_ok := _loader.load_scenario("1879")
	print("PHASE9|SCENARIO|loaded=%s|provinces=%d|countries=%d|formations=%d" % [
		scenario_ok, _loader.provinces.size(), _loader.countries.size(), LeaderManager.formations.size()
	])
	if not scenario_ok:
		get_tree().quit(1)
		return

	# Let autoload and scenario signals settle before mutating live state.
	await get_tree().process_frame
	_validate_combat()
	_validate_production()
	_validate_technology()
	_validate_supply()
	_validate_trade()
	_validate_events()

	var passed := 0
	for system in _results:
		if bool(_results[system]):
			passed += 1
	print("PHASE9|SUMMARY|passed=%d|total=%d|results=%s" % [passed, _results.size(), JSON.stringify(_results)])
	get_tree().quit(0 if passed == 6 else 2)


func _validate_combat() -> void:
	var target: Province = null
	for province: Province in _loader.provinces.values():
		if not province.is_sea and province.owner_tag.strip_edges().to_upper() == "PER":
			target = province
			break
	var attackers: Array[Formation] = LeaderManager.get_formations_for_country("CHL")
	var defenders: Array[Formation] = LeaderManager.get_formations_for_country("PER")
	if target == null or attackers.is_empty() or defenders.is_empty():
		print("PHASE9|COMBAT|BLOCKED|target=%s|attackers=%d|defenders=%d" % [target != null, attackers.size(), defenders.size()])
		_results["Combat"] = false
		return

	# Concentrate the real scenario formations so the live resolution has a decisive attacker.
	for formation in attackers:
		formation.province_id = target.id
	for formation in defenders:
		formation.province_id = -1
	var attacker := attackers[0]
	var defender := defenders[0]
	defender.province_id = target.id
	attacker.strength = 1.0
	defender.strength = 1.0
	var owner_before := target.owner_tag
	var attacker_power := float(BattleManager.call("_combat_power", attacker, target, false))
	var defender_power := float(BattleManager.call("_combat_power", defender, target, true))
	var side_attacker_power := float(BattleManager.call("_side_power", target.id, "CHL", false))
	var side_defender_power := float(BattleManager.call("_side_power", target.id, "PER", true))
	print("PHASE9|COMBAT|BEFORE|attacker=%s|defender=%s|attacker_strength=%.3f|defender_strength=%.3f|province=%d|owner=%s|combat_power=%.3f/%.3f|side_power=%.3f/%.3f" % [
		attacker.formation_id, defender.formation_id, attacker.strength, defender.strength,
		target.id, owner_before, attacker_power, defender_power, side_attacker_power, side_defender_power
	])
	_battle_result = {}
	var capture_result := func(_pid: int, _winner: String, _loser: String, result: Dictionary) -> void:
		_battle_result = result.duplicate(true)
	BattleManager.battle_resolved.connect(capture_result, CONNECT_ONE_SHOT)
	print("PHASE9|COMBAT|ACTION|method=_resolve_battle|province=%d" % target.id)
	BattleManager.call("_resolve_battle", target.id, attacker.formation_id, defender.formation_id)
	var owner_after := MapManager.get_province_owner(target.id)
	var combat_ok := owner_after == "CHL" and str(_battle_result.get("winner_tag", "")) == "CHL"
	print("PHASE9|COMBAT|AFTER|winner=%s|attacker_casualties=%d|defender_casualties=%d|attacker_strength=%.3f|defender_strength=%.3f|owner_before=%s|owner_after=%s|defender_retreat_province=%d|validated=%s" % [
		_battle_result.get("winner_tag", ""), int(_battle_result.get("attacker_casualties", 0)),
		int(_battle_result.get("defender_casualties", 0)), attacker.strength, defender.strength,
		owner_before, owner_after, defender.province_id, combat_ok
	])
	_results["Combat"] = combat_ok


func _validate_production() -> void:
	const LINE_ID := "phase9_runtime_line"
	const DESIGN_ID := "m3_stuart_light"
	ProductionManager.remove_line(LINE_ID)
	var factory: Factory = null
	for candidate: Factory in FactoryManager.factories.values():
		if candidate.owner_tag == "CHL":
			factory = candidate
			break
	if factory == null:
		print("PHASE9|PRODUCTION|BLOCKED|reason=no_CHL_factory")
		_results["Production"] = false
		return
	# Isolate one real scenario factory slot from earlier suite state.
	factory.assigned_lines.clear()
	var line: ProductionLine = ProductionManager.create_line(LINE_ID)
	var template_result := ProductionManager.set_line_template(LINE_ID, DESIGN_ID)
	var assigned := ProductionManager.assign_line_to_factory(LINE_ID, factory.factory_id)
	ProductionManager.national_stockpile = {
		"steel": 1000000.0, "rubber": 1000000.0, "oil": 1000000.0,
		"aluminum": 1000000.0, "fuel": 1000000.0, "coal": 1000000.0,
	}
	var stock_before := ProductionManager.get_national_stockpile_amount(DESIGN_ID)
	print("PHASE9|PRODUCTION|BEFORE|line=%s|stockpile=%d|factory_id=%d|factory_owner=%s|factory_lines=%d|template_set=%s|assigned=%s" % [
		LINE_ID, stock_before, factory.factory_id, factory.owner_tag, factory.assigned_lines.size(),
		template_result.get("success", false), assigned
	])
	ProductionManager.advance_production(1.0)
	var progress_during := line.progress
	var percent_during := line.get_progress_percent() * 100.0
	print("PHASE9|PRODUCTION|ACTION|advance_days=1|progress=%.4f|required=%.4f|percent=%.2f" % [
		progress_during, line.design_production_cost, percent_during
	])
	var days_run := 1
	while ProductionManager.get_national_stockpile_amount(DESIGN_ID) <= stock_before and days_run < 2000:
		ProductionManager.advance_production(1.0)
		days_run += 1
	var stock_after := ProductionManager.get_national_stockpile_amount(DESIGN_ID)
	var produced := stock_after - stock_before
	var production_ok := line != null and assigned and progress_during > 0.0 and produced > 0
	print("PHASE9|PRODUCTION|AFTER|stockpile=%d|factory_id=%d|factory_lines=%d|completed_count=%d|produced_equipment=%d|days_run=%d|validated=%s" % [
		stock_after, line.factory_id, factory.assigned_lines.size(), line.completed_count,
		produced, days_run, production_ok
	])
	_results["Production"] = production_ok


func _validate_technology() -> void:
	const TAG := "P9T"
	const TECH_ID := "basic_machine_tools"
	TechnologyManager.country_state.erase(TAG)
	TechnologyManager.set_current_year(1879)
	var available: Array[String] = []
	for tech_id in TechnologyManager.technology_nodes.keys():
		if TechnologyManager.get_node_status(TAG, str(tech_id)) == "available":
			available.append(str(tech_id))
	available.sort()
	print("PHASE9|TECHNOLOGY|BEFORE|country=%s|available_count=%d|available=%s|completed=%s" % [
		TAG, available.size(), JSON.stringify(available), TechnologyManager.is_tech_completed(TAG, TECH_ID)
	])
	var started := TechnologyManager.start_research(TAG, TECH_ID)
	var active_before: Array = TechnologyManager.country_state[TAG]["active"]
	var total_days := float((active_before[0] as Dictionary).get("total_days", 1.0)) if not active_before.is_empty() else 1.0
	TechnologyManager.advance_research(total_days * 0.5)
	var active_during: Array = TechnologyManager.country_state[TAG]["active"]
	var progress_days := float((active_during[0] as Dictionary).get("progress_days", 0.0)) if not active_during.is_empty() else 0.0
	var progress_percent := progress_days / total_days * 100.0
	print("PHASE9|TECHNOLOGY|ACTION|start_research=%s|tech=%s|progress_days=%.3f|total_days=%.3f|progress_percent=%.2f" % [
		started, TECH_ID, progress_days, total_days, progress_percent
	])
	TechnologyManager.advance_research(total_days)
	var state_after: Dictionary = TechnologyManager.get_country_state(TAG)
	var tech_ok := started and progress_percent > 0.0 and TechnologyManager.is_tech_completed(TAG, TECH_ID)
	print("PHASE9|TECHNOLOGY|AFTER|completed=%s|status=%s|unlocked_technology=%s|permanent_modifiers=%s|validated=%s" % [
		TechnologyManager.is_tech_completed(TAG, TECH_ID), TechnologyManager.get_node_status(TAG, TECH_ID),
		TECH_ID, JSON.stringify(state_after.get("permanent_modifiers", {})), tech_ok
	])
	_results["Technology"] = tech_ok


func _validate_supply() -> void:
	SupplyManager.build_network(
		_loader.provinces, _loader.countries, _loader.get_city_layer(), _loader.adjacency_system, "CHL"
	)
	var route: SupplyRoutePlan = null
	for candidate: SupplyRoutePlan in SupplyManager.get_all_routes():
		if candidate != null and candidate.path_length() >= 2:
			route = candidate
			break
	var capital_id := SupplyManager.get_capital_hub_id()
	var depot: ProvinceDepotState = SupplyManager.get_depot_state(capital_id)
	var formations: Array[Formation] = LeaderManager.get_formations_for_country("CHL")
	if depot == null or formations.is_empty():
		print("PHASE9|SUPPLY|BLOCKED|capital=%d|depot=%s|formations=%d|routes=%d" % [
			capital_id, depot != null, formations.size(), SupplyManager.get_all_routes().size()
		])
		_results["Supply"] = false
		return
	var formation := formations[0]
	formation.province_id = capital_id
	formation.supply_shortfall = 0.0
	var initial_supply := depot.stockpile
	print("PHASE9|SUPPLY|BEFORE|province=%d|supply_level=%.3f|capacity=%.3f|routes=%d|formation=%s|shortfall=%.3f" % [
		capital_id, initial_supply, depot.storage_capacity, SupplyManager.get_all_routes().size(),
		formation.formation_id, formation.supply_shortfall
	])
	# Generation.
	depot.stockpile = 0.0
	SupplyManager.call("_generate_local_supply_from_development", 1.0)
	var generated_supply := depot.stockpile
	# Routing on the network built from real scenario hubs.
	var routed := false
	var route_before_src := 0.0
	var route_after_src := 0.0
	var route_before_dst := 0.0
	var route_after_dst := 0.0
	var route_id := "none"
	if route != null:
		var src: ProvinceDepotState = SupplyManager.get_depot_state(route.source_province_id)
		var dst: ProvinceDepotState = SupplyManager.get_depot_state(route.target_province_id)
		if src != null and dst != null:
			src.stockpile = minf(src.storage_capacity, maxf(100.0, src.throughput_capacity))
			dst.stockpile = 0.0
			route_before_src = src.stockpile
			route_before_dst = dst.stockpile
			SupplyManager.advance_supply_day(1.0)
			route_after_src = src.stockpile
			route_after_dst = dst.stockpile
			routed = route_after_dst > route_before_dst and route_after_src < route_before_src
			route_id = route.route_id
	# Consumption and shortage.
	depot.stockpile = 0.0
	formation.supply_shortfall = 0.0
	var consumption := SupplyManager.calculate_daily_supply_consumption(formation.formation_id)
	SupplyManager.call("_consume_supply_for_formations", 1.0)
	var shortage_level := formation.supply_shortfall
	# Recovery.
	depot.stockpile = depot.storage_capacity
	SupplyManager.call("_consume_supply_for_formations", 1.0)
	var recovered_level := formation.supply_shortfall
	var supply_after := depot.stockpile
	var supply_ok := generated_supply > 0.0 and routed and consumption > 0.0 and shortage_level > 0.0 and recovered_level < shortage_level
	print("PHASE9|SUPPLY|ACTION|generated=%.3f|route=%s|route_source=%.3f->%.3f|route_target=%.3f->%.3f|consumption=%.3f|shortage=%.4f|recovered=%.4f" % [
		generated_supply, route_id, route_before_src, route_after_src, route_before_dst, route_after_dst,
		consumption, shortage_level, recovered_level
	])
	print("PHASE9|SUPPLY|AFTER|supply_level=%.3f|generation_ok=%s|routing_ok=%s|consumption_ok=%s|shortage_ok=%s|recovery_ok=%s|validated=%s" % [
		supply_after, generated_supply > 0.0, routed, consumption > 0.0,
		shortage_level > 0.0, recovered_level < shortage_level, supply_ok
	])
	_results["Supply"] = supply_ok


func _validate_trade() -> void:
	LeaderManager.set_player_country_tag("CHL")
	ProductionManager.national_stockpile = {"steel": 25.0, "rubber": 100.0}
	var steel_before := float(ProductionManager.national_stockpile.get("steel", 0.0))
	var rubber_before := float(ProductionManager.national_stockpile.get("rubber", 0.0))
	print("PHASE9|TRADE|BEFORE|from=PER|to=CHL|steel=%.3f|rubber=%.3f" % [steel_before, rubber_before])
	var offer_id := TradeManager.create_offer(
		"PER", "CHL",
		[{"type": TradeManager.TradeItemType.RESOURCE, "id": "steel", "quantity": 40.0}],
		[{"type": TradeManager.TradeItemType.RESOURCE, "id": "rubber", "quantity": 10.0}],
		TradeManager.TradeVisibility.PUBLIC
	)
	var fairness := TradeManager.evaluate_fairness(offer_id, "CHL")
	var accepted := TradeManager.accept_offer(offer_id)
	var steel_after := float(ProductionManager.national_stockpile.get("steel", 0.0))
	var rubber_after := float(ProductionManager.national_stockpile.get("rubber", 0.0))
	var trade_ok := not offer_id.is_empty() and not fairness.is_empty() and accepted and steel_after > steel_before and rubber_after < rubber_before
	print("PHASE9|TRADE|ACTION|offer_id=%s|fairness_score=%.4f|recommendation=%s|accepted=%s" % [
		offer_id, float(fairness.get("score", 0.0)), str(fairness.get("recommendation", "")), accepted
	])
	print("PHASE9|TRADE|AFTER|steel=%.3f|rubber=%.3f|steel_delta=%.3f|rubber_delta=%.3f|resources_moved=%s|validated=%s" % [
		steel_after, rubber_after, steel_after - steel_before, rubber_after - rubber_before,
		steel_after != steel_before and rubber_after != rubber_before, trade_ok
	])
	_results["Trade"] = trade_ok


func _validate_events() -> void:
	const FROM := "P9A"
	const TO := "P9B"
	const EVENT_ID := "phase9_runtime_alliance"
	DiplomacyManager.alliances.erase(DiplomacyManager.call("_alliance_key", FROM, TO))
	DiplomacyManager.set_relation(FROM, TO, 60)
	var trigger := {"type": "relation", "from": FROM, "to": TO, "comparison": ">=", "value": 50}
	var event := {
		"id": EVENT_ID,
		"name": "Phase 9 Runtime Alliance",
		"repeatable": false,
		"trigger": trigger,
		"effects": [{"type": "diplomacy", "action": "form_alliance", "from": FROM, "to": TO}],
	}
	var relation_before := DiplomacyManager.get_relation(FROM, TO)
	var alliance_before := DiplomacyManager.has_alliance(FROM, TO)
	print("PHASE9|EVENTS|BEFORE|relation=%d|alliance=%s|event_fired=%s" % [
		relation_before, alliance_before, EVENT_ID in EventManager.get_save_data().get("fired_events", [])
	])
	var trigger_passed := bool(EventManager.call("_check_trigger", trigger, 1879, 2, 14))
	if trigger_passed:
		EventManager.call("_fire_event", event)
	var relation_after := DiplomacyManager.get_relation(FROM, TO)
	var alliance_after := DiplomacyManager.has_alliance(FROM, TO)
	var fired_after: bool = EVENT_ID in (EventManager.get_save_data().get("fired_events", []) as Array)
	var events_ok: bool = trigger_passed and alliance_after and not alliance_before and relation_after != relation_before and fired_after
	print("PHASE9|EVENTS|ACTION|check_trigger=%s|fire_event=%s|effect=diplomacy.form_alliance" % [trigger_passed, trigger_passed])
	print("PHASE9|EVENTS|AFTER|relation=%d|alliance=%s|event_fired=%s|state_changed=%s|validated=%s" % [
		relation_after, alliance_after, fired_after,
		alliance_after != alliance_before or relation_after != relation_before, events_ok
	])
	_results["Events"] = events_ok
