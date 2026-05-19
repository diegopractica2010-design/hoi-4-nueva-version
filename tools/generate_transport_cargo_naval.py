#!/usr/bin/env python3
"""Modular land transports and cargo ships — arm at the cost of cargo capacity.

Modeling:
- Land transports: base_type Land, visual_archetype transport.
  Slots: Cargo (hold module), MainWeapon (optional rocket/missile pod), Engine, Suspension.
  base_stats.cargo_capacity = nominal tons; use armed variant templates or mount weapons in
  production lines to trade firepower for supply_need/cargo_capacity (higher supply_need when armed).

- Cargo ships: base_type Naval, visual_archetype cargo_ship.
  Slots: Cargo (required hold), SecondaryWeapon (deck gun/missile), AntiAir (optional), Engine.
  Armed merchant templates have lower cargo_capacity in base_stats than pure transports.
"""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "data"
MODULES_DIR = ROOT / "modules"
TEMPLATES_DIR = ROOT / "unit_templates"
SCENARIOS_DIR = ROOT / "scenarios"

# fmt: off
MODULES: list[dict] = [
    {"id": "standard_truck_cargo_bed", "name": "Standard Truck Cargo Bed", "category": "Cargo", "tier": 2,
     "reliability_bonus": 5,
     "cost": {"steel": 6, "rubber": 2}, "production_time": 25,
     "special_flags": ["transport", "mountable_on_transport", "cargo_full"],
     "description": "Unarmored cargo bed. Full payload for supplies and troops."},
    {"id": "reduced_truck_cargo_armed", "name": "Reduced Cargo (Armed)", "category": "Cargo", "tier": 3,
     "reliability_bonus": 2,
     "cost": {"steel": 8, "rubber": 2, "explosives": 4}, "production_time": 30,
     "special_flags": ["transport", "armed_transport", "cargo_reduced"],
     "description": "Ammo racks replace part of cargo space when MainWeapon pod is fitted."},
    {"id": "merchant_full_cargo_hold", "name": "Merchant Full Hold", "category": "Cargo", "tier": 3,
     "reliability_bonus": 6,
     "cost": {"steel": 40, "rubber": 8}, "production_time": 70,
     "special_flags": ["naval", "cargo_ship", "cargo_full"],
     "description": "Unarmed merchant cargo hold. Maximum tonnage and fuel efficiency."},
    {"id": "merchant_armed_cargo_hold", "name": "Merchant Armed Hold", "category": "Cargo", "tier": 4,
     "reliability_bonus": 4,
     "cost": {"steel": 35, "rubber": 6, "explosives": 10}, "production_time": 75,
     "special_flags": ["naval", "cargo_ship", "cargo_reduced", "armed_merchant"],
     "description": "Reduced hold volume; space reserved for deck weapons and magazine."},
    {"id": "liberty_ship_engine", "name": "Liberty Ship Power Plant", "category": "Engine", "tier": 3,
     "reliability_bonus": 5, "fuel_efficiency": 3, "speed_bonus": 2,
     "cost": {"steel": 35, "copper": 8}, "production_time": 90,
     "special_flags": ["usa", "ww2", "merchant", "steam"],
     "description": "Triple-expansion steam plant on EC2-S-C1 Liberty ships."},
    {"id": "modern_container_ship_engine", "name": "Container Ship Diesel", "category": "Engine", "tier": 6,
     "reliability_bonus": 8, "fuel_efficiency": 8, "speed_bonus": 4,
     "cost": {"steel": 45, "electronics": 12}, "production_time": 100,
     "special_flags": ["merchant", "twenty_twenties", "diesel"],
     "description": "Slow-speed two-stroke diesel for modern bulk and container carriers."},
    {"id": "ww1_merchant_steamer", "name": "WWI Merchant Steamer", "category": "Engine", "tier": 2,
     "reliability_bonus": 4, "fuel_efficiency": 2,
     "cost": {"steel": 28, "copper": 6}, "production_time": 80,
     "special_flags": ["ww1", "merchant", "steam"],
     "description": "Coal-fired tramp steamer engine for Great War sealift."},
    {"id": "deck_gun_merchant_4inch", "name": "4\" Merchant Deck Gun", "category": "SecondaryWeapon", "tier": 2,
     "soft_attack": 22, "hard_attack": 18, "piercing": 16, "anti_ship": 28,
     "cost": {"steel": 8, "explosives": 6}, "production_time": 45,
     "special_flags": ["armed_merchant", "ww1", "naval"],
     "description": "Defensive gun on armed merchantmen and Q-ships."},
    {"id": "merchant_ascm_launcher", "name": "Containerized ASCM", "category": "SecondaryWeapon", "tier": 6,
     "soft_attack": 35, "hard_attack": 55, "piercing": 40, "anti_ship": 85,
     "cost": {"steel": 15, "electronics": 35, "explosives": 20}, "production_time": 90,
     "special_flags": ["armed_merchant", "twenty_twenties", "naval", "missile"],
     "description": "Boxed anti-ship missiles on deck of converted merchant. Severely reduces cargo."},
]

# Per-era transport trucks (can swap MainWeapon for rocket modules in production UI)
TRANSPORTS_LAND: list[dict] = [
    {"id": "us_2ton_truck_transport", "name": "US 2½-ton Truck", "era": ["ww2_transport", "us_logistics"],
     "engine": "liberty_l12_engine", "days": 35, "cargo_cap": 5000},
    {"id": "gmc_6x6_cargo_truck", "name": "GMC CCKW Cargo", "era": ["ww2_transport", "us_logistics"],
     "engine": "liberty_l12_engine", "days": 38, "cargo_cap": 5500},
    {"id": "zil157_cargo_truck", "name": "ZIL-157 Cargo", "era": ["cold_war_transport", "soviet_logistics"],
     "engine": "v2_diesel_engine", "days": 40, "cargo_cap": 4500},
    {"id": "unimog_transport_truck", "name": "Unimog 404", "era": ["cold_war_transport", "german_logistics"],
     "engine": "maybach_hl120_trm", "days": 36, "cargo_cap": 3000},
    {"id": "hemtt_transport_truck", "name": "M977 HEMTT", "era": ["modern_transport", "us_logistics", "twenty_twenties_logistics"],
     "engine": "caterpillar_c7_engine", "days": 48, "cargo_cap": 8000},
    {"id": "kamaz_transport_truck", "name": "Kamaz 5350", "era": ["modern_transport", "russian_logistics"],
     "engine": "v46_6m_diesel", "days": 45, "cargo_cap": 7500},
]

# Cargo ships per scenario era tag
CARGO_SHIPS: list[dict] = [
    # 1918
    {"id": "tramp_steamer_1918", "name": "Tramp Steamer", "era": ["naval_1918", "ww1_naval", "merchant_naval"],
     "hold": "merchant_full_cargo_hold", "engine": "ww1_merchant_steamer", "gun": "deck_gun_merchant_4inch",
     "cargo_cap": 12000, "armed_cap": 7000, "nation": ["merchant_naval_1918"]},
    {"id": "liberty_ship_1918", "name": "Design 1017 Cargo", "era": ["naval_1918", "us_naval_1918"],
     "hold": "merchant_full_cargo_hold", "engine": "ww1_merchant_steamer", "gun": "deck_gun_merchant_4inch",
     "cargo_cap": 10000, "armed_cap": 6000, "nation": ["us_naval_1918"]},
    # 1936
    {"id": "tramp_steamer_1936", "name": "Coastal Freighter", "era": ["naval_1936", "interwar_naval", "merchant_naval"],
     "hold": "merchant_full_cargo_hold", "engine": "liberty_ship_engine", "gun": "deck_gun_merchant_4inch",
     "cargo_cap": 14000, "armed_cap": 8000, "nation": ["merchant_naval_1936"]},
    {"id": "liberty_ship_1941", "name": "Liberty Ship", "era": ["ww2_naval", "us_naval_ww2", "merchant_naval"],
     "hold": "merchant_full_cargo_hold", "engine": "liberty_ship_engine", "gun": "ww1_4inch_qf_mk4",
     "cargo_cap": 18000, "armed_cap": 10000, "nation": ["us_naval_ww2", "merchant_naval"]},
    # 2026
    {"id": "container_ship_2026", "name": "Container Ship", "era": ["naval_2026", "twenty_twenties_naval", "merchant_naval"],
     "hold": "merchant_full_cargo_hold", "engine": "modern_container_ship_engine", "gun": None,
     "cargo_cap": 45000, "armed_cap": 28000, "nation": ["merchant_naval_2026"]},
    {"id": "armed_merchant_2026", "name": "Armed Merchant (Modular)", "era": ["naval_2026", "twenty_twenties_naval"],
     "hold": "merchant_armed_cargo_hold", "engine": "modern_container_ship_engine",
     "gun": "merchant_ascm_launcher", "cargo_cap": 25000, "armed_cap": 25000,
     "nation": ["merchant_naval_2026"], "aa": "nasams_launcher"},
]
# fmt: on


def land_transport(spec: dict) -> dict:
    return {
        "id": spec["id"],
        "name": spec["name"],
        "design_family": "generic_transport",
        "base_type": "Land",
        "size_category": "Light",
        "visual_archetype": "transport",
        "crew_required": 2,
        "base_training_level": 14,
        "max_experience_level": 90,
        "base_production_days": spec["days"],
        "base_stats": {
            "speed": 32, "reliability": 75, "fuel_consumption": 5,
            "supply_need": 8, "armor": 6, "hardness": 20,
            "cargo_capacity": spec["cargo_cap"],
        },
        "slots": {
            "Cargo": {"max": 1},
            "MainWeapon": {"max": 1},
            "Engine": {"max": 1},
            "Suspension": {"max": 1},
        },
        "module_loadout": {
            "Cargo": "standard_truck_cargo_bed",
            "Engine": spec["engine"],
            "Suspension": "truck_rocket_mount",
        },
        "unlock_tech": spec["era"] + ["transport", "logistics"],
        "can_mount_drones": False,
        "is_vehicle": True,
    }


def cargo_ship(spec: dict, armed: bool = False) -> dict:
    cap = spec["armed_cap"] if armed else spec["cargo_cap"]
    loadout = {
        "Cargo": spec["hold"] if armed else spec["hold"],
        "Engine": spec["engine"],
    }
    slots = {
        "Cargo": {"max": 1},
        "Engine": {"max": 1},
        "Sensors": {"max": 1},
    }
    if spec.get("gun"):
        slots["SecondaryWeapon"] = {"max": 1}
        if armed:
            loadout["SecondaryWeapon"] = spec["gun"]
    if armed and spec.get("aa"):
        slots["AntiAir"] = {"max": 1}
        loadout["AntiAir"] = spec["aa"]
    suffix = "_armed" if armed else "_transport"
    return {
        "id": spec["id"] + suffix,
        "name": spec["name"] + (" (Armed)" if armed else ""),
        "design_family": "merchant_naval",
        "base_type": "Naval",
        "size_category": "Medium",
        "visual_archetype": "cargo_ship",
        "crew_required": 45 if not armed else 65,
        "base_training_level": 18 if "1918" in spec["id"] else 24,
        "max_experience_level": 100,
        "base_production_days": 90 if "2026" not in spec["id"] else 110,
        "base_stats": {
            "speed": 16 if "2026" not in spec["id"] else 22,
            "reliability": 70 if not armed else 65,
            "fuel_consumption": 40 if not armed else 55,
            "supply_need": 50 if not armed else 75,
            "armor": 8 if not armed else 14,
            "deck_armor": 4,
            "hardness": 30 if not armed else 38,
            "cargo_capacity": cap,
        },
        "slots": slots,
        "module_loadout": loadout,
        "unlock_tech": spec["era"] + spec.get("nation", []),
        "can_mount_drones": False,
        "is_vehicle": True,
    }


def main() -> None:
    MODULES_DIR.mkdir(parents=True, exist_ok=True)
    TEMPLATES_DIR.mkdir(parents=True, exist_ok=True)
    existing_m = {p.stem for p in MODULES_DIR.glob("*.json")}
    existing_t = {p.stem for p in TEMPLATES_DIR.glob("*.json")}
    mc = tc = 0
    for mod in MODULES:
        if mod["id"] in existing_m:
            continue
        with (MODULES_DIR / f"{mod['id']}.json").open("w", encoding="utf-8") as f:
            json.dump(mod, f, indent=2, ensure_ascii=False)
            f.write("\n")
        mc += 1
    templates: list[dict] = []
    for spec in TRANSPORTS_LAND:
        templates.append(land_transport(spec))
    for spec in CARGO_SHIPS:
        templates.append(cargo_ship(spec, armed=False))
        if spec.get("gun"):
            templates.append(cargo_ship(spec, armed=True))
    for tpl in templates:
        if tpl["id"] in existing_t:
            continue
        with (TEMPLATES_DIR / f"{tpl['id']}.json").open("w", encoding="utf-8") as f:
            json.dump(tpl, f, indent=2, ensure_ascii=False)
            f.write("\n")
        tc += 1
    mods = {p.stem for p in MODULES_DIR.glob("*.json")}
    errs = []
    for tpl in templates:
        for slot, mid in tpl.get("module_loadout", {}).items():
            if mid and mid not in mods:
                errs.append(f"{tpl['id']}: {mid}")
    print(f"Transport/cargo: {mc} modules, {tc} templates. Missing refs: {len(errs)}")
    for e in errs:
        print(f"  ! {e}")


if __name__ == "__main__":
    main()
