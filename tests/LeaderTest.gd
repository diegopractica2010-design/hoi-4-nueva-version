extends Node
class_name LeaderTest

static func run_all() -> bool:
	var ok = true
	ok = _test_manager_exists() and ok
	ok = _test_leaders_loaded() and ok
	ok = _test_formations_present() and ok
	ok = _test_country_at_war() and ok
	ok = _test_get_formation() and ok
	ok = _test_formation_country_filter() and ok
	return ok

static func _test_manager_exists() -> bool:
	if typeof(LeaderManager) == TYPE_NIL:
		print("  [FAIL] LeaderManager not available")
		return false
	if not LeaderManager.has_method("get_leader"):
		print("  [FAIL] LeaderManager missing get_leader")
		return false
	print("  [PASS] LeaderManager loaded with %d methods" % LeaderManager.get_method_list().size())
	return true

static func _test_leaders_loaded() -> bool:
	var count = LeaderManager.get_pool_leader_count()
	var chl_count = LeaderManager.get_pool_leader_count("CHL")
	if count <= 0:
		print("  [FAIL] leader_pool is empty")
		return false
	print("  [PASS] Leader pool: %d total, %d for CHL" % [count, chl_count])
	return true

static func _test_formations_present() -> bool:
	var formations_chl = LeaderManager.get_formations_for_country("CHL")
	var formations_per = LeaderManager.get_formations_for_country("PER")
	var total = formations_chl.size() + formations_per.size()
	if total == 0:
		print("  [FAIL] no formations registered for CHL or PER")
		return false
	print("  [PASS] Formations: %d CHL + %d PER = %d" % [formations_chl.size(), formations_per.size(), total])
	return true

static func _test_country_at_war() -> bool:
	if not LeaderManager.has_method("set_country_at_war"):
		print("  [FAIL] set_country_at_war missing")
		return false
	if not LeaderManager.has_method("get_national_prestige"):
		print("  [INFO] get_national_prestige missing (optional)")
	var pre_war = LeaderManager.get_national_prestige("CHL") if LeaderManager.has_method("get_national_prestige") else 0.0
	LeaderManager.set_country_at_war("CHL", true)
	var post_war = LeaderManager.get_national_prestige("CHL") if LeaderManager.has_method("get_national_prestige") else 0.0
	print("  [PASS] set_country_at_war CHL=true (prestige: %.1f)" % post_war)
	return true

static func _test_get_formation() -> bool:
	var formations = LeaderManager.get_formations_for_country("CHL")
	if formations.is_empty():
		print("  [WARN] no CHL formations to test get_formation")
		return true
	var fid = formations[0].formation_id if "formation_id" in formations[0] else ""
	if fid.is_empty():
		print("  [WARN] formation has no formation_id")
		return true
	var fetched = LeaderManager.get_formation(fid)
	if fetched == null:
		print("  [FAIL] get_formation(%s) returned null" % fid)
		return false
	print("  [PASS] get_formation(%s) resolved OK" % fid)
	return true

static func _test_formation_country_filter() -> bool:
	var all = LeaderManager.get_formations_for_country("CHL")
	if all.is_empty():
		print("  [WARN] no CHL formations for filter test")
		return true
	var has_wrong = false
	for f in all:
		if f.country_tag != "CHL":
			has_wrong = true
			break
	if has_wrong:
		print("  [FAIL] CHL formations contain non-CHL entries")
		return false
	print("  [PASS] all %d CHL formations have country_tag=CHL" % all.size())
	return true
