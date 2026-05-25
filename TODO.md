# Epochs of Ascendancy — TODO / Future Systems

## Leader & Training Systems

### Completed
- Leveled traits with XP spending (I–III, rarity, exclusivity in `data/leaders/traits.json`)
- Historical leaders (1918 + 1936 + 2026) with timeline gating and scenario loading
- Doctrine Training Paths (invest + switch, `TrainingPathScreen`)
- Officer Training backend (quality progression, cadet generation, trait inheritance risk)
- Training path combat & supply modifier helpers on `LeaderManager`
- Leader Detail Screen with trait levels, effects, and next-level preview
- Officer Training national position card with **Generate Cadet** button
- `RetirementOfferPopup` + `LeaderEventUI` news toasts (including training quality notices)
- Leader Replacement Picker (vacancy queue, auto-fallback scoring, `LeaderReplacementPickerPopup`)

### Outstanding
- Wire training path bonuses into actual combat resolution (helpers exist; full battle loop)
- Improve Officer Training UI (quality bar, richer cadet-generation feedback)
- Tech/focus gating for Admiral and Air Marshal cadets (doctrine placeholders in place)
- Path switching cost preview in `TrainingPathScreen` before confirm
- Political Alignment + Hidden Traits system
- ~~Pending-replacement badge on Leader Assignment screen~~ (done)
- ~~Player-country filtering for replacement popups (AI auto-resolve)~~ (done)
- Full news feed panel (history beyond toasts)
- Earned trait triggers (terrain, campaigns)
- Field Marshal tier + multi-formation command
- Full integration of training bonuses into `SupplyManager` and attrition systems

---

## Leader System — Legacy Notes (May 18, 2026)

---

## Current Session State (Last Worked On)

**Date:** May 2026

**Recently Completed:**
- Officer Training Command (mentor, quality, Generate Cadet UI)
- Training path UI polish + combat/supply modifier wiring (helpers)

**Good Place to Resume:**
- Combat resolver: apply training path bonuses in battle
- Leader replacement picker after death/retirement
- Wire `resolve_formation_destroyed()` into formation elimination code

**Last Updated:** May 18, 2026

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

- Proper per-country/culture name lists for generated leaders (USA/GER/ENG pools started).
- Replacement picker UI after death/retirement.
- Earned trait triggers (terrain time, encirclements, etc.).
- Promotion paths and Field Marshal multi-formation command.

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
