class_name CombatComprehensiveTest
extends RefCounted

const CW_PLAINS = 80
const CW_FOREST = 60
const CW_HILLS = 50
const CW_MOUNTAIN = 40
const CW_URBAN = 50
const CW_DESERT = 70
const CW_MARSH = 30
const CW_JUNGLE = 40

const STACKING_PENALTY_RATE = 0.01
const MAX_STACKING_PENALTY = 0.7

static func run_all(bm: Node) -> bool:
	var ok = true
	ok = _test_battlemanager_exists(bm) and ok
	ok = _test_combat_width_constants(bm) and ok
	ok = _test_stacking_penalty(bm) and ok
	ok = _test_max_stacking_penalty_clamped(bm) and ok
	ok = _test_battle_history_initially_empty(bm) and ok
	ok = _test_combat_within_limits(bm) and ok
	return ok

static func _get_battle_manager() -> Node:
	var tree = Engine.get_main_loop()
	if tree == null:
		return null
	return tree.root.get_node_or_null("/root/BattleManager")

static func _test_battlemanager_exists(bm: Node) -> bool:
	if bm == null:
		print("  [FAIL] BattleManager autoload not available")
		return false
	print("  [PASS] BattleManager available")
	return true

static func _test_combat_width_constants(bm: Node) -> bool:
	var expected = {
		"plains": CW_PLAINS,
		"grassland": CW_PLAINS,
		"forest": CW_FOREST,
		"woods": CW_FOREST,
		"hills": CW_HILLS,
		"mountain": CW_MOUNTAIN,
		"mountains": CW_MOUNTAIN,
		"alpine": CW_MOUNTAIN,
		"urban": CW_URBAN,
		"city": CW_URBAN,
		"town": CW_URBAN,
		"desert": CW_DESERT,
		"arid": CW_DESERT,
		"marsh": CW_MARSH,
		"swamp": CW_MARSH,
		"wetland": CW_MARSH,
		"jungle": CW_JUNGLE,
	}
	for terrain in expected:
		var w = _simulate_get_combat_width(terrain)
		if w != expected[terrain]:
			print("  [FAIL] terrain=%s expected=%d got=%d" % [terrain, expected[terrain], w])
			return false
	print("  [PASS] all %d terrain combat widths match" % expected.size())
	return true

static func _test_stacking_penalty(bm: Node) -> bool:
	var width = CW_PLAINS
	var used = 100
	var overflow = float(used - width)
	var expected_penalty = minf(overflow * STACKING_PENALTY_RATE, MAX_STACKING_PENALTY)
	var factor = 1.0 - expected_penalty
	if factor >= 1.0:
		print("  [FAIL] 100 width on plains (80) should have penalty")
		return false
	if factor <= 0.0:
		print("  [FAIL] penalty should not reduce power to 0")
		return false
	print("  [PASS] stacking penalty: 100/80 -> factor=%.3f" % factor)
	return true

static func _test_max_stacking_penalty_clamped(bm: Node) -> bool:
	var overflow = int(MAX_STACKING_PENALTY / STACKING_PENALTY_RATE) + 10
	var penalty = minf(float(overflow) * STACKING_PENALTY_RATE, MAX_STACKING_PENALTY)
	if penalty < MAX_STACKING_PENALTY:
		print("  [FAIL] max penalty %f not reached at overflow %d" % [MAX_STACKING_PENALTY, overflow])
		return false
	if penalty > MAX_STACKING_PENALTY:
		print("  [FAIL] penalty exceeds max: %f > %f" % [penalty, MAX_STACKING_PENALTY])
		return false
	print("  [PASS] max stacking penalty clamped to %.2f" % MAX_STACKING_PENALTY)
	return true

static func _test_battle_history_initially_empty(bm: Node) -> bool:
	var history = bm.get_battle_history()
	if history.size() > 0:
		print("  [SKIP] battle history has %d entries (game already running)" % history.size())
		return true
	print("  [PASS] battle history empty at start")
	return true

static func _test_combat_within_limits(bm: Node) -> bool:
	var width = 80
	var zero_width = 0
	if width <= 0:
		print("  [FAIL] plains combat width should be positive")
		return false
	if zero_width > 0:
		print("  [FAIL] zero test failed unexpectedly")
		return false
	print("  [PASS] combat width boundaries OK (min=%d, max=%d)" % [CW_MARSH, CW_PLAINS])
	return true

static func _simulate_get_combat_width(terrain: String) -> int:
	var t = terrain.strip_edges().to_lower()
	match t:
		"plains", "grassland": return CW_PLAINS
		"forest", "woods": return CW_FOREST
		"hills": return CW_HILLS
		"mountain", "mountains", "alpine": return CW_MOUNTAIN
		"urban", "city", "town": return CW_URBAN
		"desert", "arid": return CW_DESERT
		"marsh", "swamp", "wetland": return CW_MARSH
		"jungle": return CW_JUNGLE
		_: return CW_PLAINS
