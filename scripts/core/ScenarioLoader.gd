class_name ScenarioLoader
extends Node

var base_provinces: Dictionary = {}
var provinces: Dictionary = {}
## Key = country tag (e.g. "GER"); value = Country resource or plain Dictionary with at least `color` (and usually `tag`, `name`).
var countries: Dictionary = {}
var province_geometry: Dictionary = {}
var province_adjacency: Dictionary = {}
var province_terrain_layer: Dictionary = {}
var province_city_layer: Dictionary = {}
var province_economy_layer: Dictionary = {}
var province_resources_layer: Dictionary = {}
var province_state_by_id: Dictionary = {}
var province_region_by_id: Dictionary = {}
var province_projects_by_id: Dictionary = {}

## Built when a scenario is loaded; used by MapRenderer.initialize and pathfinding helpers.
var adjacency_system: AdjacencySystem

## Current/last loaded scenario name (for SaveLoadManager metadata and validation).
var current_scenario_name: String = ""
var _last_scenario_data: Dictionary = {}

signal scenario_loaded()

func get_current_scenario_name() -> String:
	return current_scenario_name

func _ready():
	load_province_geometry()
	load_province_layers()
	load_base_provinces()

func load_province_geometry():
	var file_path = "res://data/provinces/provinces_geometry.json"
	province_geometry.clear()
	if not FileAccess.file_exists(file_path):
		push_warning("Province geometry file missing: " + file_path)
		return

	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		push_warning("Could not open province geometry file: " + file_path)
		return

	var json = JSON.new()
	var parse_result = json.parse(file.get_as_text())
	file.close()
	if parse_result != OK:
		push_warning("Failed to parse province geometry JSON")
		return

	var data = json.data
	if typeof(data) != TYPE_DICTIONARY:
		push_warning("Province geometry JSON root must be a dictionary")
		return

	var entries = data.get("provinces", [])
	if typeof(entries) != TYPE_ARRAY:
		push_warning("Province geometry 'provinces' must be an array")
		return

	for entry in entries:
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		var province_id = int(entry.get("id", 0))
		if province_id <= 0:
			continue
		province_geometry[province_id] = entry

	print("[OK] Province geometry loaded: ", province_geometry.size())

func load_province_layers():
	_load_adjacency_layer()
	_load_terrain_layer()
	_load_city_layer()
	_load_resources_layer()
	_load_economy_layer()
	_load_state_and_region_layers()
	_load_project_sites_layer()

func _load_json_dict(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		push_warning("Missing layer file: " + path)
		return {}
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		push_warning("Could not open layer file: " + path)
		return {}
	var json = JSON.new()
	var parse_result = json.parse(file.get_as_text())
	file.close()
	if parse_result != OK or typeof(json.data) != TYPE_DICTIONARY:
		push_warning("Failed to parse layer file: " + path)
		return {}
	return json.data

func _load_adjacency_layer():
	province_adjacency.clear()
	var data = _load_json_dict("res://data/provinces/province_adjacency.json")
	var raw = data.get("adjacency", {})
	if typeof(raw) == TYPE_DICTIONARY:
		province_adjacency = raw

func _load_terrain_layer():
	province_terrain_layer.clear()
	var data = _load_json_dict("res://data/provinces/province_terrain_layer.json")
	var raw = data.get("provinces", {})
	if typeof(raw) == TYPE_DICTIONARY:
		province_terrain_layer = raw

func _load_city_layer():
	province_city_layer.clear()
	var data = _load_json_dict("res://data/provinces/province_city_layer.json")
	var raw = data.get("provinces", {})
	if typeof(raw) == TYPE_DICTIONARY:
		province_city_layer = raw

func _load_resources_layer():
	province_resources_layer.clear()
	var data = _load_json_dict("res://data/provinces/province_resources_layer.json")
	var raw = data.get("provinces", {})
	if typeof(raw) == TYPE_DICTIONARY:
		province_resources_layer = raw

func _load_economy_layer():
	province_economy_layer.clear()
	var data = _load_json_dict("res://data/provinces/province_economy_layer.json")
	var raw = data.get("provinces", {})
	if typeof(raw) == TYPE_DICTIONARY:
		province_economy_layer = raw

func _load_state_and_region_layers():
	province_state_by_id.clear()
	province_region_by_id.clear()
	var states_data = _load_json_dict("res://data/provinces/province_states.json")
	var states = states_data.get("states", [])
	if typeof(states) == TYPE_ARRAY:
		for s in states:
			if typeof(s) != TYPE_DICTIONARY:
				continue
			var state_id = int(s.get("id", 0))
			var pids = s.get("province_ids", [])
			if typeof(pids) == TYPE_ARRAY:
				for pid in pids:
					province_state_by_id[int(pid)] = state_id

	var regions_data = _load_json_dict("res://data/provinces/strategic_regions.json")
	var regions = regions_data.get("regions", [])
	if typeof(regions) == TYPE_ARRAY:
		for r in regions:
			if typeof(r) != TYPE_DICTIONARY:
				continue
			var region_id = int(r.get("id", 0))
			var pids = r.get("province_ids", [])
			if typeof(pids) == TYPE_ARRAY:
				for pid in pids:
					province_region_by_id[int(pid)] = region_id

func _load_project_sites_layer():
	province_projects_by_id.clear()
	var data = _load_json_dict("res://data/provinces/project_sites.json")
	var sites = data.get("sites", [])
	if typeof(sites) != TYPE_ARRAY:
		return
	for site in sites:
		if typeof(site) != TYPE_DICTIONARY:
			continue
		var pid = int(site.get("province_id", 0))
		if pid <= 0:
			continue
		if not province_projects_by_id.has(pid):
			province_projects_by_id[pid] = []
		province_projects_by_id[pid].append(site)

func load_base_provinces():
	var file_path = "res://data/provinces/provinces_base.json"
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		push_warning("Could not open base provinces file: " + file_path)
		return
	var json = JSON.new()
	var parse_result = json.parse(file.get_as_text())
	file.close()
	if parse_result != OK or typeof(json.data) != TYPE_DICTIONARY:
		push_warning("Failed to parse base provinces JSON: " + file_path)
		return
	var data = json.data
	if not data.has("provinces") or typeof(data["provinces"]) != TYPE_ARRAY:
		push_warning("Base provinces JSON missing 'provinces' array")
		return
	base_provinces.clear()
	for p_data in data["provinces"]:
		var p = Province.new()
		p.id = int(p_data.get("id", 0))
		p.name = str(p_data.get("name", "Unnamed"))
		p.terrain = str(p_data.get("terrain", "plains"))
		p.is_sea = bool(p_data.get("is_sea", false))
		if not p.is_sea and (p.terrain.to_lower() == "sea" or p.terrain.to_lower() == "ocean"):
			p.is_sea = true
		if p_data.has("has_port"):
			p.has_port = bool(p_data["has_port"])
		var raw_res = p_data.get("natural_resources", p_data.get("resources", {}))
		p.resources = raw_res.duplicate(true) if typeof(raw_res) == TYPE_DICTIONARY else {}
		p.owner_tag = str(p_data.get("owner_tag", ""))
		p.controller_tag = str(p_data.get("controller_tag", ""))
		p.core_for = _string_array_from_json(p_data.get("core_for_tags", p_data.get("core_for", [])))
		p.tags = _string_array_from_json(p_data.get("tags", []))
		p.development_level = int(p_data.get("development_level", 1))
		p.infrastructure = int(p_data.get("infrastructure", 1))
		p.factories = int(p_data.get("factories", 0))
		p.population = int(p_data.get("population_base", p_data.get("population", 1_000_000)))
		p.victory_points = int(p_data.get("victory_points", 0))
		p.special_features = _merged_special_features_from(p_data.get("special_features", []), p_data.get("special_levels", {}))
		_apply_geometry_to_province(p)
		_apply_layer_data_to_province(p)
		base_provinces[p.id] = p
	_infer_port_access_for_all(base_provinces)
	print("[OK] Base provinces loaded: ", base_provinces.size(), " provinces")

func load_scenario(scenario_name: String) -> bool:
	var scenario_result := ScenarioDataResolver.load_scenario_data(scenario_name)
	if not bool(scenario_result.get("success", false)):
		push_warning(str(scenario_result.get("error", "Could not load scenario")))
		return false
	var data: Dictionary = scenario_result.get("data", {}) as Dictionary
	var scenario_year := _parse_scenario_start_year(data)
	if scenario_year < 0:
		push_error("ScenarioLoader: aborting load due to invalid start_date.")
		return false
	var start_date_str := str(data.get("start_date", ""))
	var country_result := ScenarioCountryRuntime.resolve_countries(data)
	var resolved_country_entries: Array = country_result.get("entries", []) as Array
	var scenario_runtime_data := data.duplicate(true)
	scenario_runtime_data["countries"] = resolved_country_entries

	current_scenario_name = scenario_name
	_last_scenario_data = data
	
	provinces.clear()
	countries.clear()

	for id in base_provinces:
		provinces[id] = _duplicate_province_from_base(base_provinces[id])

	ScenarioProvinceApplier.apply_overrides(provinces, data)
	countries = country_result.get("registry", {}) as Dictionary

	_rebuild_adjacency_system()
	_infer_port_access_for_all(provinces)
	_spawn_scenario_factories(scenario_name, scenario_runtime_data)
	# New central clock (non-breaking: we still pass year to legacy systems for now)
	if typeof(TimeManager) != TYPE_NIL:
		TimeManager.initialize_from_scenario_start_date(start_date_str)

	_load_scenario_leaders(scenario_name, scenario_year)
	_apply_scenario_starting_technology(scenario_name, scenario_year)
	_spawn_scenario_formations(scenario_name)
	_deploy_starting_forces(data)
	var production_mgr := get_node_or_null("/root/ProductionManager")
	if production_mgr != null and production_mgr.has_method("clear_all_caches"):
		production_mgr.clear_all_caches()
	if typeof(AIManager) != TYPE_NIL and AIManager.has_method("configure_scenario_state"):
		AIManager.configure_scenario_state(scenario_runtime_data)
	print("[OK] Scenario loaded | Provinces: ", provinces.size(), " | Countries: ", countries.size())
	scenario_loaded.emit()

	# Centralize map data for the rest of the game (MapManager is the preferred access point)
	var mm := get_node_or_null("/root/MapManager")
	if mm != null and mm.has_method("initialize_from_map_data"):
		var map_data := get_map_data()
		mm.call("initialize_from_map_data", map_data)

	return true


func get_war_state() -> Dictionary:
	return _last_scenario_data.get("initial_war_state", {})


## Despliega las fuerzas iniciales del escenario (starting_forces) colocando las
## formaciones de cada nacion en sus provincias historicas (Santiago, Antofagasta,
## Lima, Arica, Sucre, La Paz...). Antes las formaciones nacian sin posicion (province_id=-1).
func _deploy_starting_forces(data: Dictionary) -> void:
	if typeof(LeaderManager) == TYPE_NIL:
		return
	var forces: Variant = data.get("starting_forces", [])
	if typeof(forces) != TYPE_ARRAY:
		return

	# Agrupar formaciones existentes (sin desplegar) por nacion.
	var pool: Dictionary = {}  # tag -> Array[Formation]
	for fid in LeaderManager.formations:
		var f: Formation = LeaderManager.formations[fid]
		if f == null:
			continue
		var tag := f.country_tag.strip_edges().to_upper()
		if not pool.has(tag):
			pool[tag] = []
		(pool[tag] as Array).append(f)

	var deployed := 0
	for entry in forces as Array:
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		var tag := str((entry as Dictionary).get("country", "")).strip_edges().to_upper()
		var pid := int((entry as Dictionary).get("province", -1))
		var count := int((entry as Dictionary).get("count", 1))
		if pid < 0 or not pool.has(tag):
			continue
		var arr: Array = pool[tag]
		for _i in count:
			if arr.is_empty():
				break
			var f: Formation = arr.pop_back()
			f.province_id = pid
			deployed += 1
	print("[OK] Starting forces deployed: %d formaciones colocadas en sus provincias" % deployed)


func _spawn_scenario_factories(scenario_name: String, scenario_data: Dictionary) -> void:
	ScenarioFactoryBootstrap.spawn_factories(scenario_name, scenario_data, self)


func _parse_scenario_start_year(data: Dictionary) -> int:
	var start_date := str(data.get("start_date", ""))
	var parts := start_date.split("-")
	if parts.size() != 3:
		return -1
	for part in parts:
		if not part.is_valid_int():
			return -1
	var year := int(parts[0])
	var month := int(parts[1])
	var day := int(parts[2])
	if year < 1 or month < 1 or month > 12:
		return -1
	var days_per_month: Array[int] = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
	if (year % 400 == 0) or (year % 4 == 0 and year % 100 != 0):
		days_per_month[1] = 29
	if day < 1 or day > days_per_month[month - 1]:
		return -1
	if year >= 1:
		return year
	return -1


func _load_scenario_leaders(scenario_name: String, start_year: int) -> void:
	if typeof(LeaderManager) == TYPE_NIL:
		return
	var loaded := LeaderManager.load_leaders_for_scenario(scenario_name, start_year)
	print(
		"[OK] Scenario leaders loaded (%s, %d): %d active, %d pooled"
		% [
			scenario_name,
			start_year,
			loaded,
			LeaderManager.get_pool_leader_count(),
		]
	)


func _apply_scenario_starting_technology(scenario_name: String, start_year: int) -> void:
	if typeof(TechnologyManager) == TYPE_NIL:
		return
	var tags: Array[String] = []
	for tag in countries.keys():
		tags.append(str(tag))
	TechnologyManager.apply_scenario_starting_tech(scenario_name, tags, start_year)


func _spawn_scenario_formations(scenario_name: String) -> void:
	LeaderManager.clear_all_formations()
	var formation_spawner := FormationSpawner.new()
	var countries_to_spawn: Array[String] = _get_formation_spawn_countries(scenario_name)
	var count_by_tag: Dictionary = _get_formation_counts_for_scenario(scenario_name)
	for country_tag in countries_to_spawn:
		var count := int(count_by_tag.get(country_tag, 4))
		formation_spawner.spawn_test_formations_for_country(country_tag, count)
	LeaderManager.clear_all_leader_caches()
	print(
		"Scenario loaded with formations for %d countries (leader assignment)."
		% countries_to_spawn.size()
	)


func _get_formation_spawn_countries(_scenario_name: String) -> Array[String]:
	var tags: Array[String] = []
	for tag in countries.keys():
		tags.append(str(tag))
	if tags.is_empty():
		return ["GER", "USA", "SOV"] as Array[String]
	tags.sort()
	return tags


func _get_formation_counts_for_scenario(scenario_name: String) -> Dictionary:
	var counts: Dictionary = {}
	for tag in countries.keys():
		var country: Variant = countries[tag]
		var is_major := false
		if typeof(country) == TYPE_DICTIONARY:
			is_major = bool((country as Dictionary).get("major_power", false))
		counts[str(tag)] = 8 if is_major else 4
	if scenario_name == "1918":
		for major_tag in ["GER", "FRA", "ENG", "USA", "SOV", "JAP"]:
			counts[major_tag] = 8
	return counts


func get_country(tag: String) -> Variant:
	return countries.get(tag)


func get_map_data() -> MapScenarioData:
	return MapScenarioData.new(provinces, build_geometry_dict_for_map(), adjacency_system, countries)



## Geometry dict keyed by province id -> { "points": PackedVector2Array, "label_anchor": Vector2 } for MapRenderer.
func build_geometry_dict_for_map() -> Dictionary:
	var out: Dictionary = {}
	for gid in province_geometry:
		var entry: Variant = province_geometry[gid]
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		var pid := int(gid)
		var pts := PackedVector2Array()
		var raw_points = entry.get("points", [])
		if typeof(raw_points) == TYPE_ARRAY:
			for rp in raw_points:
				if typeof(rp) == TYPE_ARRAY and rp.size() >= 2:
					pts.append(Vector2(float(rp[0]), float(rp[1])))
		var anchor := Vector2.ZERO
		var raw_anchor = entry.get("label_anchor", [])
		if typeof(raw_anchor) == TYPE_ARRAY and raw_anchor.size() >= 2:
			anchor = Vector2(float(raw_anchor[0]), float(raw_anchor[1]))
		elif pts.size() > 0:
			var c := Vector2.ZERO
			for pt in pts:
				c += pt
			anchor = c / pts.size()
		out[pid] = {"points": pts, "label_anchor": anchor}
	return out


func _infer_port_access_for_all(province_map: Dictionary) -> void:
	for id in province_map:
		var p: Province = province_map[id]
		if p == null or p.is_sea:
			p.has_port = false
			continue
		if p.has_port or p.resolve_has_port():
			p.has_port = true
			continue
		for neighbor_id in p.adjacencies:
			var neighbor: Province = province_map.get(neighbor_id)
			if neighbor != null and neighbor.is_sea:
				p.has_port = true
				break


func _rebuild_adjacency_system() -> void:
	adjacency_system = AdjacencySystem.new()
	adjacency_system.load_adjacency()
	adjacency_system.begin_bulk_registration()
	for p in provinces.values():
		adjacency_system.register_province(p)
	adjacency_system.end_bulk_registration()


func get_city_layer() -> Dictionary:
	return province_city_layer


func get_city_count(province_id: int) -> int:
	var pid_key := str(province_id)
	if province_city_layer.has(pid_key):
		var city_entry = province_city_layer[pid_key]
		if typeof(city_entry) == TYPE_DICTIONARY:
			var cities = city_entry.get("cities", [])
			if typeof(cities) == TYPE_ARRAY:
				return cities.size()
	return 0


func _duplicate_province_from_base(base_p: Province) -> Province:
	var p := Province.new()
	p.id = base_p.id
	p.name = base_p.name
	p.terrain = base_p.terrain
	p.is_sea = base_p.is_sea
	p.has_port = base_p.has_port
	p.coordinates = base_p.coordinates
	p.adjacencies = base_p.adjacencies.duplicate()
	p.owner_tag = base_p.owner_tag
	p.controller_tag = base_p.controller_tag
	p.core_for = base_p.core_for.duplicate()
	p.development_level = base_p.development_level
	p.infrastructure = base_p.infrastructure
	p.factories = base_p.factories
	p.population = base_p.population
	p.resources = base_p.resources.duplicate(true)
	p.victory_points = base_p.victory_points
	p.special_features = base_p.special_features.duplicate(true)
	p.tags = base_p.tags.duplicate()
	return p


func _string_array_from_json(raw: Variant) -> Array[String]:
	var out: Array[String] = []
	if typeof(raw) != TYPE_ARRAY:
		return out
	for item in raw:
		out.append(str(item))
	return out


func _merged_special_features_from(features_variant: Variant, levels_variant: Variant) -> Dictionary:
	var levels: Dictionary = levels_variant if typeof(levels_variant) == TYPE_DICTIONARY else {}
	var out: Dictionary = {}
	if typeof(features_variant) == TYPE_DICTIONARY:
		for k in features_variant:
			var ks := str(k)
			out[ks] = _special_level_coerce(features_variant[k], levels, ks)
	elif typeof(features_variant) == TYPE_ARRAY:
		for item in features_variant:
			var ks := str(item)
			var lvl := 1
			if levels.has(item):
				lvl = int(levels[item])
			elif levels.has(ks):
				lvl = int(levels[ks])
			out[ks] = lvl
	for k in levels:
		var ks := str(k)
		if not out.has(ks):
			out[ks] = int(levels[k])
	return out


func _special_level_coerce(v: Variant, levels: Dictionary, key: String) -> int:
	match typeof(v):
		TYPE_INT, TYPE_FLOAT:
			return int(v)
		TYPE_BOOL:
			return 1 if v else 0
		_:
			if levels.has(key):
				return int(levels[key])
			return 1


func _apply_geometry_to_province(p: Province):
	if not province_geometry.has(p.id):
		p.coordinates = Vector2.ZERO
		return

	var geometry = province_geometry[p.id]
	if typeof(geometry) != TYPE_DICTIONARY:
		return

	var raw_points = geometry.get("points", [])
	var points := PackedVector2Array()
	if typeof(raw_points) == TYPE_ARRAY:
		for raw_point in raw_points:
			if typeof(raw_point) == TYPE_ARRAY and raw_point.size() >= 2:
				points.append(Vector2(float(raw_point[0]), float(raw_point[1])))

	var raw_anchor = geometry.get("label_anchor", [])
	if typeof(raw_anchor) == TYPE_ARRAY and raw_anchor.size() >= 2:
		p.coordinates = Vector2(float(raw_anchor[0]), float(raw_anchor[1]))
	elif points.size() > 0:
		var center := Vector2.ZERO
		for point in points:
			center += point
		p.coordinates = center / points.size()
	else:
		p.coordinates = Vector2.ZERO


func _apply_layer_data_to_province(p: Province):
	var pid_key := str(p.id)
	p.adjacencies.clear()
	if province_adjacency.has(pid_key) and typeof(province_adjacency[pid_key]) == TYPE_ARRAY:
		for neighbor in province_adjacency[pid_key]:
			p.adjacencies.append(int(neighbor))

	if province_terrain_layer.has(pid_key) and typeof(province_terrain_layer[pid_key]) == TYPE_DICTIONARY:
		var terrain_data: Dictionary = province_terrain_layer[pid_key].duplicate(true)
		if terrain_data.has("terrain"):
			p.terrain = str(terrain_data["terrain"])
			if not p.is_sea:
				var tt := str(terrain_data["terrain"]).to_lower()
				if tt == "sea" or tt == "ocean":
					p.is_sea = true

	if province_resources_layer.has(pid_key) and typeof(province_resources_layer[pid_key]) == TYPE_DICTIONARY:
		var resources_data: Dictionary = province_resources_layer[pid_key].duplicate(true)
		if resources_data.has("resources"):
			p.resources = resources_data["resources"].duplicate(true)

	if province_economy_layer.has(pid_key) and typeof(province_economy_layer[pid_key]) == TYPE_DICTIONARY:
		var economy_data: Dictionary = province_economy_layer[pid_key].duplicate(true)
		p.population = int(economy_data.get("population", p.population))
		p.factories = int(economy_data.get("factories", p.factories))
		p.infrastructure = int(economy_data.get("infrastructure", p.infrastructure))
		p.development_level = int(round(float(economy_data.get("development_level", p.development_level))))
		if economy_data.has("resources"):
			p.resources = economy_data["resources"].duplicate(true)
