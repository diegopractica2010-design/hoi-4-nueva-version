class_name DivisionTemplate
extends Resource

@export var id: String = ""
@export var display_name: String = ""
@export var manpower: int = 0
@export var support_supply_per_day: float = 0.0
@export var equipment: Array[Dictionary] = []
## Equipment template id (or category key) -> count. Falls back to `equipment` entries when empty.
@export var required_equipment: Dictionary = {}


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
	return div


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


static func _dict_from_variant(raw: Variant) -> Dictionary:
	if typeof(raw) != TYPE_DICTIONARY:
		return {}
	var out: Dictionary = {}
	for key in raw:
		out[str(key)] = int(raw[key])
	return out
