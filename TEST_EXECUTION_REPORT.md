# Test Execution Report

## Inventory

Path: `tests/`. Class/method: test scripts and their `run_all` methods. Command: regex count of `^static func _?test_`. Result: 24 test/validation GDScripts, 20 `*Test.gd` files, 131 declared test functions. Declaration is not execution.

## HeadlessTestRunner

Command: `Godot_v4.6-stable_win64_console.exe --headless --path . res://scenes/HeadlessTestRunner.tscn -- --qa-smoke`.

Path/class/method: `scripts/core/HeadlessTestRunner.gd`, `HeadlessTestRunner._ready`; `scripts/core/AutoloadValidator.gd`, `AutoloadValidator.validate_all`.

Result: exit 1. The runner executed 25 autoload-presence checks, found 8 missing, emitted `Autoload validation failed`, and returned before loading the scenario or invoking any test suite.

| Metric | Exact result |
|---|---:|
| Declared test cases available | 131 |
| Product test cases executed | 0 |
| Passed | 0 |
| Failed assertions | 0 |
| Crashed product tests | 0 |
| Skipped/not reached | 131 |
| Runner result | FAIL (startup gate) |

Condensed execution log:

```text
[FAIL] Autoload FactoryManager not found at /root/FactoryManager
[FAIL] Autoload ProductionManager not found at /root/ProductionManager
...
Autoload validation complete (25 checks)
ERROR: Autoload validation failed
HEADLESS_RUNNER_EXIT_CODE=1
```

## TestRunner

Command: `Godot_v4.6-stable_win64_console.exe --headless --path . res://scenes/TestScenario.tscn -- --qa-smoke`.

Path/class/method: `scripts/core/TestRunner.gd`, `TestRunner._ready/_run_production_line_tests`; `tests/ProductionLineTest.gd`, `ProductionLineTest.run_all`.

Result: exit 1. It entered the 20 production cases and then aborted at `QA_SMOKE: production characterization failed`; no later comprehensive suite ran.

| Metric | Exact result |
|---|---:|
| Production cases invoked | 20 |
| Passed | 2 |
| Explicit FAIL results | 7 |
| Runtime-error/crashed cases | 6 |
| Explicit SKIP results | 5 |
| Later declared cases not reached | 111 |
| Runner result | FAIL |

Condensed execution log:

```text
=== Production Line Tests ===
[FAIL] production report={ "days_advanced": 120.0, "units_completed": 0, ... }
[SKIP] ProductionManager autoload not available (headless CLI)
[PASS] equipment shortages (tracker only; no autoload)
[PASS] combat width (plains=10.0 effective=5.4)
Production line tests failed
ERROR: QA_SMOKE: production characterization failed
TEST_RUNNER_EXIT_CODE=1
```

Passed cases: equipment-shortage tracker and combat-width calculation. Explicit failures: production/tooling, new-design profile, refinement, refinement tradeoffs, cargo logistics, armed-cargo penalty and armed-merchant template. Runtime errors: data loading, retooling similarity, infantry stats, sustainment, leader manager and formation spawner. Skips were caused by unavailable autoloads.

## Combined actual execution

Across both required runner commands, unique product cases successfully validated: 2/131. Failed or crashed after invocation: 13. Explicitly skipped: 5. Never reached: 111. Both runners exit 1. This is a failed test gate, not a passing suite with a hang.
