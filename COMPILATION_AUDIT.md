# Compilation Audit

## Result: FAIL

Command: `Godot_v4.6-stable_win64_console.exe --headless --path . --editor --quit`. Path: repository root/project configuration. Class/method: Godot project scan and autoload creation. Result: parser/compile errors; the project does not pass compilation.

A second command, `Godot_v4.6-stable_win64_console.exe --headless --path . --quit-after 1`, produced 51 `SCRIPT ERROR` lines at 50 unique reload locations across 25 script files and 12 failed autoload instantiations. Exit code was 0 only because `--quit-after` forces a timed clean exit; the emitted errors make the run a failure.

## Proven issue groups

| Path | Class / method | Observed issue | Evidence result |
|---|---|---|---|
| `scripts/autoload/ProductionManager.gd` | `ProductionManager`, parse / methods around lines 514, 695, 873, 970, 1019, 1022, 1475 | `Logger` shadows native class; seven uninferable locals | failed load and autoload |
| `scripts/core/DesignDataLoader.gd` | `DesignDataLoader`, parse | `Logger` shadows native class | breaks `ProductionLine` and `GameData` dependencies |
| `scripts/production/FactoryManager.gd` | `FactoryManager`, parse | `Logger` shadows native class | autoload not instantiated |
| `scripts/leaders/LeaderManager.gd` | `LeaderManager`, parse | `Logger` shadows native class | autoload not instantiated |
| `scripts/autoload/TimeManager.gd` | `TimeManager`, parse | `Logger` shadows native class | autoload not instantiated |
| `scripts/technology/TechnologyManager.gd` | `TechnologyManager`, parse | `Logger` shadows native class | autoload not instantiated |
| `scripts/core/ScenarioLoader.gd` | `ScenarioLoader`, parse | `Logger` shadows native class | scene runner dependency fails |
| `scripts/agents/AgentManager.gd` | `AgentManager`, parse | `Logger` shadows native class | autoload not instantiated |
| `scripts/autoload/SaveLoadManager.gd` | `SaveLoadManager`, parse | `Logger` shadows native class | autoload not instantiated |
| `scripts/events/EventManager.gd` | `EventManager`, parse | `Logger` shadows native class | autoload not instantiated |
| `scripts/military/CombatExpansionManager.gd` | `CombatExpansionManager`, parse | `Logger` collision plus three Variant inference warnings treated as errors | autoload not instantiated |
| `scripts/ai/AIEconomyManager.gd` | `AIEconomyManager`, `_start_production_line` and parse | `Logger` collision, inference errors, and `create_line()` called with 2 args where at most 1 is accepted | autoload not instantiated |
| `scripts/ai/AdvancedAIManager.gd` | `AdvancedAIManager`, parse | `Logger` collision and Variant inference warning treated as error | autoload not instantiated |
| `scripts/diplomacy/DiplomacyManager.gd` | `DiplomacyManager`, `_ready`, `declare_war`, `sign_peace`, alliance/guarantee methods | `Logger.info()` resolves to native `Logger`, where static `info()` does not exist | autoload not instantiated |
| `scripts/production/ProductionNavalRules.gd` | unnamed, line 85 | cannot infer `template` | dependent `DesignManager` fails |
| `scripts/ui/TradeScreen.gd` | `TradeScreen`, offer list/create methods | undeclared `TradeStatus`, `TradeItemType`, `TradeVisibility`; one uninferable local; four Variant warnings treated as errors | `--check-only` exit 1 |

Dependent compile failures were also emitted for `GameData.gd`, `ProductionLine.gd`, `AttritionReplenishmentLedger.gd`, `NationalModifierManager.gd`, `NationalSpiritManager.gd`, `ProvinceEffects.gd`, `MapManager.gd`, `SupplyManager.gd`, `DesignManager.gd`, and `NationalIncomeManager.gd`.

## Reference and resource checks

Command: literal `res://` extraction plus `Test-Path` over 175 references. Class/method: N/A static scan. Result: three missing paths, listed in `REPOSITORY_REALITY_REPORT.md`. Command: JSON parse of all data. Result: 0/2,183 malformed JSON.

No invalid inheritance was conclusively isolated independently of the parser cascade: **UNVERIFIED**. Godot messages saying a failed script “does not inherit from Node” occur after compilation failure and are not treated as proof of declared inheritance errors.

Final compilation gate: **FAIL**.
