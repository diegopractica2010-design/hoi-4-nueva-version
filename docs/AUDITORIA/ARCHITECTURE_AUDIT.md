# Architecture Audit

## Exact static measurements

Command scope: `scripts/`, `tests/`, `addons/`, GDScript only. Class/method: N/A static scan.

| Metric | Count | Command/result definition |
|---|---:|---|
| Scripts over 800 lines | 13 | line count; includes one test |
| Product scripts over 800 lines | 12 | same count excluding `tests/ProductionLineTest.gd` |
| `/root/` reference lines | 25 | `rg -n --glob '*.gd' '/root/'` |
| `print()` call-site lines | 688 | regex `\bprint\s*\(` |
| `push_warning()` call-site lines | 78 | regex scan |
| `push_error()` call-site lines | 142 | regex scan |
| Literal `load/preload` edges | 155 | extracted `res://*.gd` references |
| Literal load cycles | 0 | DFS over those 155 edges |
| Mutual autoload textual-reference pairs | 26 | manager-name cross-reference matrix |

God objects: `ProvinceInsight.gd` 3,813; `LeaderManager.gd` 3,594; `MapRenderer.gd` 2,434; `ProductionManager.gd` 1,672; `TechnologyManager.gd` 1,532; `AgentManager.gd` 1,521; `TradeManager.gd` 1,291; `AgentAssignmentScreen.gd` 1,290; `DesignManager.gd` 1,002; `SaveLoadManager.gd` 888; `MapManager.gd` 826; `DesignPickerPopup.gd` 812. Test outlier: `ProductionLineTest.gd` 1,497.

## Dependency interpretation

No literal `load/preload` cycle was found. Runtime circular dependency: **UNVERIFIED**. However, 26 mutual textual pairs are proven, including `GameData <-> ProductionManager`, `FactoryManager <-> ProductionManager`, `DesignManager <-> ProductionManager`, `LeaderManager <-> TimeManager`, and several `SaveLoadManager` pairs. This makes autoload ordering and cold initialization high-risk.

## Debt severity

- **Critical:** logging identifier migration collides with Godot 4.6 native `Logger`, breaking central managers; 12 autoload scripts fail to instantiate. Evidence: project startup command and affected paths/method parse stage.
- **High:** 12 product God objects; 26 mutual autoload-reference pairs; save/load omits five new managers; event data/handler contract mismatch.
- **Medium:** 25 hard `/root/` references; 688 direct print call sites; test runner aggregates cases without machine-readable per-case accounting.
- **Low:** 78 warning and 142 error call sites create noisy startup/test output, but the calls themselves are not defects.

Maintainability conclusion: high coupling and oversized managers materially amplify the current compilation regression.
