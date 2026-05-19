# Supply line system

## Phase 2 (current)

### Combat / intel → interdiction

Register forces per province, then refresh intel:

```gdscript
SupplyManager.register_unit_presence(province_id, owner_tag, unit_template, count)
SupplyManager.refresh_intel_from_forces()
# or bulk: SupplyManager.seed_demo_enemy_forces() for border demo
```

`SupplyIntelBridge` writes `enemy_presence` used by `SupplyInterdictionEstimator` (air superiority ratio, naval at port, brigade equivalents, adjacent enemy).

Combat systems should call `register_unit_presence` each tick or after battles; intel can call `register_force_report` with a full `ProvinceForceReport`.

### Multimodal routing

`SupplyMultimodalRouter.find_best_route()` compares **land**, **sea** (ports + sea adjacency), and **air** (airport-to-airport) graphs.

- `SupplyCargoProfile.from_template()` sets `prefers_air` / `prefers_sea` from `cargo_capacity` and `base_type`.
- `SupplyManager.set_routing_mode("land"|"sea"|"air"|"")` — empty = auto.
- UI: mode dropdown on supply menu (**L** on map).

### Attrition replenishment

```gdscript
SupplyManager.record_attrition("us_infantry_div_ww2", manpower_lost, {"m4_sherman_medium": 2.0})
var cargo := SupplyManager.get_attrition_cargo_summary()
```

Division templates: `data/formations/division_templates.json`.

### Depot stockpiles & throughput

Each hub has `ProvinceDepotState` (stockpile, capacity, in/out per day).

```gdscript
SupplyManager.advance_supply_day(1.0)  # moves cargo along routes, applies interdiction loss
```

Supply menu shows selected depot, top depots, attrition queue, route preview.

## Controls

- **L** — toggle supply overlay
- Click provinces — reroute (first click sets target; further clicks add waypoints)
- **Commit route** — apply custom path

## Tests

```bash
godot4 --headless --path . -s res://scripts/core/HeadlessSupplyTest.gd
```
