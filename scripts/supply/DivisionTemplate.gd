class_name DivisionTemplate
extends Resource

@export var id: String = ""
@export var display_name: String = ""
@export var manpower: int = 0
@export var support_supply_per_day: float = 0.0
@export var equipment: Array[Dictionary] = []


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
	return div
