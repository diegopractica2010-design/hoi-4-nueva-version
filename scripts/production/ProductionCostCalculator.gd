## Resolves abstract Production Point costs for unit designs (data-driven + inferred).
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


static func resolve_cost(template: UnitTemplate) -> float:
	if template == null:
		return 100.0
	if template.production_cost > 0.0:
		return template.production_cost

	_load_rules()
	var category := template.production_category
	if category.is_empty():
		category = infer_category(template)

	var categories: Dictionary = _rules.get("category_costs", {})
	var cat_rules: Dictionary = categories.get(category, categories.get("default", {}))
	var base_cost := float(cat_rules.get("base_cost", 100.0))
	var ref_days := maxf(float(cat_rules.get("reference_days", 60.0)), 1.0)
	var days := maxf(template.base_production_days, 1.0)

	var exponent := float(_rules.get("days_scale_exponent", 0.85))
	var days_factor := pow(days / ref_days, exponent)
	var min_f := float(_rules.get("min_days_factor", 0.5))
	var max_f := float(_rules.get("max_days_factor", 3.5))
	days_factor = clampf(days_factor, min_f, max_f)

	var complexity := maxf(template.production_complexity, 0.1)
	return maxf(base_cost * days_factor * complexity, 1.0)


static func infer_category(template: UnitTemplate) -> String:
	if not template.production_category.is_empty():
		return template.production_category

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
		if "destroyer" in id_lower or "_dd" in id_lower or "frigate" in id_lower or "corvette" in id_lower:
			return "destroyer"
		if "torpedo_boat" in id_lower or "patrol" in id_lower:
			return "destroyer"
		return "destroyer"
	if bt == "air":
		if "bomber" in id_lower or "bomber" in arch or "strategic" in name_lower:
			return "bomber"
		return "fighter"
	if bt == "armored":
		if size == "heavy" or "heavy" in id_lower or "heavy_tank" in arch:
			return "heavy_tank"
		if size == "light" or "light_tank" in arch:
			return "light_vehicle"
		return "medium_tank"
	if bt == "land":
		if "truck" in id_lower or "transport" in id_lower or "cargo" in id_lower:
			return "light_vehicle"
		if "infantry" in id_lower or "rifle" in id_lower:
			return "infantry_equipment"
		if "mbt" in id_lower or "tank" in id_lower:
			return "medium_tank"
		return "light_vehicle"
	if "space" in bt or "orbital" in id_lower or "satellite" in id_lower:
		return "space"
	return "default"


static func estimate_build_days(production_cost: float, daily_points: float = -1.0) -> float:
	if daily_points < 0.0:
		daily_points = get_base_daily_points()
	if daily_points <= 0.0:
		return 9999.0
	return production_cost / daily_points


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
