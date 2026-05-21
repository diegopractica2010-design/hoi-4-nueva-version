class_name AttritionReplenishmentLedger
extends RefCounted

## Tracks combat/attrition losses and converts them into cargo demand for supply routes.

var _losses: Dictionary = {}


func record_manpower_loss(division_id: String, amount: int) -> void:
	if amount <= 0:
		return
	var key := "manpower:%s" % division_id
	_losses[key] = int(_losses.get(key, 0)) + amount


func record_equipment_loss(template_id: String, count: float) -> void:
	if count <= 0.0:
		return
	var key := "equip:%s" % template_id
	_losses[key] = float(_losses.get(key, 0.0)) + count


func clear() -> void:
	_losses.clear()


func compute_replenishment_cargo(
	_division_loader: DivisionTemplateLoader,
	design_data: DesignDataLoader,
	rules: SupplyRules,
) -> Dictionary:
	var cargo_rules := rules.get_block("cargo")
	var per_man := float(cargo_rules.get("crew_replacement_tons_per_man", 0.02))
	var attrition_frac := float(cargo_rules.get("attrition_replacement_fraction", 0.25))
	var out := {
		"crew_tons": 0.0,
		"fuel_tons": 0.0,
		"supply_tons": 0.0,
		"equipment_tons": 0.0,
		"total_tons": 0.0,
	}

	for key in _losses:
		var amount: float = float(_losses[key])
		if str(key).begins_with("manpower:"):
			out["crew_tons"] += amount * per_man * attrition_frac
		elif str(key).begins_with("equip:"):
			var tpl_id := str(key).trim_prefix("equip:")
			var tpl: UnitTemplate = design_data.get_template(tpl_id) if design_data else null
			if tpl != null:
				var req := UnitSupplyRequirements.from_template(tpl, rules)
				out["equipment_tons"] += amount * (req.crew_replacement_cargo + req.supply_cargo_per_day * 3.0)
			else:
				out["equipment_tons"] += amount * 2.0

	out["total_tons"] = out["crew_tons"] + out["fuel_tons"] + out["supply_tons"] + out["equipment_tons"]
	return out
