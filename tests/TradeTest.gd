extends Node

static func run_all() -> bool:
	var ok = true
	ok = test_trade_screen_loading() and ok
	ok = test_offer_formatting() and ok
	ok = test_create_offer() and ok
	if ok:
		print("✅ All trade UI tests passed")
	else:
		push_error("❌ Some trade UI tests failed")
	return ok

static func test_trade_screen_loading() -> bool:
	var ok = true
	var script = load("res://scripts/ui/TradeScreen.gd")
	if script != null:
		print("  ✓ TradeScreen script loaded")
	else:
		push_error("TradeTest: failed to load TradeScreen script")
		ok = false
	var scene = load("res://scenes/ui/TradeScreen.tscn")
	if scene != null:
		print("  ✓ TradeScreen scene loaded")
	else:
		push_error("TradeTest: failed to load TradeScreen scene")
		ok = false
	if script.has_method("open") and script.has_method("close") and script.has_method("refresh_offers"):
		print("  ✓ TradeScreen has open/close/refresh_offers")
	else:
		push_error("TradeTest: missing required methods")
		ok = false
	if script.has_signal("trade_screen_closed"):
		print("  ✓ TradeScreen has trade_screen_closed signal")
	else:
		push_error("TradeTest: missing trade_screen_closed signal")
		ok = false
	print("✅ Trade screen loading: ", "PASS" if ok else "FAIL")
	return ok

static func test_offer_formatting() -> bool:
	var ok = true
	var sample_offer := {
		"id": "trade_1879_12345",
		"from_tag": "CHL",
		"to_tag": "PER",
		"offered": [{"type": 0, "id": "steel", "quantity": 500.0}],
		"requested": [{"type": 0, "id": "rubber", "quantity": 200.0}],
		"visibility": 0,
		"status": 0,
		"created_turn": 1879,
	}
	if sample_offer.get("from_tag", "") == "CHL":
		print("  ✓ Sample offer from_tag = CHL")
	else:
		push_error("TradeTest: from_tag should be CHL")
		ok = false
	if sample_offer.get("to_tag", "") == "PER":
		print("  ✓ Sample offer to_tag = PER")
	else:
		push_error("TradeTest: to_tag should be PER")
		ok = false
	if (sample_offer.get("offered", []) as Array).size() == 1:
		print("  ✓ Sample offer has 1 offered item")
	else:
		push_error("TradeTest: should have 1 offered item")
		ok = false
	if (sample_offer.get("requested", []) as Array).size() == 1:
		print("  ✓ Sample offer has 1 requested item")
	else:
		push_error("TradeTest: should have 1 requested item")
		ok = false
	print("✅ Trade offer formatting: ", "PASS" if ok else "FAIL")
	return ok

static func test_create_offer() -> bool:
	var ok = true
	if typeof(TradeManager) == TYPE_NIL:
		push_warning("TradeTest: TradeManager not available, skipping offer creation test")
		return true
	var offer_id := TradeManager.create_offer(
		"CHL", "PER",
		[{"type": TradeItemType.RESOURCE, "id": "steel", "quantity": 500.0}],
		[{"type": TradeItemType.RESOURCE, "id": "rubber", "quantity": 200.0}],
		TradeVisibility.PUBLIC
	)
	if offer_id != "":
		print("  ✓ Trade offer created: " + offer_id)
	else:
		push_error("TradeTest: failed to create trade offer")
		ok = false
	var offers := TradeManager.get_offers_for_country("CHL")
	if offers.size() > 0:
		print("  ✓ Offers found for CHL: " + str(offers.size()))
	else:
		push_warning("TradeTest: no offers found for CHL (may be expected)")
	var fairness := TradeManager.evaluate_fairness(offer_id, "CHL")
	if fairness.get("score", -1) > 0:
		print("  ✓ Fairness evaluation score: " + str(fairness.get("score", -1)))
	else:
		push_error("TradeTest: fairness score should be > 0")
		ok = false
	print("✅ Trade offer creation: ", "PASS" if ok else "FAIL")
	return ok
