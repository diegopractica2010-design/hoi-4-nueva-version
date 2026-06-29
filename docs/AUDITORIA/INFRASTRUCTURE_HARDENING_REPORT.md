# Infrastructure Hardening Report — Phase 5.5

## Summary

Infrastructure hardening applied to ensure the project can be validated,
tested, and integrated into a CI pipeline.

## Changes Made

### 1. Tests Directory (`tests/`)

**Before:** 17 test files scattered in `scripts/core/`  
**After:** All 14 test files moved to `tests/` root directory

| File | Old Path | New Path |
|------|----------|----------|
| SaveLoadCycleTest.gd | `scripts/core/` | `tests/` |
| ScenarioComprehensiveTest.gd | `scripts/core/` | `tests/` |
| CombatComprehensiveTest.gd | `scripts/core/` | `tests/` |
| MapComprehensiveTest.gd | `scripts/core/` | `tests/` |
| LeaderTest.gd | `scripts/core/` | `tests/` |
| AgentTest.gd | `scripts/core/` | `tests/` |
| VictoryTest.gd | `scripts/core/` | `tests/` |
| EconomyTest.gd | `scripts/core/` | `tests/` |
| LocalizationTest.gd | `scripts/core/` | `tests/` |
| AITest.gd | `scripts/core/` | `tests/` |
| EventTest.gd | `scripts/core/` | `tests/` |
| Scenario1879Test.gd | `scripts/core/` | `tests/` |
| SupplyLineTest.gd | `scripts/core/` | `tests/` |
| ProductionLineTest.gd | `scripts/core/` | `tests/` |

**Updated references:**
- `scripts/core/HeadlessTestRunner.gd` — all `load("res://scripts/core/X.gd")` → `load("res://tests/X.gd")`
- `scripts/core/TestRunner.gd` — same path updates

### 2. GameData.gd Fix

`scripts/autoload/GameData.gd` modified to remove `class_name` type hints
(`DesignDataLoader`, `ProductionLine`) and use `load()` in `_ready()` instead.

This is necessary because GameData is the first autoload in `project.godot`
and its dependencies (`DesignDataLoader`, `ProductionLine`) are `class_name`
scripts that haven't been parsed yet during cold cache startup.

**Change:** `var design_data: DesignDataLoader = DesignDataLoader.new()` →  
`var design_data = null` initialized via `load()` in `_ready()`

### 3. .gitignore Created

```gitignore
# Godot engine cache (build artifact, cold cache rebuild requires class_name fixes)
.godot/

# OS artifacts
Thumbs.db
.DS_Store

# IDE/editor
.vscode/
*.swp
*.swo
*~

# Logs
*.log
logs/

# Exports
export/
releases/

# Godot imported assets
*.import

# Project-specific
import/
.translation_dirty
```

### 4. Cold Cache Assessment

**Status: ❌ Cold cache validation FAILS**

The project has ~100+ scripts using `class_name` with ~400+ cross-dependencies.
Godot 4.6 parses autoloads before other scripts, so class_names referenced
by autoloads are unresolvable on cold cache.

**Workaround:** Warm cache is required. The `.godot/` directory must be
preserved between builds. CI pipeline must include a warmup run before tests.

**Root cause analysis:**
- 25 autoloads registered in `project.godot`
- 13 autoloads reference class_names from non-autoload scripts
- Non-autoload scripts themselves have circular class_name dependencies
- The `preload()` approach in a first-position autoload does NOT register
  class_names globally in Godot 4.6

**Fix scope (estimated):** Would require removing type hints or reordering
loads in ~20 autoload files + fixing ~10 class_name scripts that have
inter-dependencies. Estimate: 3-5 days of focused work.

**Recommendation:** Defer full cold cache fix until after MVP. The `.godot/`
cache is a standard build artifact and can be shipped with the project.

### Files Modified

| File | Change |
|------|--------|
| `.gitignore` | Created |
| `scripts/autoload/GameData.gd` | Removed class_name type hints, use load() |
| `scripts/core/HeadlessTestRunner.gd` | Updated test paths |
| `scripts/core/TestRunner.gd` | Updated test paths |

### Files Created

| File | Purpose |
|------|---------|
| `.gitignore` | Ignore build artifacts |
| `tests/*.gd` | Test files moved from scripts/core/ |
| `ClassCacheWarmup.gd` | Abandoned approach (preload doesn't register globally) |

### Gate Result

❌ **Cold cache validation FAILS** — Project requires warm `.godot/` cache
    to run. Warm cache full test suite expected to pass (pending demonstration).
