# Epochs of Ascendancy — TODO / Future Systems

## Current Session State (Last Worked On)

**Date:** May 2026

**Recently Completed:**
- Created `ProductionScreenData` and `LeaderScreenData` resources
- Added helper methods (`_get_factory_status`, `_get_factory_type`, `_get_skill_tier`, etc.)
- Refactored `get_production_screen_data()` and `get_leader_screen_data()` for cleanliness
- Created detailed specs for both Production Assignment Screen and Leader Assignment Screen
- Updated and organized `TODO.md`

**Good Place to Resume:**
- Implement caching for screen data classes (noted in TODO)
- Expand `CombatResolver` with more modifiers
- Begin actual UI scene work for the Production Assignment Screen

**Last Updated:** May 2026

## Core Systems (High Priority)

### National Position Costs (Chiefs of Staff)
- Changing `chief_of_army`, `chief_of_navy`, `chief_of_air_force`, or `chief_of_space_force` should have a real cost (Stability, Prestige, Political Power, or cooldown).
- Must show clear cost preview to the player before confirming the change.
- Should support mitigation via Focuses, high leader Prestige, or national spirits.
- Currently only has a placeholder in `can_assign_national_position()`.

### Province Infrastructure System
- Provinces are still placeholders.
- `CombatWidthCalculator`, supply, factory repair, and logistics currently use temporary/default values.
- Needs full implementation and wiring into multiple systems.

### Civilian vs Military Factories
- Separate civilian production from military production.
- Different ideologies should have different consumer goods / stability requirements.
- Allow conversion of civilian factories to military factories (with time and cost — especially important for democratic countries).
- Focuses and agents should be able to influence conversion speed.

### Production Licensing & Diplomatic Factory Use
- Allow nations to license production templates from other countries.
- Use factories as part of diplomatic/trade deals.

### Smart Production Advisor
- Tool that suggests which factories to assign when trying to build equipment for a new division/unit, with time-to-completion estimates.

## Leader System

- Proper per-country/culture name lists for generated leaders.
- Expand negative traits and add trait conflict rules.
- Deeper integration of terrain-specific trait bonuses into combat.
- Create Leader Assignment UI flow (view traits, experience, assign to armies/fleets).
- Promotion paths and special trait earning through long campaigns or achievements.

## Combat System

- Expand `CombatResolver` with terrain, weather, air support, shore bombardment, engineers, night penalties, recon, etc.
- Implement proper **Combat Width** using infrastructure + terrain modifiers.
- Add reserve/reinforcement mechanics during battles.
- Effects of being surrounded and attacking from multiple directions.
- How supply interdiction affects combat over time.
- Wire more leader and equipment modifiers into actual combat calculations.

## UI & Screen Systems

### Screen Data Caching
- `ProductionScreenData` and `LeaderScreenData` are currently computed on demand.
- Implement simple caching with proper invalidation when relevant state changes (factory reassignment, leader assignment, daily tick, etc.).

### Production Assignment Screen
- Detailed spec: `docs/PRODUCTION_ASSIGNMENT_SCREEN.md` (layout, filters, interaction flow, data requirements).
- Implement UI against `ProductionScreenData` when visuals are prioritized.

### Leader Assignment Screen
- Detailed spec: `docs/LEADER_ASSIGNMENT_SCREEN.md` (national positions, two-column layout, data requirements).
- Implement UI against `LeaderScreenData` when visuals are prioritized.

## Production & Economy

- Improve long-term usage of real scenario data in `ScenarioFactorySpawner`.
- Create proper Supply production system from provinces (capital as main source + limited local production in large cities).

## Notes

- Map, graphics, province visuals, and unit models are intentionally deprioritized for now.
- Focus remains on building solid backend systems and data structures first.
- Keep complexity layered: surface information should be simple and clear; deeper math and modifiers should be accessible but not forced on the player.
