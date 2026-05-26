# Scenario starting technology

Loaded when `ScenarioLoader.load_scenario()` runs. File name must match the scenario id (`1936.json`, `1918.json`, `2026.json`).

## Schema

| Field | Type | Description |
|-------|------|-------------|
| `scenario` | string | Scenario id (informational) |
| `defaults` | object | Applied to every country in the scenario, then merged with per-tag overrides |
| `countries` | object | Map of country tag → override object |

Per-country / defaults object:

| Field | Type | Description |
|-------|------|-------------|
| `completed` | string[] | Tech ids granted at start (prerequisites resolved automatically) |
| `research_slots` | int | Max concurrent research slots |
| `doctrine_xp` | int | Starting doctrine XP pool |
| `doctrine_keys_granted` | string[] | Doctrine keys without completing a tech (rare; prefer tech unlocks) |

Arrays in `countries` entries are **merged** with `defaults` (unique union). Scalar fields in `countries` override `defaults`.
