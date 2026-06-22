# Scene Audit

## Commands and interpretation

- Path/class/method: `tests/qa/SceneValidation.gd`, `SceneValidation._run/_validate_scene`. Command: `Godot ... -s res://tests/qa/SceneValidation.gd -- --manifest=res://tests/qa/scene_manifest.txt`. Result: `PASS count=28`, exit 0, while the same log contains script compile errors and resource leaks.
- The four scenes omitted by the manifest (`AutoloadTest`, `HeadlessTestRunner`, `DiplomacyScreen`, `TradeScreen`) were run individually with `--scene=...`; all returned the validator's shallow PASS. `TradeScreen` simultaneously emitted a script parse failure.
- Static path command: extract every scene `ext_resource path` and run `Test-Path`. Result: 0 missing text paths across all 32 scenes.

The included validator proves only that `ResourceLoader` returned a `PackedScene` and `instantiate()` returned an object. It does not reject failed attached scripts, does not enter the tree, does not exercise `_ready`, does not verify signals and does not inspect required nodes. Its PASS is therefore not a functional PASS.

| Scene group/name | PackedScene loads/instantiates | Script/runtime status | Final status/errors |
|---|---|---|---|
| `StartMenu.tscn` (main scene) | YES | project startup emits 51 script errors | BROKEN as application entry |
| `MainMenu.tscn` | YES | `MainMenu.gd` `Logger` collision observed during manifest run | BROKEN |
| `DiplomacyScreen.tscn` | YES | manager autoload fails; functional methods not executed | BROKEN |
| `TradeScreen.tscn` | YES | `TradeScreen.gd` has 9 parser errors | BROKEN |
| `TestScenario.tscn` | YES | `TestRunner.gd` dependency compilation fails; world-map texture import missing during run | BROKEN |
| `HeadlessTestRunner.tscn` | YES | starts, but aborts at autoload validation, exit 1 | BROKEN |
| `WorldMap.tscn` | shallow YES | `MapRenderer.gd` Logger collision; one run could not open imported `world_map.png` texture | BROKEN |
| `TopInfoBar.tscn` | YES | `TopInfoBar.gd` Logger collision | BROKEN |
| `DesignPickerPopup.tscn` / `RetoolingWarningPopup.tscn` | YES | dependent `RetoolingSimilarityTable.gd` inference error | BROKEN |
| Remaining 22 UI/test scenes | YES | no per-scene `_ready`/signal/node behavioral validation was completed because startup is broken | PARTIAL / UNVERIFIED behavior |

Counts: 32/32 have existing text scene files and shallow PackedScene instantiation evidence; 0/32 meet the five-level VALIDATED definition. Required-node and signal correctness for the remaining scenes is **UNVERIFIED**.
