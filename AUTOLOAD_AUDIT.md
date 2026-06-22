# Autoload Audit

Command: `Godot_v4.6-stable_win64_console.exe --headless --path . res://scenes/HeadlessTestRunner.tscn -- --qa-smoke`. Path: `project.godot`, `scripts/core/HeadlessTestRunner.gd`; class/method: `HeadlessTestRunner._ready`, `AutoloadValidator.validate_all`. Result: 25 checks, 8 reported missing, validation failed, process exit 1. The validator omits four configured autoloads, so startup output was also examined directly.

Scale: a component is WORKING only when EXISTS, COMPILES, LOADS, EXECUTES and VALIDATED all pass.

| Autoload | Exists | Compiles | Loads/initializes | Executes/validated | Classification | Evidence |
|---|---|---|---|---|---|---|
| GameData | YES | NO | placeholder node; `_ready` errors | NO/NO | BROKEN | `GameData._ready`: nonexistent `new` on failed GDScript |
| FactoryManager | YES | NO | NO | NO/NO | BROKEN | failed autoload instantiation |
| ProductionManager | YES | NO | NO | NO/NO | BROKEN | parser errors; failed instantiation |
| SupplyManager | YES | NO (dependency) | validator sees node, script load fails | NO/NO | BROKEN | `SupplyManager.gd` compilation failed |
| LeaderManager | YES | NO | NO | NO/NO | BROKEN | failed instantiation |
| TimeManager | YES | NO | NO | NO/NO | BROKEN | failed instantiation |
| DesignManager | YES | NO (dependency) | validator sees node | NO/NO | BROKEN | `DesignManager.gd` dependency compilation failed |
| DiplomacyManager | YES | NO | NO | NO/NO | BROKEN | seven `Logger.info` parser errors |
| LeaderEventUI | YES | UNVERIFIED | YES by validator | NO/NO | PARTIAL | node found; no behavior test reached |
| AgentManager | YES | NO | NO | NO/NO | BROKEN | failed instantiation |
| NationalModifierManager | YES | NO (dependency) | validator sees node | NO/NO | BROKEN | dependency compile error |
| NationalSpiritManager | YES | NO (dependency) | validator sees node | NO/NO | BROKEN | dependency compile error |
| NationalIncomeManager | YES | NO (dependency) | validator sees node | NO/NO | BROKEN | script load failed |
| TradeManager | YES | UNVERIFIED project-wide | YES by validator | NO/NO | PARTIAL | node found; trade suite never reached |
| MapManager | YES | NO (dependency) | validator sees node | NO/NO | BROKEN | dependency compile error |
| TechnologyManager | YES | NO | NO | NO/NO | BROKEN | failed instantiation |
| SaveLoadManager | YES | NO | NO | NO/NO | BROKEN | failed instantiation |
| VictoryConditions | YES | UNVERIFIED | YES by validator | NO/NO | PARTIAL | node found; suite never reached |
| EventManager | YES | NO | NO | NO/NO | BROKEN | failed instantiation |
| CombatExpansionManager | YES | NO | NO | NO/NO | BROKEN | failed instantiation; omitted by validator |
| UnitMovementSystem | YES | UNVERIFIED | YES by validator | NO/NO | PARTIAL | node found; no current execution validation |
| BattleManager | YES | UNVERIFIED | YES by validator | NO/NO | PARTIAL | node found; combat suite never reached |
| AIManager | YES | UNVERIFIED | YES by validator | NO/NO | PARTIAL | node found; AI suite never reached |
| AIEconomyManager | YES | NO | NO | NO/NO | BROKEN | failed instantiation; omitted by validator |
| AdvancedAIManager | YES | NO | NO | NO/NO | BROKEN | failed instantiation; omitted by validator |
| LocalizationSettings | YES | UNVERIFIED | YES by validator | NO/NO | PARTIAL | node found; suite never reached |
| LanguageManager | YES | UNVERIFIED | YES by validator | NO/NO | PARTIAL | node found; suite never reached |
| TranslationProvider | YES | UNVERIFIED | YES by validator | NO/NO | PARTIAL | node found; suite never reached |
| Localization | YES | UNVERIFIED | YES by validator | NO/NO | PARTIAL | node found; suite never reached |

WORKING: 0. PARTIAL: 10. BROKEN: 19.

## Dependency risks

Command: textual cross-reference matrix across all 29 autoload scripts. Class/method: N/A static dependency scan. Result: 26 mutual-reference pairs, including `GameData <-> ProductionManager`, `FactoryManager <-> ProductionManager`, `DesignManager <-> ProductionManager`, `LeaderManager <-> TimeManager`, and `SaveLoadManager` mutually referencing seven managers. These are cold-start/initialization risks, not proof of runtime recursion. Literal `load/preload` graph: 155 edges, 0 literal cycles.

Cold-cache claim: current cold editor scan fails, and a subsequent warm run also fails. Therefore cache warming does not validate the current revision.
