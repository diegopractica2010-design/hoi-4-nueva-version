# Epochs of Ascendancy — TODO / Future Systems

Last Updated: May 2026

## High Priority / Core Systems

### National Position Costs (Chiefs of Staff)
- Changing `chief_of_army`, `chief_of_navy`, `chief_of_air_force`, or `chief_of_space_force` should have a real cost.
- Possible costs: Stability, Prestige, Political Power, or a cooldown.
- Currently implemented as a placeholder in `LeaderManager.can_assign_national_position()`.
- Should clearly display the cost to the player before they confirm the change (transparency).
- Should support mitigation via Focuses, high leader Prestige, national spirits, or specific events.
- Need a proper Stability / Prestige / Political Power system to hook this into.

### Province Infrastructure System
- Provinces are currently placeholders.
- `CombatWidthCalculator` and supply systems use temporary/default infrastructure values.
- When real province data is implemented, update:
  - Combat width calculation
  - Supply production and throughput
  - Factory efficiency / repair speed
  - Logistics and movement modifiers

### Civilian vs Military Factories
- Separate civilian production from military production.
- Different ideologies should have different consumer goods / stability requirements.
- Allow conversion of civilian factories to military factories (with time/cost, especially for democratic countries like the USA).
- Focuses and agents should be able to influence conversion speed and efficiency.

## Leader System

- Add proper name lists per country/culture for generated leaders.
- Expand trait system with more negative traits and trait conflicts.
- Add terrain-specific bonuses more deeply into combat resolution.
- Create UI for viewing available leaders, their traits, experience, and assigning them to armies/fleets.
- Allow promotion paths and special trait earning through long campaigns.

## Combat System

- Expand `CombatResolver` with terrain, weather, leaders, air support, shore bombardment, engineers, night penalties, etc.
- Implement proper Combat Width system using infrastructure + terrain.
- Add reserve/reinforcement mechanics during battles.
- Define how being surrounded, multi-directional attacks, and supply interdiction affect combat.

## Production & Economy

- Full Civilian Factory system + consumer goods requirements.
- Production licensing (buying templates and production rights from other nations).
- Using factories as diplomatic/trade leverage.
- Smart Production Advisor tool (suggests which factories to assign when building a new division).

## Other Notes

- Add more historical leaders to `data/leaders/historical_leaders_1936.json` and other era files.
- Improve Scenario Factory Spawner to better reflect historical industrial strength.
- Create proper Supply production system from provinces (capital + local production).
