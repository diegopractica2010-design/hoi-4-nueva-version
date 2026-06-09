class_name ScenarioProvinceApplier
extends RefCounted


static func apply_overrides(provinces: Dictionary, scenario_data: Dictionary) -> void:
	if not scenario_data.has("provinces"):
		return
	var raw_provinces: Variant = scenario_data["provinces"]
	if typeof(raw_provinces) != TYPE_ARRAY:
		push_warning("ScenarioProvinceApplier: scenario provinces must be an array")
		return

	for p_data in raw_provinces as Array:
		if typeof(p_data) != TYPE_DICTIONARY:
			continue
		var d: Dictionary = p_data
		var id := int(d.get("id", 0))
		if not provinces.has(id):
			push_warning("ScenarioProvinceApplier: province id %d not found in base map" % id)
			continue
		_apply_province_override(provinces[id] as Province, d)


static func _apply_province_override(p: Province, d: Dictionary) -> void:
	if p == null:
		return
	p.owner_tag = str(d.get("owner_tag", p.owner_tag))
	p.controller_tag = str(d.get("controller_tag", p.controller_tag))
	p.factories = int(d.get("factories", p.factories))
	p.development_level = int(d.get("development_level", p.development_level))
	p.infrastructure = int(d.get("infrastructure", p.infrastructure))
	if d.has("population"):
		p.population = int(d["population"])
	p.victory_points = int(d.get("victory_points", p.victory_points))
	if d.has("core_for_tags") or d.has("core_for"):
		p.core_for = _string_array_from_json(d.get("core_for_tags", d.get("core_for", [])))
	if d.has("tags"):
		p.tags = _string_array_from_json(d["tags"])
	if d.has("terrain"):
		p.terrain = str(d["terrain"])
	if d.has("is_sea"):
		p.is_sea = bool(d["is_sea"])
	if d.has("has_port"):
		p.has_port = bool(d["has_port"])
	if d.has("natural_resources") or d.has("resources"):
		var rr: Variant = d.get("natural_resources", d.get("resources", {}))
		p.resources = rr.duplicate(true) if typeof(rr) == TYPE_DICTIONARY else {}
	if d.has("special_features"):
		p.special_features = _merged_special_features_from(
			d["special_features"],
			d.get("special_levels", {}),
		)
	elif d.has("special_levels"):
		var merged: Dictionary = p.special_features.duplicate(true)
		var levels: Variant = d["special_levels"]
		if typeof(levels) == TYPE_DICTIONARY:
			for k in (levels as Dictionary).keys():
				merged[str(k)] = int((levels as Dictionary)[k])
		p.special_features = merged


static func _string_array_from_json(raw: Variant) -> Array[String]:
	var out: Array[String] = []
	if typeof(raw) != TYPE_ARRAY:
		return out
	for item in raw as Array:
		out.append(str(item))
	return out


static func _merged_special_features_from(features_variant: Variant, levels_variant: Variant) -> Dictionary:
	var levels: Dictionary = levels_variant if typeof(levels_variant) == TYPE_DICTIONARY else {}
	var out: Dictionary = {}
	if typeof(features_variant) == TYPE_DICTIONARY:
		for k in (features_variant as Dictionary).keys():
			var ks := str(k)
			out[ks] = _special_level_coerce((features_variant as Dictionary)[k], levels, ks)
	elif typeof(features_variant) == TYPE_ARRAY:
		for item in features_variant as Array:
			var ks := str(item)
			var lvl := 1
			if levels.has(item):
				lvl = int(levels[item])
			elif levels.has(ks):
				lvl = int(levels[ks])
			out[ks] = lvl
	for k in levels.keys():
		var ks := str(k)
		if not out.has(ks):
			out[ks] = int(levels[k])
	return out


static func _special_level_coerce(v: Variant, levels: Dictionary, key: String) -> int:
	match typeof(v):
		TYPE_INT, TYPE_FLOAT:
			return int(v)
		TYPE_BOOL:
			return 1 if v else 0
		_:
			if levels.has(key):
				return int(levels[key])
			return 1
