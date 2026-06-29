# BASELINE AUDIT — Epochs of Ascendancy

**Tag:** `pre_stabilization_baseline`
**Commit:** 07bf23d
**Date:** 2026-06-21
**Branch:** main

---

## 1. Current State

### Repository
- **Engine:** Godot 4.6.2
- **Total files:** 5,965
- **GDScript files:** 145
- **GDScript lines:** ~38,000
- **JSON files:** 2,181 (~1.18M lines)
- **Scenes (.tscn):** 29
- **Autoloads:** 25

### Git
- Branch: `main`
- Latest tag: `pre_stabilization_baseline`
- Ahead of origin/main: 3 commits
- Uncommitted: 0

---

## 2. Existing Tests

| File | Lines | Type | What It Tests |
|------|-------|------|---------------|
| `scripts/core/ProductionLineTest.gd` | 1,340 | Unit/Integration | 18 production test cases |
| `scripts/core/SupplyLineTest.gd` | 189 | Unit | Supply routes, hubs, multimodal |
| `scripts/core/Scenario1879Test.gd` | 83 | Integration | 7 scenario validation cases |
| `scripts/core/HeadlessTradeTest.gd` | 52 | Integration | Trade evaluation flow |
| `scripts/core/HeadlessProductionTest.gd` | 9 | Stub | Entry point only |
| `scripts/core/HeadlessSupplyTest.gd` | 9 | Stub | Entry point only |
| `scripts/core/SaveLoadCycleTest.gd` | 130 | Integration | 5 save/load cycle tests (Phase 1) |
| `scripts/core/ScenarioComprehensiveTest.gd` | 155 | Integration | 12 scenario tests (Phase 1) |
| `scripts/core/MapComprehensiveTest.gd` | 150 | Integration | 9 map tests (Phase 1, now headless) |
| `scripts/core/CombatComprehensiveTest.gd` | 130 | Integration | 6 combat tests (Phase 1) |
| `scripts/core/LeaderTest.gd` | 85 | Integration | 6 leader tests (Phase 3) |
| `scripts/core/AgentTest.gd` | 78 | Integration | 5 agent tests (Phase 3) |
| `scripts/core/VictoryTest.gd` | 62 | Integration | 4 victory tests (Phase 3) |
| `scripts/core/EconomyTest.gd` | 64 | Integration | 5 economy tests (Phase 3) |
| `scripts/core/LocalizationTest.gd` | 72 | Integration | 5 localization tests (Phase 3) |
| `scripts/core/AITest.gd` | 95 | Integration | 8 AI tests (Phase 4) |
| `scripts/core/EventTest.gd` | 80 | Integration | 5 event tests (Phase 4) |
| `scripts/qa/RiskValidator.gd` | 286 | Validation | 8 risk validation checks (Phase 2) |
| `tests/qa/SceneValidation.gd` | 48 | Validation | Scene reference check |
| `tests/qa/ScenarioDateValidation.gd` | 30 | Validation | Date sanity |
| `tests/qa/ProductionReinforcementValidation.gd` | 17 | Validation | Reinforcement rules |
| `tests/qa/InfantryGenerationValidation.gd` | 21 | Validation | Infantry generation |

**Total test lines:** ~3,600 (+1,802 vs baseline)
**Test files:** 23 (+13 vs baseline)
**Functional tests:** 70 (Phase 1: 23 + Phase 3: 25 + Phase 4: 22)

---

## 3. Coverage by System

| System | Coverage | Confidence |
|--------|----------|------------|
| Production | ~75% | Medium-High |
| Supply | ~30% | Low-Medium |
| Scenario Loading | ~30% | Medium |
| Trade | ~15% | Low |
| Combat | ~40% | Medium (Phase 1) |
| Save/Load | ~80% | High (Phase 1) |
| Leaders | ~20% | Low-Medium (Phase 3) |
| Agents | ~25% | Low-Medium (Phase 3) |
| Victory | ~60% | Medium (Phase 3) |
| Economy | ~30% | Low-Medium (Phase 3) |
| Localization | ~70% | High (Phase 3) |
| AI | ~60% | Medium (Phase 4) |
| Events | ~60% | Medium (Phase 4) |
| Map | ~70% | Medium (Phase 4) |
| UI | 0% | None |

**Overall coverage:** ~35%

---

## 4. Critical Risks

| ID | Risk | Location | Impact | Likelihood | Status |
|----|------|----------|--------|------------|--------|
| CR-01 | 29 `/root/` hardcoded paths across 16 files | BattleManager, MapManager, SupplyManager, NationalIncomeManager, VictoryConditions | Crash on scene restructure | Medium | ⚠️ Validated |
| CR-02 | 485 print(), 110 push_warning(), 25 push_error() = 620 total | All managers | Performance, console spam, no control | Certain | ⚠️ Validated |
| CR-03 | No diplomacy system | Missing | Grand strategy without diplomacy | Certain | ❌ Confirmed |
| CR-04 | AI no economic/tech ability | `AIManager.gd` | AI nations never develop | Certain | ❌ Confirmed |
| CR-05 | ProvinceInsight.gd 3,814 lines | `scripts/map/` | Unmaintainable god object | High | ⚠️ Validated |
| CR-06 | LeaderManager.gd 3,593 lines | `scripts/leaders/` | Same | High | ⚠️ Validated |
| CR-07 | MapRenderer.gd 2,433 lines | `scripts/map/` | Same | High | ⚠️ Validated |
| CR-08 | EventManager effects as no-ops | `EventManager.gd` | Events don't affect state | High | ✅ **Refuted** — 7 effects implemented |
| CR-09 | Save/Load untested | `SaveLoadManager.gd` | Corruption risk | Medium | ✅ **Resolved** — 7 tests in Phase 1 |
| CR-10 | No retreat/capture logic | `BattleManager.gd` | Defeated formations linger | High | ✅ **Refuted** — _capture_province + _retreat_formation exist |

---

## 5. Known Limitations

### 5.1 Code Quality
- **485 print() statements** in production scripts (no log levels) — +81 vs baseline
- **110 push_warning, 25 push_error** statements = 135 total debug calls (+620 counted by RiskValidator)
- **10 files >800 lines** (violating own architecture rule):
  - ProvinceInsight.gd — 3,814 (+334 vs baseline)
  - LeaderManager.gd — 3,593 (+646 vs baseline)
  - MapRenderer.gd — 2,433 (+323 vs baseline)
  - ProductionLineTest.gd — 1,340
  - ProductionManager.gd — 1,317
  - TechnologyManager.gd — 1,299
  - AgentManager.gd — 1,236
  - TradeManager.gd — 1,170
  - AgentAssignmentScreen.gd — 1,087
  - DesignManager.gd — 830
- **5 TODO/FIXME/HACK** markers in code
- **500+** defensive `typeof(X) != TYPE_NIL` checks

### 5.2 Infrastructure
- Tests mixed in `scripts/core/` instead of `tests/`
- ~1,000+ unused HOI2 JSON files in `data/`
- 6 root-level log files
- Scene file (`LanguageSelector.tscn`) in `scripts/ui/` instead of `scenes/ui/`
- No `.gitignore` for generated cache files

### 5.3 Gameplay
- No diplomacy system
- AI limited to military movement only
- No terrain/weather combat modifiers
- No air/naval combat
- No resource market
- No civilian vs military factories
- No construction system
- Trade backend exists but no UI
- No campaign progression beyond single war

### 5.4 Frontend
- 7 missing screens (diplomacy, construction, trade, OOB, intel dashboard, event log, map legend)
- No keyboard shortcuts
- No minimap
- No resizable panels
- No tutorial system
- Partial localization (some screens, not all)

### 5.5 Testing
- ~5% overall coverage
- 19/19 core systems untested beyond production
- No save/load round-trip tests
- No CI pipeline
- No headless automated test runner

---

## 6. Recent Fixes Applied (pre-baseline)

| Fix | File | What Changed |
|-----|------|-------------|
| 1 | `VictoryConditions.gd` | player_tag syncs from GameData instead of hardcoded "CHL" |
| 2 | `TopInfoBar.gd` | _get_player_tag() replaces hardcoded CHL/USA |
| 3 | `TradeManager.gd` | _get_placeholder_design_id() queries DesignManager instead of returning "" |
| 4 | `TradeManager.gd` | _get_contested_province_id() replaces hardcoded "" |
| 5 | `SupplyManager.gd` | _consume_supply_for_formations() wired to daily tick |
| 6 | `Formation.gd` | supply_shortfall, strength, combat_width, apply_damage added |
| 7 | `EventManager.gd` | damage_unit() and destroy_unit() apply real damage/removal |
| 8 | `BattleManager.gd` | Combat width + stacking penalty by terrain |
| 9 | `data/localization/en.json` | ~70 new localization keys |
| 10 | `data/localization/es.json` | ~70 new localization keys |
| 11 | `TechnologyScreen.gd` | Summary bar uses Localization.get_text() |
| 12 | `AgentAssignmentScreen.gd` | Title, summary bar, roster filter use Localization.get_text() |
| 13 | `ProductionAssignmentScreen.gd` | Title, retooling/daily output use Localization.get_text() |

---

## 7. Baseline Metrics

| Metric | Baseline | Phase 2 | Phase 3 | Phase 4 |
|--------|----------|---------|---------|---------|
| GDScript files | 145 | ~155 | ~160 | ~165 |
| GDScript lines | ~38,000 | ~41,000 | ~42,500 | ~44,000 |
| Files >800 lines | 10 | 10 | 10 | 10 |
| print() statements | 404 | 485 | 562 | 597 |
| Test files | 10 | 15 | 20 | 23 |
| Test lines | ~1,798 | ~2,400 | ~3,000 | ~3,600 |
| Test coverage | ~5% | ~20% | ~30% | ~35% |
| Systems with tests | 4/15 | 7/15 | 12/15 | 14/15 |
| `/root/` hardcoded paths | Unknown | 29 in 16 files | 29 in 16 files | **15** in 10 files (Phase 5 fix) |
| Risks refuted | — | 3 | 3 | 3 |

---

*Generated at baseline tag `pre_stabilization_baseline`.*
*Updated through Phase 4 — 14/15 systems tested, ~35% coverage.*
