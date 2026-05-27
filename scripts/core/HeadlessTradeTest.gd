# scripts/core/HeadlessTradeTest.gd
## Run: godot --headless --path . -s res://scripts/core/HeadlessTradeTest.gd
extends SceneTree

const TradeManagerScript := preload("res://scripts/national/TradeManager.gd")


func _init() -> void:
	var tm: Node = TradeManagerScript.new()
	tm.name = "TradeManagerTest"
	root.add_child(tm)
	_run(tm)
	quit(0 if _failures == 0 else 1)


var _failures := 0


func _fail(msg: String) -> void:
	_failures += 1
	push_error(msg)


func _run(tm: Node) -> void:
	# Offer: GER gives 100 steel, wants 50 rubber. USA accepts.
	var offer_id: String = tm.create_offer(
		"GER",
		"USA",
		[{"type": tm.TradeItemType.RESOURCE, "id": "steel", "quantity": 100.0}],
		[{"type": tm.TradeItemType.RESOURCE, "id": "rubber", "quantity": 50.0}],
	)
	if offer_id.is_empty():
		_fail("create_offer returned empty id")

	if typeof(ProductionManager) == TYPE_NIL:
		_fail("ProductionManager autoload required")
		return

	ProductionManager.add_stockpile({"steel": 200.0, "rubber": 200.0})
	var after_seed_steel := float(ProductionManager.national_stockpile.get("steel", 0.0))
	var after_seed_rubber := float(ProductionManager.national_stockpile.get("rubber", 0.0))

	if typeof(LeaderManager) != TYPE_NIL and LeaderManager.has_method("set_player_country_tag"):
		LeaderManager.set_player_country_tag("USA")

	if not tm.accept_offer(offer_id):
		_fail("accept_offer failed (check player stockpile validation)")

	var after_steel := float(ProductionManager.national_stockpile.get("steel", 0.0))
	var after_rubber := float(ProductionManager.national_stockpile.get("rubber", 0.0))

	var steel_delta := after_steel - after_seed_steel
	var rubber_delta := after_rubber - after_seed_rubber
	if steel_delta < 90.0:
		_fail("USA did not receive offered steel (delta %s)" % steel_delta)
	if rubber_delta > -40.0:
		_fail("USA did not pay requested rubber (delta %s)" % rubber_delta)

	# Expiry year math
	var exp_id: String = tm.create_offer("GER", "USA", [], [], tm.TradeVisibility.PUBLIC, 2)
	var exp_offer: Dictionary = tm._offers.get(exp_id, {})
	var deadline: int = int(exp_offer.get("expires_turn", -1))
	if deadline <= tm._current_year:
		_fail("expires_turn should be future year, got %d (current %d)" % [deadline, tm._current_year])

	if _failures == 0:
		print("HeadlessTradeTest: all checks passed")
	else:
		print("HeadlessTradeTest: %d failure(s)" % _failures)
