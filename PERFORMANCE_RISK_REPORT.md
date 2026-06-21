# PERFORMANCE RISK REPORT — Phase 0

## Large File Risk
8 files exceed 800-line soft limit, 3 exceed 2000 lines:
| File | Lines | Risk |
|------|-------|------|
| ProvinceInsight.gd | 3,813 | CRITICAL — single-file monolith |
| LeaderManager.gd | 3,589 | CRITICAL — single-file monolith |
| MapRenderer.gd | 2,432 | CRITICAL — single-file monolith |
| ProductionManager.gd | 1,664 | HIGH |
| TechnologyManager.gd | 1,530 | HIGH |
| AgentManager.gd | 1,514 | HIGH |
| TradeManager.gd | 1,278 | HIGH |
| DesignManager.gd | 1,002 | HIGH |

## Autoload Initialization Cost
25 autoloads loaded at startup. Estimated parse + _ready() cost: significant.
Each autoload's `_ready()` performs defensive `typeof()` checks against all dependencies.

## Supply System Complexity
36 files in `scripts/supply/` — the largest subsystem. Risk of:
- O(N²) pathfinding in SupplyPathfinder
- Per-province depot state updates every tick
- Memory growth from route plan caching

## Map Rendering
MapRenderer.gd (2,432 lines) renders 847 provinces. Risk of:
- Per-frame province color updates
- Texture atlas management
- UI overlay compositing

## Save System
SaveLoadManager.gd (886 lines) serializes full game state. Risk:
- Large save files due to verbose Dictionary serialization
- No incremental/background save support

## Known Memory Concerns
- LeaderManager caches full leader roster in memory (all scenarios loaded)
- TradeManager holds all active offers in Dictionary
- ProvinceInsight caches per-province computed data
- AgentManager tracks network states per province

## Recommendations
1. Refactor ProvinceInsight.gd, LeaderManager.gd, MapRenderer.gd (critical)
2. Profile save/load with 100-turn game state
3. Monitor SupplyPathfinder for O(N²) behavior on large maps
4. Add frame timing instrumentation to all _process() and _physics_process() calls
