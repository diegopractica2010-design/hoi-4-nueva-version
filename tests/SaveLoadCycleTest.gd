class_name SaveLoadCycleTest
extends RefCounted

const TEST_SLOT = "_test_cycle_slot"

static func run_all() -> bool:
	var ok = true
	ok = _test_save_creates_file() and ok
	ok = _test_save_has_required_keys() and ok
	ok = _test_load_restores_state() and ok
	ok = _test_list_saves_includes_slot() and ok
	ok = _test_delete_cleanup() and ok
	return ok

static func _get_slm() -> Node:
	var tree = Engine.get_main_loop()
	if tree == null:
		return null
	return tree.root.get_node_or_null("/root/SaveLoadManager")

static func _test_save_creates_file() -> bool:
	var slm = _get_slm()
	if slm == null:
		print("  [SKIP] SaveLoadManager autoload not available")
		return true
	var path = slm.get_save_path(TEST_SLOT)
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)
	var ok = slm.save_game(TEST_SLOT)
	if not ok or not FileAccess.file_exists(path):
		print("  [FAIL] save_game did not create file: %s" % path)
		return false
	print("  [PASS] save_game created file at %s" % path)
	return true

static func _test_save_has_required_keys() -> bool:
	var slm = _get_slm()
	if slm == null:
		print("  [SKIP] SaveLoadManager autoload not available")
		return true
	var path = slm.get_save_path(TEST_SLOT)
	if not FileAccess.file_exists(path):
		print("  [FAIL] no save file to validate")
		return false
	var text = FileAccess.get_file_as_string(path)
	var parsed = JSON.parse_string(text)
	if typeof(parsed) != TYPE_DICTIONARY:
		print("  [FAIL] save file is not a JSON Dictionary")
		return false
	var d: Dictionary = parsed
	var required = ["save_version", "metadata", "time", "technology", "map", "supply"]
	for key in required:
		if not d.has(key):
			print("  [FAIL] save missing required key: %s" % key)
			return false
	if not d.get("metadata", {}).has("timestamp"):
		print("  [FAIL] save metadata missing timestamp")
		return false
	if not d.get("metadata", {}).has("scenario_id"):
		print("  [FAIL] save metadata missing scenario_id")
		return false
	print("  [PASS] save file has all required keys (v%d)" % d.get("save_version", -1))
	return true

static func _test_load_restores_state() -> bool:
	var slm = _get_slm()
	if slm == null:
		print("  [SKIP] SaveLoadManager autoload not available")
		return true
	var path = slm.get_save_path(TEST_SLOT)
	if not FileAccess.file_exists(path):
		print("  [FAIL] no save file to load")
		return false
	var ok = slm.load_game(TEST_SLOT)
	if not ok:
		print("  [FAIL] load_game returned false")
		return false
	print("  [PASS] load_game completed successfully")
	return true

static func _test_list_saves_includes_slot() -> bool:
	var slm = _get_slm()
	if slm == null:
		print("  [SKIP] SaveLoadManager autoload not available")
		return true
	var saves = slm.list_saves()
	var found = false
	for s in saves:
		if s.get("slot", "") == TEST_SLOT:
			found = true
			break
	if not found:
		print("  [FAIL] list_saves does not include test slot")
		return false
	print("  [PASS] list_saves includes test slot (%d total)" % saves.size())
	return true

static func _test_delete_cleanup() -> bool:
	var slm = _get_slm()
	if slm == null:
		print("  [SKIP] SaveLoadManager autoload not available")
		return true
	var path = slm.get_save_path(TEST_SLOT)
	if not FileAccess.file_exists(path):
		print("  [SKIP] no save file to delete")
		return true
	var ok = slm.delete_save(TEST_SLOT)
	if not ok or FileAccess.file_exists(path):
		print("  [FAIL] delete_save did not remove file")
		return false
	print("  [PASS] delete_save cleanup ok")
	return true
