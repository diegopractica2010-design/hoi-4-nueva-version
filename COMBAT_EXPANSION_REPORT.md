# Combat Expansion Report — Phase 9

## Summary

Added terrain modifiers, weather system, entrenchment mechanics, and reinforcement queuing to the combat system.

## Files Created/Modified

| File | Change |
|------|--------|
| `scripts/military/CombatExpansionManager.gd` | Created — autoload for terrain/weather/entrenchment/reinforcement |
| `tests/CombatExpansionTest.gd` | Created — 5 test groups, ~25 checks |
| `scripts/core/HeadlessTestRunner.gd` | Modified — added CombatExpansionTest |
| `project.godot` | Modified — added CombatExpansionManager autoload |

## CombatExpansionManager Features

### Terrain Modifiers (16 terrain types)
| Terrain | Attack | Defense |
|---------|:------:|:-------:|
| Plains/Grassland | 1.0 | 1.0 |
| Forest/Woods | 0.8 | 1.3 |
| Hills | 0.85 | 1.2 |
| Mountain | 0.6 | 1.5 |
| Alpine | 0.5 | 1.6 |
| Urban/City/Town | 0.7 | 1.4 |
| Desert/Arid | 1.1 | 0.8 |
| Marsh | 0.6 | 1.2 |
| Swamp | 0.5 | 1.3 |
| Wetland | 0.6 | 1.2 |
| Jungle | 0.55 | 1.4 |

### Weather System
| Weather | Attack | Defense |
|---------|:------:|:-------:|
| Clear | 1.0 | 1.0 |
| Rain | 0.9 | 1.1 |
| Snow | 0.7 | 1.15 |
| Storm | 0.6 | 1.2 |
| Fog | 0.85 | 1.05 |
| Heatwave | 0.8 | 0.9 |

- Weather changes every 30 days (~40% chance per region)
- Per-region weather state (extensible to provinces)
- Signal `weather_changed(region, weather)`

### Entrenchment System
- Formations gain +1 entrenchment level every 7 days stationary
- Max 5 levels (clamped)
- Each level = +5% defense modifier
- Movement resets entrenchment to 0
- Signal `entrenchment_changed(formation_id, new_level)`
- In combat slows entrenchment gain

### Reinforcement Queue
- Queue reinforcements with delay in days
- Processed every 7 days
- Calls `UnitMovementSystem.reinforce_formation()` when delay expires
- Validates amount > 0 and delay >= 0

### Combined Power Multiplier
`get_effective_power_multiplier()` chains:
1. Base terrain modifier
2. Weather modifier
3. Entrenchment modifier (defender only)
4. Built-in +15% defense multiplier (from existing BattleManager)
5. Fortification bonus (+10% per level)

## Tests

| Group | Checks | What It Validates |
|-------|:------:|-------------------|
| Terrain Modifiers | 6 | Plains, Mountain, Jungle, Marsh attack/defense values |
| Weather | 5 | Set/get, clear/storm/snow modifiers |
| Entrenchment | 6 | Default 0, set/get, max clamp (5), modifier calc, reset on move |
| Reinforcement | 4 | Queue size, multiple queues, invalid input ignored |
| Combined Modifiers | 3 | Terrain+weather, full multiplier stack, fort integration |

## Coverage Impact

| System | Tests |
|--------|:-----:|
| Combat Expansion | ~25 unit tests |

✅ **Combat Expansion complete** — terrain modifiers, weather, entrenchment, and reinforcement systems added.
