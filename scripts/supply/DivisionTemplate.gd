class_name DivisionTemplate
extends Resource

@export var id: String = ""
@export var display_name: String = ""
@export var manpower: int = 0
@export var support_supply_per_day: float = 0.0
@export var equipment: Array[Dictionary] = []
## Equipment template id (or category key) -> count. Falls back to `equipment` entries when empty.
@export var required_equipment: Dictionary = {}
## Primary issued infantry weapon template (e.g. infantry_m1_garand).
@export var infantry_equipment_template: String = ""
## Resolved UnitTemplate references for infantry aggregation (runtime).
@export var subunits: Array = []


static func from_dict(data: Dictionary) -> DivisionTemplate:
	var div := DivisionTemplate.new()
	div.id = str(data.get("id", ""))
	div.display_name = str(data.get("name", div.id))
	div.manpower = int(data.get("manpower", 0))
	div.support_supply_per_day = float(data.get("support_supply_per_day", 0.0))
	var raw: Variant = data.get("equipment", [])
	if typeof(raw) == TYPE_ARRAY:
		for item in raw:
			if typeof(item) == TYPE_DICTIONARY:
				div.equipment.append(item)
	div.required_equipment = _dict_from_variant(data.get("required_equipment", {}))
	div.infantry_equipment_template = str(data.get("infantry_equipment_template", ""))
	return div


func resolve_subunits(design_data: DesignDataLoader) -> void:
	subunits.clear()
	if design_data == null:
		return
	if not infantry_equipment_template.is_empty():
		var primary := design_data.get_template(infantry_equipment_template)
		if primary != null and primary.is_infantry_equipment():
			subunits.append(primary)
	for entry in equipment:
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		var template_id := str(entry.get("template_id", ""))
		if template_id.is_empty():
			continue
		var tpl := design_data.get_template(template_id)
		if tpl != null and tpl.is_infantry_equipment() and tpl not in subunits:
			subunits.append(tpl)


func get_required_equipment() -> Dictionary:
	if not required_equipment.is_empty():
		return required_equipment.duplicate(true)
	var out: Dictionary = {}
	for entry in equipment:
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		var template_id := str(entry.get("template_id", ""))
		var count := int(entry.get("count", 0))
		if template_id.is_empty() or count <= 0:
			continue
		out[template_id] = int(out.get(template_id, 0)) + count
	return out


func get_aggregated_infantry_stats(design_data: DesignDataLoader = null) -> Dictionary:
	if design_data != null:
		resolve_subunits(design_data)
	elif subunits.is_empty() and GameData.design_data != null:
		resolve_subunits(GameData.design_data)

	var total_soft := 0.0
	var total_hard := 0.0
	var total_supply := 0.0
	var total_reliability := 0.0
	var total_generation := 0
	var count := 0

	for subunit in subunits:
		if subunit is UnitTemplate:
			var stats: Dictionary = (subunit as UnitTemplate).get_infantry_stats()
			total_soft += float(stats.get("soft_attack", 0.9))
			total_hard += float(stats.get("hard_attack", 0.03))
			total_supply += float(stats.get("supply_consumption", 1.0))
			total_reliability += float(stats.get("reliability", 0.95))
			total_generation += (subunit as UnitTemplate).infantry_equipment_generation
			count += 1

	if count == 0:
		return {
			"soft_attack": 0.9,
			"hard_attack": 0.03,
			"supply_consumption": 1.0,
			"reliability": 0.95,
			"average_generation": 1,
		}

	return {
		"soft_attack": total_soft / float(count),
		"hard_attack": total_hard / float(count),
		"supply_consumption": total_supply / float(count),
		"reliability": total_reliability / float(count),
		"average_generation": int(round(float(total_generation) / float(count))),
	}


static func _dict_from_variant(raw: Variant) -> Dictionary:
	if typeof(raw) != TYPE_DICTIONARY:
		return {}
	var out: Dictionary = {}
	for key in raw:
		out[str(key)] = int(raw[key])
	return out
