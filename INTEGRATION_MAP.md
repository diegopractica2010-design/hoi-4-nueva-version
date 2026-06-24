# INTEGRATION MAP — Phase 7

## Legend
`→` = method call with typeof guard  
`⚠` = method call WITHOUT typeof guard (crash risk)  
`✗` = integration missing / broken  
`✓` = integration verified PASS  

---

## A. Trade ↔ TradeManager

| Caller | Target | Method | Guard | Status |
|--------|--------|--------|-------|--------|
| TradeScreen.refresh_offers | TradeManager | get_offers_for_country | ✓ typeof | ✓ |
| TradeScreen._on_offer_selected | TradeManager | evaluate_fairness | ✓ typeof (after fix) | ✓ |
| TradeScreen._on_accept_pressed | TradeManager | accept_offer | ✓ typeof | ✓ |
| TradeScreen._on_reject_pressed | TradeManager | reject_offer | ✓ typeof | ✓ |
| TradeScreen._on_create_offer_pressed | TradeManager | create_offer | ✓ typeof | ✓ |
| TradeManager._execute_transfer | DesignManager | grant_acquired_design | ✓ typeof | ✓ |
| TradeManager._execute_transfer | ProductionManager | add_stockpile / pay_cost | ✓ typeof | ✓ |
| TradeManager._execute_transfer | TechnologyManager | apply_tech_intel_bonus | ✓ typeof | ✓ |
| TradeManager._execute_transfer | NationalModifierManager | apply_national_effect | ✓ typeof | ✓ |
| TradeManager._execute_transfer | MapManager | update_province_owner | ✓ typeof | ✓ |

---

## B. Diplomacy ↔ DiplomacyManager

| Caller | Target | Method | Guard | Status |
|--------|--------|--------|-------|--------|
| DiplomacyScreen._update_info | DiplomacyManager | get_relation | ✓ typeof (after fix) | ✓ |
| DiplomacyScreen._update_info | DiplomacyManager | get_status_between | ✓ typeof (after fix) | ✓ |
| DiplomacyScreen._update_info | DiplomacyManager | has_guarantee | ✓ typeof (after fix) | ✓ |
| DiplomacyScreen._on_declare_war_pressed | DiplomacyManager | declare_war | ✓ typeof (after fix) | ✓ |
| DiplomacyScreen._on_form_alliance_pressed | DiplomacyManager | form_alliance | ✓ typeof (after fix) | ✓ |
| DiplomacyScreen._on_give_guarantee_pressed | DiplomacyManager | give_guarantee | ✓ typeof (after fix) | ✓ |
| DiplomacyScreen._on_sign_peace_pressed | DiplomacyManager | get_wars_for / sign_peace | ✓ typeof (after fix) | ✓ |

---

## C. Events ↔ Diplomacy

| Caller | Target | Method | Guard | Status |
|--------|--------|--------|-------|--------|
| EventManager._apply_effect("declare_war") | DiplomacyManager | declare_war | ✓ typeof | ✓ |
| EventManager._apply_effect("force_peace") | DiplomacyManager | sign_peace | ✓ typeof | ✓ |
| EventManager._apply_effect("diplomacy") | DiplomacyManager | form_alliance / declare_war / sign_peace | ✓ typeof | ✓ |
| EventManager._apply_effect("peace") | DiplomacyManager | sign_peace | ✓ typeof | ✓ |
| EventManager._check_conditions | DiplomacyManager | is_at_war (war_exists) | ✓ typeof | ✓ |
| EventManager._check_conditions | DiplomacyManager | is_nation_at_war (peace condition) | ✓ typeof | ✓ |
| EventManager._check_trigger("relation") | DiplomacyManager | get_relation | ✓ typeof | ✓ |

---

## D. Events ↔ Economy

| Caller | Target | Method | Guard | Status |
|--------|--------|--------|-------|--------|
| EventManager._apply_effect("modifier") | NationalModifierManager | apply_national_effect | ✓ typeof | ✓ |
| EventManager._apply_effect("add_national_spirit") | NationalModifierManager | apply_national_effect | ✓ typeof | ✓ |

---

## E. AI Economy ↔ Economy

| Caller | Target | Method | Guard | Status |
|--------|--------|--------|-------|--------|
| AIEconomyManager._evaluate_production | ProductionManager | get_production_lines_for_nation | ✓ typeof + has_method | ✓ |
| AIEconomyManager._start_production_line | ProductionManager | create_line / set_line_template | ✓ typeof + has_method | ✓ |
| AIEconomyManager._evaluate_factory_construction | NationalIncomeManager | get_national_stockpile | ✓ typeof + has_method | ✓ |
| AIEconomyManager._evaluate_technology_research | TechnologyManager | get_available_techs / start_research | ✓ typeof + has_method | ✓ |
| AIEconomyManager._is_nation_at_war | DiplomacyManager | get_wars_for | ✓ typeof | ✓ |
| AIEconomyManager._get_available_designs | DesignManager | get_available_designs_for_nation | ✓ typeof + has_method | ✓ |

---

## F. AI ↔ Diplomacy

| Caller | Target | Method | Guard | Status |
|--------|--------|--------|-------|--------|
| AdvancedAI._evaluate_alliances | DiplomacyManager | get_relation / has_alliance / form_alliance | ✓ typeof | ✓ |
| AdvancedAI._get_potential_alliance_partners | DiplomacyManager | is_at_war / has_alliance / get_relation | ✓ typeof | ✓ |
| AdvancedAI._evaluate_war_declarations | DiplomacyManager | get_wars_for / get_relation / declare_war | ✓ typeof | ✓ |
| AdvancedAI._get_potential_war_targets | DiplomacyManager | is_at_war / has_alliance / get_relation | ✓ typeof | ✓ |
| AdvancedAI._get_enemy_tags | DiplomacyManager | get_wars_for / get_relation | ✓ typeof | ✓ |
| AdvancedAI._determine_strategic_goals | DiplomacyManager | get_wars_for / get_allies | ✓ typeof | ✓ |

---

## G. AdvancedAI ↔ Economy

| Caller | Target | Method | Guard | Status |
|--------|--------|--------|-------|--------|
| AdvancedAI._enemy_tags fallback | GameData | .world.tags | ✓ typeof (after fix) | ✓ |
| AdvancedAI._evaluate_nation_supply | SupplyManager | get_supply_status | ✓ typeof + has_method | ✓ |
| AdvancedAI._optimize_supply_routes | SupplyManager | reroute_supply | ✓ typeof + has_method | ✓ |

---

## H. Production ↔ Supply

| Caller | Target | Method | Guard | Status |
|--------|--------|--------|-------|--------|
| ProductionManager.get_division_required_equipment | SupplyManager | division_templates.get_division | ✓ `supply == null` | ✓ |
| ProductionManager.get_division_sustainment_readiness_multiplier | SupplyManager | division_templates.get_division | ✓ `supply == null` | ✓ |
| ProductionManager.get_division_infantry_stats | SupplyManager | division_templates.get_division | ✓ `supply == null` | ✓ |
| ProductionManager.get_division_combat_modifiers | SupplyManager | division_templates.get_division | ✓ `supply == null` | ✓ |
| ProductionManager.get_division_final_combat_stats | SupplyManager | division_templates.get_division | ✓ `supply == null` | ✓ |

---

## I. Technology ↔ Production

| Caller | Target | Method | Guard | Status |
|--------|--------|--------|-------|--------|
| ProductionManager.set_line_template | TechnologyManager | factory_can_build_design | ✓ typeof | ✓ |
| ProductionManager.reassign_factory | TechnologyManager | factory_can_build_design | ✓ typeof | ✓ |
| **TechnologyManager → ProductionManager** | ✗ | **Missing: no unlock/production modifier call** | — | **✗ PARTIAL** |

---

## J. Combat ↔ Supply

| Caller | Target | Method | Guard | Status |
|--------|--------|--------|-------|--------|
| SupplyManager.record_attrition | LeaderManager | get_formation / resolve_leader_id | ✓ typeof | ✓ |
| SupplyManager.calculate_daily_supply_consumption | LeaderManager | get_formation / apply_supply_consumption | ✓ typeof | ✓ |
| SupplyManager._consume_supply_for_formations | LeaderManager | .formations (dict iteration) | ✓ typeof | ✓ |
| **BattleManager → SupplyManager** | ✗ | **Missing: no attrition/consumption call** | — | **✗ PARTIAL** |

---

## K. Combat ↔ Diplomacy

| Caller | Target | Method | Guard | Status |
|--------|--------|--------|-------|--------|
| BattleManager._capture_province | MapManager | update_province_owner | ✓ typeof + has_method | ✓ |
| BattleManager._capture_province | FactoryManager | capture_province_factories | ✓ typeof + has_method | ✓ |
| **BattleManager → DiplomacyManager** | ✗ | **Missing: no war state update** | — | **✗ PARTIAL** |

---

## L. Persistence (SaveLoad) Cross-Check

| Manager | get_save_data | load_save_data | Guard | Status |
|---------|---------------|----------------|-------|--------|
| TimeManager | ✓ date/seed/paused | ✓ set date/seed/paused | ✓ typeof + data.has | ✓ |
| TechnologyManager | ✓ get_save_data | ✓ apply | ✓ typeof + has_method | ✓ |
| AgentManager | ✓ _serialize (internal) | ✓ _apply (internal) | ✓ typeof | ✓ |
| MapManager | ✓ _serialize (internal) | ✓ _apply (internal) | ✓ typeof | ✓ |
| SupplyManager | ✓ _serialize (internal) | ✓ _apply (internal) | ✓ typeof | ✓ |
| NationalModifierManager | ✓ country_modifiers.duplicate | ✓ wholesale replace | ✓ typeof | ✓ |
| ProductionManager | ✓ get_save_data | ✓ apply_save_data | ✓ typeof + has_method | ✓ |
| FactoryManager | ✓ get_save_data | ✓ apply_save_data | ✓ typeof + has_method | ✓ |
| DesignManager | ✓ get_save_data | ✓ apply_save_data | ✓ typeof + has_method | ✓ |
| LeaderManager | ✓ get_save_data | ✓ apply_save_data | ✓ typeof + has_method | ✓ |
| NationalIncomeManager | ✓ get_save_data | ✓ load_save_data | ✓ typeof | ✓ |
| EventManager | ✓ get_save_data | ✓ load_save_data | ✓ typeof | ✓ |
| AIManager | ✓ get_save_data | ✓ load_save_data | ✓ typeof | ✓ |
| TradeManager | ✗ NOT IMPLEMENTED | ✗ NOT IMPLEMENTED | — | **✗ PARTIAL** |
| DiplomacyManager | ✗ NOT IMPLEMENTED | ✗ NOT IMPLEMENTED | — | **✗ PARTIAL** |

---

## Summary

| Integration | Status |
|-------------|--------|
| Trade ↔ TradeManager | ✓ PASS |
| Diplomacy ↔ DiplomacyManager | ✓ PASS (after fix) |
| Events ↔ Diplomacy | ✓ PASS |
| Events ↔ Economy | ✓ PASS |
| AI Economy ↔ Economy | ✓ PASS |
| AI ↔ Diplomacy | ✓ PASS |
| AdvancedAI ↔ Economy | ✓ PASS (after fix) |
| Production ↔ Supply | ✓ PASS |
| Technology ↔ Production | ◐ PARTIAL (missing ProductionManager unlock) |
| Combat ↔ Supply | ◐ PARTIAL (missing BattleManager attrition) |
| Combat ↔ Diplomacy | ◐ PARTIAL (missing BattleManager war state) |
| **SaveLoad (TradeManager)** | ✗ MISSING |
| **SaveLoad (DiplomacyManager)** | ✗ MISSING |
