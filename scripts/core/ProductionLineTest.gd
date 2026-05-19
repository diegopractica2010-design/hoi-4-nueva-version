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
