class_name UnitTemplate
extends Resource

@export var id: String = ""
@export var display_name: String = ""
@export var base_type: String = ""
@export var size_category: String = ""
@export var visual_archetype: String = ""
@export var design_family: String = ""
@export var crew_required: int = 0
@export var base_training_level: int = 0
@export var max_experience_level: int = 100
@export var base_stats: Dictionary = {}
@export var slots: Dictionary = {}
@export var module_loadout: Dictionary = {}
@export var unlock_tech: Array[String] = []
@export var can_mount_drones: bool = false
@export var is_vehicle: bool = true
@export var base_production_days: float = 60.0
## Production Points to complete one unit (0 = auto from category + build days).
@export var production_cost: float = 0.0
@export var production_category: String = ""
@export var production_complexity: float = 1.0


func get_module_ids() -> Array[String]:
	var ids: Array[String] = []
	for slot_name in module_loadout:
		var module_id := str(module_loadout[slot_name])
		if not module_id.is_empty():
			ids.append(module_id)
	return ids


func count_filled_slots() -> int:
	return get_module_ids().size()


func get_base_reliability() -> float:
	return float(base_stats.get("reliability", 50.0))


func get_stat(stat_name: String, default_value: float = 0.0) -> float:
	return float(base_stats.get(stat_name, default_value))


func get_fuel_consumption() -> float:
	return get_stat("fuel_consumption", 0.0)


func get_supply_need() -> float:
	return get_stat("supply_need", 0.0)


## STORED (in port/airfield), READIED, TRAINING, COMBAT — see supply_rules.json consumption_rates.
func get_daily_supply_draw(mode: String, rules: SupplyRules) -> Dictionary:
	var req := UnitSupplyRequirements.from_template(self, rules)
	return req.daily_consumption_cargo(mode, rules)


static func from_dict(data: Dictionary) -> UnitTemplate:
	var tpl := UnitTemplate.new()
	tpl.id = str(data.get("id", ""))
	tpl.display_name = str(data.get("name", tpl.id))
	tpl.base_type = str(data.get("base_type", ""))
	tpl.size_category = str(data.get("size_category", ""))
	tpl.visual_archetype = str(data.get("visual_archetype", ""))
	tpl.design_family = str(data.get("design_family", ""))
	tpl.crew_required = int(data.get("crew_required", 0))
	tpl.base_training_level = int(data.get("base_training_level", 0))
	tpl.max_experience_level = int(data.get("max_experience_level", 100))
	tpl.base_stats = _dict_from_variant(data.get("base_stats", {}))
	tpl.slots = _dict_from_variant(data.get("slots", {}))
	tpl.module_loadout = _dict_from_variant(data.get("module_loadout", {}))
	tpl.unlock_tech = _string_array(data.get("unlock_tech", []))
	tpl.can_mount_drones = bool(data.get("can_mount_drones", false))
	tpl.is_vehicle = bool(data.get("is_vehicle", true))
	tpl.base_production_days = float(data.get("base_production_days", data.get("production_days", 60)))
	tpl.production_cost = float(data.get("production_cost", 0.0))
	tpl.production_category = str(data.get("production_category", data.get("category", "")))
	tpl.production_complexity = float(data.get("production_complexity", data.get("complexity", 1.0)))
	return tpl


func get_production_point_cost() -> float:
	return ProductionCostCalculator.resolve_cost(self)


func get_inferred_production_category() -> String:
	if not production_category.is_empty():
		return production_category
	return ProductionCostCalculator.infer_category(self)


static func _dict_from_variant(raw: Variant) -> Dictionary:
	if typeof(raw) != TYPE_DICTIONARY:
		return {}
	return raw.duplicate(true)


static func _string_array(raw: Variant) -> Array[String]:
	var out: Array[String] = []
	if typeof(raw) != TYPE_ARRAY:
		return out
	for item in raw:
		out.append(str(item))
	return out
