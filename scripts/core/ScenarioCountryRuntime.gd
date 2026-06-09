class_name ScenarioCountryRuntime
extends RefCounted

const COUNTRIES_DIR := "res://data/countries/"


static func resolve_countries(scenario_data: Dictionary) -> Dictionary:
	var entries: Array[Dictionary] = []

	if scenario_data.has("country_refs"):
		entries = _entries_from_refs(scenario_data.get("country_refs", []))
	elif scenario_data.has("countries"):
		entries = _entries_from_countries_block(scenario_data.get("countries", []))

	var registry: Dictionary = {}
	for entry in entries:
		var tag := str(entry.get("tag", "")).strip_edges().to_upper()
		if tag.is_empty():
			push_warning("ScenarioCountryRuntime: skipped country without tag")
			continue
		entry["tag"] = tag
		entry["color"] = parse_country_color(entry.get("color", "#CCCCCC"))
		registry[tag] = entry

	return {"registry": registry, "entries": entries}


static func parse_country_color(raw: Variant) -> Color:
	match typeof(raw):
		TYPE_COLOR:
			return raw as Color
		TYPE_STRING:
			return Color(String(raw))
		TYPE_ARRAY:
			var a: Array = raw
			if a.size() < 3:
				return Color(0.65, 0.65, 0.65)
			var rf := float(a[0])
			var gf := float(a[1])
			var bf := float(a[2])
			var af := float(a[3]) if a.size() > 3 else 1.0
			if rf > 1.0 or gf > 1.0 or bf > 1.0:
				rf /= 255.0
				gf /= 255.0
				bf /= 255.0
				if a.size() > 3 and af > 1.0:
					af /= 255.0
			return Color(rf, gf, bf, af)
		_:
			return Color(0.65, 0.65, 0.65)


static func _entries_from_refs(raw_refs: Variant) -> Array[Dictionary]:
	var out: Array[Dictionary] = []
	if typeof(raw_refs) != TYPE_ARRAY:
		push_warning("ScenarioCountryRuntime: country_refs must be an array")
		return out

	for raw_ref in raw_refs as Array:
		var entry := _entry_from_reference(raw_ref)
		if not entry.is_empty():
			out.append(entry)
	return out


static func _entries_from_countries_block(block: Variant) -> Array[Dictionary]:
	var out: Array[Dictionary] = []
	match typeof(block):
		TYPE_ARRAY:
			for item in block as Array:
				var entry := _entry_from_reference_or_inline(item, "")
				if not entry.is_empty():
					out.append(entry)
		TYPE_DICTIONARY:
			for key in (block as Dictionary).keys():
				var inner: Variant = (block as Dictionary)[key]
				var entry := _entry_from_reference_or_inline(inner, str(key))
				if not entry.is_empty():
					out.append(entry)
		_:
			push_warning("ScenarioCountryRuntime: countries must be an array or object")
	return out


static func _entry_from_reference_or_inline(raw: Variant, tag_hint: String) -> Dictionary:
	if typeof(raw) == TYPE_STRING:
		return _entry_from_reference(raw)
	if typeof(raw) != TYPE_DICTIONARY:
		return {}

	var d: Dictionary = (raw as Dictionary).duplicate(true)
	var ref := str(d.get("ref", d.get("country_ref", d.get("definition", ""))))
	if ref.is_empty():
		if not d.has("tag") and not tag_hint.is_empty():
			d["tag"] = tag_hint
		return d

	var base := _entry_from_reference(ref)
	if base.is_empty():
		return {}
	for key in d.keys():
		var k := str(key)
		if k in ["ref", "country_ref", "definition"]:
			continue
		base[k] = d[key]
	if not base.has("tag") and not tag_hint.is_empty():
		base["tag"] = tag_hint
	return base


static func _entry_from_reference(raw_ref: Variant) -> Dictionary:
	var ref := str(raw_ref).strip_edges()
	if ref.is_empty():
		return {}

	var direct_path := ref
	if not direct_path.begins_with("res://"):
		if direct_path.ends_with(".json"):
			direct_path = COUNTRIES_DIR + direct_path
		else:
			direct_path = COUNTRIES_DIR + direct_path + ".json"
	if FileAccess.file_exists(direct_path):
		return _read_country_file(direct_path)

	var by_tag_path := _find_country_file_by_tag(ref)
	if not by_tag_path.is_empty():
		return _read_country_file(by_tag_path)

	push_warning("ScenarioCountryRuntime: country definition not found for '" + ref + "'")
	return {}


static func _find_country_file_by_tag(tag: String) -> String:
	var needle := tag.strip_edges().to_upper()
	if needle.is_empty():
		return ""
	var dir := DirAccess.open(COUNTRIES_DIR)
	if dir == null:
		return ""
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".json"):
			var path := COUNTRIES_DIR + file_name
			var data := _read_country_file(path)
			if str(data.get("tag", "")).strip_edges().to_upper() == needle:
				dir.list_dir_end()
				return path
		file_name = dir.get_next()
	dir.list_dir_end()
	return ""


static func _read_country_file(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_warning("ScenarioCountryRuntime: could not open country file " + path)
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	file.close()
	if typeof(parsed) != TYPE_DICTIONARY:
		push_warning("ScenarioCountryRuntime: invalid country JSON at " + path)
		return {}
	var data: Dictionary = (parsed as Dictionary).duplicate(true)
	data["_source_path"] = path
	return data
