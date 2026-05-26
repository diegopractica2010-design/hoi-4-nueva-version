# Testing Plan — Epochs of Ascendancy

## Goals

- Ensure new systems (especially Time + Daily Effects) work reliably.
- Catch regressions when adding new features.
- Make it easy to verify that daily/monthly/yearly systems behave correctly.

## Recommended Testing Approach

### 1. Core Time System Tests

- Load a scenario and verify the top bar date matches `start_date`.
- Let the game run for several in-game days/months/years.
- Test Pause / Speed buttons.
- Verify that yearly systems (research, agent missions, leader events) still trigger correctly.

### 2. Daily Agent Pressure Tests

- Create or load a scenario with active `supply_disruption` and `infrastructure_sabotage` networks.
- Observe daily changes in:
  - Province infrastructure level
  - Local supply generation
  - Depot stock / throughput
- Use counter-intel missions and verify `clear_daily_sabotage_effects` works.
- On the map: confirm ⛟/⚙ pressure tint, ring glyphs, status bars (infra/depot), and tooltip repair lines.

### 3. Technology Tests (Support/Radio)

- Research `radio_ii` and verify supply route performance improves.
- Check that `planning_speed` and `reconnaissance` bonuses appear in tooltips and the map.
- Verify ETA and progress display correctly in the Technology screen.

### 4. Multi-Overlay Map Tests

- Enable Supply overlay (L) while having both contested and agent pressure provinces.
- Verify legend, tooltips, and hover states remain readable.
- Check that daily time pulses and Technology bonuses display cleanly.
- Hover pressure provinces: legend footer should show compact repair/depot info.

### 5. Regression Tests

- After any `TimeManager` change, verify yearly systems still fire.
- After any `AgentManager` change, verify daily + yearly paths both work.

## Suggested Test Scenarios

- **1936 start** with radio tech already granted.
- Scenario with **active enemy agent networks** on key provinces.
- **Long play session** (multiple in-game months) to test cumulative effects.

## Automated / Headless Hooks (Existing)

| Script | Purpose |
|--------|---------|
| `scripts/core/TestRunner.gd` | Entry point for headless test runs |
| `scripts/core/HeadlessSupplyTest.gd` | Supply system smoke tests |
| `scripts/core/ProductionLineTest.gd` | Production line tests |
| `scripts/core/SupplyLineTest.gd` | Supply routing tests |

Run from Godot with the project’s test scene or headless entry (see `TestRunner.gd` for invocation).

## Future: Structured Harness

- [ ] Scenario fixtures for “agent pressure on capital + hub”
- [ ] Assert infra repair rate and depot `sabotage_level` after N days
- [ ] Snapshot tests for `ProvinceInsight` tooltip BBCode keys (optional)
