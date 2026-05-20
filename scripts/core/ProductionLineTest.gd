class_name ProductionLineTest
extends RefCounted

## Headless checks for the production line system. Call from TestRunner or the Godot CLI.


static func run_all(design_data: DesignDataLoader) -> bool:
	var ok := true
	ok = _test_data_loaded(design_data) and ok
	ok = _test_retooling_similarity(design_data) and ok
	ok = _test_production_and_tooling(design_data) and ok
	ok = _test_new_design_reliability_debuff(design_data) and ok
	ok = _test_refinement(design_data) and ok
	ok = _test_refinement_tradeoffs(design_data) and ok
	ok = _test_production_manager() and ok
	ok = _test_equipment_shortages() and ok
	ok = _test_national_equipment_stockpile() and ok
	ok = _test_infantry_equipment_stats(design_data) and ok
	ok = _test_priority_reinforcement() and ok
	ok = _test_sustainment_equipment(design_data) and ok
	ok = _test_cargo_logistics(design_data) and ok
	ok = _test_armed_cargo_penalty(design_data) and ok
	ok = _test_armed_merchant_template(design_data) and ok
	return ok


static func _get_production_manager() -> Node:
	var tree := Engine.get_main_loop()
	if tree == null:
		return null
	return tree.root.get_node_or_null("ProductionManager")


static func _test_production_manager() -> bool:
	var pm := _get_production_manager()
	if pm == null:
		print("  [SKIP] ProductionManager autoload not available (headless CLI)")
		return true

	pm.remove_line("mgr_test_a")
	pm.remove_line("mgr_test_b")

	pm.set_production_stance("quantity")
	pm.apply_doctrine("land_mass_production")

	var line_a = pm.create_line("mgr_test_a")
	var line_b = pm.create_line("mgr_test_b")
	line_a != null and line_b != null

	pm.set_line_template("mgr_test_a", "m3_stuart_light")
	pm.set_line_template("mgr_test_b", "m4_sherman_medium")

	var report: Dictionary = pm.advance_days(150.0)
	var units := int(report.get("total_units_completed", 0))
	var family_units: int = pm.get_family_units_produced("us_armored_ww2")

	pm.set_production_stance("balanced")
	pm.revoke_doctrine("land_mass_production")
	pm.remove_line("mgr_test_a")
	pm.remove_line("mgr_test_b")

	var passed := units >= 1 and family_units >= 1
	if passed:
		print("  [PASS] ProductionManager units=", units, " family=", family_units)
	else:
		print("  [FAIL] ProductionManager units=", units, " family=", family_units)
	return passed


static func _test_data_loaded(design_data: DesignDataLoader) -> bool:
	var modules_ok := design_data.modules.size() >= 6
	var templates_ok := design_data.templates.has("m3_stuart_light") and design_data.templates.has("m4_sherman_medium")
	var rules_ok := not design_data.production_rules.is_empty()
	if modules_ok and templates_ok and rules_ok:
		print("  [PASS] design data loaded")
		return true
	print("  [FAIL] design data loaded (modules=", design_data.modules.size(), " templates=", design_data.templates.keys(), ")")
	return false


static func _test_retooling_similarity(design_data: DesignDataLoader) -> bool:
	var stuart: UnitTemplate = design_data.get_template("m3_stuart_light")
	var sherman: UnitTemplate = design_data.get_template("m4_sherman_medium")
	var rules := design_data.production_rules
	var similarity := RetoolingCalculator.compute_similarity(stuart, sherman, rules)
	var days := RetoolingCalculator.compute_retooling_days(similarity, rules)
	# Shared engine + same base_type → partial similarity, not full retool.
	var passed := similarity > 0.3 and similarity < 1.0 and days > 3.0 and days < 42.0
	if passed:
		print("  [PASS] retooling similarity=", similarity, " days=", days)
	else:
		print("  [FAIL] retooling similarity=", similarity, " days=", days)
	return passed


static func _test_production_and_tooling(design_data: DesignDataLoader) -> bool:
	var line := ProductionLine.new(design_data, "test_line")
	line.set_template("m3_stuart_light")
	var initial_reliability := line.get_effective_reliability()
	var report := line.advance_days(120.0)
	var tooling := line.get_tooling_efficiency()
	var passed: bool = (
		int(report.get("units_completed", 0)) >= 1
		and tooling > 0.0
		and line.get_effective_reliability() >= initial_reliability
	)
	if passed:
		print("  [PASS] production units=", report["units_completed"], " tooling=", tooling)
	else:
		print("  [FAIL] production report=", report, " tooling=", tooling)
	return passed


static func _test_new_design_reliability_debuff(design_data: DesignDataLoader) -> bool:
	var line := ProductionLine.new(design_data, "immature_line")
	line.set_template("m4_sherman_medium")
	var profile := line.get_reliability_profile()
	var passed := (
		profile.design_maturity < 0.05
		and profile.effective_reliability < profile.paper_reliability * 0.72
		and profile.maintenance_index > 0.25
		and profile.combat_readiness < 0.85
	)
	if passed:
		print(
			"  [PASS] new design debuff reliability=",
			profile.effective_reliability,
			" maintenance=",
			profile.maintenance_index,
		)
	else:
		print("  [FAIL] new design profile ", profile.effective_reliability, profile.maintenance_index)
	return passed


static func _test_refinement(design_data: DesignDataLoader) -> bool:
	var line := ProductionLine.new(design_data, "refine_line")
	line.set_template("m4_sherman_medium")
	var before := line.get_reliability_profile()
	if not line.start_refinement("quality_control"):
		print("  [FAIL] could not start refinement project")
		return false
	line.advance_days(30.0)
	var after := line.get_reliability_profile()
	var passed := after.effective_reliability > before.effective_reliability
	if passed:
		print("  [PASS] refinement raised reliability ", before.effective_reliability, " -> ", after.effective_reliability)
	else:
		print("  [FAIL] refinement reliability ", before.effective_reliability, " -> ", after.effective_reliability)
	return passed


static func _test_cargo_logistics(design_data: DesignDataLoader) -> bool:
	var line := ProductionLine.new(design_data, "cargo_line")
	line.set_template("container_ship_2026_transport")
	var profile := line.get_reliability_profile()
	var passed := (
		profile.base_cargo_capacity > 40000.0
		and profile.effective_cargo_capacity > profile.base_cargo_capacity * 0.95
		and profile.armed_weapon_slots == 0
		and profile.logistics_supply_demand > 0.0
	)
	if passed:
		print(
			"  [PASS] cargo logistics capacity=",
			profile.effective_cargo_capacity,
			" supply_demand=",
			profile.logistics_supply_demand,
		)
	else:
		print(
			"  [FAIL] cargo logistics base=",
			profile.base_cargo_capacity,
			" effective=",
			profile.effective_cargo_capacity,
		)
	return passed


static func _test_armed_cargo_penalty(design_data: DesignDataLoader) -> bool:
	var line := ProductionLine.new(design_data, "armed_cargo_line")
	line.set_template("gmc_6x6_cargo_truck")
	var unarmed := line.get_reliability_profile()

	line.set_slot_module("MainWeapon", "bm13_katyusha_rack")
	var armed := line.get_reliability_profile()

	var passed := (
		unarmed.effective_cargo_capacity > armed.effective_cargo_capacity
		and armed.armed_weapon_slots == 1
		and armed.combat_soft_attack > unarmed.combat_soft_attack
		and armed.maintenance_index >= unarmed.maintenance_index
	)
	if passed:
		print(
			"  [PASS] armed truck cargo ",
			unarmed.effective_cargo_capacity,
			" -> ",
			armed.effective_cargo_capacity,
			" soft_atk=",
			armed.combat_soft_attack,
		)
	else:
		print(
			"  [FAIL] armed cargo penalty unarmed=",
			unarmed.effective_cargo_capacity,
			" armed=",
			armed.effective_cargo_capacity,
			" slots=",
			armed.armed_weapon_slots,
		)
	return passed


static func _test_armed_merchant_template(design_data: DesignDataLoader) -> bool:
	var line := ProductionLine.new(design_data, "merchant_line")
	line.set_template("armed_merchant_2026_armed")
	var armed := line.get_reliability_profile()

	line.set_template("container_ship_2026_transport")
	var transport := line.get_reliability_profile()

	var passed := (
		armed.armed_weapon_slots >= 2
		and armed.effective_cargo_capacity < armed.base_cargo_capacity * 0.5
		and armed.combat_anti_ship > 0.0
		and transport.effective_cargo_capacity > armed.effective_cargo_capacity * 2.0
	)
	if passed:
		print(
			"  [PASS] armed merchant cargo=",
			armed.effective_cargo_capacity,
			" vs container=",
			transport.effective_cargo_capacity,
		)
	else:
		print(
			"  [FAIL] armed merchant effective=",
			armed.effective_cargo_capacity,
			" slots=",
			armed.armed_weapon_slots,
		)
	return passed


static func _test_equipment_shortages() -> bool:
	var tracker := EquipmentShortageTracker.new()
	var required := {"rifle": 100, "m4_sherman_medium": 10}
	var stock := {"rifle": 80, "m4_sherman_medium": 10}
	var shortages := tracker.calculate_shortages(required, stock)
	if shortages.get("rifle", 0) != 20 or shortages.has("m4_sherman_medium"):
		print("  [FAIL] equipment shortage calculation: ", shortages)
		return false

	var readiness := tracker.get_readiness_from_shortages(shortages, required)
	if readiness <= 0.3 or readiness >= 1.0:
		print("  [FAIL] readiness penalty out of range: ", readiness)
		return false

	var pm := _get_production_manager()
	if pm == null:
		print("  [PASS] equipment shortages (tracker only; no autoload)")
		return true

	pm.set_national_equipment_stockpile({})
	pm.clear_unit_equipment_stock("test_div_1")
	pm.set_unit_equipment_stock("test_div_1", stock)
	var report: Dictionary = pm.get_shortage_report("test_div_1", required)
	if int(report.get("missing_equipment", {}).get("rifle", 0)) != 20:
		print("  [FAIL] ProductionManager shortage report: ", report)
		return false

	var modified := pm.apply_equipment_shortage_modifiers("test_div_1", 1.0, required)
	if absf(modified - readiness) > 0.001:
		print("  [FAIL] apply_equipment_shortage_modifiers: ", modified, " vs ", readiness)
		return false

	pm.clear_unit_equipment_stock("test_div_1")
	print("  [PASS] equipment shortages and readiness penalties")
	return true


static func _test_national_equipment_stockpile() -> bool:
	var pm := _get_production_manager()
	if pm == null:
		print("  [SKIP] national equipment stockpile (no autoload)")
		return true

	pm.set_national_equipment_stockpile({})
	pm.clear_unit_equipment_stock("stock_test_unit")

	pm.add_to_national_stockpile("m4_sherman_medium", 5)
	if pm.get_national_stockpile_amount("m4_sherman_medium") != 5:
		print("  [FAIL] add_to_national_stockpile")
		return false

	var taken := pm.take_from_national_stockpile("m4_sherman_medium", 2)
	if taken != 2 or pm.get_national_stockpile_amount("m4_sherman_medium") != 3:
		print("  [FAIL] take_from_national_stockpile: taken=", taken)
		return false

	pm.add_to_national_stockpile("rifle", 100)
	var required := {"rifle": 80, "m4_sherman_medium": 2}
	# Shortages use unit + national totals (50 + 30 = 80 available → 20 short of 100)
	pm.set_national_equipment_stockpile({"rifle": 30, "m4_sherman_medium": 3})
	pm.set_unit_equipment_stock("stock_test_unit", {"rifle": 50})
	var pre_shortages := pm.get_unit_shortages("stock_test_unit", {"rifle": 100})
	if int(pre_shortages.get("rifle", 0)) != 20:
		print("  [FAIL] national-aware shortages: ", pre_shortages)
		return false

	var fulfilled := pm.auto_reinforce_unit_from_stockpile("stock_test_unit", required)
	if int(fulfilled.get("rifle", 0)) != 80 or int(fulfilled.get("m4_sherman_medium", 0)) != 2:
		print("  [FAIL] auto_reinforce_unit_from_stockpile: ", fulfilled)
		return false

	var report := pm.get_shortage_report("stock_test_unit", required)
	if not report.get("missing_equipment", {}).is_empty():
		print("  [FAIL] unit should be fully reinforced: ", report)
		return false

	pm.clear_unit_equipment_stock("stock_test_unit")
	pm.set_national_equipment_stockpile({})
	print("  [PASS] national equipment stockpile and unit reinforcement")
	return true


static func _test_infantry_equipment_stats(design_data: DesignDataLoader) -> bool:
	var garand := design_data.get_template("infantry_m1_garand")
	if garand == null:
		print("  [FAIL] infantry_m1_garand template missing")
		return false
	var stats := garand.get_infantry_stats()
	if float(stats.get("soft_attack", 0.0)) < 1.4:
		print("  [FAIL] garand soft_attack too low: ", stats)
		return false

	var supply := Engine.get_main_loop().root.get_node_or_null("/root/SupplyManager")
	if supply == null:
		print("  [PASS] infantry equipment stats (templates only)")
		return true

	supply.division_templates.load_all()
	var div: DivisionTemplate = supply.division_templates.get_division("us_infantry_div_ww2")
	if div == null:
		print("  [PASS] infantry equipment stats (no division template)")
		return true

	var agg := div.get_aggregated_infantry_stats(design_data)
	if float(agg.get("soft_attack", 0.0)) <= 0.0:
		print("  [FAIL] division aggregated infantry stats: ", agg)
		return false

	var german_mixed := supply.division_templates.get_division("german_infantry_division_1943_mixed")
	if german_mixed == null:
		print("  [FAIL] german_infantry_division_1943_mixed missing")
		return false
	var mixed_stats := german_mixed.get_aggregated_infantry_stats(design_data)
	if int(mixed_stats.get("generation", mixed_stats.get("average_generation", 0))) < 2:
		print("  [FAIL] mixed division generation too low: ", mixed_stats)
		return false

	var pm := _get_production_manager()
	if pm != null:
		var via_pm: Dictionary = pm.get_division_infantry_stats("german_infantry_division_1943")
		if via_pm.is_empty():
			print("  [FAIL] ProductionManager.get_division_infantry_stats")
			return false

	print("  [PASS] infantry equipment type/generation stats")
	return true


static func _test_priority_reinforcement() -> bool:
	var pm := _get_production_manager()
	if pm == null:
		print("  [SKIP] priority reinforcement (no autoload)")
		return true

	pm.set_national_equipment_stockpile({"rifle": 50})
	pm.clear_unit_equipment_stock("priority_unit")
	pm.clear_unit_equipment_stock("normal_unit")
	pm.set_unit_priority_reinforcement("priority_unit", false)
	pm.set_unit_priority_reinforcement("normal_unit", false)

	var required := {"rifle": 40}
	var required_map := {
		"normal_unit": required,
		"priority_unit": required,
	}

	pm.set_unit_priority_reinforcement("priority_unit", true)
	pm.reinforce_all_units(required_map)

	var priority_stock := pm.get_unit_equipment_stock("priority_unit")
	var normal_stock := pm.get_unit_equipment_stock("normal_unit")
	if int(priority_stock.get("rifle", 0)) != 40:
		print("  [FAIL] priority unit should be fully reinforced: ", priority_stock)
		return false
	if int(normal_stock.get("rifle", 0)) != 10:
		print("  [FAIL] normal unit should get remainder: ", normal_stock)
		return false
	if not pm.is_unit_priority_reinforced("priority_unit"):
		print("  [FAIL] priority flag not set")
		return false

	pm.set_unit_priority_reinforcement("priority_unit", false)
	pm.set_national_equipment_stockpile({})
	pm.clear_unit_equipment_stock("priority_unit")
	pm.clear_unit_equipment_stock("normal_unit")
	print("  [PASS] priority reinforcement ordering")
	return true


static func _test_sustainment_equipment(design_data: DesignDataLoader) -> bool:
	design_data.load_sustainment_equipment()
	var basic := design_data.get_sustainment_equipment("basic_sustainment")
	if basic.is_empty():
		print("  [FAIL] basic_sustainment template missing")
		return false

	var supply := Engine.get_main_loop().root.get_node_or_null("/root/SupplyManager")
	if supply == null:
		print("  [PASS] sustainment equipment (data only)")
		return true

	supply.division_templates.load_all()
	var us_div: DivisionTemplate = supply.division_templates.get_division("us_infantry_division_1943")
	if us_div == null:
		print("  [FAIL] us_infantry_division_1943 missing")
		return false
	if us_div.get_sustainment_equipment_template() != "improved_sustainment":
		print("  [FAIL] sustainment template on division")
		return false
	var required := us_div.get_required_equipment(design_data)
	if not required.has("improved_sustainment"):
		print("  [FAIL] sustainment not in required equipment: ", required)
		return false
	if float(us_div.get_sustainment_consumption_multiplier(design_data)) >= 1.0:
		print("  [FAIL] improved sustainment should reduce consumption multiplier")
		return false

	print("  [PASS] sustainment equipment templates and division support")
	return true


static func _test_refinement_tradeoffs(design_data: DesignDataLoader) -> bool:
	var line := ProductionLine.new(design_data, "tradeoff_line")
	line.set_template("m3_stuart_light")
	var before := line.get_reliability_profile()
	if not line.start_refinement("pilot_shakedown"):
		print("  [FAIL] could not start shakedown")
		return false
	line.advance_days(15.0)
	var after := line.get_reliability_profile()
	var passed := (
		after.effective_reliability > before.effective_reliability
		and after.maintenance_index < before.maintenance_index
		and after.design_maturity > before.design_maturity
	)
	if passed:
		print("  [PASS] shakedown improved reliability and lowered maintenance burden")
	else:
		print("  [FAIL] shakedown tradeoff before/after ", before.maintenance_index, after.maintenance_index)
	return passed
