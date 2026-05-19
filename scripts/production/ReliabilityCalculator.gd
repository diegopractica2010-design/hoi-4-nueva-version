class_name ReliabilityCalculator
extends RefCounted

## Computes reliability, maintenance burden, and combat readiness from design maturity.


static func compute_profile(
	template: UnitTemplate,
	state: DesignLineState,
	rules: Dictionary,
	tooling_efficiency: float,
	global_mods: ProductionModifiers,
	design_data: DesignDataLoader,
	active_refinement: RefinementProject = null,
	loadout_override: Dictionary = {},
) -> ReliabilityProfile:
	var profile := ReliabilityProfile.new()
	if template == null or state == null:
		return profile

	var reliability_rules: Dictionary = rules.get("reliability", {})
	var paper := template.get_base_reliability()
	var new_design_mult := float(reliability_rules.get("new_design_multiplier", 0.68))
	var tooling_bonus_per_10 := float(reliability_rules.get("tooling_reliability_bonus_per_10_efficiency", 1.2))
	var max_refinement := float(reliability_rules.get("max_refinement_bonus", 25))

	var maturity := clampf(state.design_maturity, 0.0, 1.0)
	var maturity_factor := lerpf(new_design_mult, 1.0, maturity)
	var tooling_bonus := (tooling_efficiency / 10.0) * tooling_bonus_per_10
	var refinement_bonus := clampf(state.reliability_refinement_bonus, 0.0, max_refinement)
	var module_delta := _module_reliability_delta(template, design_data, loadout_override)

	var reliability := paper * maturity_factor + tooling_bonus + refinement_bonus + module_delta
	if global_mods != null:
		reliability = reliability * global_mods.reliability_multiplier + global_mods.reliability_flat_bonus

	var effective := clampf(reliability, 1.0, 100.0)
	var maintenance := _compute_maintenance_index(effective, paper, maturity, state, rules)
	var supply_mult := _compute_supply_multiplier(maintenance, rules)
	var combat := _compute_combat_readiness(effective, paper, maturity, rules)
	var breakdown := _compute_breakdown_risk(effective, paper, maturity, rules)

	profile.template_id = template.id
	profile.paper_reliability = paper
	profile.effective_reliability = effective
	profile.design_maturity = maturity
	profile.new_design_penalty_percent = (1.0 - maturity_factor) * 100.0
	profile.refinement_bonus = refinement_bonus
	profile.maintenance_index = maintenance
	profile.supply_cost_multiplier = supply_mult
	profile.combat_readiness = combat
	profile.breakdown_risk = breakdown
	profile.units_produced = state.units_produced
	if active_refinement != null:
		profile.active_refinement_id = active_refinement.id
		profile.active_refinement_progress = active_refinement.progress_ratio()

	var logistics := LogisticsCalculator.compute(
		template, design_data, rules, combat, loadout_override,
	)
	profile.base_cargo_capacity = float(logistics.get("base_cargo_capacity", 0.0))
	profile.effective_cargo_capacity = float(logistics.get("effective_cargo_capacity", 0.0))
	profile.cargo_capacity_ratio = float(logistics.get("cargo_capacity_ratio", 1.0))
	profile.armed_weapon_slots = int(logistics.get("armed_weapon_slots", 0))
	profile.logistics_supply_demand = float(logistics.get("logistics_supply_demand", 0.0))
	profile.combat_soft_attack = float(logistics.get("combat_soft_attack", 0.0))
	profile.combat_hard_attack = float(logistics.get("combat_hard_attack", 0.0))
	profile.combat_air_attack = float(logistics.get("combat_air_attack", 0.0))
	profile.combat_anti_air = float(logistics.get("combat_anti_air", 0.0))
	profile.combat_anti_ship = float(logistics.get("combat_anti_ship", 0.0))

	# Armed cargo units: maintenance/supply scale with lost cargo space and weapon complexity.
	if profile.has_cargo_role():
		var cargo_burden := 1.0 - clampf(profile.cargo_capacity_ratio, 0.0, 1.0)
		profile.maintenance_index = clampf(
			profile.maintenance_index + cargo_burden * float(
				rules.get("logistics", {}).get("maintenance_index_per_lost_cargo_fraction", 0.12),
			),
			0.0,
			1.0,
		)
		var supply_from_logistics := profile.logistics_supply_demand
		if supply_from_logistics > 0.0:
			var base_supply := template.get_stat("supply_need", 1.0)
			profile.supply_cost_multiplier *= supply_from_logistics / maxf(base_supply, 1.0)

	return profile


static func recompute_design_maturity(state: DesignLineState, rules: Dictionary) -> void:
	if state == null:
		return
	var reliability_rules: Dictionary = rules.get("reliability", {})
	var per_unit := float(reliability_rules.get("maturity_gain_per_unit_produced", 0.028))
	var max_prod := float(reliability_rules.get("max_maturity_from_production", 0.55))
	var production_part := minf(float(state.units_produced) * per_unit, max_prod)
	state.design_maturity = clampf(production_part + state.maturity_from_projects, 0.0, 1.0)


static func _compute_maintenance_index(
	effective: float,
	paper: float,
	maturity: float,
	state: DesignLineState,
	rules: Dictionary,
) -> float:
	var maintenance_rules: Dictionary = rules.get("maintenance", {})
	var immaturity_scale := float(maintenance_rules.get("immaturity_maintenance_scale", 0.45))
	var reliability_scale := float(maintenance_rules.get("low_reliability_maintenance_scale", 0.35))

	var immaturity_component := (1.0 - maturity) * immaturity_scale
	var reliability_gap := clampf((paper - effective) / maxf(paper, 1.0), 0.0, 1.0)
	var reliability_component := reliability_gap * reliability_scale
	var burden := state.maintenance_burden_multiplier

	var index := (immaturity_component + reliability_component) * burden
	return clampf(index, 0.0, 1.0)


static func _compute_supply_multiplier(maintenance_index: float, rules: Dictionary) -> float:
	var maintenance_rules: Dictionary = rules.get("maintenance", {})
	var per_index := float(maintenance_rules.get("supply_cost_per_maintenance_index", 0.35))
	return 1.0 + maintenance_index * per_index


static func _compute_combat_readiness(
	effective: float,
	paper: float,
	maturity: float,
	rules: Dictionary,
) -> float:
	var combat_rules: Dictionary = rules.get("combat_readiness", {})
	var min_readiness := float(combat_rules.get("minimum_readiness", 0.62))
	var maturity_weight := float(combat_rules.get("maturity_weight", 0.35))
	var reliability_weight := float(combat_rules.get("reliability_weight", 0.65))

	var reliability_ratio := clampf(effective / maxf(paper, 1.0), 0.0, 1.1)
	var readiness := reliability_ratio * reliability_weight + maturity * maturity_weight
	return clampf(readiness, min_readiness, 1.0)


static func _compute_breakdown_risk(
	effective: float,
	paper: float,
	maturity: float,
	rules: Dictionary,
) -> float:
	var combat_rules: Dictionary = rules.get("combat_readiness", {})
	var base_risk := float(combat_rules.get("base_breakdown_risk", 0.04))
	var immaturity_risk := float(combat_rules.get("immaturity_breakdown_risk", 0.18))
	var reliability_relief := clampf(effective / maxf(paper, 1.0), 0.0, 1.0)

	var risk := base_risk + (1.0 - maturity) * immaturity_risk
	risk *= 1.0 - reliability_relief * 0.65
	return clampf(risk, 0.0, 0.45)


static func _module_reliability_delta(
	template: UnitTemplate,
	design_data: DesignDataLoader,
	loadout_override: Dictionary = {},
) -> float:
	var delta := 0.0
	if design_data == null or template == null:
		return delta
	var loadout := LogisticsCalculator.resolve_loadout(template, loadout_override)
	for module_id in loadout.values():
		var mod: EquipmentModule = design_data.get_module(module_id)
		if mod == null:
			continue
		delta += mod.reliability_bonus + mod.reliability_penalty
	return delta
