class_name ScenarioDataResolver
extends RefCounted

const SCENARIOS_DIR := "res://data/scenarios/"
const PACKAGE_SCENARIO_FILE := "scenario.json"
const PACKAGE_MAIN_FILE := "main.json"
const PACKAGE_MANIFEST_FILE := "manifest.json"


static func load_scenario_data(scenario_name: String) -> Dictionary:
	var name := scenario_name.strip_edges()
	if name.is_empty():
		return _failure("Scenario name is empty")

	var package_dir := SCENARIOS_DIR + name + "/"
	var package_scenario := package_dir + PACKAGE_SCENARIO_FILE
	if FileAccess.file_exists(package_scenario):
		return _read_scenario_file(package_scenario, name, package_dir)

	var package_main := package_dir + PACKAGE_MAIN_FILE
	if FileAccess.file_exists(package_main):
		return _read_scenario_file(package_main, name, package_dir)

	var package_manifest := package_dir + PACKAGE_MANIFEST_FILE
	if FileAccess.file_exists(package_manifest):
		var manifest_result := _read_json_file(package_manifest)
		if bool(manifest_result.get("success", false)):
			var manifest: Dictionary = manifest_result.get("data", {}) as Dictionary
			var entry_path := str(manifest.get("scenario_file", manifest.get("loader_entry", "")))
			if not entry_path.is_empty():
				if not entry_path.begins_with("res://"):
					entry_path = package_dir + entry_path
				return _read_scenario_file(entry_path, name, package_dir)

	var legacy_path := SCENARIOS_DIR + name + ".json"
	if FileAccess.file_exists(legacy_path):
		return _read_scenario_file(legacy_path, name, "")

	return _failure("Scenario file not found for '" + name + "'")


static func _read_scenario_file(path: String, scenario_name: String, package_dir: String) -> Dictionary:
	var result := _read_json_file(path)
	if not bool(result.get("success", false)):
		return result

	var data: Dictionary = result.get("data", {}) as Dictionary
	var redirect := str(data.get("scenario_file", data.get("loader_entry", "")))
	var has_payload := data.has("provinces") or data.has("countries") or data.has("country_refs")
	if not redirect.is_empty() and not has_payload:
		var resolved := redirect
		if not resolved.begins_with("res://"):
			var base_dir := package_dir
			if base_dir.is_empty():
				base_dir = _directory_for_path(path)
			resolved = base_dir + resolved
		return _read_scenario_file(resolved, scenario_name, package_dir)

	if not data.has("scenario"):
		data["scenario"] = scenario_name
	data["_source_path"] = path
	data["_package_dir"] = package_dir
	return {"success": true, "data": data, "path": path, "package_dir": package_dir}


static func _read_json_file(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return _failure("Missing JSON file: " + path)
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return _failure("Could not open JSON file: " + path)
	var json := JSON.new()
	var parse_result := json.parse(file.get_as_text())
	file.close()
	if parse_result != OK or typeof(json.data) != TYPE_DICTIONARY:
		return _failure("Failed to parse JSON file: " + path)
	return {"success": true, "data": json.data}


static func _directory_for_path(path: String) -> String:
	var slash := path.rfind("/")
	if slash < 0:
		return ""
	return path.substr(0, slash + 1)


static func _failure(message: String) -> Dictionary:
	return {"success": false, "error": message, "data": {}}
