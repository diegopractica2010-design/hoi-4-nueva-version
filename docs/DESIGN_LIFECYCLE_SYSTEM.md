# Design Lifecycle System — Epochs of Ascendancy

**Status:** Phase A–C in progress (`DesignManager` + `DesignPickerPopup` UI)  
**Last updated:** May 2026  
**Related systems:** `UnitTemplate`, `DivisionTemplate`, `DesignPickerPopup`, `ProductionManager`, `TechnologyManager`, `TimeManager`, `MapTechnologyContext`

---

## 1. Overview & goals

The goal of this system is to keep the **production selection window** manageable and clean in late-game scenarios (especially 2026+), while still giving players access to older designs when needed.

### 1.1 Core problems being solved

- Production windows become overwhelming with decades of old designs (1918, 1936, 1980s, etc.).
- Players need a way to phase out old equipment without losing the ability to rebuild designs they still use.
- The production selector can currently grow too large and go off-screen.
- Players should feel the system is *helping* them, not forcing them to manually manage dozens of old designs.

### 1.2 Design philosophy

- Make obsolescence **automatic and smart** by default.
- Minimize player micromanagement.
- Always keep at least one usable design per role available.
- Provide clear **Obsolete** and **Previously Used** sections instead of hiding designs completely.
- Ensure the production window stays usable regardless of how many years the game spans.

---

## 2. Core concepts

| Term | Definition | Example |
|------|------------|---------|
| **Active designs** | Designs shown by default in the production window | 2026 MBT, modern IFV |
| **Previously used** | Designs the country has used before but are no longer the newest in that role | 2010 MBT (still buildable) |
| **Obsolete** | Old designs hidden by default but still buildable when the filter is on | 1936 tank, 1980s fighter |
| **Role / category** | Logical equipment slot for grouping and obsolescence | `mbt`, `ifv`, `fighter`, `destroyer` |
| **Last used design** | Most recent design a country unlocked or fielded in a role | Protected from auto-obsoletion |
| **Protection rules** | Automatic rules that keep a design buildable even if old | No newer design in role, still in use, or player-protected |

---

## 3. Data model

### 3.1 Design status enum

Add to unit designs (`UnitTemplate` and related resources), `DivisionTemplate`, and modules where lifecycle applies:

```gdscript
enum DesignStatus {
    ACTIVE,
    PREVIOUSLY_USED,
    OBSOLETE,
}
```

### 3.2 Per-design fields

```gdscript
var design_status: DesignStatus = DesignStatus.ACTIVE
var unlock_year: int = 1936
var category: String = ""       # e.g. "mbt", "ifv", "fighter", "destroyer"
var role: String = ""           # More specific role when category is broad
var last_used_by_country: bool = false  # Set when country last fielded this design in role
```

### 3.3 Per-country runtime state

Stored by a new **`DesignManager`** autoload (or subsystem of `ProductionManager` until split):

```gdscript
# country_tag -> design_id -> lifecycle metadata
var _country_design_state: Dictionary = {}

# Player overrides
var _protected_designs: Dictionary = {}   # country_tag -> Array[String]
var _manual_obsolete: Dictionary = {}     # country_tag -> Array[String]
```

Key persisted fields per `(country_tag, design_id)`:

- `status: DesignStatus`
- `last_used_year: int`
- `times_assigned: int` (optional analytics)
- `protected: bool`

### 3.4 Category / role taxonomy

Categories should align with existing production filters and `UnitTemplate.production_category` / `base_type`:

| Domain filter | Example categories |
|---------------|-------------------|
| Land | `mbt`, `ifv`, `apc`, `artillery`, `spg` |
| Naval | `destroyer`, `cruiser`, `carrier`, `submarine`, `frigate` (`base_type: Naval`) |
| Air | `fighter`, `cas`, `bomber`, `transport`, `helicopter` |
| Space | satellites, space stations, crew vehicles, launch vehicles (`base_type: Space`) |
| Support | `aa`, `radar`, `logistics`, `drone`, ground rockets |

`role` is optional refinement when one category has multiple parallel lines (e.g. `mbt_main_battle` vs `mbt_light`).

---

## 4. DesignManager API (target)

Central service for lifecycle queries and mutations. All production UI should filter through these methods instead of iterating raw `GameData.design_data.templates`.

```gdscript
# Returns designs that appear in the main production list (ACTIVE only by default)
func get_active_designs(country_tag: String, category: String = "") -> Array[String]

# Returns designs obsoleted but still buildable
func get_obsolete_designs(country_tag: String, category: String = "") -> Array[String]

# Returns designs the country has used before but are no longer current in role
func get_previously_used_designs(country_tag: String, category: String = "") -> Array[String]

# Combined picker list respecting UI filters (active + optional sections)
func get_designs_for_picker(
    country_tag: String,
    category: String = "",
    show_obsolete: bool = false,
    domain_filter: String = "",
) -> Dictionary  # { "active": [], "previously_used": [], "obsolete": [] }

# Player or script actions
func obsolete_design(country_tag: String, design_id: String) -> void
func protect_design(country_tag: String, design_id: String) -> void
func unprotect_design(country_tag: String, design_id: String) -> void

# Called when country assigns or completes production on a design
func mark_design_used(country_tag: String, design_id: String, year: int) -> void

# Called by TimeManager on year (or month) boundaries
func process_automatic_obsolescence(country_tag: String) -> void

# Fallback when auto-picking a line or AI assignment
func get_best_available_design(country_tag: String, category: String) -> String
```

**Eligibility:** `TechnologyManager.get_design_availability()` remains the authority for *unlock* gates; `DesignManager` only controls *visibility tier* (active / previously used / obsolete). A design can be obsolete but still `available` if tech was completed historically.

---

## 5. Automatic obsolescence rules

### 5.1 When a design becomes obsolete

A design transitions to `OBSOLETE` when **all** of the following are true:

1. The design is **30+ years** older than the current game year (`current_year - unlock_year >= 30`).
2. The country has a **newer viable design** in the same `category` / `role` (newer `unlock_year`, tech-available, not obsolete).
3. The design is **not** the country's `last_used` design for that role.
4. The country has **no active divisions / production lines** still using this design (query `ProductionManager` + formation registry).
5. The design is **not** player-protected.

### 5.2 Protection rules (stay active or previously used)

A design **does not** auto-obsolete if any of the following hold:

- No newer design exists in that category/role for the country.
- The player manually **protected** it (`protect_design()`).
- The design is still **actively used** (assigned production line or fielded template).
- It is the **last used** design for that role (demoted to `PREVIOUSLY_USED` when superseded, not `OBSOLETE`, until age/use rules clear).

### 5.3 Promotion / demotion flow

```
NEW TECH UNLOCK (same role)
    → previous last_used → PREVIOUSLY_USED
    → new design → ACTIVE, last_used = true

YEARLY process_automatic_obsolescence()
    → eligible old designs → OBSOLETE

PLAYER protect_design()
    → stays ACTIVE or PREVIOUSLY_USED (never auto-OBSOLETE)

PLAYER obsolete_design()
    → forced OBSOLETE (unless protected)
```

### 5.4 Minimum availability guarantee

After any obsolescence pass, `get_best_available_design(country_tag, category)` must return a non-empty design id when the country has ever unlocked anything in that category—prevents soft-locking production for a role.

---

## 6. UI behavior (production window)

Applies primarily to **`DesignPickerPopup`** (factory design change) and any future national design browser. Must respect existing `TechnologyManager` lock icons (🔒).

### 6.1 Main production list (default)

- Show **Active** designs only.
- **Category / domain filters**: Land, Naval, Air, Support (maps to `category` / `production_category`).
- **Search** continues to match display name + design id across visible sections only.

### 6.2 Show obsolete toggle

- Checkbox or filter: **“Show obsolete designs”**.
- When enabled, append two collapsible sections below the main list:
  1. **Previously used** — country has fielded before; not current best.
  2. **Obsolete** — hidden by default; older equipment.
- Both sections remain **selectable** for assignment (subject to tech + factory naval rules).

### 6.3 Window size constraint

- The picker must **never** grow off-screen.
- Use a fixed max size + `ScrollContainer` for the design list.
- Category filters reduce visible rows; scrolling is the fallback for large catalogs.
- Consider per-section item caps with “show more” only if performance requires it (MVP: scroll only).

### 6.4 Visual affordances

| Status | List placement | Label hint |
|--------|----------------|------------|
| Active | Main list | (none) |
| Previously used | Secondary section | “Previously used” |
| Obsolete | Tertiary section | “Obsolete” |
| Protected | Any section | Pin icon or “Protected” |
| Tech-locked | Any section | Existing 🔒 from `TechnologyManager` |

### 6.5 Player actions (optional MVP+)

- Right-click or detail button: **Protect from obsolescence** / **Mark obsolete**.
- Bulk action in Production screen: “Obsolete all unused designs older than X years” (advanced; not required for MVP).

---

## 7. Integration points

| System | Responsibility |
|--------|----------------|
| **TimeManager** | On `game_year_advanced` (and optionally month), call `DesignManager.process_automatic_obsolescence(player_tag)` and AI countries as needed. |
| **TechnologyManager** | When a design unlocks via research, call `mark_design_used` / update `last_used`; mark prior design in same `category` as `PREVIOUSLY_USED`. |
| **ProductionManager** | On line assign / design change, `mark_design_used`; populate picker via `get_designs_for_picker()`; include lifecycle status in save payload. |
| **DesignPickerPopup** | Replace raw `GameData.design_data.templates` iteration with `DesignManager` + filters + scroll sections. |
| **MapTechnologyContext** | Optional: province tooltip “factories need tech” only lists **active** designs for clarity. |
| **SaveLoadManager** | Persist `_country_design_state`, protected sets, manual obsolete sets per country. |
| **Agent networks** (future) | Missions may target obsolete supply chains or sabotage legacy equipment lines. |

### 7.1 Existing code touchpoints

| File | Change |
|------|--------|
| `scripts/data/UnitTemplate.gd` | Add `design_status`, `unlock_year`, `category`, `role` exports (defaults from JSON). |
| `scripts/supply/DivisionTemplate.gd` | Mirror lifecycle fields if templates are player-authored. |
| `scripts/ui/DesignPickerPopup.gd` | Filtered sections, scroll, show-obsolete toggle. |
| `scripts/autoload/ProductionManager.gd` | Hook assign/complete → `mark_design_used`. |
| New: `scripts/production/DesignManager.gd` | Autoload implementing API in §4. |

---

## 8. Content & data authoring

### 8.1 JSON template fields

Extend design JSON schema (see `data/` templates) with:

```json
{
  "id": "m1_abrams",
  "unlock_year": 1980,
  "category": "mbt",
  "role": "mbt_main_battle",
  "production_category": "armor"
}
```

`design_status` is **runtime** per country, not authored globally.

### 8.2 Scenario start

On scenario load, seed `ACTIVE` for all designs at or before start year that pass tech gates; set `unlock_year` from template or scenario era table.

---

## 9. Player experience goals

- The system should feel **helpful**, not like busywork.
- Players should **rarely** manually obsolete designs.
- Old designs should **never** completely disappear if still needed for rebuilds or nostalgia campaigns.
- The production window stays **clean and fast** in 2050+ scenarios.
- **Category filters** + **Show obsolete** are the main navigation tools.

---

## 10. Phased implementation plan

| Phase | Scope | Acceptance |
|-------|--------|------------|
| **A — Data & API** | `DesignStatus`, template fields, `DesignManager` stub, save hooks | Unit tests for `get_active_designs` / obsolescence rules |
| **B — Auto obsolescence** | TimeManager yearly pass, tech-unlock demotion, production-use detection | 2026 scenario: 1936 designs move to Obsolete when superseded |
| **C — Picker UI** | Scroll, domain filter, show-obsolete sections | Picker never exceeds viewport; sections match status |
| **D — Polish** | Protect / manual obsolete, toasts, Production screen hints | Player can pin one legacy design per role |

---

## 11. Open questions

1. Should **infantry equipment** use the same lifecycle, or a simplified “always show last 2 generations” rule?
2. Should **AI** use `get_best_available_design()` for auto-assignment, or a separate weighting table?
3. Is **30 years** a global constant, or moddable per scenario (`design_lifecycle_rules.json`)?

---

## 12. Related documents

- [PRODUCTION_ASSIGNMENT_SCREEN.md](PRODUCTION_ASSIGNMENT_SCREEN.md) — Factory list UI and filters  
- [TECHNOLOGY_SYSTEM_DESIGN.md](TECHNOLOGY_SYSTEM_DESIGN.md) — Research unlocks and production gates  
- [UI_DESIGN_REFERENCE.md](UI_DESIGN_REFERENCE.md) — Retrowave patterns for pickers and panels  
