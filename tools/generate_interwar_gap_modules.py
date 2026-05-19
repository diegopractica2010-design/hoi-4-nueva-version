#!/usr/bin/env python3
"""Fill interwar / late-WWII module gaps referenced by unit templates."""

from __future__ import annotations

import json
from pathlib import Path

MODULES_DIR = Path(__file__).resolve().parents[1] / "data" / "modules"

MODULES: list[dict] = [
    {"id": "kwk_42_75mm_gun", "name": "7.5 cm KwK 42 L/70", "category": "MainWeapon", "tier": 3,
     "soft_attack": 52, "hard_attack": 50, "piercing": 108, "air_attack": 5,
     "cost": {"steel": 22, "explosives": 3}, "production_time": 72,
     "special_flags": ["excellent_ap", "late_war"],
     "description": "Panther Ausf. G main gun. High-velocity 75 mm; outperforms many 88 mm guns at range."},
    {"id": "qf_75mm_roqf", "name": "75 mm ROQF Mk V", "category": "MainWeapon", "tier": 2,
     "soft_attack": 46, "hard_attack": 34, "piercing": 70, "air_attack": 4,
     "cost": {"steel": 14}, "production_time": 52,
     "special_flags": ["decent_ap"],
     "description": "Churchill Mk VII infantry tank gun. Balanced HE and AP for infantry support."},
    {"id": "maybach_hl120_trm", "name": "Maybach HL 120 TRM", "category": "Engine", "tier": 2,
     "reliability_bonus": 2, "fuel_efficiency": 1, "speed_bonus": 5,
     "cost": {"steel": 12, "rubber": 2}, "production_time": 42,
     "description": "300 hp engine for Panzer III and early Panzer IV. Adequate for medium tanks."},
    {"id": "renault_4cyl_ft_engine", "name": "Renault 4-cyl FT Engine", "category": "Engine", "tier": 1,
     "reliability_bonus": 4, "fuel_efficiency": 6, "speed_bonus": 2,
     "cost": {"steel": 5}, "production_time": 25,
     "special_flags": ["ww1", "light_tank"],
     "description": "39 hp gasoline engine on Renault FT. Slow but simple and maintainable."},
    {"id": "daimler_knight_engine", "name": "Daimler-Knight Sleeve Valve", "category": "Engine", "tier": 1,
     "reliability_bonus": -4, "fuel_efficiency": 2, "speed_bonus": 3,
     "cost": {"steel": 8}, "production_time": 35,
     "special_flags": ["ww1", "heavy_tank"],
     "description": "Mark IV and early British tank engine. Underpowered and mechanically delicate."},
    {"id": "packard_merlin_v1650", "name": "Packard Merlin V-1650", "category": "Engine", "tier": 3,
     "reliability_bonus": 9, "fuel_efficiency": 6, "speed_bonus": 15,
     "cost": {"steel": 12, "aluminum": 16}, "production_time": 56,
     "special_flags": ["fighter_powerplant"],
     "description": "License-built Merlin for P-51D Mustang. Excellent high-altitude fighter performance."},
    {"id": "us_parsons_turbine", "name": "Parsons Steam Turbine Set", "category": "Engine", "tier": 2,
     "reliability_bonus": 6, "fuel_efficiency": -6, "speed_bonus": 8,
     "cost": {"steel": 45, "copper": 12}, "production_time": 120,
     "special_flags": ["naval", "steam"],
     "description": "Representative U.S./RN destroyer and cruiser propulsion plant."},
    {"id": "german_wagner_turbine", "name": "Wagner High-Pressure Turbine", "category": "Engine", "tier": 3,
     "reliability_bonus": 2, "fuel_efficiency": -8, "speed_bonus": 10,
     "cost": {"steel": 52, "chromium": 6}, "production_time": 140,
     "special_flags": ["naval", "steam"],
     "description": "Bismarck-class battleship turbine plant. Powerful but complex."},
    {"id": "ijn_kampon_turbine", "name": "Kampon Turbine Set", "category": "Engine", "tier": 3,
     "reliability_bonus": 4, "fuel_efficiency": -7, "speed_bonus": 11,
     "cost": {"steel": 48, "chromium": 5}, "production_time": 135,
     "special_flags": ["naval", "steam", "japan"],
     "description": "Imperial Japanese Navy high-performance steam plant for destroyers and battleships."},
    {"id": "christie_suspension_bt", "name": "Christie Suspension Package", "category": "Suspension", "tier": 2,
     "reliability_bonus": -2, "fuel_efficiency": 0, "speed_bonus": 8,
     "cost": {"steel": 6, "rubber": 4}, "production_time": 28,
     "special_flags": ["interwar", "fast_tank"],
     "description": "Christie-derived suspension on BT-7 and T-34 prototypes. Enables high road speed."},
    {"id": "m1897_towed_carriage", "name": "M1897 Towed Carriage", "category": "Suspension", "tier": 1,
     "reliability_bonus": 5, "speed_bonus": 0,
     "cost": {"steel": 6, "rubber": 2}, "production_time": 22,
     "special_flags": ["artillery", "towed"],
     "description": "Standard split-trail carriage for divisional field guns."},
]


def main() -> None:
    MODULES_DIR.mkdir(parents=True, exist_ok=True)
    existing = {p.name for p in MODULES_DIR.glob("*.json")}
    created = 0
    for mod in MODULES:
        path = MODULES_DIR / f"{mod['id']}.json"
        if path.name in existing:
            continue
        with path.open("w", encoding="utf-8") as f:
            json.dump(mod, f, indent=2, ensure_ascii=False)
            f.write("\n")
        created += 1
        print(f"  + {path.name}")
    print(f"Interwar gap modules: {created} created.")


if __name__ == "__main__":
    main()
