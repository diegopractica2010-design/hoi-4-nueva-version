# REPOSITORY AUDIT — Phase 0

## Overview
- **Engine:** Godot 4.6
- **Language:** GDScript
- **Main scene:** `scenes/ui/StartMenu.tscn`
- **Test scene:** `scenes/TestScenario.tscn`
- **Total .gd files:** ~275
- **Total .tscn files:** 28
- **Total data files:** 3,679
- **Autoload singletons:** 25

## Directory Structure (scripts/)
| Directory    | Files | Purpose |
|-------------|-------|---------|
| agents/     | 10    | Agent system, networks, missions |
| ai/         | 2     | AI manager + war state |
| autoload/   | 8     | Core singletons (GameData, Production, Save, Time) |
| combat/     | 4     | Combat resolver, width calculator |
| core/       | 26    | Scenario loading, tests, victory conditions |
| data/       | 12    | Data models (Province, Country, UnitTemplate, etc.) |
| events/     | 2     | EventManager |
| formations/ | 4     | Formation, FormationSpawner |
| leaders/    | 6     | Leader, LeaderManager, LeaderGenerator |
| localization/ | 8   | Localization system (4 singletons) |
| map/        | 34    | Map rendering, province visuals, factories |
| military/   | 4     | BattleManager, UnitMovementSystem |
| national/   | 10    | Modifiers, spirits, income, trade |
| production/ | 30    | Lines, factories, designs, calculators |
| scenarios/  | 2     | Scenario factory spawner |
| supply/     | 36    | Supply network, routes, depots, attrition |
| technology/ | 4     | Tech tree, unlocks |
| ui/         | 63    | All UI screens, popups, HUD |
| ui_data/    | 10    | Screen data models |

## Large Files (>800 lines — refactor targets)
1. **ProvinceInsight.gd** — 3813 lines (map/)
2. **LeaderManager.gd** — 3589 lines (leaders/)
3. **MapRenderer.gd** — 2432 lines (map/)
4. **ProductionManager.gd** — 1664 lines (autoload/)
5. **TechnologyManager.gd** — 1530 lines (technology/)
6. **AgentManager.gd** — 1514 lines (agents/)
7. **TradeManager.gd** — 1278 lines (national/)
8. **DesignManager.gd** — 1002 lines (production/)

## Identified Risks
- **HIGH:** 8 files exceed 800-line limit (architecture debt)
- **HIGH:** 25 autoloads with implicit initialization order dependency
- **MEDIUM:** 7 autoloads without `class_name` (access must use singleton name)
- **MEDIUM:** 3,679 data files may contain orphaned/legacy data
- **LOW:** Localization keys partially applied (SettingsPopup still hardcoded)
