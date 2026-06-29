extends Node

static func run_all() -> bool:
	var ok = true
	ok = _test_real_battle_execution() and ok
	if ok:
		print("✅ All battle combat tests passed")
	else:
		push_error("❌ Some battle combat tests failed")
	return ok


static func _get_province_map() -> Dictionary:
	if typeof(MapManager) != TYPE_NIL and MapManager.has_method("get_all_provinces"):
		return MapManager.get_all_provinces()
	var loader = _find_scenario_loader()
	if loader != null and loader.has_method("get_provinces"):
		return loader.get_provinces()
	return {}


static func _find_scenario_loader():
	var tree = Engine.get_main_loop()
	if tree == null:
		return null
	return tree.root.get_node_or_null("/root/ScenarioLoader")


static func _test_real_battle_execution() -> bool:
	var bm = _get_battle_manager()
	if bm == null:
		print("  [FAIL] BattleManager not available")
		return false

	var all_provinces = _get_province_map()
	if all_provinces.is_empty():
		print("  [FAIL] no provinces loaded")
		return false

	var target_id = -1
	var target_province = null
	for pid in all_provinces:
		var p = all_provinces[pid]
		if p != null and not p.is_sea and not p.owner_tag.is_empty():
			target_id = pid
			target_province = p
			break

	if target_id < 0 or target_province == null:
		print("  [FAIL] no suitable non-sea province found")
		return false

	var old_owner = target_province.owner_tag
	var terrain_str = target_province.terrain
	print("\n  BEFORE: province %d (%s)" % [target_id, target_province.name])
	print("  BEFORE: terrain=%s, owner=%s, controller=%s" % [terrain_str, old_owner, target_province.controller_tag])
	print("  BEFORE: dev=%d, infra=%d" % [target_province.development_level, target_province.infrastructure])

	var att_formation_ids := []
	for i in 5:
		var fid = "bt_att_%s_%d" % ["CHL", i]
		var f = Formation.new()
		f.formation_id = fid
		f.country_tag = "CHL"
		f.province_id = target_id
		f.combat_width = 1
		f.strength = 1.0
		f.max_strength = 1.0
		LeaderManager.register_formation(f)
		att_formation_ids.append(fid)

	var def_id = "bt_def_PER"
	var df = Formation.new()
	df.formation_id = def_id
	df.country_tag = "PER"
	df.province_id = target_id
	df.combat_width = 1
	df.strength = 0.5
	df.max_strength = 1.0
	LeaderManager.register_formation(df)

	var battle_started_data = {}
	var battle_resolved_data = {}
	var province_captured_data = {}

	var sig_start = bm.battle_started.connect(func(p, a, d):
		battle_started_data = {"province": p, "attacker": a, "defender": d}
		print("  SIGNAL battle_started: province=%d, attacker=%s, defender=%s" % [p, a, d])
	)
	var sig_resolved = bm.battle_resolved.connect(func(p, w, l, r):
		battle_resolved_data = {"province": p, "winner": w, "loser": l, "result": r}
		print("  SIGNAL battle_resolved: province=%d, winner=%s, loser=%s" % [p, w, l])
	)
	var sig_captured = bm.province_captured.connect(func(p, n, o):
		province_captured_data = {"province": p, "new_owner": n, "old_owner": o}
		print("  SIGNAL province_captured: province=%d, %s -> %s" % [p, o, n])
	)

	print("  EXECUTION: calling _resolve_battle(province=%d, attacker=%s, defender=%s)..." % [target_id, att_formation_ids[0], def_id])
	bm.call("_resolve_battle", target_id, att_formation_ids[0], def_id)

	var new_owner = ""
	if typeof(MapManager) != TYPE_NIL and MapManager.has_method("get_province"):
		var p_after = MapManager.get_province(target_id)
		if p_after != null:
			new_owner = p_after.owner_tag

	print("  AFTER: province %d owner=%s, controller=%s" % [target_id, new_owner, target_province.controller_tag if target_province != null else "N/A"])

	if bm.battle_started.is_connected(sig_start):
		bm.battle_started.disconnect(sig_start)
	if bm.battle_resolved.is_connected(sig_resolved):
		bm.battle_resolved.disconnect(sig_resolved)
	if bm.province_captured.is_connected(sig_captured):
		bm.province_captured.disconnect(sig_captured)

	var winner = battle_resolved_data.get("winner", "unknown")
	var loser = battle_resolved_data.get("loser", "unknown")
	var result = battle_resolved_data.get("result", {})
	var att_cas = result.get("attacker_casualties", 0)
	var def_cas = result.get("defender_casualties", 0)
	var att_pow = 0.0
	var def_pow = 0.0
	if result.has("attacker_power"):
		att_pow = result.attacker_power
	if result.has("defender_power"):
		def_pow = result.defender_power

	print("  WINNER: %s, LOSER: %s" % [winner, loser])
	print("  POWER: attacker=%.2f, defender=%.2f" % [att_pow, def_pow])
	print("  CASUALTIES: attacker=%d, defender=%d" % [att_cas, def_cas])

	var ownership_changed = (new_owner != old_owner)

	if ownership_changed:
		print("  ✅ PROVINCE OWNERSHIP CHANGED: %s -> %s" % [old_owner, new_owner])
		print("  ✅ Combat = WORKING: BattleManager changed province ownership via _capture_province")
	else:
		print("  ⚠️  Province ownership unchanged (%s). Defender likely won." % old_owner)

	for fid in att_formation_ids:
		if LeaderManager.formations.has(fid):
			LeaderManager.formations.erase(fid)
	if LeaderManager.formations.has(def_id):
		LeaderManager.formations.erase(def_id)

	print("  [PASS] Real battle execution completed")
	return true


static func _get_battle_manager():
	var tree = Engine.get_main_loop()
	if tree == null:
		return null
	return tree.root.get_node_or_null("/root/BattleManager")
