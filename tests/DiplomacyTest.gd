extends Node

static func run_all() -> bool:
	var ok = true
	ok = test_relations() and ok
	ok = test_war_peace() and ok
	ok = test_alliances() and ok
	ok = test_guarantees() and ok
	ok = test_neutral() and ok
	if ok:
		print("✅ All diplomacy tests passed")
	else:
		push_error("❌ Some diplomacy tests failed")
	return ok

static func test_relations() -> bool:
	var ok = true
	var dm = DiplomacyManager
	dm.set_relation("CHL", "PER", 50)
	dm.set_relation("CHL", "BOL", -75)
	if dm.get_relation("CHL", "PER") == 50:
		print("  ✓ CHL-PER relation = 50")
	else:
		push_error("DiplomacyTest: CHL-PER relation expected 50")
		ok = false
	if dm.get_relation("CHL", "BOL") == -75:
		print("  ✓ CHL-BOL relation = -75")
	else:
		push_error("DiplomacyTest: CHL-BOL relation expected -75")
		ok = false
	if dm.get_relation("PER", "CHL") == 50:
		print("  ✓ PER-CHL relation = 50 (bidirectional)")
	else:
		push_error("DiplomacyTest: PER-CHL relation expected 50 (bidirectional)")
		ok = false
	dm.modify_relation("CHL", "PER", -10)
	if dm.get_relation("CHL", "PER") == 40:
		print("  ✓ CHL-PER relation modified to 40")
	else:
		push_error("DiplomacyTest: CHL-PER expected 40 after modify")
		ok = false
	if dm.get_relation("CHL", "PER") >= -200 and dm.get_relation("CHL", "PER") <= 200:
		print("  ✓ Relation in valid range")
	else:
		push_error("DiplomacyTest: Relation out of range")
		ok = false
	print("✅ Diplomacy relations: ", "PASS" if ok else "FAIL")
	return ok

static func test_war_peace() -> bool:
	var ok = true
	var dm = DiplomacyManager
	if dm.declare_war("CHL", "PER"):
		print("  ✓ War declared: CHL vs PER")
	else:
		push_error("DiplomacyTest: Failed to declare war")
		ok = false
	if dm.is_at_war("CHL", "PER"):
		print("  ✓ CHL at war with PER")
	else:
		push_error("DiplomacyTest: CHL should be at war with PER")
		ok = false
	if dm.is_at_war("PER", "CHL"):
		print("  ✓ PER at war with CHL (bidirectional)")
	else:
		push_error("DiplomacyTest: PER should be at war with CHL")
		ok = false
	if dm.sign_peace("CHL", "PER", "CHL"):
		print("  ✓ Peace signed, CHL wins")
	else:
		push_error("DiplomacyTest: Failed to sign peace")
		ok = false
	if not dm.is_at_war("CHL", "PER"):
		print("  ✓ No longer at war after peace")
	else:
		push_error("DiplomacyTest: Should not be at war after peace")
		ok = false
	if not dm.declare_war("CHL", "PER"):
		push_error("DiplomacyTest: Should be able to declare war again after peace")
		ok = false
	dm.sign_peace("CHL", "PER", "PER")
	print("✅ Diplomacy war/peace: ", "PASS" if ok else "FAIL")
	return ok

static func test_alliances() -> bool:
	var ok = true
	var dm = DiplomacyManager
	if dm.form_alliance("CHL", "ARG"):
		print("  ✓ Alliance formed: CHL + ARG")
	else:
		push_error("DiplomacyTest: Failed to form alliance")
		ok = false
	if dm.has_alliance("CHL", "ARG"):
		print("  ✓ Has alliance CHL-ARG")
	else:
		push_error("DiplomacyTest: Should have alliance")
		ok = false
	if dm.has_alliance("ARG", "CHL"):
		print("  ✓ Has alliance ARG-CHL (bidirectional)")
	else:
		push_error("DiplomacyTest: Alliance not bidirectional")
		ok = false
	if not dm.form_alliance("CHL", "ARG"):
		print("  ✓ Duplicate alliance prevented")
	else:
		push_error("DiplomacyTest: Should prevent duplicate alliance")
		ok = false
	var allies = dm.get_allies("CHL")
	if "ARG" in allies:
		print("  ✓ CHL has ARG as ally")
	else:
		push_error("DiplomacyTest: ARG should be in CHL allies")
		ok = false
	if dm.declare_war("CHL", "ARG"):
		print("  ✓ Declaring war breaks alliance")
		ok = dm.sign_peace("CHL", "ARG", "CHL")
	else:
		push_error("DiplomacyTest: Should declare war despite alliance")
		ok = false
	print("✅ Diplomacy alliances: ", "PASS" if ok else "FAIL")
	return ok

static func test_guarantees() -> bool:
	var ok = true
	var dm = DiplomacyManager
	if dm.give_guarantee("CHL", "BOL"):
		print("  ✓ CHL guarantees BOL")
	else:
		push_error("DiplomacyTest: Failed to give guarantee")
		ok = false
	if dm.has_guarantee("CHL", "BOL"):
		print("  ✓ Guarantee CHL->BOL exists")
	else:
		push_error("DiplomacyTest: Guarantee not found")
		ok = false
	if not dm.give_guarantee("CHL", "BOL"):
		print("  ✓ Duplicate guarantee prevented")
	else:
		push_error("DiplomacyTest: Should prevent duplicate guarantee")
		ok = false
	if dm.revoke_guarantee("CHL", "BOL"):
		print("  ✓ Guarantee revoked")
	else:
		push_error("DiplomacyTest: Failed to revoke guarantee")
		ok = false
	if not dm.has_guarantee("CHL", "BOL"):
		print("  ✓ Guarantee no longer exists after revoke")
	else:
		push_error("DiplomacyTest: Guarantee should be gone")
		ok = false
	print("✅ Diplomacy guarantees: ", "PASS" if ok else "FAIL")
	return ok

static func test_neutral() -> bool:
	var ok = true
	var dm = DiplomacyManager
	var status = dm.get_status_between("CHL", "BOL")
	if status == "neutral":
		print("  ✓ CHL-BOL status: neutral")
	else:
		push_error("DiplomacyTest: Expected neutral, got " + status)
		ok = false
	dm.form_alliance("CHL", "PER")
	var allied = dm.get_status_between("CHL", "PER")
	if allied == "allied":
		print("  ✓ CHL-PER status: allied")
	else:
		push_error("DiplomacyTest: Expected allied, got " + allied)
		ok = false
	dm.break_alliance("CHL", "PER")
	dm.declare_war("CHL", "PER")
	var war = dm.get_status_between("CHL", "PER")
	if war == "war":
		print("  ✓ CHL-PER status: war")
	else:
		push_error("DiplomacyTest: Expected war, got " + war)
		ok = false
	dm.sign_peace("CHL", "PER", "CHL")
	var self_status = dm.get_status_between("CHL", "CHL")
	if self_status == "self":
		print("  ✓ Self status: self")
	else:
		push_error("DiplomacyTest: Expected self, got " + self_status)
		ok = false
	print("✅ Diplomacy status API: ", "PASS" if ok else "FAIL")
	return ok
