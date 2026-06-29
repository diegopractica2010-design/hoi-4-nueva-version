# Phase 3 Scene Recovery

Date: 2026-06-21
Repository: `hoi-4-nueva-version`
Engine: `Godot 4.6.stable.official.89cea1439`

## Objective

Validate that the project scene surface can be loaded headlessly without parser failures, startup aborts, or scene-instantiation hangs.

## Files Modified

- `scripts/core/HeadlessTestRunner.gd`
- `scripts/core/TestRunner.gd`
- `scripts/technology/TechnologyManager.gd`
- `scripts/ui/DesignPickerPopup.gd`
- `scripts/ui/LeaderDetailScreen.gd`
- `scripts/ui/LeaderReplacementPickerPopup.gd`
- `scripts/ui/MissionPickerPopup.gd`
- `scripts/ui/RetirementOfferPopup.gd`
- `scripts/ui/TradeScreen.gd`
- `scripts/ui/TrainingPathScreen.gd`
- `scripts/ui/TutorialPopup.gd`
- `tests/qa/SceneValidation.gd`
- `tests/qa/scene_manifest.txt`
- `PHASE_3_SCENES.md`

## Validation Commands

```powershell
& "C:\Users\Diego y Pauli\Desktop\proyecto\godot\Godot_v4.6-stable_win64_console.exe" --headless --path "C:\Users\Diego y Pauli\Desktop\proyecto\hoi4 diferente\hoi-4-nueva-version" --editor --quit
```

```powershell
& "C:\Users\Diego y Pauli\Desktop\proyecto\godot\Godot_v4.6-stable_win64_console.exe" --headless --path "C:\Users\Diego y Pauli\Desktop\proyecto\hoi4 diferente\hoi-4-nueva-version" -s res://tests/qa/SceneValidation.gd -- --manifest=res://tests/qa/scene_manifest.txt --scene-validation
```

```powershell
& "C:\Users\Diego y Pauli\Desktop\proyecto\godot\Godot_v4.6-stable_win64_console.exe" --headless --path "C:\Users\Diego y Pauli\Desktop\proyecto\hoi4 diferente\hoi-4-nueva-version" res://scenes/AutoloadTest.tscn
```

```powershell
& "C:\Users\Diego y Pauli\Desktop\proyecto\godot\Godot_v4.6-stable_win64_console.exe" --headless --path "C:\Users\Diego y Pauli\Desktop\proyecto\hoi4 diferente\hoi-4-nueva-version" res://scenes/HeadlessTestRunner.tscn --scene-validation --quit-after 1
```

```powershell
& "C:\Users\Diego y Pauli\Desktop\proyecto\godot\Godot_v4.6-stable_win64_console.exe" --headless --path "C:\Users\Diego y Pauli\Desktop\proyecto\hoi4 diferente\hoi-4-nueva-version" res://scenes/TestScenario.tscn --scene-validation --quit-after 1
```

## Results

Status: `PASS`

Recovered scene failure families:

- UI scenes that destroyed themselves during `_ready()` when opened without runtime context now render a safe placeholder state instead of exiting the tree
- `TechnologyManager` no longer recurses between `get_node_status()` and `can_research()`
- `TradeScreen.gd` now uses the correct `TradeManager` enums and explicit typing required by strict parsing
- `TutorialPopup` no longer frees itself on startup merely because the tutorial marker already exists
- scene validation now covers the intended 29 regular scenes from a manifest and traces progress per scene
- `Window`-rooted popup scenes are validated safely in headless mode by load/instantiate instead of blocking on native window attachment
- both test harness scenes now support `--scene-validation` so they can be checked without entering gameplay test flows

Validated runtime result:

- `29/29` regular manifest scenes passed scene validation
- `AutoloadTest.tscn` passed
- `HeadlessTestRunner.tscn --scene-validation` passed
- `TestScenario.tscn --scene-validation` passed
- compilation gate `--headless --editor --quit` passed

## Remaining Notes

- `TestScenario.tscn` still emits invalid UID fallback warnings for ext_resource references, but the scene loads and exits with code `0`
- the scene-validation pass still reports resource/object leak warnings at engine shutdown; these warnings did not block the phase gate and require a deeper lifetime cleanup pass if they are to become a hard requirement

## Phase Decision

Phase 3 validation passed.

Recovery may proceed beyond the startup/scene gates.
