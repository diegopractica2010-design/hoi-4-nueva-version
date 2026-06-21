extends Node
class_name AITest

static func run_all() -> bool:
	var ok = true
	ok = _test_manager_exists() and ok
	ok = _test_player_tag_set() and ok
	ok = _test_ai_tags_populated() and ok
	ok = _test_difficulty_default() and ok
	ok = _test_difficulty_switch() and ok
	ok = _test_combat_multiplier() and ok
	ok = _test_get_ai_status() and ok
	ok = _test_save_load() and ok
	return ok

static func _test_manager_exists() -> bool:
	if typeof(AIManager) == TYPE_NIL:
		print("  [FAIL] AIManager not available")
		return false
	print("  [PASS] AIManager loaded")
	return true

static func _test_player_tag_set() -> bool:
	if typeof(AIManager) == TYPE_NIL:
		return false
	if AIManager.player_tag.is_empty():
		print("  [FAIL] player_tag is empty")
		return false
	print("  [PASS] player_tag = '%s'" % AIManager.player_tag)
	return true

static func _test_ai_tags_populated() -> bool:
	if typeof(AIManager) == TYPE_NIL:
		return false
	if AIManager.ai_tags.is_empty():
		print("  [FAIL] ai_tags is empty")
		return false
	print("  [PASS] %d AI tags: %s" % [AIManager.ai_tags.size(), str(AIManager.ai_tags)])
	return true

static func _test_difficulty_default() -> bool:
	if typeof(AIManager) == TYPE_NIL:
		return false
	var diff = AIManager.get_difficulty()
	var name = AIManager.get_difficulty_name()
	if name.is_empty():
		print("  [FAIL] difficulty name empty")
		return false
	print("  [PASS] difficulty=%d name='%s'" % [diff, name])
	return true

static func _test_difficulty_switch() -> bool:
	if typeof(AIManager) == TYPE_NIL:
		return false
	AIManager.set_difficulty(2)
	var d2 = AIManager.get_difficulty()
	var n2 = AIManager.get_difficulty_name()
	AIManager.set_difficulty(1)
	if d2 != 2:
		print("  [FAIL] set_difficulty(2) failed: %d" % d2)
		return false
	print("  [PASS] set_difficulty(2) -> '%s'" % n2)
	return true

static func _test_combat_multiplier() -> bool:
	if typeof(AIManager) == TYPE_NIL:
		return false
	AIManager.set_difficulty(0)
	var facil = AIManager.get_ai_combat_multiplier()
	AIManager.set_difficulty(2)
	var dificil = AIManager.get_ai_combat_multiplier()
	AIManager.set_difficulty(1)
	if facil != 0.8 or dificil != 1.25:
		print("  [FAIL] combat multipliers: facil=%.2f dificil=%.2f" % [facil, dificil])
		return false
	print("  [PASS] combat multipliers: facil=%.2f dificil=%.2f" % [facil, dificil])
	return true

static func _test_get_ai_status() -> bool:
	if typeof(AIManager) == TYPE_NIL:
		return false
	if not AIManager.has_method("get_ai_status"):
		print("  [WARN] get_ai_status missing")
		return true
	var status = AIManager.get_ai_status()
	if status.is_empty():
		print("  [WARN] get_ai_status returned empty")
		return true
	print("  [PASS] AI status: %s" % status)
	return true

static func _test_save_load() -> bool:
	if typeof(AIManager) == TYPE_NIL:
		return false
	if not AIManager.has_method("get_save_data"):
		print("  [WARN] get_save_data missing")
		return true
	var data = AIManager.get_save_data()
	if data.is_empty():
		print("  [WARN] save data empty")
		return true
	print("  [PASS] AI save data has %d keys" % data.size())
	return true
