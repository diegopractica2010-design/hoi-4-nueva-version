# AUTOLOAD AUDIT — Phase 0

## Registered Singletons (25 total)

| # | Name | Script | class_name | Risk |
|---|------|--------|-----------|------|
| 1 | GameData | autoload/GameData.gd | No | LOW |
| 2 | FactoryManager | production/FactoryManager.gd | - | LOW |
| 3 | ProductionManager | autoload/ProductionManager.gd | - | LOW |
| 4 | SupplyManager | supply/SupplyManager.gd | - | LOW |
| 5 | LeaderManager | leaders/LeaderManager.gd | - | HIGH (3589 lines) |
| 6 | TimeManager | autoload/TimeManager.gd | No | MEDIUM |
| 7 | DesignManager | production/DesignManager.gd | - | LOW |
| 8 | LeaderEventUI | ui/LeaderEventUI.gd | - | LOW |
| 9 | AgentManager | agents/AgentManager.gd | No | MEDIUM |
| 10 | NationalModifierManager | national/NationalModifierManager.gd | - | LOW |
| 11 | NationalSpiritManager | national/NationalSpiritManager.gd | - | LOW |
| 12 | NationalIncomeManager | national/NationalIncomeManager.gd | - | LOW |
| 13 | TradeManager | national/TradeManager.gd | - | LOW |
| 14 | MapManager | map/MapManager.gd | No | MEDIUM |
| 15 | TechnologyManager | technology/TechnologyManager.gd | - | LOW |
| 16 | SaveLoadManager | autoload/SaveLoadManager.gd | - | LOW |
| 17 | VictoryConditions | core/VictoryConditions.gd | No | MEDIUM |
| 18 | EventManager | events/EventManager.gd | No | LOW |
| 19 | UnitMovementSystem | military/UnitMovementSystem.gd | No | LOW |
| 20 | BattleManager | military/BattleManager.gd | No | MEDIUM |
| 21 | AIManager | ai/AIManager.gd | No | MEDIUM |
| 22 | LocalizationSettings | localization/LocalizationSettings.gd | - | LOW |
| 23 | LanguageManager | localization/LanguageManager.gd | - | LOW |
| 24 | TranslationProvider | localization/TranslationProvider.gd | - | LOW |
| 25 | Localization | localization/Localization.gd | No (intentional) | LOW |

## DT-02 Affected Autoloads (no class_name)
AIManager, VictoryConditions, UnitMovementSystem, EventManager, TimeManager, MapManager, BattleManager

## Issues Found
- **HIGH:** Initialization order not documented in code — adding autoloads in wrong position causes silent failures
- **MEDIUM:** 7 autoloads must be accessed by singleton name only (Godot 4 restriction)
- **LOW:** No autoload has a formal `get_save_data()` / `apply_save_data()` contract documented
