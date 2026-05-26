# Current State of Epochs of Ascendancy (May 25, 2026)

## Overview

The game has made significant progress on its core simulation loop and map systems. The central `TimeManager` now drives daily, monthly, and yearly ticks, with several systems reacting to it. Agent networks apply real daily pressure on provinces, and the first Technology tree (Support/Radio) produces measurable gameplay effects.

## Key Systems Status

### Time System

- **Status:** Strong
- `TimeManager` is the central clock.
- Daily, monthly, and yearly signals exist and are being used.
- Real-time advancement + pause/speed control works via `TopInfoBar`.

### Map & Overlays

- **Status:** Good / Improving
- Active overlay layers: `ConflictOverlayLayer` + `AgentNetworkLayer`.
- Multi-overlay visuals (contested + agent + supply) are functional.
- Daily agent pressure (supply disruption + infrastructure sabotage) is visible on the map: province tints, ⛟/⚙ glyphs, ambient ring pulse, infra/depot status bars under rings, repair/depot lines in tooltips and inspector.

### Technology

- **Status:** Partial but promising
- `TechnologyManager` is mature.
- Support/Radio tree is a functional vertical slice with real impact in Supply.
- Map integration via `MapTechnologyContext` (tooltips, legend, mode chips, inspector).

### Agent Networks

- **Status:** Good
- Update daily via `AgentManager.advance_networks_daily()`.
- Apply real province-level effects (national debuff, depot hits, infra chips).
- Visual and tooltip feedback improving.

### Repair / Counter-Play

- **Status:** Basic but functional
- Automatic slow infrastructure repair (`MapManager.advance_daily_infrastructure_repair()`).
- `clear_daily_sabotage_effects()` works via counter-intel missions.
- Tooltips show repair rate, ETA to infra 50, and depot recovery context under pressure.

## Major Gaps

- Save/Load is almost non-existent.
- Map build eligibility (Technology affecting construction) is still early.
- Many systems are still yearly-only instead of daily/monthly.
- Testing infrastructure is weak (see [TESTING_PLAN.md](TESTING_PLAN.md)).
- Top bar / menu needs modernization.

## Related Docs

- [TESTING_PLAN.md](TESTING_PLAN.md) — manual and regression checklist
- [MAP_IMPLEMENTATION_PLAN.md](MAP_IMPLEMENTATION_PLAN.md) — province/map roadmap
- [TECHNOLOGY_SYSTEM_DESIGN.md](TECHNOLOGY_SYSTEM_DESIGN.md) — tech system design
