# Baseline Report

Date: 2026-06-21
Repository: `hoi-4-nueva-version`
Engine: `Godot 4.6.stable.official.89cea1439`
Audited commit baseline: `465cbf43744a326f2f4b8e7c5be5d7d71523ed6c`

## Objective

Establish the current executable reality before starting recovery work, using the forensic audit as the source of truth and refreshing the critical startup gates with direct execution evidence.

## Files Modified

- `BASELINE_REPORT.md`

## Dependency Graph

Current startup dependency surface is anchored by 29 autoloads declared in `project.godot`.

High-risk dependency clusters confirmed by the forensic audit and still relevant to the current baseline:

- `GameData <-> ProductionManager`
- `FactoryManager <-> ProductionManager`
- `DesignManager <-> ProductionManager`
- `LeaderManager <-> TimeManager`
- `SaveLoadManager` mutually references multiple managers

Known graph metrics from the forensic audit used as baseline truth:

- 155 literal `load`/`preload` edges
- 26 mutual textual autoload reference pairs
- 0 literal load-cycle proofs

## Validation Commands

```powershell
& "C:\Users\Diego y Pauli\Desktop\proyecto\godot\Godot_v4.6-stable_win64_console.exe" --headless --path "C:\Users\Diego y Pauli\Desktop\proyecto\hoi4 diferente\hoi-4-nueva-version" --editor --quit
```

```powershell
& "C:\Users\Diego y Pauli\Desktop\proyecto\godot\Godot_v4.6-stable_win64_console.exe" --headless --path "C:\Users\Diego y Pauli\Desktop\proyecto\hoi4 diferente\hoi-4-nueva-version" res://scenes/HeadlessTestRunner.tscn -- --qa-smoke
```

```powershell
& "C:\Users\Diego y Pauli\Desktop\proyecto\godot\Godot_v4.6-stable_win64_console.exe" --headless --path "C:\Users\Diego y Pauli\Desktop\proyecto\hoi4 diferente\hoi-4-nueva-version" res://scenes/TestScenario.tscn -- --qa-smoke
```

## Results

### Compilation baseline

Status: `FAIL`

The editor headless scan still reproduces the same blocking compilation issues documented by the forensic audit. The dominant current failure families are:

- local `Logger` identifiers shadowing Godot 4.6 native `Logger`
- strict type inference failures
- Variant inference warnings treated as errors
- invalid API usage in AI economy code
- dependent script compilation cascades

Representative hard failures reproduced directly:

- `scripts/autoload/ProductionManager.gd`
- `scripts/core/DesignDataLoader.gd`
- `scripts/production/FactoryManager.gd`
- `scripts/diplomacy/DiplomacyManager.gd`
- `scripts/ai/AIEconomyManager.gd`
- `scripts/ai/AdvancedAIManager.gd`
- `scripts/military/CombatExpansionManager.gd`

### Autoload baseline

Status: `FAIL`

The project still declares 29 autoloads in `project.godot`, but startup is not healthy.

The headless autoload validation run still reports only 25 checks and fails before continuing. Missing at runtime in the refreshed execution:

- `FactoryManager`
- `ProductionManager`
- `LeaderManager`
- `TimeManager`
- `AgentManager`
- `TechnologyManager`
- `SaveLoadManager`
- `EventManager`

The forensic audit remains the trusted broader baseline for full autoload state:

- 0 working
- 10 partial
- 19 broken

### Test baseline

`HeadlessTestRunner` status: `FAIL`, exit code `1`

- aborts during autoload validation
- product test cases executed: `0`

`TestRunner` status: `FAIL`, exit code `1`

- enters the production characterization path
- reproduces dependency failures from missing/broken autoloads
- still only validates `2/131` declared test cases according to the forensic baseline

### Repository baseline anchor

The current `HEAD` still matches the forensic audit commit:

- `465cbf43744a326f2f4b8e7c5be5d7d71523ed6c`

This means the recovery starts from the same revision already audited, with no evidence that the code state has materially improved since that audit.

## Remaining Blockers

- Compilation gate is red, so every downstream phase is currently contaminated by parser and dependency failures.
- At least 8 autoloads are still absent at runtime in the direct baseline run.
- Both test entry points still fail before any meaningful full-suite validation can occur.
- The autoload validator itself only checks 25 of 29 configured autoloads, so later recovery phases must validate all 29 explicitly.

## Phase Decision

Phase 0 validation passed because the repository state is now documented with direct execution evidence.

Recovery may proceed to Phase 1: compilation recovery.
