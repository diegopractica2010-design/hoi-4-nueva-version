## Resolves Production Point costs: base category + era + modules + complexity.
class_name ProductionCostCalculator
extends RefCounted

const RULES_PATH := "res://data/production/production_cost_rules.json"

static var _rules: Dictionary = {}
static var _loaded: bool = false


static func get_rules() -> Dictionary:
	_load_rules()
	return _rules


static func get_base_daily_points() -> float:
	return float(get_rules().get("base_daily_points", 12.0))


static func resolve_cost(
	template: UnitTemplate,
	design_data: DesignDataLoader = null,
	loadout_override: Dictionary = {},
) -> float:
	var breakdown := resolve_cost_breakdown(template, design_data, loadout_override)
	return float(breakdown.get("total", 100.0))


static func resolve_cost_breakdown(
	template: UnitTemplate,
	design_data: DesignDataLoader = null,
	loadout_override: Dictionary = {},
) -> Dictionary:
	if template == null:
		return {"total": 100.0}

	if template.production_cost > 0.0:
		return {
			"total": template.production_cost,
			"override": true,
			"base_cost": template.production_cost,
		}

	_load_rules()
	var category := infer_category(template)
	var era := infer_era(template)

	var base_costs: Dictionary = _rules.get("base_costs", {})
	var base := float(base_costs.get(category, base_costs.get("default", 100.0)))

	var era_mults: Dictionary = _rules.get("era_multipliers", {})
	var era_mult := float(era_mults.get(era, 1.0))
	var base_after_era := base * era_mult

	var module_ids := _collect_module_ids(template, loadout_override)
	var module_total := 0.0
	var module_details: Array[Dictionary] = []
	for module_id in module_ids:
		var mod: EquipmentModule = _get_module(design_data, module_id)
		var mod_cost := _module_production_cost(mod, module_id)
		module_total += mod_cost
		module_details.append({"id": module_id, "cost": mod_cost})

	var subtotal := base_after_era + module_total
	var complexity_mult := _complexity_multiplier(module_ids.size())
	var template_complexity := maxf(template.production_complexity, 0.1)

	var days_factor := 1.0
	if bool(_rules.get("use_days_fine_tune", true)):
		days_factor = _days_fine_tune_factor(template, category)

	var total := maxf(subtotal * complexity_mult * template_complexity * days_factor, 1.0)

	return {
		"total": total,
		"category": category,
		"era": era,
		"base_cost": base,
		"era_multiplier": era_mult,
		"base_after_era": base_after_era,
		"module_count": module_ids.size(),
		"module_cost_total": module_total,
		"module_details": module_details,
		"complexity_multiplier": complexity_mult,
		"template_complexity": template_complexity,
		"days_fine_tune": days_factor,
	}


static func infer_category(template: UnitTemplate) -> String:
	if not template.production_category.is_empty():
		return _normalize_category(template.production_category)

	var id_lower := template.id.to_lower()
	var arch := template.visual_archetype.to_lower()
	var size := template.size_category.to_lower()
	var bt := template.base_type.to_lower()
	var name_lower := template.display_name.to_lower()

	if "icbm" in id_lower or "rocket" in id_lower or "missile" in id_lower or "ballistic" in id_lower:
		return "rocket"
	if bt == "submarine" or "submarine" in arch or "ssn" in id_lower or "ssbn" in id_lower:
		return "submarine"
	if "carrier" in id_lower or "carrier" in name_lower or "lhd" in id_lower or "cvb" in id_lower:
		return "carrier"
	if "battleship" in id_lower or "battleship" in name_lower or "_bb" in id_lower or id_lower.ends_with("_bb"):
		return "battleship"
	if "cruiser" in id_lower or "cruiser" in name_lower or "_ca" in id_lower:
		return "cruiser"
	if bt == "naval":
		return "destroyer"
	if bt == "air":
		if "bomber" in id_lower or "bomber" in arch or "strategic" in name_lower:
			return "bomber"
		return "fighter"
	if bt == "armored":
		if size == "heavy" or "heavy" in id_lower or "heavy_tank" in arch:
			return "heavy_tank"
		if size == "light" or "light_tank" in arch:
			return "light_tank"
		return "medium_tank"
	if bt == "land":
		if "truck" in id_lower or "transport" in id_lower or "cargo" in id_lower:
			return "light_tank"
		if "infantry" in id_lower or "rifle" in id_lower:
			return "infantry_equipment"
		if "mbt" in id_lower or "tank" in id_lower:
			return "medium_tank"
		return "light_tank"
	if "space" in bt or "orbital" in id_lower or "satellite" in id_lower:
		return "space"
	return "default"


static func infer_era(template: UnitTemplate) -> String:
	var era_override := str(template.base_stats.get("production_era", ""))
	if not era_override.is_empty():
		return era_override

	var id_lower := template.id.to_lower()
	var family := template.design_family.to_lower()

	if "2030" in id_lower or "2040" in id_lower or "space" in family or "orbital" in id_lower:
		return "future"
	if "2026" in id_lower or "2020" in id_lower or "2010" in id_lower or "2000" in id_lower:
		return "modern"
	if "1990" in id_lower or "1980" in id_lower or "1970" in id_lower or "sixties" in family:
		return "late_cold_war"
	if "1960" in id_lower or "1950" in id_lower or "cold_war" in family:
		return "early_cold_war"
	if "1945" in id_lower or "1944" in id_lower or "1943" in id_lower or "1942" in id_lower or "1940" in id_lower:
		return "ww2"
	if "1936" in id_lower or "1939" in id_lower or "interwar" in family:
		return "interwar"
	if "1918" in id_lower or "ww1" in family or "great_war" in family:
		return "ww1"

	var days := template.base_production_days
	if days >= 280.0:
		return "modern"
	if days >= 200.0:
		return "late_cold_war"
	if days >= 140.0:
		return "early_cold_war"
	if days >= 90.0:
		return "ww2"
	if days >= 55.0:
		return "interwar"
	return "ww1"


static func estimate_build_days(production_cost: float, daily_points: float = -1.0) -> float:
	if daily_points < 0.0:
		daily_points = get_base_daily_points()
	if daily_points <= 0.0:
		return 9999.0
	return production_cost / daily_points


static func _normalize_category(category: String) -> String:
	var cat := category.to_lower()
	if cat == "light_vehicle":
		return "light_tank"
	if cat == "vehicle":
		return "light_tank"
	if cat == "tank" and cat != "heavy_tank":
		return "medium_tank"
	return cat


static func _collect_module_ids(template: UnitTemplate, loadout_override: Dictionary) -> Array[String]:
	var ids: Array[String] = []
	var loadout := loadout_override if not loadout_override.is_empty() else template.module_loadout
	for slot_name in loadout:
		var module_id := str(loadout[slot_name])
		if module_id.is_empty() or module_id in ids:
			continue
		ids.append(module_id)
	return ids


static func _get_module(design_data: DesignDataLoader, module_id: String) -> EquipmentModule:
	if design_data != null:
		return design_data.get_module(module_id)
	return null


static func _module_production_cost(mod: EquipmentModule, module_id: String) -> float:
	var module_costs: Dictionary = _rules.get("module_costs", {})
	var tier_rules: Dictionary = _rules.get("module_tier_scaling", {})
	var per_tier := float(tier_rules.get("per_tier_bonus", 0.12))

	var key := "default"
	if mod != null:
		key = _infer_module_cost_key(mod)
	else:
		key = _infer_module_cost_key_from_id(module_id)

	var base := float(module_costs.get(key, module_costs.get("default", 6.0)))
	var tier := mod.tier if mod != null else 1
	var tier_mult := 1.0 + maxf(float(tier) - 1.0, 0.0) * per_tier
	return base * tier_mult


static func _infer_module_cost_key(mod: EquipmentModule) -> String:
	return _infer_module_cost_key_from_id(mod.id, mod.category, mod.special_flags)


static func _infer_module_cost_key_from_id(
	module_id: String,
	category: String = "",
	flags: Array = [],
) -> String:
	var id_lower := module_id.to_lower()
	var cat_lower := category.to_lower()

	for flag in flags:
		var f := str(flag).to_lower()
		if "stealth" in f:
			return "stealth_coating"

	if "stealth" in id_lower or "low_observable" in id_lower:
		return "stealth_coating"
	if "missile" in id_lower or "sam" in id_lower or "aam" in id_lower or "torpedo" in id_lower:
		return "missile_system"
	if "radar" in id_lower or "sonar" in id_lower or "asw" in id_lower:
		return "radar"
	if "fire_control" in id_lower or "fcs" in id_lower or "director" in id_lower:
		return "fire_control"
	if "computer" in id_lower or "electronics" in id_lower or "ew" in id_lower or "ecm" in id_lower:
		return "advanced_electronics"
	if "engine" in id_lower or "turbine" in id_lower or "propulsion" in id_lower:
		return "engine"
	if "armor" in id_lower or "belt" in id_lower or "plate" in id_lower:
		return "armor_plate"
	if "gun" in id_lower or "cannon" in id_lower or "howitzer" in id_lower or "rifle" in id_lower:
		return "gun"

	if cat_lower.contains("weapon") or cat_lower == "mainweapon" or cat_lower == "secondaryweapon":
		return "gun"
	if cat_lower.contains("engine"):
		return "engine"
	if cat_lower.contains("armor"):
		return "armor_plate"
	if cat_lower.contains("sensor") or cat_lower.contains("fire"):
		return "fire_control"
	if cat_lower.contains("electronic"):
		return "advanced_electronics"

	return "default"


static func _complexity_multiplier(module_count: int) -> float:
	var penalty: Dictionary = _rules.get("complexity_penalty", {})
	var free_modules := int(penalty.get("free_modules", 4))
	var per_extra := float(penalty.get("per_module_after", 0.08))
	var extra := maxi(module_count - free_modules, 0)
	return 1.0 + float(extra) * per_extra


static func _days_fine_tune_factor(template: UnitTemplate, category: String) -> float:
	var ref_days_map: Dictionary = _rules.get("category_reference_days", {})
	var ref_days := maxf(float(ref_days_map.get(category, ref_days_map.get("default", 60.0))), 1.0)
	var days := maxf(template.base_production_days, 1.0)
	var exponent := float(_rules.get("days_scale_exponent", 0.85))
	var factor := pow(days / ref_days, exponent)
	var min_f := float(_rules.get("min_days_factor", 0.5))
	var max_f := float(_rules.get("max_days_factor", 3.5))
	return clampf(factor, min_f, max_f)


static func _load_rules() -> void:
	if _loaded:
		return
	_loaded = true
	if not FileAccess.file_exists(RULES_PATH):
		push_warning("ProductionCostCalculator: missing ", RULES_PATH)
		return
	var file := FileAccess.open(RULES_PATH, FileAccess.READ)
	if file == null:
		return
	var parser := JSON.new()
	if parser.parse(file.get_as_text()) == OK and typeof(parser.data) == TYPE_DICTIONARY:
		_rules = parser.data
