# Production Assignment Screen — Detailed Specification

**Last Updated:** May 2026  
**Status:** Design Phase  
**Related Systems:** ProductionManager, ProductionScreenData, Factory, Retooling

---

## 1. Purpose

The Production Assignment Screen is one of the core strategic interfaces in *Epochs of Ascendancy*. It allows the player to:

- See the overall state of their military industry at a glance.
- Understand what each factory is currently producing.
- Reassign factories to different designs.
- Monitor efficiency, retooling progress, and bottlenecks.
- Make informed decisions about industrial focus and trade-offs.

The screen must feel **clear, fast, and strategic** — not overwhelming.

---

## 2. Core Design Philosophy

- **Layered Complexity**: Show the most important information on the surface. Hide detailed calculations and modifiers behind tooltips and detail panels.
- **Minimalist Retrowave Aesthetic**: Clean layouts, strong visual hierarchy, dark backgrounds with neon/cyan/magenta accents, high readability.
- **Decision Speed**: The player should be able to understand their industrial situation within a few seconds.
- **Transparency with Depth**: Clearly communicate *why* something is happening (especially retooling penalties), but don't force the player to see the math unless they want to.

---

## 3. Recommended Screen Layout

### 3.1 Top Summary Bar (Always Visible)

**Purpose**: Give instant high-level status of the nation's military industry.

**Elements**:
- Total Military Factories
- Average Factory Efficiency (with color coding)
- Factories Currently Retooling
- Estimated Total Daily Output (across all factories)
- Quick Status Indicators (e.g., warning icons if many factories are retooling or have low efficiency)

**Color Coding**:
- Green = Healthy
- Yellow = Warning
- Red = Critical

---

### 3.2 Filters & Search Bar

**Purpose**: Allow the player to quickly narrow down the factory list.

**Filters**:
- **Factory Type**: All / Shipyards / Tank & Vehicle Factories / Aircraft Factories / Artillery & Support / Other
- **Status**: All / Producing / Retooling / Idle / Low Efficiency
- **Search**: Free text search on current design name or province

---

### 3.3 Main Factory List (Central Area)

This is the heart of the screen.

**Recommended Columns** (left to right):

| Column                    | Purpose                                      | Priority |
|---------------------------|----------------------------------------------|----------|
| Location / Province       | Where the factory is located                 | High     |
| Current Design            | What is being produced (with icon if possible) | High   |
| Efficiency                | Current efficiency % + visual progress bar   | High     |
| Retooling Status          | Clear text or progress bar if retooling      | High     |
| Production Lines          | Lines in use / Max lines                     | Medium   |
| Estimated Daily Output    | How much this factory contributes per day    | Medium   |
| Quick Action              | Button: "Change Production"                  | High     |

**Sorting Options**:
- By Efficiency (default)
- By Output
- By Retooling Progress
- Alphabetically by Design

---

### 3.4 Detail Panel (Right Side)

Appears when a factory is selected from the list.

**Contents**:
- Factory ID and Location
- Current Design + Production Progress (if applicable)
- Current Efficiency breakdown (base + modifiers)
- Retooling Information (if active):
  - Time remaining
  - Efficiency penalty
  - Estimated time until full recovery
- Assigned Production Lines count
- **Primary Action Button**: **Change Production**
- Secondary Actions (future): Prioritize, Pause, etc.

**Important**: Changing production must trigger the **Retooling Warning Popup** we defined earlier (showing efficiency impact and recovery time).

---

### 3.5 Optional / Future Sections

- **Designs Currently in Production** summary (grouped view)
- **Industrial Bottlenecks** panel (e.g., many factories retooling, low overall efficiency)
- **Smart Assign** button (suggests best factories to assign for a chosen design)

---

## 4. Interaction Flow

1. Player opens Production Assignment Screen.
2. Sees high-level summary at the top.
3. Can filter or search the factory list.
4. Clicks on a factory → Detail panel opens on the right.
5. Clicks **Change Production** → Opens design selection interface.
6. Selects new design → **Retooling Warning Popup** appears.
7. Player confirms or cancels.
8. Factory enters retooling state and list updates.

---

## 5. Data Requirements

This screen should be powered primarily by `ProductionScreenData`.

**Required Fields from `ProductionScreenData`**:
- `total_factories`
- `average_efficiency`
- `factories_in_retooling`
- `estimated_daily_output`
- `factories` (array of factory summaries)
- `designs_in_production`
- `has_critical_efficiency`
- `has_many_retooling`

**Factory Summary Dictionary** should contain:
- `factory_id`
- `province_id`
- `current_design`
- `efficiency`
- `is_retooling`
- `retooling_progress`
- `max_lines`
- `assigned_lines`
- `daily_output_estimate` (if available)

---

## 6. Visual & UX Guidelines

- Use strong **color coding** for efficiency and status.
- Keep text concise and scannable.
- Use progress bars for efficiency and retooling.
- Make the **Change Production** action prominent but not aggressive.
- Retooling should feel like a meaningful decision (clear warning + consequences shown).
- Avoid showing raw internal numbers (e.g., exact Production Points) unless the player expands a tooltip.

---

## 7. Future Enhancements

- Smart Production Advisor suggestions
- Bulk reassignment tools
- Production queue / prioritization system
- Historical production graphs
- Integration with resource shortage warnings
- Ability to see which units are waiting for equipment from specific designs

---

## 8. Success Criteria

A good Production Assignment Screen should allow a player to answer these questions quickly:

- How healthy is my industry right now?
- What am I currently producing the most of?
- Which factories are underperforming or stuck in retooling?
- What will happen if I switch this factory to a new design?
- Where should I focus my industrial effort next?

---

**End of Specification**
