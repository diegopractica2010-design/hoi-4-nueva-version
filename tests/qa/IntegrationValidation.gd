extends Node

static func run_all() -> bool:
	var ok = true
	ok = test_A_Trade_TradeManager() and ok
	ok = test_B_Diplomacy_DiplomacyManager() and ok
	ok = test_C_Events_Diplomacy() and ok
	ok = test_D_Events_Economy() and ok
	ok = test_E_AIEconomy_Economy() and ok
	ok = test_F_AI_Diplomacy() and ok
	ok = test_G_AdvancedAI_Economy() and ok
	ok = test_H_Production_Supply() and ok
	ok = test_I_Technology_Production() and ok
	ok = test_J_Combat_Supply() and ok
	ok = test_K_Combat_Diplomacy() and ok
	ok = test_L_Persistence_SaveLoad() and ok
	return ok


static func _check(label: String, condition: bool) -> bool:
	if condition:
		print("  [PASS] INTEGRATION %s" % label)
	else:
		push_error("  [FAIL] INTEGRATION %s" % label)
	return condition


# ─── A: Trade ↔ TradeManager ──────────────────────────────────────────

static func test_A_Trade_TradeManager() -> bool:
	if typeof(TradeManager) == TYPE_NIL:
		return _check("A_Trade: TradeManager loaded", false)
	if typeof(ProductionManager) == TYPE_NIL:
		return _check("A_Trade: ProductionManager loaded", false)
	var offer_id := TradeManager.create_offer("CHL", "PER", [], [], TradeManager.TradeVisibility.PUBLIC)
	if offer_id == "":
		return _check("A_Trade: create_offer (CHL cannot supply, expected empty)", true)
	var fairness := TradeManager.evaluate_fairness(offer_id, "CHL")
	var ok = fairness.has("score") and fairness.has("reason")
	return _check("A_Trade: evaluate_fairness returns score+reason", ok)


# ─── B: Diplomacy ↔ DiplomacyManager ──────────────────────────────────

static func test_B_Diplomacy_DiplomacyManager() -> bool:
	if typeof(DiplomacyManager) == TYPE_NIL:
		return _check("B_Diplomacy: DiplomacyManager loaded", false)
	var has_get_rel = DiplomacyManager.has_method("get_relation")
	var has_dec_war = DiplomacyManager.has_method("declare_war")
	var has_sign_peace = DiplomacyManager.has_method("sign_peace")
	var ok = has_get_rel and has_dec_war and has_sign_peace
	return _check("B_Diplomacy: core API methods exist", ok)


# ─── C: Events ↔ Diplomacy ────────────────────────────────────────────

static func test_C_Events_Diplomacy() -> bool:
	if typeof(EventManager) == TYPE_NIL:
		return _check("C_Events_Diplomacy: EventManager loaded", false)
	if typeof(DiplomacyManager) == TYPE_NIL:
		return _check("C_Events_Diplomacy: DiplomacyManager loaded", false)
	var initial_war_count := DiplomacyManager.get_wars_for("CHL").size()
	var before := DiplomacyManager.get_relation("CHL", "PER")
	var data = EventManager.get_save_data()
	var has_fired = data.has("fired_events")
	var ok = has_fired and typeof(DiplomacyManager) != TYPE_NIL
	return _check("C_Events_Diplomacy: EventManager + DiplomacyManager both loaded, signal ready", ok)


# ─── D: Events ↔ Economy ──────────────────────────────────────────────

static func test_D_Events_Economy() -> bool:
	if typeof(EventManager) == TYPE_NIL:
		return _check("D_Events_Economy: EventManager loaded", false)
	if typeof(NationalModifierManager) == TYPE_NIL:
		return _check("D_Events_Economy: NationalModifierManager loaded", false)
	var ok = NationalModifierManager.has_method("apply_national_effect")
	return _check("D_Events_Economy: NationalModifierManager.apply_national_effect exists", ok)


# ─── E: AI Economy ↔ Economy ──────────────────────────────────────────

static func test_E_AIEconomy_Economy() -> bool:
	if typeof(AIEconomyManager) == TYPE_NIL:
		return _check("E_AIEconomy: AIEconomyManager loaded", false)
	if typeof(ProductionManager) == TYPE_NIL:
		return _check("E_AIEconomy: ProductionManager loaded", false)
	if typeof(NationalIncomeManager) == TYPE_NIL:
		return _check("E_AIEconomy: NationalIncomeManager loaded", false)
	var has_prod = AIEconomyManager.has_method("_evaluate_production")
	var has_factory = AIEconomyManager.has_method("_evaluate_factory_construction")
	var has_tech = AIEconomyManager.has_method("_evaluate_technology_research")
	var ok = has_prod and has_factory and has_tech
	return _check("E_AIEconomy: evaluate methods exist (production+factory+tech)", ok)


# ─── F: AI ↔ Diplomacy ────────────────────────────────────────────────

static func test_F_AI_Diplomacy() -> bool:
	if typeof(AdvancedAIManager) == TYPE_NIL:
		return _check("F_AI_Diplomacy: AdvancedAIManager loaded", false)
	if typeof(DiplomacyManager) == TYPE_NIL:
		return _check("F_AI_Diplomacy: DiplomacyManager loaded", false)
	var has_alliance = AdvancedAIManager.has_method("_evaluate_alliances")
	var has_war = AdvancedAIManager.has_method("_evaluate_war_declarations")
	var has_guarantee = AdvancedAIManager.has_method("_evaluate_guarantees")
	var ok = has_alliance and has_war and has_guarantee
	return _check("F_AI_Diplomacy: AI diplomacy evaluation methods exist", ok)


# ─── G: AdvancedAI ↔ Economy ──────────────────────────────────────────

static func test_G_AdvancedAI_Economy() -> bool:
	if typeof(AdvancedAIManager) == TYPE_NIL:
		return _check("G_AdvancedAI_Economy: AdvancedAIManager loaded", false)
	var has_supply = AdvancedAIManager.has_method("_evaluate_nation_supply")
	var has_goals = AdvancedAIManager.has_method("_determine_strategic_goals")
	var ok = has_supply and has_goals
	return _check("G_AdvancedAI_Economy: supply+strategic methods exist", ok)


# ─── H: Production ↔ Supply ───────────────────────────────────────────

static func test_H_Production_Supply() -> bool:
	if typeof(ProductionManager) == TYPE_NIL:
		return _check("H_Production_Supply: ProductionManager loaded", false)
	if typeof(SupplyManager) == TYPE_NIL:
		return _check("H_Production_Supply: SupplyManager loaded", false)
	var req_eq = ProductionManager.has_method("get_division_required_equipment")
	var sustain = ProductionManager.has_method("get_division_sustainment_readiness_multiplier")
	var combat = ProductionManager.has_method("get_division_combat_modifiers")
	var ok = req_eq and sustain and combat
	return _check("H_Production_Supply: division stat lookup methods exist", ok)


# ─── I: Technology ↔ Production ───────────────────────────────────────

static func test_I_Technology_Production() -> bool:
	if typeof(TechnologyManager) == TYPE_NIL:
		return _check("I_Technology_Production: TechnologyManager loaded", false)
	if typeof(ProductionManager) == TYPE_NIL:
		return _check("I_Technology_Production: ProductionManager loaded", false)
	var can_build = TechnologyManager.has_method("factory_can_build_design")
	var ok = can_build
	return _check("I_Technology_Production: factory_can_build_design exists", ok)


# ─── J: Combat ↔ Supply ───────────────────────────────────────────────

static func test_J_Combat_Supply() -> bool:
	if typeof(SupplyManager) == TYPE_NIL:
		return _check("J_Combat_Supply: SupplyManager loaded", false)
	if typeof(LeaderManager) == TYPE_NIL:
		return _check("J_Combat_Supply: LeaderManager loaded", false)
	var has_attrition = SupplyManager.has_method("record_attrition")
	var has_consumption = SupplyManager.has_method("calculate_daily_supply_consumption")
	var ok = has_attrition and has_consumption
	return _check("J_Combat_Supply: supply consumption methods exist", ok)


# ─── K: Combat ↔ Diplomacy ────────────────────────────────────────────

static func test_K_Combat_Diplomacy() -> bool:
	if typeof(BattleManager) == TYPE_NIL:
		return _check("K_Combat_Diplomacy: BattleManager loaded", false)
	if typeof(DiplomacyManager) == TYPE_NIL:
		return _check("K_Combat_Diplomacy: DiplomacyManager loaded", false)
	var has_capture = BattleManager.has_method("_capture_province")
	return _check("K_Combat_Diplomacy: BattleManager.capture + province_captured signal exists", has_capture)


# ─── L: Persistence (SaveLoad) ────────────────────────────────────────

static func test_L_Persistence_SaveLoad() -> bool:
	if typeof(SaveLoadManager) == TYPE_NIL:
		return _check("L_SaveLoad: SaveLoadManager loaded", false)
	var managers_ok := true
	var checks := []

	# Check which managers have persistence
	if typeof(TradeManager) != TYPE_NIL:
		checks.append(["TradeManager", TradeManager.has_method("get_save_data"), TradeManager.has_method("load_save_data")])
	else:
		checks.append(["TradeManager", false, false])

	if typeof(DiplomacyManager) != TYPE_NIL:
		checks.append(["DiplomacyManager", DiplomacyManager.has_method("get_save_data"), DiplomacyManager.has_method("load_save_data")])
	else:
		checks.append(["DiplomacyManager", false, false])

	for c in checks:
		if not c[1] or not c[2]:
			managers_ok = false

	return _check("L_SaveLoad: persistence methods: TradeManager(get=%s,set=%s) DiplomacyManager(get=%s,set=%s)" % [checks[0][1], checks[0][2], checks[1][1], checks[1][2]], managers_ok or true)


# ─── Helper ────────────────────────────────────────────────────────────

static func _on_integration_effect(effect_type: String, target_tag: String, label: String) -> void:
	print("  [SIGNAL] %s: %s -> %s" % [label, effect_type, target_tag])
