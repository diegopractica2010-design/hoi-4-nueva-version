class_name UnitSupplyRequirements
extends RefCounted

## Per-template supply draw: crew replacements, fuel, general supplies (abstract tons).

var template_id: String = ""
var crew_required: int = 0
var supply_need: float = 0.0
var fuel_consumption: float = 0.0
var cargo_capacity: float = 0.0
var crew_replacement_cargo: float = 0.0
var fuel_cargo_per_day: float = 0.0
var supply_cargo_per_day: float = 0.0


static func from_template(template: UnitTemplate, rules: SupplyRules) -> UnitSupplyRequirements:
	var req := UnitSupplyRequirements.new()
	if template == null:
		return req
	var cargo_rules := rules.get_block("cargo")
	req.template_id = template.id
	req.crew_required = template.crew_required
	req.supply_need = template.get_stat("supply_need", 0.0)
	req.fuel_consumption = template.get_stat("fuel_consumption", 0.0)
	req.cargo_capacity = template.get_stat("cargo_capacity", 0.0)
	var per_man := float(cargo_rules.get("crew_replacement_tons_per_man", 0.02))
	var fuel_scale := float(cargo_rules.get("fuel_ton_per_consumption_point", 0.15))
	var supply_scale := float(cargo_rules.get("supply_ton_per_need_point", 0.12))
	req.crew_replacement_cargo = float(req.crew_required) * per_man
	req.fuel_cargo_per_day = req.fuel_consumption * fuel_scale
	req.supply_cargo_per_day = req.supply_need * supply_scale
	return req


func daily_consumption_cargo(mode: String, rules: SupplyRules) -> Dictionary:
	var rate := rules.consumption_rate(mode)
	return {
		"fuel": fuel_cargo_per_day * rate,
		"supplies": supply_cargo_per_day * rate,
		"crew_replacements": crew_replacement_cargo * rate * float(
			rules.get_block("cargo").get("attrition_replacement_fraction", 0.25),
		),
		"total": (fuel_cargo_per_day + supply_cargo_per_day) * rate,
	}


func can_airlift(rules: SupplyRules) -> bool:
	return cargo_capacity >= rules.get_float("routing", "min_cargo_capacity_for_airlift", 500.0)


func can_sealift(rules: SupplyRules) -> bool:
	return cargo_capacity >= rules.get_float("routing", "min_cargo_capacity_for_sealift", 2000.0)
