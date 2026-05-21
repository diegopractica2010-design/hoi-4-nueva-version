# Leader Timeline & Mortality

## Timeline fields (JSON)

Each historical leader entry supports:

| Field | Purpose |
|-------|---------|
| `birth_year` | Age calculation and mortality brackets |
| `start_year` | First year the leader can appear in-game |
| `end_year` | Optional last year they remain in the roster (availability only — not a forced death date) |

Loading a scenario uses `start_date` from the scenario JSON (e.g. `1918-11-11` → year **1918**). Leaders with `start_year > current_year` are stored in **`leader_pool`** until `introduce_eligible_leaders_for_year()` or `advance_game_year()` runs.

## Mortality (probability chart)

Yearly rolls in `LeaderManager.check_leader_mortality()` — **no fixed historic death dates**.

### Base chances by age

| Age | Death / year | Retirement / year |
|-----|--------------|-------------------|
| &lt; 50 | 0.3% | 0.5% |
| 50–59 | 0.8% | 2.0% |
| 60–64 | 1.8% | 5.0% |
| 65–69 | 3.5% | 12.0% |
| 70–74 | 6.5% | 22.0% |
| 75–79 | 11.0% | 30.0% |
| 80+ | 18.0%+ | 35.0% |

Modifiers: `training` / `rear_area` duty, traits (`iron_will`, `reckless`, etc.), experience 800+, injury, `stayed_past_retirement`.

**Note:** Being assigned to combat does **not** increase yearly natural death. Combat risk is handled separately (below).

### Combat casualties (per battle)

| Situation | Chance |
|-----------|--------|
| Leader in combat, formation survives | **0.03%** death per battle (`COMBAT_DEATH_CHANCE_PER_BATTLE`) |
| Leader's formation destroyed | **~30%** death **or** capture (`FORMATION_DESTROYED_FATE_CHANCE`) |

Destroyed formation: ~45% of fate outcomes are death, remainder capture (tunable via `FORMATION_DESTROYED_DEATH_SHARE`).

```gdscript
CombatResolver.resolve_combat_experience(attacker_id, defender_id, 1.0)
CombatResolver.resolve_formation_destroyed(formation_id)
```

### Retirement flow

1. Retirement roll → leader added to `pending_retirements`, `leader_retirement_offered` signal.
2. `resolve_retirement(leader_id, let_retire, ask_to_stay)`:
   - **Retire** — leader removed with honors.
   - **Ask to stay** — ~55% chance they remain; `stayed_past_retirement` increases next year’s risk.

### API

```gdscript
LeaderManager.advance_game_year()  # year++, introduce pool, mortality check
LeaderManager.check_leader_mortality()
LeaderManager.resolve_retirement("ger_hindenburg", false, true)  # ask to stay
LeaderManager.set_current_year(1940)
LeaderManager.introduce_eligible_leaders_for_year(1940)
```

## Next phases

- Phase 3: UI for retirement offers and “Your country still needs you…”
- Phase 4: Officer Training Program position, replacement picker
- Phase 5: Trait mentoring for generated officers
