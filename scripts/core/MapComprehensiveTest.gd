class_name MapComprehensiveTest
extends RefCounted

static func run_all(mm: Node, loader: ScenarioLoader) -> bool:
	var ok = true
	ok = _test_mapmanager_initialized(mm) and ok
	ok = _test_provinces_loaded(mm) and ok
	ok = _test_adjacency_loaded(mm) and ok
	ok = _test_adjacency_bidirectional(mm, loader) and ok
	ok = _test_terrain_distribution(mm) and ok
	ok = _test_province_has_valid_id(mm) and ok
	ok = _test_province_data_integrity(mm) and ok
	ok = _test_core_ownership(mm) and ok
	ok = _test_province_effects(mm) and ok
	return ok

static func _test_mapmanager_initialized(mm: Node) -> bool:
	if mm == null:
		print("  [FAIL] MapManager is null")
		return false
	if not mm.has_province_data():
		print("  [FAIL] MapManager has_province_data() false")
		return false
	print("  [PASS] MapManager initialized")
	return true

static func _test_provinces_loaded(mm: Node) -> bool:
	var all = mm.get_all_provinces()
	if all.is_empty():
		print("  [FAIL] get_all_provinces empty")
		return false
	var count = all.size()
	if count < 500:
		print("  [FAIL] only %d provinces (expected >= 500)" % count)
		return false
	print("  [PASS] %d provinces loaded" % count)
	return true

static func _test_adjacency_loaded(mm: Node) -> bool:
	var adj = mm.get_adjacency_system()
	if adj == null:
		print("  [FAIL] adjacency_system is null")
		return false
	print("  [PASS] adjacency system loaded")
	return true

static func _test_adjacency_bidirectional(mm: Node, loader: ScenarioLoader) -> bool:
	if loader == null:
		print("  [SKIP] no loader available")
		return true
	var broken = 0
	for pid in loader.provinces:
		var p = loader.provinces[pid]
		if p == null:
			continue
		for neighbor_id in p.adjacencies:
			var neighbor = loader.provinces.get(neighbor_id)
			if neighbor == null:
				continue
			if not neighbor.adjacencies.has(pid):
				broken += 1
				if broken <= 3:
					print("    [INFO] one-way adjacency: %d -> %d (but not back)" % [pid, neighbor_id])
	if broken > 10:
		print("  [FAIL] %d one-way adjacencies" % broken)
		return false
	print("  [PASS] adjacency bidirectional check (%d one-way edges)" % broken)
	return true

static func _test_terrain_distribution(mm: Node) -> bool:
	var all = mm.get_all_provinces()
	var terrains = {}
	var sea_count = 0
	for pid in all:
		var p = all[pid]
		if p.terrain.is_empty():
			print("  [FAIL] province %d has empty terrain" % pid)
			return false
		if p.is_sea:
			sea_count += 1
		terrains[p.terrain] = terrains.get(p.terrain, 0) + 1
	if terrains.is_empty():
		print("  [FAIL] no terrain types found")
		return false
	print("  [PASS] %d terrain types, %d sea provinces" % [terrains.size(), sea_count])
	return true

static func _test_province_has_valid_id(mm: Node) -> bool:
	var all = mm.get_all_provinces()
	for pid in all:
		if pid <= 0:
			print("  [FAIL] invalid province id: %d" % pid)
			return false
	print("  [PASS] all province ids are valid")
	return true

static func _test_province_data_integrity(mm: Node) -> bool:
	var all = mm.get_all_provinces()
	var missing_name = 0
	var negative_population = 0
	for pid in all:
		var p = all[pid]
		if p.name.is_empty():
			missing_name += 1
		if p.population < 0:
			negative_population += 1
	if missing_name > all.size() / 2:
		print("  [FAIL] %d / %d provinces missing name" % [missing_name, all.size()])
		return false
	if negative_population > 10:
		print("  [FAIL] %d provinces with negative population" % negative_population)
		return false
	print("  [PASS] province data integrity: %d unnamed, %d negative pop" % [missing_name, negative_population])
	return true

static func _test_core_ownership(mm: Node) -> bool:
	var all = mm.get_all_provinces()
	var owned = 0
	for pid in all:
		var p = all[pid]
		if not p.owner_tag.is_empty():
			owned += 1
	if owned == 0:
		print("  [FAIL] 0 provinces have owners")
		return false
	print("  [PASS] %d / %d provinces have owners (1879 scenario: limited)" % [owned, all.size()])
	return true

static func _test_province_effects(mm: Node) -> bool:
	var all = mm.get_all_provinces()
	if all.is_empty():
		print("  [FAIL] no provinces to test effects on")
		return false
	var pid = all.keys()[0]
	var fx = mm.get_province_effects(pid, "CHL")
	if fx == null:
		print("  [FAIL] get_province_effects returned null for province %d" % pid)
		return false
	print("  [PASS] ProvinceEffects created for province %d" % pid)
	return true
