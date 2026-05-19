#!/usr/bin/env python3
"""Pre-1940 helicopter and autogyro prototypes — experimental rotary-wing aviation."""

from __future__ import annotations

import json
from pathlib import Path

MODULES_DIR = Path(__file__).resolve().parents[1] / "data" / "modules"
TEMPLATES_DIR = Path(__file__).resolve().parents[1] / "data" / "unit_templates"

# fmt: off
MODULES: list[dict] = [
    {"id": "de_bothezat_rotor_system", "name": "de Bothezat Rotor System", "category": "Engine", "tier": 1,
     "reliability_bonus": -12, "fuel_efficiency": -8, "speed_bonus": 2,
     "cost": {"steel": 14, "aluminum": 4, "electronics": 2}, "production_time": 90,
     "special_flags": ["usa", "prototype", "pre_war", "helicopter", "experimental"],
     "description": "US Army 'Flying Octopus' 1922. Six-bladed rotor; barely controllable but proved vertical lift."},
    {"id": "cierva_autogyro_c30", "name": "Cierva C.30 Autogyro", "category": "Sensors", "tier": 2,
     "reliability_bonus": 4,
     "cost": {"steel": 6, "aluminum": 8, "electronics": 3}, "production_time": 55,
     "special_flags": ["uk", "spain", "autogyro", "thirties", "pre_war"],
     "description": "Autorotating wing with powered rotor spin-up. Not true helicopter but operational before WWII."},
    {"id": "breguet_dorand_gyro_laboratory", "name": "Breguet-Dorand Gyro Lab", "category": "Engine", "tier": 1,
     "reliability_bonus": -8, "fuel_efficiency": -6, "speed_bonus": 3,
     "cost": {"steel": 12, "aluminum": 6}, "production_time": 80,
     "special_flags": ["france", "prototype", "pre_war", "experimental"],
     "description": "French experimental gyroplane 1930s. Bridged autogyro and helicopter development."},
    {"id": "fw61_twin_intermeshing_rotor", "name": "Fw 61 Intermeshing Rotors", "category": "Engine", "tier": 2,
     "reliability_bonus": 2, "fuel_efficiency": 0, "speed_bonus": 8,
     "cost": {"steel": 10, "aluminum": 10, "electronics": 6}, "production_time": 70,
     "special_flags": ["germany", "prototype", "pre_war", "helicopter", "fw61"],
     "description": "Focke-Wulf Fw 61 twin-rotor system. First practical helicopter flights 1936–37."},
    {"id": "fw61_control_system", "name": "Fw 61 Cyclic Control", "category": "Sensors", "tier": 2,
     "reliability_bonus": 6,
     "cost": {"steel": 4, "electronics": 10, "aluminum": 4}, "production_time": 50,
     "special_flags": ["germany", "helicopter", "pre_war", "control_system"],
     "description": "Cyclic and collective pitch control proving helicopter maneuverability."},
    {"id": "vs300_sikorsky_single_rotor", "name": "VS-300 Single Rotor", "category": "Engine", "tier": 2,
     "reliability_bonus": 0, "fuel_efficiency": -4, "speed_bonus": 10,
     "cost": {"steel": 8, "aluminum": 12, "electronics": 8}, "production_time": 65,
     "special_flags": ["usa", "prototype", "pre_war", "sikorsky", "vs300"],
     "description": "Igor Sikorsky VS-300 1939. Single main rotor and tail rotor configuration."},
    {"id": "vs300_tail_rotor_anti_torque", "name": "VS-300 Tail Rotor", "category": "Sensors", "tier": 2,
     "reliability_bonus": 5,
     "cost": {"steel": 5, "aluminum": 6, "electronics": 5}, "production_time": 45,
     "special_flags": ["usa", "helicopter", "pre_war", "anti_torque"],
     "description": "Tail rotor anti-torque solution adopted by virtually all Western helicopters."},
    {"id": "kay_gyroglider_proto", "name": "Kay Gyroglider Proto", "category": "Engine", "tier": 1,
     "reliability_bonus": -6, "fuel_efficiency": 2, "speed_bonus": 4,
     "cost": {"steel": 5, "aluminum": 4}, "production_time": 40,
     "special_flags": ["uk", "prototype", "pre_war", "autogyro"],
     "description": "British 1930s gyroglider experiments. Tow-launched rotary-wing research."},
    {"id": "weir_w5_proto_engine", "name": "Weir W.5 Proto Engine", "category": "Engine", "tier": 2,
     "reliability_bonus": 2, "fuel_efficiency": 0, "speed_bonus": 6,
     "cost": {"steel": 8, "aluminum": 8}, "production_time": 55,
     "special_flags": ["uk", "prototype", "pre_war", "helicopter"],
     "description": "Early British helicopter prototype engine development parallel to Cierva."},
    {"id": "henri_coanda_rotor_blower", "name": "Coandă Rotor Blower", "category": "Engine", "tier": 1,
     "reliability_bonus": -10, "fuel_efficiency": -10, "speed_bonus": 5,
     "cost": {"steel": 10, "aluminum": 6, "electronics": 4}, "production_time": 60,
     "special_flags": ["romania", "france", "prototype", "pre_war", "experimental"],
     "description": "Henri Coandă 1910s rotorcraft concepts. Influential but not operationally successful."},
    {"id": "asw_autogyro_naval_proto", "name": "Naval Autogyro ASW Proto", "category": "Sensors", "tier": 2,
     "reliability_bonus": 3,
     "cost": {"steel": 6, "electronics": 8, "aluminum": 6}, "production_time": 48,
     "special_flags": ["uk", "naval", "prototype", "pre_war", "asw"],
     "description": "Royal Navy trials of autogyros for convoy spotting before true naval helicopters."},
    {"id": "bramo_323_drache_engine", "name": "BMW Bramo 323 (Fa 223)", "category": "Engine", "tier": 3,
     "reliability_bonus": 4, "fuel_efficiency": -6, "speed_bonus": 14,
     "cost": {"steel": 14, "aluminum": 12, "electronics": 6}, "production_time": 72,
     "special_flags": ["germany", "helicopter", "ww2", "fa223", "transport"],
     "description": "1,000 hp Bramo 323Q radial driving twin rotors via transmission. Fa 223 Drache powerplant."},
    {"id": "fa223_transverse_twin_rotor", "name": "Fa 223 Transverse Twin Rotor", "category": "Sensors", "tier": 3,
     "reliability_bonus": 8,
     "cost": {"steel": 12, "aluminum": 14, "electronics": 8}, "production_time": 65,
     "special_flags": ["germany", "helicopter", "ww2", "fa223", "transport"],
     "description": "Two 12 m rotors on outrigger booms. First production helicopter; crossed English Channel 1942."},
    {"id": "fa223_transport_cabin", "name": "Fa 223 Transport Cabin", "category": "Cargo", "tier": 3,
     "reliability_bonus": 5,
     "cost": {"steel": 10, "aluminum": 10, "electronics": 4}, "production_time": 55,
     "special_flags": ["germany", "helicopter", "ww2", "fa223", "cargo", "luftwaffe"],
     "description": "Enclosed cabin for troops, wounded, or 1,000+ kg cargo. Naval rescue and supply trials."},
]

HELO_LEGACY = {
    "speed": 42, "reliability": 50, "fuel_consumption": 14,
    "supply_need": 10, "armor": 4, "hardness": 8,
}

TEMPLATES: list[dict] = [
    {
        "id": "de_bothezat_flying_octopus",
        "name": "de Bothezat Flying Octopus",
        "design_family": "experimental_rotary_pre_war",
        "base_type": "Air",
        "size_category": "Medium",
        "visual_archetype": "helicopter",
        "crew_required": 1,
        "base_training_level": 15,
        "max_experience_level": 80,
        "base_production_days": 120,
        "base_stats": {**HELO_LEGACY, "speed": 28, "reliability": 35},
        "slots": {"Engine": {"max": 1}, "Sensors": {"max": 1}},
        "module_loadout": {"Engine": "de_bothezat_rotor_system", "Sensors": "de_bothezat_rotor_system"},
        "unlock_tech": ["rotary_wing_experiments", "pre_war_aviation", "prototype"],
        "can_mount_drones": False,
        "is_vehicle": True,
    },
    {
        "id": "cierva_c30_autogyro",
        "name": "Cierva C.30 Autogyro",
        "design_family": "experimental_rotary_pre_war",
        "base_type": "Air",
        "size_category": "Light",
        "visual_archetype": "helicopter",
        "crew_required": 1,
        "base_training_level": 22,
        "max_experience_level": 90,
        "base_production_days": 55,
        "base_stats": {**HELO_LEGACY, "speed": 55, "reliability": 62},
        "slots": {"Engine": {"max": 1}, "Sensors": {"max": 1}},
        "module_loadout": {"Engine": "wasp_r1340_carrier_scout", "Sensors": "cierva_autogyro_c30"},
        "unlock_tech": ["autogyro", "pre_war_aviation", "uk_aviation"],
        "can_mount_drones": False,
        "is_vehicle": True,
    },
    {
        "id": "fw61_helicopter",
        "name": "Focke-Wulf Fw 61",
        "design_family": "experimental_rotary_pre_war",
        "base_type": "Air",
        "size_category": "Light",
        "visual_archetype": "helicopter",
        "crew_required": 1,
        "base_training_level": 28,
        "max_experience_level": 95,
        "base_production_days": 75,
        "base_stats": {**HELO_LEGACY, "speed": 58, "reliability": 58},
        "slots": {"Engine": {"max": 1}, "Sensors": {"max": 1}},
        "module_loadout": {"Engine": "fw61_twin_intermeshing_rotor", "Sensors": "fw61_control_system"},
        "unlock_tech": ["helicopter", "pre_war_aviation", "german_aviation", "prototype"],
        "can_mount_drones": False,
        "is_vehicle": True,
    },
    {
        "id": "sikorsky_vs300",
        "name": "Sikorsky VS-300",
        "design_family": "experimental_rotary_pre_war",
        "base_type": "Air",
        "size_category": "Light",
        "visual_archetype": "helicopter",
        "crew_required": 1,
        "base_training_level": 26,
        "max_experience_level": 95,
        "base_production_days": 70,
        "base_stats": {**HELO_LEGACY, "speed": 52, "reliability": 55},
        "slots": {"Engine": {"max": 1}, "Sensors": {"max": 1}},
        "module_loadout": {"Engine": "vs300_sikorsky_single_rotor", "Sensors": "vs300_tail_rotor_anti_torque"},
        "unlock_tech": ["helicopter", "pre_war_aviation", "us_aviation", "prototype"],
        "can_mount_drones": False,
        "is_vehicle": True,
    },
    {
        "id": "breguet_dorand_gyrolab",
        "name": "Breguet-Dorand Gyroplane",
        "design_family": "experimental_rotary_pre_war",
        "base_type": "Air",
        "size_category": "Medium",
        "visual_archetype": "helicopter",
        "crew_required": 1,
        "base_training_level": 18,
        "max_experience_level": 85,
        "base_production_days": 85,
        "base_stats": {**HELO_LEGACY, "speed": 45, "reliability": 42},
        "slots": {"Engine": {"max": 1}, "Sensors": {"max": 1}},
        "module_loadout": {"Engine": "breguet_dorand_gyro_laboratory", "Sensors": "breguet_dorand_gyro_laboratory"},
        "unlock_tech": ["rotary_wing_experiments", "french_aviation", "prototype"],
        "can_mount_drones": False,
        "is_vehicle": True,
    },
    {
        "id": "weir_w5_prototype",
        "name": "Weir W.5 Prototype",
        "design_family": "experimental_rotary_pre_war",
        "base_type": "Air",
        "size_category": "Light",
        "visual_archetype": "helicopter",
        "crew_required": 1,
        "base_training_level": 20,
        "max_experience_level": 88,
        "base_production_days": 65,
        "base_stats": HELO_LEGACY,
        "slots": {"Engine": {"max": 1}, "Sensors": {"max": 1}},
        "module_loadout": {"Engine": "weir_w5_proto_engine", "Sensors": "cierva_autogyro_c30"},
        "unlock_tech": ["helicopter", "uk_aviation", "prototype"],
        "can_mount_drones": False,
        "is_vehicle": True,
    },
    {
        "id": "coanda_rotorcraft_proto",
        "name": "Coandă Rotorcraft (Proto)",
        "design_family": "experimental_rotary_pre_war",
        "base_type": "Air",
        "size_category": "Light",
        "visual_archetype": "helicopter",
        "crew_required": 1,
        "base_training_level": 12,
        "max_experience_level": 70,
        "base_production_days": 100,
        "base_stats": {**HELO_LEGACY, "speed": 35, "reliability": 30},
        "slots": {"Engine": {"max": 1}},
        "module_loadout": {"Engine": "henri_coanda_rotor_blower"},
        "unlock_tech": ["rotary_wing_experiments", "prototype", "pre_war_aviation"],
        "can_mount_drones": False,
        "is_vehicle": True,
    },
    {
        "id": "naval_autogyro_proto",
        "name": "Naval Autogyro (Proto)",
        "design_family": "experimental_rotary_pre_war",
        "base_type": "Air",
        "size_category": "Light",
        "visual_archetype": "helicopter",
        "crew_required": 2,
        "base_training_level": 24,
        "max_experience_level": 90,
        "base_production_days": 60,
        "base_stats": {**HELO_LEGACY, "speed": 50},
        "slots": {"Engine": {"max": 1}, "Sensors": {"max": 1}},
        "module_loadout": {"Engine": "wasp_r1340_carrier_scout", "Sensors": "asw_autogyro_naval_proto"},
        "unlock_tech": ["naval_aviation", "autogyro", "pre_war_aviation", "prototype"],
        "can_mount_drones": False,
        "is_vehicle": True,
    },
    {
        "id": "fa223_drache",
        "name": "Fa 223 Drache",
        "design_family": "german_rotary_ww2",
        "base_type": "Air",
        "size_category": "Heavy",
        "visual_archetype": "helicopter",
        "crew_required": 2,
        "base_training_level": 32,
        "max_experience_level": 100,
        "base_production_days": 95,
        "base_stats": {
            **HELO_LEGACY,
            "speed": 68,
            "reliability": 62,
            "fuel_consumption": 22,
            "supply_need": 16,
            "armor": 8,
        },
        "slots": {"Engine": {"max": 1}, "Sensors": {"max": 1}, "Cargo": {"max": 1}},
        "module_loadout": {
            "Engine": "bramo_323_drache_engine",
            "Sensors": "fa223_transverse_twin_rotor",
            "Cargo": "fa223_transport_cabin",
        },
        "unlock_tech": ["helicopter", "german_aviation", "ww2_aviation", "transport_helicopter"],
        "can_mount_drones": False,
        "is_vehicle": True,
    },
    {
        "id": "kay_gyroglider",
        "name": "Kay Gyroglider",
        "design_family": "experimental_rotary_pre_war",
        "base_type": "Air",
        "size_category": "Light",
        "visual_archetype": "helicopter",
        "crew_required": 1,
        "base_training_level": 16,
        "max_experience_level": 80,
        "base_production_days": 45,
        "base_stats": {**HELO_LEGACY, "speed": 48},
        "slots": {"Engine": {"max": 1}},
        "module_loadout": {"Engine": "kay_gyroglider_proto"},
        "unlock_tech": ["autogyro", "uk_aviation", "prototype"],
        "can_mount_drones": False,
        "is_vehicle": True,
    },
]


def main() -> None:
    MODULES_DIR.mkdir(parents=True, exist_ok=True)
    TEMPLATES_DIR.mkdir(parents=True, exist_ok=True)
    existing_m = {p.stem for p in MODULES_DIR.glob("*.json")}
    existing_t = {p.stem for p in TEMPLATES_DIR.glob("*.json")}
    mc = tc = 0
    for mod in MODULES:
        if mod["id"] in existing_m:
            continue
        path = MODULES_DIR / f"{mod['id']}.json"
        with path.open("w", encoding="utf-8") as f:
            json.dump(mod, f, indent=2, ensure_ascii=False)
            f.write("\n")
        mc += 1
        print(f"  + module {mod['id']}.json")
    for tpl in TEMPLATES:
        if tpl["id"] in existing_t:
            continue
        path = TEMPLATES_DIR / f"{tpl['id']}.json"
        with path.open("w", encoding="utf-8") as f:
            json.dump(tpl, f, indent=2, ensure_ascii=False)
            f.write("\n")
        tc += 1
        print(f"  + template {tpl['id']}.json")
    mods = {p.stem for p in MODULES_DIR.glob("*.json")}
    errs = []
    for p in TEMPLATES_DIR.glob("*.json"):
        d = json.loads(p.read_text())
        for slot, mid in d.get("module_loadout", {}).items():
            if mid not in mods:
                errs.append(f"{p.name}: {mid}")
    print(f"\nEarly helicopter: {mc} modules, {tc} templates. Missing refs: {len(errs)}")
    for e in errs:
        print(f"  ! {e}")


if __name__ == "__main__":
    main()
