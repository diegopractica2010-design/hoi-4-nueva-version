# Critical Blockers

Ranks: S = stops compile/run/release; A = major correctness/data/CI risk; B = significant quality/performance risk; C = localized debt.

| Rank | Blocker | Evidence (path, class/method, command/result) | Risk |
|---|---|---|---|
| S | Godot 4.6 `Logger` name collision and parser cascade | central managers; parse stage; project startup emits 51 script errors in 25 files | compile/startup/release |
| S | 12 autoload scripts do not instantiate | `project.godot`; startup `main.cpp` errors; headless validator fails | crash/null access |
| S | Both required runners fail | `HeadlessTestRunner._ready` and `TestRunner._ready`; exit 1/1 | CI/release gate |
| S | Main application is not a clean run | `StartMenu.tscn`; `Godot --headless --path . --quit-after 3` emits fatal script/autoload errors | playability/release |
| A | Production API mismatch | `AIEconomyManager._start_production_line` vs `ProductionManager.create_line`; 2 args vs max 1 | AI production impossible |
| A | Event schema completely mismatched | `historical_1879.json` vs `EventManager._check_trigger/_apply_effect`; 36/36 effect instances unsupported, relation trigger unsupported | silent content failure |
| A | Save/load omits five new managers | `SaveLoadManager._collect_save_data/_apply_save_data`; no diplomacy/trade/AI economy/advanced AI/combat expansion state | save corruption/state loss |
| A | CI cache warmup ignores failure | `.github/workflows/test.yml`; warm step uses `|| true`, current headless command exits 1 | misleading CI and blocked pipeline |
| B | Three broken literal load paths | QA/headless helper paths listed in repository report | test coverage holes |
| B | Cold imported texture failure observed | `WorldMap.tscn` / `assets/maps/world_map.png`; TestRunner log cannot open `.godot/imported/*.ctex` | cold-start/map load |
| B | Oversized and mutually coupled autoloads | 12 product scripts >800 lines; 26 mutual textual pairs | regression/performance/maintenance |
| C | Logging noise | 688 prints, 78 warnings, 142 errors | diagnostics/performance noise |

Performance conclusions beyond startup/cache risk are **UNVERIFIED**: no valid gameplay session ran long enough for profiling.
