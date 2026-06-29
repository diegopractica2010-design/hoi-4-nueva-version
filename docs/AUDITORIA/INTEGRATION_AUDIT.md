# Integration Audit

Static calls prove intended wiring only; because both runtime runners fail, static wiring cannot be classified CONNECTED unless execution also succeeded.

| Integration | Static evidence (path, class, method) | Runtime command/result | Verdict |
|---|---|---|---|
| TradeScreen -> TradeManager | `scripts/ui/TradeScreen.gd`, `TradeScreen._on_create_offer_pressed/_on_accept_pressed`, direct manager calls | `--check-only TradeScreen.gd` exit 1; scene not functional | PARTIAL |
| DiplomacyScreen -> DiplomacyManager | `scripts/ui/DiplomacyScreen.gd`, action handlers directly call war/alliance/peace APIs | manager fails startup; diplomacy suite never runs | PARTIAL |
| AI -> Diplomacy | `AdvancedAIManager._evaluate_alliances/_evaluate_war_declarations`; direct calls | both managers fail parser/autoload | PARTIAL |
| AI -> Economy | `AIEconomyManager._evaluate_nation_economy` calls factory, production and technology managers | AIEconomy autoload fails; invalid `create_line(tag, design_id)` arity | PARTIAL |
| Economy -> Production | `NationalIncomeManager._process_monthly_income` calls `ProductionManager.add_stockpile` | both systems fail compilation/startup | PARTIAL |
| Production -> Supply | `ProductionManager` contains SupplyManager references; textual dependency scan | production autoload absent; no executing flow | PARTIAL |
| Events -> Diplomacy | `EventManager._apply_effect` changes only `LeaderManager` war flags for `declare_war/force_peace`; it does not call `DiplomacyManager` | 1 data `diplomacy` effect and 2 `peace` effects are unsupported | DISCONNECTED |
| Events -> Economy | `EventManager._apply_effect` has no `NationalIncomeManager`/`ProductionManager` branch; data uses unsupported `modifier` effects | 33/33 modifier effects unsupported | DISCONNECTED |
| SaveLoad -> new managers | `SaveLoadManager._collect_save_data/_apply_save_data` covers technology, production, factories, design, leaders, national income, events, basic AI | search found no AIEconomyManager, AdvancedAIManager, CombatExpansionManager, DiplomacyManager or TradeManager persistence | DISCONNECTED for those five |

Command evidence: targeted `rg -n` over the listed files for manager calls and save keys; result as shown. Runtime evidence: HeadlessTestRunner exit 1 before suites; TestRunner exit 1 during production tests.

Summary: CONNECTED 0, PARTIAL 6, DISCONNECTED 3 integration groups. No integration met the execution requirement.
