# Repository Reality Report

Audit date: 2026-06-21. Scope: repository containing `project.godot`. Generated reports and old logs were treated only as clues.

## Evidence protocol

Each finding cites an evidence ID. The ID supplies path, class/method, command and observed result.

- **E-INV** — Path: repository root. Class/method: N/A (filesystem scan). Command: `Get-ChildItem -Recurse -Force -File` excluding `.git/` and `.godot/`, plus `git ls-files`. Result: 4,984 physical files at audit start; 4,201 tracked files.
- **E-TYPES** — Path: repository root. Class/method: N/A. Command: extension counts over the same scope. Result: 172 `.gd`, 32 `.tscn`, 0 `.tres/.res`, 2,183 `.json`, 29 autoload declarations, 24 test/validation GDScripts.
- **E-JSON** — Path: all 2,183 JSON files. Class/method: N/A. Command: PowerShell `ConvertFrom-Json` on every file. Result: 2,183 parsed; 0 invalid.
- **E-REF** — Paths: `scripts/`, `tests/`, `addons/`. Class/method: N/A (literal reference scan). Command: regex extraction of literal `load`, `preload`, and scene `path="res://..."`, followed by `Test-Path`. Result: 175 references checked; 3 missing.
- **E-DUP** — Paths: all GDScripts. Class/method: N/A. Command: group files by basename and `class_name`. Result: no duplicate `.gd` basenames and no duplicate `class_name` declarations.

## Exact inventory

| Category | Physical at audit start | Tracked | Evidence |
|---|---:|---:|---|
| Total files | 4,984 | 4,201 | E-INV |
| GDScript | 172 | 172 | E-TYPES |
| Scenes | 32 | 32 | E-TYPES |
| Godot resources (`.tres/.res`) | 0 | 0 | E-TYPES |
| JSON | 2,183 | 2,183 | E-TYPES, E-JSON |
| Autoloads | 29 | 29 declarations in `project.godot` | E-TYPES |
| Test/validation scripts | 24 | 24 | E-TYPES |
| Named `*Test.gd` files | 20 | 20 | `Get-ChildItem tests -Recurse -Filter '*Test.gd'` -> 20 |
| Declared test functions | 131 | 131 | regex `^static func _?test_` over `tests/**/*.gd` |

The physical total intentionally excludes VCS internals and Godot cache. It includes ignored source-adjacent `.uid` files already present before the audit. The twelve requested reports change the post-audit total and are not folded into the baseline.

## Systems present

The following system entry points physically exist: combat, economy, production, technology, supply, diplomacy, trade, events, save/load, AI economy and advanced AI. Evidence: paths in `project.godot`; class/method: each configured autoload and `_ready`; command: `Get-Content project.godot`; result: 29 declarations. This is **EXISTS** evidence only, not functionality evidence.

“New systems” relative to an earlier baseline: **UNVERIFIED**. There is no trusted baseline in the task. “Missing requested systems”: none are absent by filename, but operational availability is addressed in `SYSTEM_REALITY_REPORT.md`.

## Duplicates and broken references

- Duplicate GDScript basenames/classes: none detected (E-DUP). Semantic duplication: **UNVERIFIED** because behavior-equivalence was not established.
- `scripts/core/HeadlessSupplyTest.gd`, class `HeadlessSupplyTest`, method `_ready`: loads missing `res://scripts/core/SupplyLineTest.gd` (E-REF).
- `tests/qa/InfantryGenerationValidation.gd`, class unnamed, method `_run`: loads missing `res://scripts/core/ProductionLineTest.gd` (E-REF).
- `tests/qa/ProductionReinforcementValidation.gd`, class unnamed, method `_run`: loads the same missing path (E-REF).

Verdict: repository inventory is internally large and JSON-syntactically clean, but it contains three proven broken literal references. Functional status cannot be inferred from the counts.
