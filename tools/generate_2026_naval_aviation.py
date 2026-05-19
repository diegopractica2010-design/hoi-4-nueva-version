#!/usr/bin/env python3
"""2026 naval aviation: carrier ships, air wings, and helicopter ASW for scenario nations."""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MODULES_DIR = ROOT / "data" / "modules"
TEMPLATES_DIR = ROOT / "data" / "unit_templates"

T2026 = ["naval_2026", "twenty_twenties_naval"]

# fmt: off
MODULES: list[dict] = [
    # ─── India ───────────────────────────────────────────────────────────────────
    {"id": "mig29k_india_avionics", "name": "MiG-29K India Avionics", "category": "Sensors", "tier": 7,
     "reliability_bonus": 10,
     "cost": {"steel": 10, "electronics": 48, "aluminum": 14, "rare_earths": 8}, "production_time": 95,
     "special_flags": ["india", "twenty_twenties", "carrier_capable", "mig29k_in", "uttam"],
     "description": "Indian MiG-29K with Zhuk-ME radar, Indian ECM, and compatibility with Astra missiles."},
    {"id": "brahmos_air_launched", "name": "BrahMos-A", "category": "MainWeapon", "tier": 7,
     "soft_attack": 50, "hard_attack": 62, "piercing": 55, "anti_ship": 105, "air_attack": 8,
     "cost": {"steel": 12, "electronics": 35, "explosives": 28}, "production_time": 88,
     "special_flags": ["india", "russia_joint", "anti_ship", "twenty_twenties"],
     "description": "Air-launched BrahMos for Su-30MKI and planned naval strike roles from Vikrant."},
    {"id": "tejas_naval_proto_package", "name": "Tejas Naval Proto", "category": "Engine", "tier": 6,
     "reliability_bonus": 4, "fuel_efficiency": 8, "speed_bonus": 28,
     "cost": {"steel": 14, "aluminum": 28, "titanium": 10, "electronics": 22}, "production_time": 100,
     "special_flags": ["india", "prototype", "carrier_capable", "tejas_n"],
     "description": "Naval LCA Mk2 prototype with strengthened landing gear and carrier approach avionics."},
    {"id": "ins_vikrant_carrier_core", "name": "INS Vikrant (R11) Core", "category": "Cargo", "tier": 7,
     "reliability_bonus": 6,
     "cost": {"steel": 110, "electronics": 40, "aluminum": 35}, "production_time": 220,
     "special_flags": ["india", "carrier", "twenty_twenties", "ski_jump"],
     "description": "Indigenous STOBAR carrier commissioned 2022. Operates MiG-29K and future Tejas N."},
    {"id": "ins_vikramaditya_core", "name": "INS Vikramaditya Core", "category": "Cargo", "tier": 6,
     "reliability_bonus": 4,
     "cost": {"steel": 95, "electronics": 32, "aluminum": 28}, "production_time": 200,
     "special_flags": ["india", "carrier", "ski_jump", "ex_kiev"],
     "description": "Refitted Kiev-class carrier. Primary Indian carrier aviation platform before Vikrant."},

    # ─── Italy / Spain / Japan (STOVL) ───────────────────────────────────────────
    {"id": "cavour_stovl_deck", "name": "Cavour STOVL Deck", "category": "Cargo", "tier": 7,
     "reliability_bonus": 5,
     "cost": {"steel": 100, "electronics": 38, "aluminum": 30}, "production_time": 210,
     "special_flags": ["italy", "carrier", "stovl", "f35b", "twenty_twenties"],
     "description": "Italian Cavour light carrier configured for F-35B and EH101 ASW helicopters."},
    {"id": "juan_carlos_ski_jump", "name": "Juan Carlos I Ski-Jump", "category": "Cargo", "tier": 6,
     "reliability_bonus": 5,
     "cost": {"steel": 85, "electronics": 30, "aluminum": 25}, "production_time": 190,
     "special_flags": ["spain", "lhd", "stovl", "twenty_twenties"],
     "description": "Strategic projection ship with ski-jump for AV-8B and future F-35B operations."},
    {"id": "izumo_stovl_upgrade", "name": "Izumo STOVL Upgrade", "category": "Cargo", "tier": 7,
     "reliability_bonus": 6,
     "cost": {"steel": 90, "electronics": 42, "aluminum": 32}, "production_time": 200,
     "special_flags": ["japan", "carrier", "stovl", "f35b", "twenty_twenties"],
     "description": "JS Izumo/Kaga conversion for F-35B operations. Japan's return to fixed-wing carrier aviation."},

    # ─── Major CATOBAR / fleet carriers ──────────────────────────────────────────
    {"id": "charles_de_gaulle_core", "name": "Charles de Gaulle Core", "category": "Cargo", "tier": 7,
     "reliability_bonus": 8,
     "cost": {"steel": 120, "electronics": 45, "aluminum": 35, "uranium": 8}, "production_time": 240,
     "special_flags": ["france", "carrier", "nuclear", "catapult", "twenty_twenties"],
     "description": "Only non-U.S. nuclear carrier. Operates Rafale M and E-2C Hawkeye."},
    {"id": "queen_elizabeth_cv_core", "name": "Queen Elizabeth CV Core", "category": "Cargo", "tier": 7,
     "reliability_bonus": 7,
     "cost": {"steel": 115, "electronics": 42, "aluminum": 32}, "production_time": 230,
     "special_flags": ["uk", "carrier", "stovl", "f35b", "twenty_twenties"],
     "description": "Twin-island STOVL supercarrier. F-35B Lightning II air wing."},
    {"id": "nimitz_class_core", "name": "Nimitz-class Core", "category": "Cargo", "tier": 8,
     "reliability_bonus": 10,
     "cost": {"steel": 140, "electronics": 50, "aluminum": 40, "uranium": 12}, "production_time": 280,
     "special_flags": ["usa", "carrier", "nuclear", "catapult", "twenty_twenties"],
     "description": "U.S. supercarrier hull. CATOBAR ops with Super Hornet, Growler, and E-2D."},
    {"id": "ford_class_core", "name": "Gerald R. Ford Core", "category": "Cargo", "tier": 8,
     "reliability_bonus": 12,
     "cost": {"steel": 150, "electronics": 65, "aluminum": 45, "uranium": 14}, "production_time": 300,
     "special_flags": ["usa", "carrier", "emals", "twenty_twenties"],
     "description": "EMALS catapult and advanced arresting gear. Next-gen U.S. carrier air wing host."},
    {"id": "admiral_kuznetsov_core", "name": "Admiral Kuznetsov Core", "category": "Cargo", "tier": 6,
     "reliability_bonus": 2,
     "cost": {"steel": 100, "electronics": 28, "aluminum": 25}, "production_time": 220,
     "special_flags": ["russia", "carrier", "ski_jump", "twenty_twenties"],
     "description": "Russian heavy aviation cruiser. Su-33 and MiG-29KR operations; chronic maintenance issues."},
    {"id": "liaoning_carrier_core", "name": "Liaoning Carrier Core", "category": "Cargo", "tier": 6,
     "reliability_bonus": 6,
     "cost": {"steel": 95, "electronics": 35, "aluminum": 28}, "production_time": 210,
     "special_flags": ["china", "carrier", "ski_jump", "twenty_twenties"],
     "description": "Refitted Varyag. China's first operational carrier aviation platform."},
    {"id": "shandong_carrier_core", "name": "Shandong Carrier Core", "category": "Cargo", "tier": 7,
     "reliability_bonus": 8,
     "cost": {"steel": 105, "electronics": 40, "aluminum": 32}, "production_time": 225,
     "special_flags": ["china", "carrier", "ski_jump", "indigenous", "twenty_twenties"],
     "description": "Indigenous Type 002 carrier. J-15 air wing with improved island and sensors."},

    # ─── Helicopter / LHD carriers (2026 nations) ────────────────────────────────
    {"id": "mh60r_asw_helo_suite", "name": "MH-60R ASW Suite", "category": "Sensors", "tier": 6,
     "reliability_bonus": 8,
     "cost": {"steel": 8, "electronics": 38, "aluminum": 12}, "production_time": 75,
     "special_flags": ["usa", "australia", "india", "asw", "helicopter", "twenty_twenties"],
     "description": "Romeo Seahawk dipping sonar, torpedoes, and surface search radar. Standard Western ASW helo."},
    {"id": "nh90_nato_naval_helo", "name": "NH90 NFH Suite", "category": "Sensors", "tier": 6,
     "reliability_bonus": 7,
     "cost": {"steel": 8, "electronics": 35, "aluminum": 14}, "production_time": 72,
     "special_flags": ["france", "germany", "italy", "norway", "asw", "helicopter"],
     "description": "NATO frigate and carrier ASW helicopter. Used on European LHD and destroyers."},
    {"id": "ka27_helix_asw_suite", "name": "Ka-27 Helix ASW", "category": "Sensors", "tier": 5,
     "reliability_bonus": 6,
     "cost": {"steel": 10, "electronics": 28, "aluminum": 10}, "production_time": 68,
     "special_flags": ["russia", "india", "china", "asw", "helicopter"],
     "description": "Soviet-design naval helicopter on Russian and Indian carriers and destroyers."},
    {"id": "z18f_asw_helo_suite", "name": "Z-18F ASW Suite", "category": "Sensors", "tier": 6,
     "reliability_bonus": 7,
     "cost": {"steel": 9, "electronics": 36, "aluminum": 12}, "production_time": 70,
     "special_flags": ["china", "asw", "helicopter", "twenty_twenties"],
     "description": "Chinese ASW helicopter derived from Mi-8 lineage. Operates from Type 055 and carriers."},
    {"id": "aw159_wildcat_asw", "name": "AW159 Wildcat ASW", "category": "Sensors", "tier": 6,
     "reliability_bonus": 8,
     "cost": {"steel": 7, "electronics": 32, "aluminum": 10}, "production_time": 65,
     "special_flags": ["uk", "south_korea", "philippines", "asw", "helicopter"],
     "description": "Light naval helicopter for frigates and smaller carriers. Sea Skua and torpedo capable."},
    {"id": "tcg_anadolu_uav_deck", "name": "TCG Anadolu UAV Deck", "category": "Cargo", "tier": 6,
     "reliability_bonus": 5,
     "cost": {"steel": 75, "electronics": 35, "aluminum": 22}, "production_time": 175,
     "special_flags": ["turkey", "lhd", "uav_carrier", "twenty_twenties"],
     "description": "Amphibious assault ship operating TB2/TB3 Bayraktar drones without fixed-wing fighters."},
    {"id": "atlantica_helo_carrier", "name": "NAe Atlântica Layout", "category": "Cargo", "tier": 5,
     "reliability_bonus": 4,
     "cost": {"steel": 60, "electronics": 22, "aluminum": 18}, "production_time": 150,
     "special_flags": ["brazil", "helicopter_carrier", "twenty_twenties"],
     "description": "Former HMS Ocean configured for Brazilian ASW and assault helicopters."},
    {"id": "dokdo_lph_core", "name": "Dokdo-class LPH Core", "category": "Cargo", "tier": 6,
     "reliability_bonus": 6,
     "cost": {"steel": 70, "electronics": 28, "aluminum": 20}, "production_time": 165,
     "special_flags": ["south_korea", "lph", "twenty_twenties"],
     "description": "ROK amphibious assault ship with helicopter assault group; no fixed-wing carrier."},
    {"id": "canberra_lhd_core", "name": "Canberra LHD Core", "category": "Cargo", "tier": 6,
     "reliability_bonus": 7,
     "cost": {"steel": 80, "electronics": 30, "aluminum": 22}, "production_time": 170,
     "special_flags": ["australia", "lhd", "twenty_twenties"],
     "description": "Spanish-designed LHD for RAN. MH-60R and MRH90; F-35B discussed but not adopted by 2026."},
    {"id": "mistral_lhd_core", "name": "Mistral-class LHD Core", "category": "Cargo", "tier": 5,
     "reliability_bonus": 5,
     "cost": {"steel": 65, "electronics": 24, "aluminum": 18}, "production_time": 155,
     "special_flags": ["egypt", "france", "lhd", "helicopter"],
     "description": "Helicopter assault ship (Egypt's Gamal Abdel Nasser). No fixed-wing aviation."},

    # ─── Missing SAM / weapons referenced by templates ───────────────────────────
    {"id": "astra_mk1_missile", "name": "Astra Mk I", "category": "MainWeapon", "tier": 6,
     "soft_attack": 10, "hard_attack": 8, "air_attack": 78, "anti_air": 74,
     "cost": {"steel": 5, "electronics": 32, "explosives": 8}, "production_time": 62,
     "special_flags": ["india", "air_to_air", "twenty_twenties"],
     "description": "Indian BVR AAM for Tejas and MiG-29. Indigenous alternative to R-77 imports."},
    {"id": "barak8_sam", "name": "Barak-8 (MR-SAM)", "category": "AntiAir", "tier": 7,
     "soft_attack": 12, "hard_attack": 10, "air_attack": 85, "anti_air": 88,
     "cost": {"steel": 14, "electronics": 42, "explosives": 12}, "production_time": 90,
     "special_flags": ["india", "israel", "sam", "naval", "twenty_twenties"],
     "description": "Joint Indo-Israeli medium-range naval SAM. Equips Kolkata and Vikrant classes."},
    {"id": "aster30_sam", "name": "Aster 30", "category": "AntiAir", "tier": 7,
     "soft_attack": 14, "hard_attack": 12, "air_attack": 88, "anti_air": 90,
     "cost": {"steel": 12, "electronics": 45, "explosives": 14}, "production_time": 92,
     "special_flags": ["france", "italy", "uk", "sam", "naval", "twenty_twenties"],
     "description": "European naval area-defense missile. PAAMS on Horizon, FREMM, and carriers."},
    {"id": "sea_viper_sam", "name": "Sea Viper (PAAMS)", "category": "AntiAir", "tier": 7,
     "soft_attack": 14, "hard_attack": 12, "air_attack": 90, "anti_air": 92,
     "cost": {"steel": 14, "electronics": 48, "explosives": 14}, "production_time": 95,
     "special_flags": ["uk", "sam", "naval", "twenty_twenties"],
     "description": "Royal Navy PAAMS on Type 45 and Queen Elizabeth escort doctrine."},
    {"id": "bayraktar_tb2_package", "name": "Bayraktar TB2 Package", "category": "Sensors", "tier": 5,
     "reliability_bonus": 6,
     "cost": {"steel": 4, "electronics": 35, "aluminum": 8}, "production_time": 55,
     "special_flags": ["turkey", "uav", "naval", "twenty_twenties"],
     "description": "MALE UCAV operated from TCG Anadolu. Maritime surveillance and light strike."},
    {"id": "chakri_naruebet_core", "name": "Chakri Naruebet Layout", "category": "Cargo", "tier": 4,
     "reliability_bonus": 3,
     "cost": {"steel": 45, "electronics": 15, "aluminum": 12}, "production_time": 120,
     "special_flags": ["thailand", "helicopter_carrier", "twenty_twenties"],
     "description": "Small Spanish-built STOVL carrier. Harrier retired; operates helicopters only."},
    {"id": "halifax_asw_helo", "name": "CH-148 Cyclone ASW", "category": "Sensors", "tier": 6,
     "reliability_bonus": 7,
     "cost": {"steel": 8, "electronics": 36, "aluminum": 12}, "production_time": 72,
     "special_flags": ["canada", "asw", "helicopter", "twenty_twenties"],
     "description": "Canadian naval helicopter for Halifax-class frigates."},
]

# Naval ship template helper
def naval_tpl(
    id_: str, name: str, family: str, cargo: str, sensors: str, antiair: str,
    unlock: list[str], size: str = "Heavy", days: int = 220, training: int = 34,
    stats: dict | None = None,
) -> dict:
    base_stats = stats or {
        "speed": 28, "reliability": 75, "fuel_consumption": 95,
        "supply_need": 120, "armor": 50, "deck_armor": 38, "hardness": 70,
    }
    return {
        "id": id_, "name": name, "design_family": family, "base_type": "Naval",
        "size_category": size, "visual_archetype": "carrier",
        "crew_required": 2200, "base_training_level": training,
        "max_experience_level": 100, "base_production_days": days,
        "base_stats": base_stats,
        "slots": {"Cargo": {"max": 1}, "Sensors": {"max": 2}, "AntiAir": {"max": 2}},
        "module_loadout": {"Cargo": cargo, "Sensors": sensors, "AntiAir": antiair},
        "unlock_tech": unlock, "can_mount_drones": False, "is_vehicle": True,
    }


def air_tpl(
    id_: str, name: str, family: str, archetype: str, loadout: dict,
    unlock: list[str], stats: dict | None = None, crew: int = 1, days: int = 80, training: int = 36,
) -> dict:
    return {
        "id": id_, "name": name, "design_family": family, "base_type": "Air",
        "size_category": "Medium", "visual_archetype": archetype,
        "crew_required": crew, "base_training_level": training,
        "max_experience_level": 100, "base_production_days": days,
        "base_stats": stats or {
            "speed": 102, "reliability": 82, "fuel_consumption": 26,
            "supply_need": 20, "armor": 18, "hardness": 30,
        },
        "slots": {
            "MainWeapon": {"max": 2}, "SecondaryWeapon": {"max": 1},
            "Engine": {"max": 1}, "Sensors": {"max": 1},
        },
        "module_loadout": loadout,
        "unlock_tech": unlock, "can_mount_drones": False, "is_vehicle": True,
    }


JET_MOD = {
    "speed": 102, "reliability": 82, "fuel_consumption": 26,
    "supply_need": 20, "armor": 18, "hardness": 30,
}

TEMPLATES: list[dict] = [
    # ─── WWII follow-ups (if not already from carrier generator) ───────────────
    # (skipped at runtime if exists)

    # ─── India · aircraft & carriers ───────────────────────────────────────────
    air_tpl("mig29k_indian_navy", "MiG-29K (Indian Navy)", "indian_carrier_air_2026", "fighter",
            {"MainWeapon": "r77_1_adder", "SecondaryWeapon": "brahmos_air_launched",
             "Engine": "rd33mk_mig29k", "Sensors": "mig29k_india_avionics"},
            T2026 + ["indian_naval_aviation", "vikrant_air_wing", "vikramaditya_air_wing"], crew=1, days=88),
    air_tpl("tejas_n_planned", "Tejas N (Planned)", "indian_carrier_air_2026", "fighter",
            {"MainWeapon": "astra_mk1_missile", "Engine": "tejas_naval_proto_package",
             "Sensors": "carrier_operations_kit"},
            T2026 + ["indian_naval_aviation", "prototype", "vikrant_air_wing"],
            stats={**JET_MOD, "reliability": 70}, days=105, training=32),
    naval_tpl("ins_vikrant_carrier", "INS Vikrant", "indian_naval_2026", "ins_vikrant_carrier_core",
              "mig29k_india_avionics", "barak8_sam", T2026 + ["indian_carriers_2026"], days=240, training=35),
    naval_tpl("ins_vikramaditya_carrier", "INS Vikramaditya", "indian_naval_2026", "ins_vikramaditya_core",
              "type055_destroyer_vls", "hq9b_sam", T2026 + ["indian_carriers_2026"], days=220, training=33,
              stats={"speed": 29, "reliability": 68, "fuel_consumption": 90, "supply_need": 110,
                     "armor": 45, "deck_armor": 32, "hardness": 65}),

    # ─── Italy / Spain / Japan · STOVL ─────────────────────────────────────────
    air_tpl("f35b_cavour", "F-35B (Cavour)", "italian_carrier_air_2026", "fighter",
            {"MainWeapon": "aim120d_amraam", "Engine": "pratt_f135_engine", "Sensors": "f35b_stovl_package"},
            T2026 + ["italian_naval_aviation", "cavour_air_wing"]),
    naval_tpl("cavour_class_carrier", "ITS Cavour", "italian_naval_2026", "cavour_stovl_deck",
              "aesa_radar_gen1", "aster30_sam", T2026 + ["italian_carriers_2026"], size="Medium", days=210),
    air_tpl("av8b_matador", "AV-8B Matador II+", "spanish_naval_aviation_2026", "fighter",
            {"MainWeapon": "aim9x_sidewinder", "Engine": "av8b_harrier_ii_engine",
             "Sensors": "carrier_operations_kit"},
            T2026 + ["spanish_naval_aviation", "juan_carlos_air_wing"], days=75),
    air_tpl("f35b_spain_planned", "F-35B (Spain Planned)", "spanish_naval_aviation_2026", "fighter",
            {"MainWeapon": "aim120d_amraam", "Engine": "pratt_f135_engine", "Sensors": "f35b_stovl_package"},
            T2026 + ["spanish_naval_aviation", "planned", "juan_carlos_air_wing"], days=115),
    naval_tpl("juan_carlos_lhd", "LHD Juan Carlos I", "spanish_naval_2026", "juan_carlos_ski_jump",
              "aesa_radar_gen1", "meteor_missile", T2026 + ["spanish_amphibious_2026"], size="Medium", days=185),
    air_tpl("f35b_jsdf_carrier", "F-35B (JASDF Carrier)", "japanese_carrier_air_2026", "fighter",
            {"MainWeapon": "aim120d_amraam", "Engine": "pratt_f135_engine", "Sensors": "f35b_stovl_package"},
            T2026 + ["japanese_naval_aviation", "izumo_air_wing"]),
    naval_tpl("izumo_class_carrier", "JS Izumo (CV)", "japanese_naval_2026", "izumo_stovl_upgrade",
              "aesa_radar_gen1", "type055_destroyer_vls", T2026 + ["japanese_carriers_2026"], days=205),

    # ─── France / UK / USA / Russia / China · carriers ─────────────────────────
    naval_tpl("charles_de_gaulle_carrier", "Charles de Gaulle", "french_naval_2026", "charles_de_gaulle_core",
              "aesa_radar_gen1", "aster30_sam", T2026 + ["french_carriers_2026"], days=250, training=36),
    naval_tpl("queen_elizabeth_cv", "HMS Queen Elizabeth", "uk_naval_2026", "queen_elizabeth_cv_core",
              "aesa_radar_gen1", "sea_viper_sam", T2026 + ["uk_carriers_2026"], days=235, training=35),
    naval_tpl("nimitz_class_carrier_2026", "Nimitz-class", "us_naval_2026", "nimitz_class_core",
              "aegis_spy1_radar", "aegis_bmd_package", T2026 + ["us_carriers_2026"], days=270, training=38),
    naval_tpl("ford_class_carrier_2026", "Gerald R. Ford", "us_naval_2026", "ford_class_core",
              "aegis_spy1_radar", "aim120d_amraam", T2026 + ["us_carriers_2026"], days=290, training=40),
    naval_tpl("admiral_kuznetsov_carrier", "Admiral Kuznetsov", "russian_naval_2026", "admiral_kuznetsov_core",
              "s400_triumf_proto", "kalibr_cruise_missile", T2026 + ["russian_carriers_2026"],
              stats={"speed": 27, "reliability": 55, "fuel_consumption": 100, "supply_need": 115,
                     "armor": 48, "deck_armor": 35, "hardness": 68}, training=32),
    naval_tpl("liaoning_carrier", "CNS Liaoning", "chinese_naval_2026", "liaoning_carrier_core",
              "type055_destroyer_vls", "hq9b_sam", T2026 + ["chinese_carriers_2026"], days=215),
    naval_tpl("shandong_carrier", "CNS Shandong", "chinese_naval_2026", "shandong_carrier_core",
              "type055_destroyer_vls", "hq9b_sam", T2026 + ["chinese_carriers_2026"], days=225),

    # ─── Helicopter aviation · 2026 navies ─────────────────────────────────────────
    air_tpl("mh60r_seahawk_india", "MH-60R (Indian Navy)", "indian_naval_helo_2026", "helicopter",
            {"MainWeapon": "mk48_torpedo", "Sensors": "mh60r_asw_helo_suite", "Engine": "ge_f404_hornet"},
            T2026 + ["indian_naval_aviation", "asw_helicopter"], crew=3, days=70, training=34,
            stats={"speed": 65, "reliability": 85, "fuel_consumption": 12, "supply_need": 10, "armor": 8, "hardness": 15}),
    air_tpl("mh60r_seahawk_aus", "MH-60R (RAN)", "australian_naval_helo_2026", "helicopter",
            {"MainWeapon": "mk48_torpedo", "Sensors": "mh60r_asw_helo_suite", "Engine": "ge_f404_hornet"},
            T2026 + ["australian_naval_aviation", "asw_helicopter"], crew=3, days=70),
    air_tpl("nh90_nfh_italy", "NH90 NFH", "italian_naval_helo_2026", "helicopter",
            {"Sensors": "nh90_nato_naval_helo", "Engine": "ge_f110_proto"},
            T2026 + ["italian_naval_aviation", "asw_helicopter"], crew=2, days=68),
    air_tpl("ka27_helix_india", "Ka-28 Helix (IN)", "indian_naval_helo_2026", "helicopter",
            {"MainWeapon": "mk48_torpedo", "Sensors": "ka27_helix_asw_suite", "Engine": "klimov_m105_engine"},
            T2026 + ["indian_naval_aviation", "asw_helicopter"], crew=3, days=65),
    air_tpl("z18f_asw_china", "Z-18F ASW", "chinese_naval_helo_2026", "helicopter",
            {"MainWeapon": "mk48_torpedo", "Sensors": "z18f_asw_helo_suite", "Engine": "ws10_proto_turbofan"},
            T2026 + ["chinese_naval_aviation", "asw_helicopter"], crew=3, days=68),
    air_tpl("aw159_korea", "AW159 Wildcat (ROK)", "korean_naval_helo_2026", "helicopter",
            {"Sensors": "aw159_wildcat_asw", "Engine": "ge_f404_hornet"},
            T2026 + ["korean_naval_aviation", "asw_helicopter"], crew=2, days=62),

    # ─── LHD / helicopter carriers · smaller 2026 navies ─────────────────────────
    naval_tpl("tcg_anadolu", "TCG Anadolu", "turkish_naval_2026", "tcg_anadolu_uav_deck",
              "bayraktar_tb2_package", "hq9_sam_proto", T2026 + ["turkish_amphibious_2026"], size="Medium", days=170),
    naval_tpl("nae_atlantica", "NAe Atlântica", "brazilian_naval_2026", "atlantica_helo_carrier",
              "mh60r_asw_helo_suite", "exocet_block2", T2026 + ["brazilian_naval_2026"], size="Medium", days=160,
              stats={"speed": 22, "reliability": 72, "fuel_consumption": 60, "supply_need": 75,
                     "armor": 25, "deck_armor": 18, "hardness": 50}),
    naval_tpl("dokdo_lph", "ROKS Dokdo", "korean_naval_2026", "dokdo_lph_core",
              "aesa_radar_gen1", "aim120d_amraam", T2026 + ["korean_amphibious_2026"], size="Medium", days=165),
    naval_tpl("canberra_lhd", "HMAS Canberra", "australian_naval_2026", "canberra_lhd_core",
              "mh60r_asw_helo_suite", "aim120d_amraam", T2026 + ["australian_amphibious_2026"], size="Medium", days=168),
    naval_tpl("mistral_egypt", "ENS Gamal Abdel Nasser", "egyptian_naval_2026", "mistral_lhd_core",
              "nh90_nato_naval_helo", "mica_air_missile", T2026 + ["egyptian_naval_2026"], size="Medium", days=155),
    naval_tpl("chakri_naruebet_carrier", "HTMS Chakri Naruebet", "thai_naval_2026", "chakri_naruebet_core",
              "mh60r_asw_helo_suite", "aim9_sidewinder", T2026 + ["thai_naval_2026"], size="Light", days=130,
              stats={"speed": 24, "reliability": 65, "fuel_consumption": 50, "supply_need": 60,
                     "armor": 20, "deck_armor": 14, "hardness": 42}),

    # ─── Additional 2026 scenario nations · naval helicopter aviation ───────────
    air_tpl("ch148_cyclone_canada", "CH-148 Cyclone", "canadian_naval_helo_2026", "helicopter",
            {"MainWeapon": "mk48_torpedo", "Sensors": "halifax_asw_helo", "Engine": "ge_f404_hornet"},
            T2026 + ["canadian_naval_aviation", "asw_helicopter"], crew=3, days=68),
    air_tpl("nh90_norway", "NH90 NFH (Norway)", "norwegian_naval_helo_2026", "helicopter",
            {"Sensors": "nh90_nato_naval_helo", "Engine": "ge_f110_proto"},
            T2026 + ["norwegian_naval_aviation", "asw_helicopter"], crew=2, days=65),
    air_tpl("nh90_germany", "NH90 NFH (Germany)", "german_naval_helo_2026", "helicopter",
            {"Sensors": "nh90_nato_naval_helo", "Engine": "ge_f110_proto"},
            T2026 + ["german_naval_aviation", "asw_helicopter"], crew=2, days=65),
    air_tpl("mh60r_singapore", "MH-60R (RSAF Naval)", "singapore_naval_helo_2026", "helicopter",
            {"Sensors": "mh60r_asw_helo_suite", "Engine": "ge_f404_hornet"},
            T2026 + ["singapore_naval_aviation", "asw_helicopter"], crew=3, days=68),
    air_tpl("aw159_thailand", "AW139 (Royal Thai Navy)", "thai_naval_helo_2026", "helicopter",
            {"Sensors": "aw159_wildcat_asw", "Engine": "wasp_r1340_carrier_scout"},
            T2026 + ["thai_naval_aviation", "asw_helicopter"], crew=2, days=60,
            stats={"speed": 60, "reliability": 78, "fuel_consumption": 11, "supply_need": 9, "armor": 6, "hardness": 12}),
    air_tpl("ka27_russia_naval", "Ka-27 (Russian Navy)", "russian_naval_helo_2026", "helicopter",
            {"MainWeapon": "mk48_torpedo", "Sensors": "ka27_helix_asw_suite", "Engine": "klimov_m105_engine"},
            T2026 + ["russian_naval_aviation", "asw_helicopter"], crew=3, days=65),
    air_tpl("mh60r_israel", "SH-60F/I (Israeli Navy)", "israeli_naval_helo_2026", "helicopter",
            {"Sensors": "mh60r_asw_helo_suite", "Engine": "ge_f404_hornet"},
            T2026 + ["israeli_naval_aviation", "asw_helicopter"], crew=3, days=70),
    air_tpl("nh90_netherlands", "NH90 NFH (Netherlands)", "dutch_naval_helo_2026", "helicopter",
            {"Sensors": "nh90_nato_naval_helo", "Engine": "ge_f110_proto"},
            T2026 + ["dutch_naval_aviation", "asw_helicopter"], crew=2, days=65),
    air_tpl("sea_king_saudi", "AS332 MRS (Saudi Naval)", "saudi_naval_helo_2026", "helicopter",
            {"Sensors": "mh60r_asw_helo_suite", "Engine": "pratt_whitney_r2800"},
            T2026 + ["saudi_naval_aviation", "asw_helicopter"], crew=3, days=62,
            stats={"speed": 58, "reliability": 80, "fuel_consumption": 13, "supply_need": 10, "armor": 8, "hardness": 14}),
]


def write_json(path: Path, data: dict) -> None:
    with path.open("w", encoding="utf-8") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
        f.write("\n")


def main() -> None:
    MODULES_DIR.mkdir(parents=True, exist_ok=True)
    TEMPLATES_DIR.mkdir(parents=True, exist_ok=True)
    existing_mods = {p.stem for p in MODULES_DIR.glob("*.json")}
    existing_tpls = {p.stem for p in TEMPLATES_DIR.glob("*.json")}

    mc = ms = 0
    for mod in MODULES:
        if mod["id"] in existing_mods:
            ms += 1
            continue
        write_json(MODULES_DIR / f"{mod['id']}.json", mod)
        mc += 1
        print(f"  + module {mod['id']}.json")

    tc = ts = 0
    for tpl in TEMPLATES:
        if tpl["id"] in existing_tpls:
            ts += 1
            continue
        write_json(TEMPLATES_DIR / f"{tpl['id']}.json", tpl)
        tc += 1
        print(f"  + template {tpl['id']}.json")

    # Validate refs
    mods = {p.stem for p in MODULES_DIR.glob("*.json")}
    errs = []
    for p in TEMPLATES_DIR.glob("*.json"):
        d = json.loads(p.read_text())
        for slot, mid in d.get("module_loadout", {}).items():
            if mid not in mods:
                errs.append(f"{p.name}: {slot} -> {mid}")

    print(f"\n2026 naval: modules {mc} created ({ms} skipped), templates {tc} created ({ts} skipped)")
    print(f"Total modules: {len(mods)}, templates: {len(list(TEMPLATES_DIR.glob('*.json')))}")
    print(f"Missing refs: {len(errs)}")
    for e in errs:
        print(f"  ! {e}")


if __name__ == "__main__":
    main()
