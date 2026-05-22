# Epochs of Ascendancy — TODO / Future Systems

## Leader System — Current Status (May 21, 2026)

**Completed:**
- Leveled traits (I–III) with rarity + exclusivity (`data/leaders/traits.json`)
- Historical leaders (1918 + 1936) with `trait_levels`, skills, initiative
- Timeline gating (`birth_year`, `start_year`, `end_year`) + `leader_pool`
- Probability-based yearly mortality + retirement (no fixed death dates)
- Combat death split: **0.03%** per battle / **~30%** death-or-capture on formation destroyed
- `RetirementOfferPopup` + `LeaderEventUI` news toasts
- XP Phase A: `award_xp_to_leader`, passive XP rates, `spend_experience` (see `docs/XP_SYSTEM_DESIGN.md`)
- XP gain from combat + spend-to-level traits (basic)
- Leader Assignment screen with trait levels and detail panel

**Next priorities:**
- Officer Training national position + mentoring / trait inheritance
- Leader replacement picker after death/retirement (auto fallback + player choice)
- Full news feed panel (history beyond toasts)
- Earned trait triggers (terrain, campaigns)
- Doctrine/focus-gated trait introductions
- Field Marshal tier + multi-formation command

---

## Current Session State (Last Worked On)

**Date:** May 2026

**Recently Completed:**
- Phase A–C leader system: traits, historical rosters, timeline, mortality, combat risk
- `RetirementOfferPopup` + `LeaderEventUI` autoload
- 73 WWI + 10 WWII historical commanders with `trait_levels`

**Good Place to Resume:**
- Officer Training national position
- Leader replacement picker after death/retirement
- Wire `resolve_formation_destroyed()` into formation elimination code

**Last Updated:** May 21, 2026

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
- Officer Training Program national position (mentoring, trait pass-down).
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
