# Phase 5 — Global Data Integrity Audit

Date: 2026-06-23
Repository: `hoi-4-nueva-version`
Engine: `Godot 4.6.stable.official.89cea1439`

## Objective
Validate all JSON data files against their runtime loaders. Detect schema mismatches, orphaned references, and duplicate paths.

## Validation Method
All files parsed via `FileAccess.open` + `JSON.parse_string` and checked against loader class expectations. Cross-reference verified against runtime execution (autoload init + scenario load).

## Data Categories Audited

| # | Category | Files | Loader | Schema Match |
|---|----------|-------|--------|-------------|
| 1 | Countries | 9 files (`data/countries/*.json`) | `Country.gd`, `GameData.gd` | ✅ |
| 2 | Provinces | 8 files (`data/provinces/*.json`) | `Province.gd`, `MapDataValidator.gd` | ✅ |
| 3 | Technology Trees | 7 trees + `research_catalog.json` | `TechnologyManager.gd` | ✅ |
| 4 | Technology Starting | 4 files (`data/technology/starting/*.json`) | `TechnologyManager.gd` | ✅ |
| 5 | Leaders | `historical_leaders_1879.json`, `traits.json` | `LeaderManager.gd` | ✅ |
| 6 | Events | 7 files in `data/events/1879/` | `EventManager.gd` | ⚠️ (see below) |
| 7 | Scenarios | `1879/scenario.json`, `1918.json`, `1936.json` | `ScenarioLoader.gd` | ✅ |
| 8 | Formation Templates | `division_templates.json` | `DivisionTemplateLoader.gd` | ✅ |
| 9 | National Spirits | `spirit_definitions.json` | `NationalSpiritManager.gd` | ✅ |
| 10 | Supply Rules | `supply_rules.json` | `SupplyRules.gd` | ✅ |
| 11 | Production Rules | 5 files (`data/production/*.json`) | `ProductionManager.gd`, `FactoryManager.gd` | ✅ |
| 12 | Combat Rules | `combat_width_rules.json` | `CombatWidthCalculator.gd` | ✅ |
| 13 | Agent Missions | `mission_definitions.json` | `AgentManager.gd` | ✅ |
| 14 | Economy Rules | `resource_income_rules.json` | `NationalIncomeManager.gd` | ✅ |

## Schema Mismatches Found

### Event System — CRITICAL (rank-A)
| Issue | Detail | Count |
|-------|--------|-------|
| Unsupported effect `modifier` | `_apply_effect` has no `modifier` branch | 33 instances in `historical_1879.json` |
| Unsupported effect `diplomacy` | `_apply_effect` has no `diplomacy` branch | 1 instance in `historical_1879.json` |
| Unsupported effect `peace` | `_apply_effect` has no `peace` branch | 2 instances in `historical_1879.json` |
| Unsupported trigger `relation` | `_check_trigger` has no `relation` branch | 1 instance in `historical_1879.json` |
| Unchecked `conditions` field | `_check_trigger` ignores `conditions` dict | 2 events with `war_exists` conditions |
| **Total unsupported effect instances** | | **36/36 (100%)** |

### Non-Issues (false positives from validator)
- `provinces_base.json` root is `{"provinces": [...]}` not `[...]` — correct for `MapDataValidator`
- `research_catalog.json` root is `{id: {...}, ...}` not `[...]` — correct for `TechnologyManager`
- `traits.json` root is `{category: {...}, ...}` not `[...]` — correct for `LeaderManager`
- Individual event files in `1879/` are single event objects (not wrapped in `{"events": [...]}`) — both formats handled by `EventManager._load_event_file`
- `division_templates.json` root is `{"version": N, "divisions": [...]}` not `[...]` — correct for `DivisionTemplateLoader`

## Orphaned References Found
**None.** All country tags, province IDs, technology IDs, leader IDs, and template IDs referenced in 1879 scenario data resolve to valid definitions.

## Duplicates Resolved

| Path | Action |
|------|--------|
| `data/events/historical_1879.json` | **REMOVED** — exact duplicate (SHA256 identical) of `data/events/1879/historical_1879.json`. EventManager loads from `data/events/1879/` so the root copy was unused. |
| `data/scenarios/1879.json` | **LEFT IN PLACE** — 5-line legacy redirect to `data/scenarios/1879/scenario.json`. No loader reads it but removing it serves no purpose. |

## Files Fixed
- Removed `data/events/historical_1879.json`

## Validation Gate
- ✅ All 14 data categories parsed without errors
- ✅ No duplicate data path conflicts (resolved)
- ✅ Schema match confirmed for 13/14 categories (EventManager mismatch documented for Phase 6 fix)
- ✅ Zero orphaned references in 1879 scenario data
