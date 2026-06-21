# Architecture Notes — Epochs of Ascendancy

## DT-02: Autoloads Without `class_name`

Godot 4 emits *"Class X hides an autoload singleton"* and silently fails to load the autoload if a script declares `class_name` matching the autoload name. These files intentionally omit `class_name`. Access them only via the global singleton name. The defensive access pattern is: `if typeof(X) != TYPE_NIL:`

Affected autoloads:
- AIManager
- VictoryConditions
- UnitMovementSystem
- EventManager
- TimeManager
- MapManager
- BattleManager

## Autoload Initialization Order

The order in `project.godot` is the initialization order and must not be changed without reviewing all cross-autoload `@onready` and `_ready()` dependencies.

## File Size Limits

No single `.gd` file should exceed 800 lines. Current violations:
- ProvinceInsight.gd (3813 lines)
- LeaderManager.gd (3588 lines)
- MapRenderer.gd (2432 lines)

These are flagged for refactor in a future sprint. Do not add functionality to these files — add new files instead.

## Supported Scenarios

The only playable scenario is **1879** (Guerra del Pacifico). Data files for 1918, 1936 and 2026 exist for engine testing purposes only (see `ProductionLineTest.gd`). Do not add gameplay features for these years until 1879 is feature-complete. Do not add new scenario data files.
