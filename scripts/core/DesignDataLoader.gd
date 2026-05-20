class_name DesignDataLoader
extends RefCounted

const MODULES_DIR := "res://data/modules/"
const TEMPLATES_DIR := "res://data/unit_templates/"
const RULES_PATH := "res://data/production/production_line_rules.json"

var modules: Dictionary = {}
var templates: Dictionary = {}
var production_rules: Dictionary = {}


func load_all() -> void:
	load_modules()
	load_templates()
	load_production_rules()


func load_modules() -> void:
	modules = _load_json_objects_from_dir(MODULES_DIR, EquipmentModule.from_dict)
	print("✅ Equipment modules loaded: ", modules.size())


func load_templates() -> void:
	templates = _load_json_objects_from_dir(TEMPLATES_DIR, UnitTemplate.from_dict)
	print("✅ Unit templates loaded: ", templates.size())


func load_production_rules() -> void:
	production_rules = _load_json_dict(RULES_PATH)
	if production_rules.is_empty():
		push_warning("Production line rules missing or invalid: " + RULES_PATH)
	else:
		print("✅ Production line rules loaded")


func get_module(module_id: String) -> EquipmentModule:
	return modules.get(module_id)


func get_template(template_id: String) -> UnitTemplate:
	return templates.get(template_id)


func get_refinement_project_defs() -> Array:
	var raw = production_rules.get("refinement_projects", [])
	return raw if typeof(raw) == TYPE_ARRAY else []


func get_refinement_def(project_id: String) -> Dictionary:
	for entry in get_refinement_project_defs():
		if typeof(entry) == TYPE_DICTIONARY and str(entry.get("id", "")) == project_id:
			return entry
	return {}


func _load_json_objects_from_dir(dir_path: String, factory: Callable) -> Dictionary:
	var out: Dictionary = {}
	_load_json_objects_from_dir_recursive(dir_path, factory, out)
	return out


func _load_json_objects_from_dir_recursive(
	dir_path: String,
	factory: Callable,
	out: Dictionary,
) -> void:
	var dir := DirAccess.open(dir_path)
	if dir == null:
		push_warning("Could not open directory: " + dir_path)
		return
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if file_name == "." or file_name == "..":
			file_name = dir.get_next()
			continue
		var full_path := dir_path.path_join(file_name)
		if dir.current_is_dir():
			_load_json_objects_from_dir_recursive(full_path, factory, out)
		elif file_name.ends_with(".json"):
			var data := _load_json_dict(full_path)
			if data.is_empty():
				file_name = dir.get_next()
				continue
			var obj: Variant = factory.call(data)
			if obj == null:
				file_name = dir.get_next()
				continue
			var obj_id := str(data.get("id", data.get("template_id", "")))
			if obj_id.is_empty() and obj is Resource:
				obj_id = str(obj.get("id"))
			if not obj_id.is_empty():
				out[obj_id] = obj
		file_name = dir.get_next()
	dir.list_dir_end()


func _load_json_dict(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		push_warning("Missing JSON file: " + path)
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	if not file:
		push_warning("Could not open JSON file: " + path)
		return {}
	var json := JSON.new()
	var parse_result := json.parse(file.get_as_text())
	file.close()
	if parse_result != OK or typeof(json.data) != TYPE_DICTIONARY:
		push_warning("Failed to parse JSON: " + path)
		return {}
	return json.data
