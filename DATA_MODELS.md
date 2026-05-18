# Epochs of Ascendancy - Core Data Models

**Version**: 0.3  
**Date**: May 18, 2026  
**Status**: Initial implementation draft

This document defines the foundational data structures for *Epochs of Ascendancy*. The goal is maximum flexibility with manageable complexity.

## Core Design Principles

- **Two-Layer System**:
  1. **Design Layer** (`UnitTemplate`): Design and produce individual hardware (tanks, planes, ships, drone swarms, etc.).
  2. **Organization Layer** (`Formation`): Organize designed units into fighting forces (platoon, company, battalion, brigade, division, task force).
- Modular equipment with slots.
- Proven combat modeling (soft/hard attack + piercing + hardness, expanded with location armor).
- Crew requirements (except pure drones).
- Experience & training systems on both units and agents.
- Strong support for combined arms, trade-offs, and alternate history.
- Fully data-driven and modder-friendly.

---

## 1. EquipmentModule

The atomic building blocks placed into `UnitTemplate` slots.

**Key Stats**:
- `soft_attack`: Effectiveness vs soft targets (infantry, crew, unarmored).
- `hard_attack`: Effectiveness vs hard/armored targets.
- `piercing`: Ability to defeat armor. Higher piercing beats higher armor.
- Other combat stats: `air_attack`, `anti_ship`, `anti_drone`, etc.
- Economic: cost, production_time.

**Categories** (examples):
`MainWeapon`, `SecondaryWeapon`, `Engine`, `Suspension`, `Armor`, `ExtraFuel`, `Communications`, `LifeSupport`, `Sensors`, `Cargo`, `DroneAttachment`, `NBC_Protection`, `AntiAir`, `AntiTank`, etc.

**Example JSON**:
```json
{
  "id": "75mm_m3_gun",
  "name": "75mm M3 Gun",
  "category": "MainWeapon",
  "soft_attack": 48,
  "hard_attack": 32,
  "piercing": 68,
  "air_attack": 6,
  "cost": {"steel": 14, "rubber": 1},
  "production_time": 50
}
```

---

## 2. UnitTemplate (Design Layer)

This is the core for designing and producing individual units/vehicles.

**Key Fields**:
- `base_type`: Land, Air, Naval, Submarine, Space, Drone
- `size_category`: Light, Medium, Heavy, SuperHeavy, Swarm (affects training time, supply use, map presence)
- `visual_archetype`: truck, light_tank, medium_tank, fighter, bomber, jet_fighter, stealth_bomber, amphibious, flying_boat, helicopter, etc.
- `crew_required`: Base crew needed (tech can reduce this). Drones usually have 0.
- `base_training_level` + `max_experience_level`
- `base_stats`: speed, reliability, fuel_consumption, supply_need, armor, top_armor, deck_armor, hardness, carry_capacity
- `slots`: Defines customizable slots and allowed module categories
- `unlock_tech`
- `can_mount_drones`: Boolean
- `is_vehicle`: Boolean

**Example JSON** (Light Tank):
```json
{
  "id": "m3_stuart_light",
  "name": "M3 Stuart Light Tank",
  "base_type": "Armored",
  "size_category": "Light",
  "visual_archetype": "light_tank",
  "crew_required": 4,
  "base_training_level": 20,
  "max_experience_level": 100,
  "base_stats": {
    "speed": 42,
    "reliability": 80,
    "fuel_consumption": 7,
    "supply_need": 10,
    "armor": 38,
    "top_armor": 22,
    "hardness": 75
  },
  "slots": {
    "MainWeapon": {"max": 1},
    "SecondaryWeapon": {"max": 2},
    "Engine": {"max": 1},
    "DroneAttachment": {"max": 2}
  },
  "unlock_tech": ["light_tanks"]
}
```

**Notes**:
- Size categories at design level determine baseline characteristics.
- Location armor (`top_armor`, `deck_armor`) enables meaningful trade-offs (speed vs protection).

---

## 3. Formation (Organization Layer)

Players combine designed `UnitTemplate` instances + support into organized fighting forces.

**Size Categories** (examples): Platoon, Company, Battalion, Brigade, Division, Task Force, Fleet Element.

This layer handles:
- Combined arms composition
- Command structure
- Overall experience of the formation
- Supply & logistics at formation level

(Implementation planned after core Design Layer is solid.)

---

## 4. Combat Model (Soft vs Hard + Piercing + Location Armor)

**Core Rules** (inspired by Hearts of Iron IV, expanded):

- Weapons provide `soft_attack` + `hard_attack` + `piercing`.
- Target `UnitTemplate` has `hardness` % (portion that counts as hard target).
- Effective damage mix depends on target hardness.
- `piercing` vs `armor`: If piercing exceeds armor → significant bonuses.
- **Location armor** (`top_armor`, `deck_armor`): Specific attack types (strafing, top-attack weapons) can target weaker locations.
- Low-piercing attacks against high-armor targets primarily damage **crew** rather than destroying the platform.

This system elegantly models:
- Small arms vs APCs vs tank guns
- Planes strafing ships (crew damage on armored vessels)
- Top armor vulnerabilities on tanks
- Deck armor trade-offs on ships

---

## 5. Crew System

- Most units require crew (exception: pure drone units/swarm).
- Base crew often tied to engine count or size category.
- Technology can reduce crew requirements or improve reliability.
- Crew loss impacts unit performance.

---

## 6. Experience & Training

- Deployed units gain experience from combat performance and actions.
- New units can train to a baseline experience level.
- `base_training_level` and experience gain rates can be modified by **Focus** and **Doctrine**.
- Higher experience improves combat effectiveness.
- Agents also have separate leveling/experience systems.

---

## 7. Doctrine

Selectable in the Technology tree.

- Affects specific domains: Land, Air, Naval, **Space**.
- Can modify experience gain, training speed, unit stats, and formation bonuses.

---

## 8. Focus (Expanded Scope)

National focuses can influence:
- Facility construction and map development
- Population and manpower
- Diplomacy and prestige
- Experience and training rates
- Major national projects (Space Race, Moon/Mars, ocean exploration, etc.)
- Triggering of major events

---

## 9. Supporting Systems

- **ProductionLine**: Tied to `UnitTemplate` or `EquipmentModule`. Handles output, efficiency, and resource consumption.
- **Agent**: Level, experience, stats, abilities, mission history.
- **Event**: Moddable events that make the game world feel dynamic and reactive.
- **TechNode**: Includes both regular technology and Doctrine nodes.

---

## Implementation Recommendations

- Store base data in JSON for easy modding.
- Use Godot Resources or a custom loader at runtime.
- Build the Design Layer (`UnitTemplate` + modules) first.
- Add Production/Economy on top of these models.
- Implement Formation/Organization Layer after the above is stable.

This structure provides deep replayability, meaningful trade-offs, and excellent modding support while remaining implementable.
