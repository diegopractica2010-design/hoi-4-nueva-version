# PRODUCTION SYSTEM — Epochs of Ascendancy

**Last Updated:** May 2026  
**Status:** Core systems implemented (Retooling, Multi-slot Factories, Resource Consumption, Production Progression, Port Shipyards, Shortage Penalties)

---

## 1. Current Architecture Overview

- **Factory** (`scripts/map/Factory.gd`)
  - Lives on provinces via `ProvinceFactoryComponent`
  - Has `factory_id` (province × 100 + slot encoding)
  - Tracks `current_production_design`, damage, efficiency, retooling state
  - Supports `max_production_lines` (for shipyards, aircraft factories, etc.)

- **ProductionLine**
  - Belongs to one Factory
  - Tracks `progress`, `design_production_cost`, `daily_resource_cost`
  - Applies factory efficiency + concentration bonus + retooling + shortage penalties

- **ProductionManager** (autoload)
  - Central coordinator for assignment, retooling, progression, and queries
  - `daily_production_tick()` / `advance_production(days)`
  - Concentration bonuses (national + per-factory slot rush)
  - Resource shortage handling

- **ProductionCostCalculator**
  - Calculates `production_cost` from category + modules + era + complexity

---

## 2. Retooling System

### Rules
- When changing what a factory produces, current progress on assigned lines **is lost**.
- Efficiency is **heavily debuffed** during retooling (never fully paused).
- Efficiency **slowly recovers** after the main retool period.
- Retooling time and recovery speed are **separately modifiable** by technology, focus trees, and industrial agents.
- Hardest switches start with a **20% efficiency floor** (can be raised by tech/focus).

### Future UI Requirements (Important Notes)
- When player attempts to reassign a factory, show a **confirmation popup/warning** that includes:
  - Old design → New design
  - Expected efficiency immediately after switching
  - Estimated days until factory returns to full efficiency
  - Clear warning: **"Current production progress on this line will be lost."**
- Add a **visual indicator** on the factory (icon, overlay, or color change) while it is in retooling state.

---

## 3. Shipyard / Multi-Level Production

### Current Implementation
- Factories have `max_production_lines` (default 1).
- Shipyards are created with `FactoryManager.create_shipyard_for_province(..., levels := 4)`.
- Multiple lines can be assigned to the **same design** inside one factory → **slot rush bonus** (+12% per extra line, capped at 1.6×).
- Player can choose to concentrate all levels on one capital ship or spread them for parallel construction.

### Port & Shipyard Rules (Enforced in Code)
- **Shipyards may only be built or converted in provinces with port access** (`Province.has_port` / `resolve_has_port()`).
- Port access is set explicitly in scenario data or inferred from coastal terrain, port features/tags, or adjacency to sea provinces (`ScenarioLoader._infer_port_access_for_all`).
- Inland factories **cannot** produce naval designs; only `factory_type == "shipyard"` at a port may build ships (`ProductionNavalRules`, `ProductionManager._naval_production_allowed`).
- **Build new shipyard:** `FactoryManager.create_shipyard_for_province(province_id, owner_tag, levels)`.
- **Convert existing factory:** `FactoryManager.convert_factory_to_shipyard(factory_id, levels)` (port province only).
- `data/production/factory_rules.json` includes a `shipyard` block with `build_cost` / `convert_days` for future timed/costed conversion UI.

---

## 4. Resource Consumption & Shortages

### Current State
- Designs carry `daily_resource_cost` (steel, aluminum, fuel, electronics, etc.).
- `get_design_resource_preview()` and updated info methods expose daily costs for UI.
- Shortages apply `resource_shortage_penalty` on the line (reduces production speed; floor ~55% in `production_cost_rules.json`).
- Production **continues** during shortages (does not halt completely).
- **Critical resources** (electronics, rubber, explosives, rare earth, etc.) use stronger weighted fill ratios than common materials.
- Finished units under shortage carry a lower **`shortage_reliability_multiplier`** (logged on completion; hook for combat/readiness later).
- National stockpile is consumed proportionally when supply is partial (`ProductionManager.evaluate_line_resources`).

### Recommended Future Behavior
- Connect consumption to **provincial stockpiles** / `ProvinceDepotState` and supply lines instead of national pool only.
- Surface shortage severity on the Production Assignment UI and on deployed unit readiness.
- Optional: **partial production** variants (lower-quality unit when specific inputs are missing).

### Design Intent
- Missing critical resources should hurt more than missing steel/coal.
- Shortages should motivate exploration, synthetics, trade, and conquest of resource-rich areas.

---

## 5. Future UI / Player-Facing Notes

### Retooling Warning Popup (High Priority)
- Must clearly communicate trade-offs before allowing the change.
- Should show both immediate effect and long-term recovery time.

### Factory Visual State
- Factories in retooling should have a distinct visual state (icon, progress bar, color tint, or animation).

### Production Assignment Screen (Planned)
- Show per-factory: current design, efficiency, daily output, resource cost, retooling status, slot usage.
- Allow player to assign / reassign lines and see concentration bonuses in real time.
- Show equipment shortages for active units (see Option 4).

---

## 6. Equipment Shortages & Unit Readiness

### Current Implementation
- **`EquipmentShortageTracker`**: `calculate_shortages`, readiness multiplier (max ~70% penalty, floor 0.3), organization multiplier.
- **`DivisionTemplate.required_equipment`** / **`UnitTemplate.required_equipment`**; divisions fall back to `equipment[]` counts when explicit dict is empty.
- **`ProductionManager`**: per-unit stock (`set_unit_equipment_stock`), `get_unit_shortages`, `get_shortage_report`, `apply_equipment_shortage_modifiers` (combat hook).
- Example formation: `us_infantry_division_1943` in `data/formations/division_templates.json`.

### Future
- Connect unit stock to production completions and national equipment pools.
- Surface `get_shortage_report` on the Production Assignment UI.

---

## 7. Next Development Priorities (Current Order)

1. ~~**Equipment Shortage & Unit Readiness** (Option 4)~~ (foundation done)
2. Scenario loading + automatic factory spawning from 1918/1936 data
3. Connect resource consumption to actual provincial stockpiles / Supply system
4. ~~Enforce shipyard port location rules~~ (done)
5. Add technology & focus modifiers for retooling time + recovery speed
6. Build the actual Production Assignment UI screen
7. Timed/costed shipyard **build** and **convert** flows using `factory_rules.json` shipyard costs

---

## 8. Open Design Questions

- ~~Should we allow building **new shipyards** in port provinces, or only converting existing factories?~~ **Both are supported** (build via `create_shipyard_for_province`, convert via `convert_factory_to_shipyard`).
- How harsh should resource shortages become on **reliability** of finished units? (Current floor ~72%; tune in `production_cost_rules.json` → `resource_shortage`.)
- Do we want a "partial production" system where missing resources produce a lower-quality variant?

---

**This document should be updated as we implement new systems.**
