extends SceneTree

var _errors: Array[String] = []
var _orphaned_refs: Array[String] = []

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	_validate_countries()
	_validate_provinces()
	_validate_technology()
	_validate_leaders()
	_validate_events()
	_validate_scenarios()
	_validate_formations()
	_validate_national_spirits()
	_validate_supply()
	_validate_production()
	_validate_combat()
	_validate_agents()
	_validate_economy()
	_print_report()
	quit(1 if _errors.size() > 0 else 0)

func _e(path: String, msg: String) -> void:
	_errors.append("%s: %s" % [path, msg])
	print("  [FAIL] %s: %s" % [path, msg])

func _w(msg: String) -> void:
	print("  [WARN] %s" % msg)

func _validate_countries() -> void:
	print("\n=== Countries ===")
	var dir = DirAccess.open("res://data/countries/")
	if dir == null:
		_e("data/countries", "directory not found")
		return
	dir.list_dir_begin()
	var fname = dir.get_next()
	while fname != "":
		if fname.ends_with(".json"):
			var path = "res://data/countries/" + fname
			var parsed = _load_json(path)
			if parsed == null: continue
			var d = parsed as Dictionary
			if d.is_empty():
				_e(path, "empty root object")
			else:
				for req in ["tag", "name"]:
					if not d.has(req):
						_e(path, "missing required field '%s'" % req)
		fname = dir.get_next()
	dir.list_dir_end()

func _validate_provinces() -> void:
	print("\n=== Provinces ===")
	var base = _load_json("res://data/provinces/provinces_base.json")
	if base == null: return
	if typeof(base) != TYPE_ARRAY:
		_e("provinces_base.json", "root should be array, got %s" % typeof(base))
		return
	for p in base:
		var pd = p as Dictionary
		if not pd.has("id"):
			_e("provinces_base.json", "province entry missing 'id'")
			continue

func _validate_technology() -> void:
	print("\n=== Technology ===")
	var cat = _load_json("res://data/technology/research_catalog.json")
	if cat != null:
		if typeof(cat) != TYPE_ARRAY:
			_e("research_catalog.json", "root should be array")
	for tid in ["1879", "1918", "1936", "2026"]:
		var sp = _load_json("res://data/technology/starting/" + tid + ".json")
		if sp == null: continue
		if typeof(sp) != TYPE_DICTIONARY:
			_e("starting/%s.json" % tid, "root should be dict")
	var trees_dir = DirAccess.open("res://data/technology/trees/")
	if trees_dir == null:
		_e("data/technology/trees", "directory not found")
	else:
		trees_dir.list_dir_begin()
		var tf = trees_dir.get_next()
		while tf != "":
			if tf.ends_with(".json") and not tf.ends_with(".example.json"):
				var t = _load_json("res://data/technology/trees/" + tf)
				if t != null and typeof(t) != TYPE_DICTIONARY:
					_e("trees/" + tf, "root should be dict")
			tf = trees_dir.get_next()
		trees_dir.list_dir_end()

func _validate_leaders() -> void:
	print("\n=== Leaders ===")
	var hist = _load_json("res://data/leaders/historical_leaders_1879.json")
	if hist != null:
		if typeof(hist) != TYPE_DICTIONARY:
			_e("historical_leaders_1879.json", "root should be dict")
	var traits = _load_json("res://data/leaders/traits.json")
	if traits != null:
		if typeof(traits) != TYPE_ARRAY:
			_e("traits.json", "root should be array")

func _validate_events() -> void:
	print("\n=== Events ===")
	var dir = DirAccess.open("res://data/events/1879/")
	if dir == null:
		_e("data/events/1879", "directory not found")
		return
	var count = 0
	dir.list_dir_begin()
	var fname = dir.get_next()
	while fname != "":
		if fname.ends_with(".json"):
			var path = "res://data/events/1879/" + fname
			var parsed = _load_json(path)
			if parsed == null:
				count += 1
				continue
			if typeof(parsed) == TYPE_DICTIONARY:
				if not parsed.has("events"):
					_e(path, "missing 'events' key")
				elif typeof(parsed["events"]) != TYPE_ARRAY:
					_e(path, "'events' should be array")
			count += 1
		fname = dir.get_next()
	dir.list_dir_end()
	print("  [INFO] %d event files scanned" % count)

func _validate_scenarios() -> void:
	print("\n=== Scenarios ===")
	var s1879 = _load_json("res://data/scenarios/1879/scenario.json")
	if s1879 != null:
		var d = s1879 as Dictionary
		for req in ["scenario", "start_date", "country_refs", "provinces"]:
			if not d.has(req):
				_e("scenarios/1879/scenario.json", "missing '%s'" % req)
	var s1918 = _load_json("res://data/scenarios/1918.json")
	if s1918 != null and typeof(s1918) != TYPE_DICTIONARY:
		_e("scenarios/1918.json", "root should be dict")
	var s1936 = _load_json("res://data/scenarios/1936.json")
	if s1936 != null and typeof(s1936) != TYPE_DICTIONARY:
		_e("scenarios/1936.json", "root should be dict")

func _validate_formations() -> void:
	print("\n=== Formation Templates ===")
	var ft = _load_json("res://data/formations/division_templates.json")
	if ft == null: return
	if typeof(ft) != TYPE_ARRAY:
		_e("division_templates.json", "root should be array")
	else:
		for t in ft:
			var td = t as Dictionary
			if not td.has("id"):
				_e("division_templates.json", "template missing 'id'")

func _validate_national_spirits() -> void:
	print("\n=== National Spirits ===")
	var ns = _load_json("res://data/national/spirit_definitions.json")
	if ns == null: return
	if typeof(ns) != TYPE_DICTIONARY:
		_e("spirit_definitions.json", "root should be dict")

func _validate_supply() -> void:
	print("\n=== Supply Rules ===")
	var sr = _load_json("res://data/supply/supply_rules.json")
	if sr == null: return
	if typeof(sr) != TYPE_DICTIONARY:
		_e("supply_rules.json", "root should be dict")

func _validate_production() -> void:
	print("\n=== Production ===")
	for f in ["factory_rules.json", "production_cost_rules.json", "production_line_rules.json", "retooling_similarity.json", "global_modifiers.json"]:
		var p = _load_json("res://data/production/" + f)
		if p == null: continue
		if typeof(p) != TYPE_DICTIONARY:
			_e("production/" + f, "root should be dict")

func _validate_combat() -> void:
	print("\n=== Combat Width Rules ===")
	var cw = _load_json("res://data/combat/combat_width_rules.json")
	if cw == null: return
	if typeof(cw) != TYPE_DICTIONARY:
		_e("combat_width_rules.json", "root should be dict")

func _validate_agents() -> void:
	print("\n=== Agent Missions ===")
	var am = _load_json("res://data/agents/mission_definitions.json")
	if am == null: return
	if typeof(am) != TYPE_DICTIONARY:
		_e("mission_definitions.json", "root should be dict")

func _validate_economy() -> void:
	print("\n=== Economy Rules ===")
	var er = _load_json("res://data/economy/resource_income_rules.json")
	if er == null: return
	if typeof(er) != TYPE_DICTIONARY:
		_e("resource_income_rules.json", "root should be dict")

func _load_json(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		_e(path, "cannot open file")
		return null
	var text = file.get_as_text()
	file.close()
	var parsed = JSON.parse_string(text)
	if parsed == null:
		_e(path, "invalid JSON")
		return null
	print("  [OK] " + path + " loaded (" + str(text.length()) + " chars)")
	return parsed

func _print_report() -> void:
	var sep := "============================================================"
	print("\n" + sep)
	print("DATA INTEGRITY AUDIT SUMMARY")
	print(sep)
	if _errors.is_empty():
		print("  [PASS] ALL DATA CATEGORIES VALID — 0 errors")
	else:
		print("  [FAIL] " + str(_errors.size()) + " validation errors found:")
		for e in _errors:
			print("    " + e)
	print(sep)
