# scripts/map/MapDataValidator.gd
## Reusable integrity validator for the map data layer (data/provinces/*).
##
## Goal: detect map inconsistencies automatically before they reach runtime,
## so future historical-theater expansion (new provinces/states/regions) cannot
## silently introduce broken references or duplicate IDs.
##
## Usage (headless or in-editor):
##   var report := MapDataValidator.validate_all()
##   print(MapDataValidator.format_report(report))
##   if not report["ok"]:
##       push_error("Map data validation failed")
##
## This validator only READS data files. It never mutates project state.
class_name MapDataValidator
extends RefCounted

const PROVINCES_DIR := "res://data/provinces/"

const FILE_BASE := PROVINCES_DIR + "provinces_base.json"
const FILE_GEOMETRY := PROVINCES_DIR + "provinces_geometry.json"
const FILE_ADJACENCY := PROVINCES_DIR + "province_adjacency.json"
const FILE_TERRAIN := PROVINCES_DIR + "province_terrain_layer.json"
const FILE_CITY := PROVINCES_DIR + "province_city_layer.json"
const FILE_ECONOMY := PROVINCES_DIR + "province_economy_layer.json"
const FILE_RESOURCES := PROVINCES_DIR + "province_resources_layer.json"
const FILE_STATES := PROVINCES_DIR + "province_states.json"
const FILE_REGIONS := PROVINCES_DIR + "strategic_regions.json"
const FILE_PROJECT_SITES := PROVINCES_DIR + "project_sites.json"

const SEVERITY_ERROR := "ERROR"
const SEVERITY_WARNING := "WARNING"
const SEVERITY_INFO := "INFO"


## Runs every check and returns a structured report:
## {
##   "ok": bool,                       # false if any ERROR-level issue exists
##   "error_count": int,
##   "warning_count": int,
##   "info_count": int,
##   "province_count": int,
##   "issues": Array[Dictionary],      # each: {severity, code, message}
##   "stats": Dictionary,              # quick counters for reports
## }
static func validate_all() -> Dictionary:
	var issues: Array[Dictionary] = []
	var stats: Dictionary = {}

	var base_ids := _validate_base(issues, stats)
	_validate_geometry(base_ids, issues, stats)
	_validate_adjacency(base_ids, issues, stats)
	_validate_layer_keys(FILE_TERRAIN, "terreno", base_ids, issues, stats, "terrain")
	_validate_layer_keys(FILE_CITY, "ciudades", base_ids, issues, stats, "city")
	_validate_layer_keys(FILE_ECONOMY, "economia", base_ids, issues, stats, "economy")
	_validate_layer_keys(FILE_RESOURCES, "recursos", base_ids, issues, stats, "resources")
	_validate_grouping(FILE_STATES, "states", "estado", base_ids, issues, stats, "states")
	_validate_grouping(FILE_REGIONS, "regions", "region estrategica", base_ids, issues, stats, "regions")
	_validate_project_sites(base_ids, issues, stats)

	var error_count := 0
	var warning_count := 0
	var info_count := 0
	for issue in issues:
		match issue.get("severity", SEVERITY_INFO):
			SEVERITY_ERROR:
				error_count += 1
			SEVERITY_WARNING:
				warning_count += 1
			_:
				info_count += 1

	return {
		"ok": error_count == 0,
		"error_count": error_count,
		"warning_count": warning_count,
		"info_count": info_count,
		"province_count": base_ids.size(),
		"issues": issues,
		"stats": stats,
	}


## Human-readable Spanish report for logs and docs.
static func format_report(report: Dictionary) -> String:
	var lines: Array[String] = []
	lines.append("===== VALIDACION DE DATOS DEL MAPA =====")
	lines.append("Provincias base: %d" % int(report.get("province_count", 0)))
	lines.append(
		"Resultado: %s | Errores: %d | Advertencias: %d | Info: %d"
		% [
			"OK" if bool(report.get("ok", false)) else "FALLO",
			int(report.get("error_count", 0)),
			int(report.get("warning_count", 0)),
			int(report.get("info_count", 0)),
		]
	)
	var stats: Dictionary = report.get("stats", {})
	for key in stats.keys():
		lines.append("  - %s: %s" % [str(key), str(stats[key])])
	lines.append("--- Incidencias ---")
	var issues: Array = report.get("issues", [])
	if issues.is_empty():
		lines.append("  (ninguna)")
	for issue in issues:
		lines.append(
			"  [%s] %s: %s"
			% [
				str(issue.get("severity", SEVERITY_INFO)),
				str(issue.get("code", "")),
				str(issue.get("message", "")),
			]
		)
	lines.append("===== FIN VALIDACION =====")
	return "\n".join(lines)


# --- Internal checks -------------------------------------------------------

static func _add(issues: Array[Dictionary], severity: String, code: String, message: String) -> void:
	issues.append({"severity": severity, "code": code, "message": message})


static func _load_dict(path: String, issues: Array[Dictionary]) -> Dictionary:
	if not FileAccess.file_exists(path):
		_add(issues, SEVERITY_ERROR, "FILE_MISSING", "Archivo no encontrado: %s" % path)
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		_add(issues, SEVERITY_ERROR, "FILE_OPEN", "No se pudo abrir: %s" % path)
		return {}
	var json := JSON.new()
	var parse := json.parse(file.get_as_text())
	file.close()
	if parse != OK or typeof(json.data) != TYPE_DICTIONARY:
		_add(issues, SEVERITY_ERROR, "JSON_PARSE", "JSON invalido en: %s" % path)
		return {}
	return json.data


static func _validate_base(issues: Array[Dictionary], stats: Dictionary) -> Dictionary:
	# Returns a set-like Dictionary { id: true } of valid province ids.
	var ids: Dictionary = {}
	var data := _load_dict(FILE_BASE, issues)
	var entries: Variant = data.get("provinces", [])
	if typeof(entries) != TYPE_ARRAY:
		_add(issues, SEVERITY_ERROR, "BASE_SHAPE", "provinces_base.json no contiene un arreglo 'provinces'")
		stats["provincias_base"] = 0
		return ids
	var seen: Dictionary = {}
	var duplicates := 0
	var invalid := 0
	for entry in entries as Array:
		if typeof(entry) != TYPE_DICTIONARY:
			invalid += 1
			continue
		var pid := int((entry as Dictionary).get("id", 0))
		if pid <= 0:
			invalid += 1
			_add(issues, SEVERITY_ERROR, "BASE_ID_INVALID", "Provincia con id invalido (<=0)")
			continue
		if seen.has(pid):
			duplicates += 1
			_add(issues, SEVERITY_ERROR, "BASE_ID_DUPLICATE", "ID de provincia duplicado: %d" % pid)
			continue
		seen[pid] = true
		ids[pid] = true
	stats["provincias_base"] = ids.size()
	stats["provincias_duplicadas"] = duplicates
	stats["provincias_invalidas"] = invalid
	return ids


static func _validate_geometry(base_ids: Dictionary, issues: Array[Dictionary], stats: Dictionary) -> void:
	var data := _load_dict(FILE_GEOMETRY, issues)
	var entries: Variant = data.get("provinces", [])
	if typeof(entries) != TYPE_ARRAY:
		_add(issues, SEVERITY_ERROR, "GEO_SHAPE", "provinces_geometry.json no contiene un arreglo 'provinces'")
		return
	var geo_ids: Dictionary = {}
	var dangling := 0
	var dup := 0
	for entry in entries as Array:
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		var pid := int((entry as Dictionary).get("id", 0))
		if pid <= 0:
			continue
		if geo_ids.has(pid):
			dup += 1
			_add(issues, SEVERITY_ERROR, "GEO_ID_DUPLICATE", "Geometria duplicada para provincia %d" % pid)
			continue
		geo_ids[pid] = true
		if not base_ids.has(pid):
			dangling += 1
			_add(issues, SEVERITY_ERROR, "GEO_DANGLING", "Geometria para provincia inexistente: %d" % pid)
	var missing := 0
	for pid in base_ids.keys():
		if not geo_ids.has(pid):
			missing += 1
	stats["provincias_con_geometria"] = geo_ids.size()
	stats["provincias_sin_geometria"] = missing
	if missing > 0:
		_add(
			issues,
			SEVERITY_WARNING,
			"GEO_COVERAGE",
			"%d de %d provincias no tienen geometria (no se dibujan en el mapa)" % [missing, base_ids.size()],
		)


static func _validate_adjacency(base_ids: Dictionary, issues: Array[Dictionary], stats: Dictionary) -> void:
	var data := _load_dict(FILE_ADJACENCY, issues)
	var raw: Variant = data.get("adjacency", {})
	if typeof(raw) != TYPE_DICTIONARY:
		_add(issues, SEVERITY_ERROR, "ADJ_SHAPE", "province_adjacency.json no contiene un objeto 'adjacency'")
		return
	var adj: Dictionary = raw
	var dangling_src := 0
	var dangling_tgt := 0
	var asymmetric := 0
	for key in adj.keys():
		var src := int(str(key))
		if not base_ids.has(src):
			dangling_src += 1
			_add(issues, SEVERITY_ERROR, "ADJ_SRC_DANGLING", "Adyacencia de provincia inexistente: %d" % src)
		var neighbors: Variant = adj[key]
		if typeof(neighbors) != TYPE_ARRAY:
			continue
		for n in neighbors as Array:
			var tgt := int(n)
			if not base_ids.has(tgt):
				dangling_tgt += 1
				_add(issues, SEVERITY_ERROR, "ADJ_TGT_DANGLING", "Adyacencia %d -> %d (destino inexistente)" % [src, tgt])
				continue
			# Symmetry: tgt must list src as neighbor too.
			var back: Variant = adj.get(str(tgt), [])
			var found := false
			if typeof(back) == TYPE_ARRAY:
				for b in back as Array:
					if int(b) == src:
						found = true
						break
			if not found:
				asymmetric += 1
				_add(issues, SEVERITY_WARNING, "ADJ_ASYMMETRIC", "Adyacencia asimetrica: %d -> %d sin retorno" % [src, tgt])
	stats["adyacencias_origen_rotas"] = dangling_src
	stats["adyacencias_destino_rotas"] = dangling_tgt
	stats["adyacencias_asimetricas"] = asymmetric


static func _validate_layer_keys(
	path: String,
	label: String,
	base_ids: Dictionary,
	issues: Array[Dictionary],
	stats: Dictionary,
	stat_key: String,
) -> void:
	var data := _load_dict(path, issues)
	var raw: Variant = data.get("provinces", {})
	if typeof(raw) != TYPE_DICTIONARY:
		# Not all layers are mandatory; report as info, not error.
		_add(issues, SEVERITY_INFO, "LAYER_SHAPE", "Capa '%s' sin objeto 'provinces' (omitida)" % label)
		return
	var layer: Dictionary = raw
	var dangling := 0
	for key in layer.keys():
		var pid := int(str(key))
		if not base_ids.has(pid):
			dangling += 1
			_add(issues, SEVERITY_WARNING, "LAYER_DANGLING", "Capa '%s' referencia provincia inexistente: %d" % [label, pid])
	stats["capa_%s_entradas" % stat_key] = layer.size()
	stats["capa_%s_rotas" % stat_key] = dangling


static func _validate_grouping(
	path: String,
	root_key: String,
	label: String,
	base_ids: Dictionary,
	issues: Array[Dictionary],
	stats: Dictionary,
	stat_key: String,
) -> void:
	var data := _load_dict(path, issues)
	var groups: Variant = data.get(root_key, [])
	if typeof(groups) != TYPE_ARRAY:
		_add(issues, SEVERITY_ERROR, "GROUP_SHAPE", "%s: falta arreglo '%s'" % [label, root_key])
		return
	var seen_group_ids: Dictionary = {}
	var assigned: Dictionary = {}  # province id -> group id (to detect overlaps)
	var dup_groups := 0
	var dangling := 0
	var overlaps := 0
	for g in groups as Array:
		if typeof(g) != TYPE_DICTIONARY:
			continue
		var gid := int((g as Dictionary).get("id", 0))
		if seen_group_ids.has(gid):
			dup_groups += 1
			_add(issues, SEVERITY_ERROR, "GROUP_ID_DUPLICATE", "%s con id duplicado: %d" % [label, gid])
		else:
			seen_group_ids[gid] = true
		var pids: Variant = (g as Dictionary).get("province_ids", [])
		if typeof(pids) != TYPE_ARRAY:
			continue
		for pid_var in pids as Array:
			var pid := int(pid_var)
			if not base_ids.has(pid):
				dangling += 1
				_add(issues, SEVERITY_ERROR, "GROUP_DANGLING", "%s %d referencia provincia inexistente: %d" % [label, gid, pid])
				continue
			if assigned.has(pid):
				overlaps += 1
				_add(
					issues,
					SEVERITY_WARNING,
					"GROUP_OVERLAP",
					"Provincia %d asignada a mas de un(a) %s (%d y %d)" % [pid, label, int(assigned[pid]), gid],
				)
			else:
				assigned[pid] = gid
	var uncovered := 0
	for pid in base_ids.keys():
		if not assigned.has(pid):
			uncovered += 1
	stats["%s_grupos" % stat_key] = seen_group_ids.size()
	stats["%s_provincias_sin_asignar" % stat_key] = uncovered
	if uncovered > 0:
		_add(
			issues,
			SEVERITY_WARNING,
			"GROUP_COVERAGE",
			"%d provincias sin %s asignado" % [uncovered, label],
		)


static func _validate_project_sites(base_ids: Dictionary, issues: Array[Dictionary], stats: Dictionary) -> void:
	var data := _load_dict(FILE_PROJECT_SITES, issues)
	var sites: Variant = data.get("sites", [])
	if typeof(sites) != TYPE_ARRAY:
		_add(issues, SEVERITY_INFO, "SITES_SHAPE", "project_sites.json sin arreglo 'sites' (omitido)")
		return
	var dangling := 0
	for site in sites as Array:
		if typeof(site) != TYPE_DICTIONARY:
			continue
		var pid := int((site as Dictionary).get("province_id", 0))
		if pid <= 0 or not base_ids.has(pid):
			dangling += 1
			_add(issues, SEVERITY_ERROR, "SITE_DANGLING", "Sitio de proyecto en provincia inexistente: %d" % pid)
	stats["sitios_proyecto"] = (sites as Array).size()
	stats["sitios_proyecto_rotos"] = dangling
