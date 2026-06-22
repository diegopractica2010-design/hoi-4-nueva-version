# System Reality Report

Scale: EXISTS / COMPILES / LOADS / EXECUTES / VALIDATED. A system is WORKING only with five YES values.

| System | E | C | L | X | V | Class | Evidence (path, class, method, command/result) |
|---|:---:|:---:|:---:|:---:|:---:|---|---|
| Combat | YES | UNVERIFIED aggregate | PARTIAL | NO | NO | PARTIAL | `scripts/military/BattleManager.gd`, `BattleManager._resolve_battle/_capture_province`; code connects movement, damage and capture, but `TestRunner` aborts before combat tests. No current battle completed. |
| Economy | YES | NO | NO | NO | NO | BROKEN | `scripts/national/NationalIncomeManager.gd`, `_process_monthly_income`; startup reports dependent compile failure; economy suite never runs. |
| Production | YES | NO | NO | PARTIAL | NO | BROKEN | `ProductionManager`; parser fails. `ProductionLineTest.run_all` command: 2 pass, 7 fail, 6 crash, 5 skip; unit production result was zero. |
| Technology | YES | NO | NO | NO | NO | BROKEN | `TechnologyManager`, `_ready/start_research`; Logger parser failure, autoload absent. |
| Supply | YES | NO (dependency) | placeholder only | NO | NO | BROKEN | `SupplyManager`; project load fails, supply tests never reached. |
| Diplomacy | YES | NO | NO | NO | NO | BROKEN | `DiplomacyManager.declare_war/sign_peace/form_alliance`; seven Logger parser errors, autoload absent, diplomacy suite not run. |
| Trade | YES | NO at UI | PARTIAL manager | NO | NO | BROKEN | `TradeScreen._on_create_offer_pressed/_on_accept_pressed`; `--check-only` exit 1 with 9 parser errors; trade suite not run. |
| Events | YES | NO | NO | NO | NO | BROKEN | `EventManager._check_trigger/_apply_effect`; parser failure. Static data check: 36/36 event effects use unsupported types (`modifier`, `diplomacy`, `peace`); relation trigger is unsupported. |
| Save/Load | YES | NO | NO | NO | NO | BROKEN | `SaveLoadManager.save_game/load_game`; parser failure, autoload absent, cycle suite not reached. |
| AI economy | YES | NO | NO | NO | NO | BROKEN | `AIEconomyManager._build_factory/_start_production_line`; parser/API arity error, autoload absent. |
| Advanced AI | YES | NO | NO | NO | NO | BROKEN | `AdvancedAIManager._evaluate_nation_diplomacy/_evaluate_nation_supply`; parser failure, autoload absent. |

## Required behavior answers

- Battles, damage and province ownership: implementation paths exist in `BattleManager._resolve_battle` and `_capture_province`, but no current end-to-end execution completed: **UNVERIFIED**, system PARTIAL.
- Factory operation, income, production lines, research, supply updates/routes, war/peace/alliances, trade offers, events, save/load and AI decisions: no requested behavior was validated in the current revision. Each controlling manager is broken or its runner never reached it.
- Events have an additional proven contract mismatch: command grouping `historical_1879.json` effect types returned 36 effects, all unsupported by the `EventManager._apply_effect` match cases.

WORKING systems under the mandated definition: **0/11 audited systems**.
