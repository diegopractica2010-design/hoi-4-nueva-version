# Phase 6 — Event System Recovery

## Objective
Add the 3 missing effect types (modifier, diplomacy, peace) and 1 missing trigger type (relation) to EventManager, wire Events→Diplomacy and Events→Economy integration, and validate end-to-end execution of the 1879 historical events.

## Changes

### EventManager.gd (`scripts/events/EventManager.gd`)
- **New effect `modifier`**: applies arbitrary key/value/duration modifiers via `NationalModifierManager.apply_national_effect()` — enables 33 modifier instances (war_support, tariff_income, guerrilla_fighter, etc.)
- **New effect `diplomacy`**: dispatches `form_alliance`, `declare_war`, `sign_peace` actions via `DiplomacyManager` — enables the `"diplomatic_offer"` event
- **New effect `peace`**: calls `DiplomacyManager.sign_peace(from, to, winner)` + LeaderManager cleanup — enables 2 peace effects (Tratado de Ancón, Armisticio Boliviano)
- **New trigger `relation`**: checks `DiplomacyManager.get_relation(from, to)` with configurable comparison (>=, <=, >, <, ==, !=) — enables the `"bol_alliance_offer"` event
- **New conditions check** (`_check_conditions`): evaluates `conditions.war_exists`, `conditions.owner`, `conditions.peace` before firing events
- **Wired `declare_war`** effect → calls `DiplomacyManager.declare_war(attacker, defender)` in addition to LeaderManager.set_country_at_war
- **Wired `force_peace`** effect → calls `DiplomacyManager.sign_peace(attacker, defender, attacker)` in addition to LeaderManager.set_country_at_war(false)

### DiplomacyManager.gd (`scripts/diplomacy/DiplomacyManager.gd`)
- **New method `is_nation_at_war(tag)`**: iterates `wars` dictionary to check if a given tag participates in any war — used by `_check_conditions` for `conditions.peace`

### EventTest.gd (`tests/EventTest.gd`)
- Updated expected effect list from 7 → 10 types (added modifier, diplomacy, peace)

## Validation Results
```
✅ QA_SMOKE: all tests passed
```
- Event Tests: `[PASS] all 10 effect types implemented`
- Diplomacy Tests: all pass (wars, peace, alliances, guarantees)
- All other suites: PASS (21 suites, ~180 checks)

## Unsupported Effects After This Phase
- **0 remaining** — all 36 effect instances (33×modifier, 1×diplomacy, 2×peace) now have handler branches

## Unsupported Triggers After This Phase
- **0 remaining** — all trigger types (including `relation`) now handled

## Next Phase
Phase 7 — Save/Load System Recovery (5 disconnected managers)
