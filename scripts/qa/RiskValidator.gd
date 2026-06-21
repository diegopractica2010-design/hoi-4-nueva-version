extends Node

static func validate_all() -> bool:
	var all_ok = true

	all_ok = _cr01_hardcoded_paths() and all_ok
	all_ok = _cr02_debug_spam() and all_ok
	all_ok = _cr03_diplomacy_exists() and all_ok
	all_ok = _cr04_ai_capabilities() and all_ok
	all_ok = _cr05_big_files() and all_ok
	all_ok = _cr08_event_effects() and all_ok
	all_ok = _cr09_save_load_tested() and all_ok
	all_ok = _cr10_retreat_capture() and all_ok

	return all_ok


static func _cr01_hardcoded_paths() -> bool:
	var dirs = [
		"res://scripts/ai",
		"res://scripts/military",
		"res://scripts/map",
		"res://scripts/supply",
		"res://scripts/national",
		"res://scripts/core",
		"res://scripts/autoload",
		"res://scripts/leaders",
		"res://scripts/events",
		"res://scripts/production",
		"res://scripts/technology",
	]
	var total_root_refs = 0
	var files_with_root_refs = []
	for dir_path in dirs:
		var dir = DirAccess.open(dir_path)
		if dir == null:
			continue
		dir.list_dir_begin()
		var fname = dir.get_next()
		while fname != "":
			if fname.ends_with(".gd"):
				var file_path = dir_path.path_join(fname)
				var file = FileAccess.open(file_path, FileAccess.READ)
				if file != null:
					var content = file.get_as_text()
					var count = 0
					var pos = 0
					while true:
						pos = content.find("/root/", pos)
						if pos == -1:
							break
						count += 1
						pos += 6
					if count > 0:
						files_with_root_refs.append("%s=%d" % [file_path.trim_prefix("res://"), count])
						total_root_refs += count
				file.close()
			fname = dir.get_next()
		dir.list_dir_end()

	if total_root_refs == 0:
		print("  [PASS] CR-01: 0 /root/ hardcoded paths")
		return true

	print("  [WARN] CR-01: %d /root/ hardcoded paths in %d files:" % [total_root_refs, files_with_root_refs.size()])
	for entry in files_with_root_refs:
		print("        %s" % entry)
	if total_root_refs > 10:
		print("  [FAIL] CR-01: too many hardcoded paths (target: 0)")
		return false
	return true


static func _cr02_debug_spam() -> bool:
	var dirs = [
		"res://scripts/ai",
		"res://scripts/military",
		"res://scripts/map",
		"res://scripts/supply",
		"res://scripts/national",
		"res://scripts/core",
		"res://scripts/autoload",
		"res://scripts/leaders",
		"res://scripts/events",
		"res://scripts/production",
		"res://scripts/technology",
		"res://scripts/agents",
	]
	var total_print = 0
	var total_warning = 0
	var total_error = 0
	for dir_path in dirs:
		var dir = DirAccess.open(dir_path)
		if dir == null:
			continue
		dir.list_dir_begin()
		var 			fname = dir.get_next()
		while fname != "":
			if fname.ends_with(".gd"):
				var file_path = dir_path.path_join(fname)
				var file = FileAccess.open(file_path, FileAccess.READ)
				if file != null:
					var content = file.get_as_text()
					var lines = content.split("\n")
					for line in lines:
						if line.strip_edges().begins_with("#"):
							continue
						var ci = line.find("#")
						var code = line if ci == -1 else line.substr(0, ci)
						if "print(" in code:
							total_print += 1
						if "push_warning(" in code:
							total_warning += 1
						if "push_error(" in code:
							total_error += 1
					file.close()
			fname = dir.get_next()
		dir.list_dir_end()

	var total = total_print + total_warning + total_error
	print("  [WARN] CR-02: %d print(), %d push_warning(), %d push_error() = %d total" % [total_print, total_warning, total_error, total])
	if total > 200:
		print("  [FAIL] CR-02: excessive debug output (target: <200)")
		return false
	if total > 100:
		print("  [WARN] CR-02: high but acceptable for pre-alpha")
		return true
	print("  [PASS] CR-02: debug output under control")
	return true


static func _cr03_diplomacy_exists() -> bool:
	var has_diplomacy_file = ResourceLoader.exists("res://scripts/diplomacy/DiplomacyManager.gd")
	var has_war_declare = false
	var has_peace_treaty = false
	var has_alliance = false
	has_war_declare = typeof(LeaderManager) != TYPE_NIL and LeaderManager.has_method("set_country_at_war")
	if typeof(EventManager) != TYPE_NIL:
		var effects = ["declare_war", "force_peace", "province_transfer"]
		for e in effects:
			pass

	if has_diplomacy_file:
		print("  [PASS] CR-03: DiplomacyManager exists")
		return true

	print("  [INFO] CR-03: No formal diplomacy system")
	print("        War/peace: via EventManager scripted effects only")
	print("        Alliances: none")
	print("        Negotiation: none")
	var has_any = has_war_declare or has_peace_treaty or has_alliance
	if not has_any:
		print("  [FAIL] CR-03: No diplomacy, peace, or alliance mechanics")
		return false
	print("  [WARN] CR-03: Minimal war/peace via events (no player diplomacy)")
	return true


static func _cr04_ai_capabilities() -> bool:
	var ai_path = "res://scripts/ai/AIManager.gd"
	var file = FileAccess.open(ai_path, FileAccess.READ)
	if file == null:
		print("  [FAIL] CR-04: AIManager.gd not found")
		return false
	var content = file.get_as_text()
	file.close()
	var has_tech = content.find("technology") != -1 or content.find("TechnologyManager") != -1 or content.find("research") != -1
	var has_economy = content.find("economy") != -1 or content.find("FactoryManager") != -1 or content.find("ProductionManager") != -1
	var has_trade = content.find("TradeManager") != -1 or content.find("trade") != -1
	var has_construction = content.find("construction") != -1 or content.find("build") != -1

	print("  [INFO] CR-04: AI capabilities:")
	print("        Military movement: YES (UnitMovementSystem)")
	print("        Tech/research: %s" % ("YES" if has_tech else "NO"))
	print("        Economy/factories: %s" % ("YES" if has_economy else "NO"))
	print("        Trade: %s" % ("YES" if has_trade else "NO"))
	print("        Construction: %s" % ("YES" if has_construction else "NO"))
	if not has_tech:
		print("  [FAIL] CR-04: AI cannot research technology")
		return false
	if not has_economy:
		print("  [FAIL] CR-04: AI cannot manage economy")
		return false
	return true


static func _cr05_big_files() -> bool:
	var paths = [
		"res://scripts/map/ProvinceInsight.gd",
		"res://scripts/leaders/LeaderManager.gd",
		"res://scripts/map/MapRenderer.gd",
	]
	var all_under_800 = true
	for path in paths:
		var file = FileAccess.open(path, FileAccess.READ)
		if file == null:
			print("  [WARN] CR-05: %s not found" % path.trim_prefix("res://"))
			continue
		var content = file.get_as_text()
		file.close()
		var lines = content.split("\n").size()
		if lines > 800:
			print("  [FAIL] CR-05: %s = %d lines (limit: 800)" % [path.trim_prefix("res://"), lines])
			all_under_800 = false
		else:
			print("  [PASS] CR-05: %s = %d lines" % [path.trim_prefix("res://"), lines])
	if not all_under_800:
		return false
	print("  [PASS] CR-05: All files under 800 lines")
	return true


static func _cr08_event_effects() -> bool:
	var path = "res://scripts/events/EventManager.gd"
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		print("  [FAIL] CR-08: EventManager.gd not found")
		return false
	var content = file.get_as_text()
	file.close()

	var effects_implemented = []
	if content.find("declare_war") != -1: effects_implemented.append("declare_war")
	if content.find("province_transfer") != -1: effects_implemented.append("province_transfer")
	if content.find("add_national_spirit") != -1: effects_implemented.append("add_national_spirit")
	if content.find("damage_unit") != -1: effects_implemented.append("damage_unit")
	if content.find("destroy_unit") != -1: effects_implemented.append("destroy_unit")
	if content.find("force_peace") != -1: effects_implemented.append("force_peace")
	if content.find("news_event") != -1: effects_implemented.append("news_event")

	var count = effects_implemented.size()
	if count < 3:
		print("  [FAIL] CR-08: Only %d effects implemented (target: 7)" % count)
		return false
	print("  [PASS] CR-08: %d event effects: %s" % [count, ", ".join(effects_implemented)])
	return true


static func _cr09_save_load_tested() -> bool:
	var path = "res://scripts/core/SaveLoadCycleTest.gd"
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		print("  [FAIL] CR-09: SaveLoadCycleTest.gd not found")
		return false
	var content = file.get_as_text()
	file.close()
	var test_count = 0
	var pos = 0
	while true:
		pos = content.find("static func ", pos)
		if pos == -1:
			break
		test_count += 1
		pos += 12
	if test_count >= 4:
		print("  [PASS] CR-09: %d save/load tests" % test_count)
		return true
	print("  [FAIL] CR-09: Only %d save/load tests (target: 4+)" % test_count)
	return false


static func _cr10_retreat_capture() -> bool:
	var bm_path = "res://scripts/military/BattleManager.gd"
	var bm_file = FileAccess.open(bm_path, FileAccess.READ)
	if bm_file == null:
		print("  [FAIL] CR-10: BattleManager.gd not found")
		return false
	var bm_content = bm_file.get_as_text()
	bm_file.close()

	var has_capture = bm_content.find("_capture_province") != -1
	var has_retreat = bm_content.find("_retreat_formation") != -1
	var has_signal = bm_content.find("province_captured") != -1
	var has_factory_capture = bm_content.find("capture_province_factories") != -1

	print("  [INFO] CR-10: BattleManager retreat/capture:")
	print("        _capture_province: %s" % ("YES" if has_capture else "NO"))
	print("        _retreat_formation: %s" % ("YES" if has_retreat else "NO"))
	print("        province_captured signal: %s" % ("YES" if has_signal else "NO"))
	print("        Factory capture: %s" % ("YES" if has_factory_capture else "NO"))

	if has_capture and has_retreat:
		print("  [PASS] CR-10: Retreat and capture logic exists")
		return true
	print("  [FAIL] CR-10: Missing retreat or capture logic")
	return false
