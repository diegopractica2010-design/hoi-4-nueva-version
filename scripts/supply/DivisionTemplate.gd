class_name DivisionTemplate
extends Resource

@export var id: String = ""
@export var display_name: String = ""
@export var manpower: int = 0
@export var support_supply_per_day: float = 0.0
@export var equipment: Array[Dictionary] = []
## Equipment template id (or category key) -> count. Falls back to `equipment` entries when empty.
@export var required_equipment: Dictionary = {}
## Division-wide default infantry weapon template (e.g. infantry_k98_bolt_action).
@export var infantry_equipment_template: String = ""
## Battalion / subunit definitions from JSON (may override infantry_equipment_template per entry).
@export var subunit_defs: Array[Dictionary] = []
## Abstracted bulk gear: uniforms, helmets, ammo, tools, medical, etc.
@export var sustainment_equipment_template: String = "basic_sustainment"

var _resolved_subunits: Array[Dictionary] = []


static func from_dict(data: Dictionary) -> DivisionTemplate:
	var div := DivisionTemplate.new()
	div.id = str(data.get("id", data.get("template_id", "")))
	div.display_name = str(data.get("name", div.id))
	div.manpower = int(data.get("manpower", 0))
	div.support_supply_per_day = float(data.get("support_supply_per_day", 0.0))
	var raw_equipment: Variant = data.get("equipment", [])
	if typeof(raw_equipment) == TYPE_ARRAY:
		for item in raw_equipment:
			if typeof(item) == TYPE_DICTIONARY:
				div.equipment.append((item as Dictionary).duplicate(true))
	div.required_equipment = _dict_from_variant(data.get("required_equipment", {}))
	div.infantry_equipment_template = str(data.get("infantry_equipment_template", ""))
	div.sustainment_equipment_template = str(
		data.get("sustainment_equipment_template", "basic_sustainment")
	)
	var raw_subunits: Variant = data.get("subunits", [])
	if typeof(raw_subunits) == TYPE_ARRAY:
		for item in raw_subunits:
			if typeof(item) == TYPE_DICTIONARY:
				div.subunit_defs.append((item as Dictionary).duplicate(true))
	return div


func resolve_subunits(design_data: DesignDataLoader = null) -> void:
	_resolved_subunits.clear()
	var loader := _resolve_design_data(design_data)
	if loader == null:
		return

	for subunit_def in subunit_defs:
		if typeof(subunit_def) != TYPE_DICTIONARY:
			continue
		var resolved := (subunit_def as Dictionary).duplicate(true)
		var equipment_template_id := str(
			resolved.get("infantry_equipment_template", resolved.get("infantry_equipment_override", ""))
		)
		if equipment_template_id.is_empty():
			equipment_template_id = infantry_equipment_template
		_apply_infantry_template_to_subunit(resolved, equipment_template_id, loader)
		_resolved_subunits.append(resolved)

	if _resolved_subunits.is_empty():
		for entry in equipment:
			if typeof(entry) != TYPE_DICTIONARY:
				continue
			if str(entry.get("type", "")).to_lower() != "infantry":
				continue
			var resolved := entry.duplicate(true)
			var equipment_template_id := _infantry_template_id_for_equipment_entry(entry)
			_apply_infantry_template_to_subunit(resolved, equipment_template_id, loader)
			_resolved_subunits.append(resolved)

	if _resolved_subunits.is_empty() and not infantry_equipment_template.is_empty():
		var division_block := {"source": "division_default"}
		_apply_infantry_template_to_subunit(division_block, infantry_equipment_template, loader)
		_resolved_subunits.append(division_block)


func get_aggregated_infantry_stats(design_data: DesignDataLoader = null) -> Dictionary:
	resolve_subunits(design_data)

	var total_soft := 0.0
	var total_hard := 0.0
	var total_supply := 0.0
	var total_reliability := 0.0
	var sample_count := 0

	for subunit in _resolved_subunits:
		if not subunit.has("infantry_equipment_stats"):
			continue
		var stats: Dictionary = subunit["infantry_equipment_stats"]
		var weight := maxi(int(subunit.get("count", 1)), 1)
		for _i in weight:
			total_soft += float(stats.get("soft_attack", 0.9))
			total_hard += float(stats.get("hard_attack", 0.03))
			total_supply += float(stats.get("supply_consumption", 1.0))
			total_reliability += float(stats.get("reliability", 0.95))
			sample_count += 1

	if sample_count == 0:
		return _default_infantry_stats()

	return {
		"soft_attack": total_soft / float(sample_count),
		"hard_attack": total_hard / float(sample_count),
		"supply_consumption": total_supply / float(sample_count),
		"reliability": total_reliability / float(sample_count),
		"generation": get_average_generation(),
		"average_generation": get_average_generation(),
	}


func get_average_generation() -> int:
	var total := 0
	var count := 0
	for subunit in _resolved_subunits:
		if subunit.has("infantry_equipment_generation"):
			var weight := maxi(int(subunit.get("count", 1)), 1)
			total += int(subunit["infantry_equipment_generation"]) * weight
			count += weight
	if count == 0:
		return 1
	return int(round(float(total) / float(count)))


func get_resolved_subunits() -> Array[Dictionary]:
	var copy: Array[Dictionary] = []
	for subunit in _resolved_subunits:
		if typeof(subunit) == TYPE_DICTIONARY:
			copy.append((subunit as Dictionary).duplicate(true))
	return copy


func get_sustainment_equipment_template() -> String:
	return sustainment_equipment_template


func get_sustainment_stats(design_data: DesignDataLoader = null) -> Dictionary:
	var loader := _resolve_design_data(design_data)
	if loader == null:
		return {}
	var data := loader.get_sustainment_equipment(sustainment_equipment_template)
	if data.is_empty():
		return {
			"supply_consumption": get_sustainment_consumption_multiplier(design_data),
			"reliability_impact": 0.0,
			"readiness_bonus": 0.0,
		}
	return {
		"supply_consumption": float(data.get("supply_consumption", 1.0)),
		"reliability_impact": float(data.get("reliability_impact", 0.0)),
		"readiness_bonus": float(data.get("readiness_bonus", 0.0)),
		"description": str(data.get("description", "")),
	}


func get_sustainment_consumption_multiplier(design_data: DesignDataLoader = null) -> float:
	return float(get_sustainment_stats(design_data).get("supply_consumption", 1.0))


func get_sustainment_readiness_bonus(design_data: DesignDataLoader = null) -> float:
	return float(get_sustainment_stats(design_data).get("readiness_bonus", 0.0))


func get_sustainment_reliability_impact(design_data: DesignDataLoader = null) -> float:
	return float(get_sustainment_stats(design_data).get("reliability_impact", 0.0))


func get_required_equipment(design_data: DesignDataLoader = null) -> Dictionary:
	var out: Dictionary = {}
	if not required_equipment.is_empty():
		out = required_equipment.duplicate(true)
	for entry in equipment:
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		var eq_type := str(entry.get("type", "")).to_lower()
		if eq_type == "infantry":
			var infantry_id := _infantry_template_id_for_equipment_entry(entry)
			var count := int(entry.get("count", 0))
			if not infantry_id.is_empty() and count > 0:
				out[infantry_id] = int(out.get(infantry_id, 0)) + count
			continue
		var template_id := str(entry.get("template_id", entry.get("type", "")))
		var amount := int(entry.get("count", 0))
		if template_id.is_empty() or amount <= 0:
			continue
		out[template_id] = int(out.get(template_id, 0)) + amount
	_append_sustainment_requirements(out, design_data)
	return out


func _append_sustainment_requirements(out: Dictionary, design_data: DesignDataLoader) -> void:
	var soldier_count := _sustainment_headcount()
	if soldier_count <= 0:
		return
	var per_soldier := get_sustainment_consumption_multiplier(design_data)
	var sustainment_id := get_sustainment_equipment_template()
	if sustainment_id.is_empty():
		sustainment_id = "basic_sustainment"
	var amount := int(ceil(float(soldier_count) * per_soldier))
	out[sustainment_id] = int(out.get(sustainment_id, 0)) + amount

	# Specialized subunits draw extra sustainment packages.
	for subunit_def in subunit_defs:
		if typeof(subunit_def) != TYPE_DICTIONARY:
			continue
		var sub_id := str(subunit_def.get("sustainment_equipment_template", ""))
		if sub_id.is_empty():
			continue
		var weight := maxi(int(subunit_def.get("count", 1)), 1)
		var sub_data := {}
		var loader := _resolve_design_data(design_data)
		if loader != null:
			sub_data = loader.get_sustainment_equipment(sub_id)
		var sub_per_soldier := float(sub_data.get("supply_consumption", 1.0))
		var extra := int(ceil(200.0 * float(weight) * sub_per_soldier))
		out[sub_id] = int(out.get(sub_id, 0)) + extra


func _sustainment_headcount() -> int:
	var count := 0
	for entry in equipment:
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		if str(entry.get("type", "")).to_lower() == "infantry":
			count += int(entry.get("count", 0))
	if count > 0:
		return count
	if manpower > 0:
		return manpower
	return 0


func _infantry_template_id_for_equipment_entry(entry: Dictionary) -> String:
	var override: Variant = entry.get("infantry_equipment_override")
	if override != null:
		var override_text := str(override)
		if not override_text.is_empty() and override_text.to_lower() != "null":
			return override_text
	return infantry_equipment_template


func _apply_infantry_template_to_subunit(
	subunit: Dictionary,
	equipment_template_id: String,
	loader: DesignDataLoader,
) -> void:
	if equipment_template_id.is_empty():
		return
	var infantry_template := loader.get_infantry_equipment(equipment_template_id)
	if infantry_template == null:
		return
	subunit["infantry_equipment_template"] = equipment_template_id
	subunit["infantry_equipment_stats"] = infantry_template.get_infantry_stats()
	subunit["infantry_equipment_generation"] = infantry_template.infantry_equipment_generation
	subunit["infantry_equipment_type"] = infantry_template.infantry_equipment_type


func _resolve_design_data(design_data: DesignDataLoader) -> DesignDataLoader:
	if design_data != null:
		return design_data
	if GameData.design_data != null:
		return GameData.design_data
	return null


static func _default_infantry_stats() -> Dictionary:
	return {
		"soft_attack": 0.9,
		"hard_attack": 0.03,
		"supply_consumption": 1.0,
		"reliability": 0.95,
		"generation": 1,
		"average_generation": 1,
	}


static func _dict_from_variant(raw: Variant) -> Dictionary:
	if typeof(raw) != TYPE_DICTIONARY:
		return {}
	var out: Dictionary = {}
	for key in raw:
		out[str(key)] = int(raw[key])
	return out
