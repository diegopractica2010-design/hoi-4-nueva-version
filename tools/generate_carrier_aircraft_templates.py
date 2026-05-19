#!/usr/bin/env python3
"""Carrier aircraft unit templates: naval fighters, strike, AEW, ASW — WWII through 2030s."""

from __future__ import annotations

import json
from pathlib import Path

TEMPLATES_DIR = Path(__file__).resolve().parents[1] / "data" / "unit_templates"

# Shared unlock tags
U_WW2 = ["us_naval_aviation", "carrier_air_wing"]
U_CW = ["us_carrier_aviation", "cold_war_naval_air"]
UK_WW2 = ["uk_naval_aviation", "carrier_air_wing"]
JP_WW2 = ["japanese_naval_aviation", "kido_butai"]
DE_WW2 = ["german_naval_aviation", "german_carriers"]
FR_CV = ["french_naval_aviation", "carrier_strike"]
RU_CV = ["russian_naval_aviation", "carrier_aviation"]
CN_CV = ["chinese_naval_aviation", "carrier_air_wing"]


def air_tpl(
    id_: str,
    name: str,
    family: str,
    archetype: str,
    size: str,
    stats: dict,
    slots: dict,
    loadout: dict,
    unlock: list[str],
    crew: int = 1,
    days: int = 50,
    training: int = 32,
) -> dict:
    return {
        "id": id_,
        "name": name,
        "design_family": family,
        "base_type": "Air",
        "size_category": size,
        "visual_archetype": archetype,
        "crew_required": crew,
        "base_training_level": training,
        "max_experience_level": 100,
        "base_production_days": days,
        "base_stats": stats,
        "slots": slots,
        "module_loadout": loadout,
        "unlock_tech": unlock,
        "can_mount_drones": False,
        "is_vehicle": True,
    }


FIGHTER_STATS_WW2 = {"speed": 88, "reliability": 72, "fuel_consumption": 10, "supply_need": 8, "armor": 14, "hardness": 24}
FIGHTER_STATS_LATE_WW2 = {"speed": 92, "reliability": 78, "fuel_consumption": 11, "supply_need": 9, "armor": 18, "hardness": 28}
BOMBER_STATS_WW2 = {"speed": 70, "reliability": 68, "fuel_consumption": 14, "supply_need": 12, "armor": 16, "hardness": 22}
JET_STATS_50S = {"speed": 95, "reliability": 70, "fuel_consumption": 18, "supply_need": 14, "armor": 10, "hardness": 22}
JET_STATS_60S = {"speed": 98, "reliability": 74, "fuel_consumption": 20, "supply_need": 15, "armor": 12, "hardness": 24}
JET_STATS_70S = {"speed": 100, "reliability": 76, "fuel_consumption": 22, "supply_need": 16, "armor": 14, "hardness": 26}
JET_STATS_80S = {"speed": 102, "reliability": 80, "fuel_consumption": 24, "supply_need": 18, "armor": 16, "hardness": 28}
JET_STATS_MODERN = {"speed": 105, "reliability": 82, "fuel_consumption": 26, "supply_need": 20, "armor": 18, "hardness": 30}
STEALTH_STATS = {"speed": 108, "reliability": 84, "fuel_consumption": 28, "supply_need": 22, "armor": 20, "hardness": 32}

STD_FIGHTER_SLOTS = {
    "MainWeapon": {"max": 2},
    "SecondaryWeapon": {"max": 1},
    "Engine": {"max": 1},
    "Sensors": {"max": 1},
}
STD_STRIKE_SLOTS = {
    "MainWeapon": {"max": 2},
    "Engine": {"max": 1},
    "Sensors": {"max": 1},
}
STD_AEW_SLOTS = {
    "Sensors": {"max": 2},
    "Engine": {"max": 1},
    "Communications": {"max": 1},
}

TEMPLATES: list[dict] = [
    # ═══ USA · WWII ═══════════════════════════════════════════════════════════
    air_tpl("f4f_wildcat", "F4F Wildcat", "us_carrier_air_ww2", "fighter", "Light", FIGHTER_STATS_WW2,
            STD_FIGHTER_SLOTS,
            {"MainWeapon": "browning_an_m3_gun", "SecondaryWeapon": "m2_browning_gun_pod",
             "Engine": "wasp_r1340_carrier_scout", "Sensors": "carrier_operations_kit"},
            U_WW2, days=42, training=30),
    air_tpl("f6f_hellcat", "F6F Hellcat", "us_carrier_air_ww2", "fighter", "Medium", FIGHTER_STATS_LATE_WW2,
            STD_FIGHTER_SLOTS,
            {"MainWeapon": "f6f_gun_battery", "Engine": "pratt_r2800_hellcat", "Sensors": "carrier_operations_kit"},
            U_WW2, days=48, training=34),
    air_tpl("f4u_corsair_carrier", "F4U Corsair (Carrier)", "us_carrier_air_ww2", "fighter", "Medium",
            {**FIGHTER_STATS_LATE_WW2, "speed": 94},
            STD_FIGHTER_SLOTS,
            {"MainWeapon": "f4u_gun_battery", "Engine": "pratt_r2800_corsair", "Sensors": "carrier_operations_kit"},
            U_WW2 + ["corsair_ops"], days=50, training=35),
    air_tpl("f8f_bearcat", "F8F Bearcat", "us_carrier_air_ww2", "fighter", "Light",
            {**FIGHTER_STATS_LATE_WW2, "speed": 96},
            STD_FIGHTER_SLOTS,
            {"MainWeapon": "f6f_gun_battery", "Engine": "f8f_bearcat_engine", "Sensors": "carrier_operations_kit"},
            U_WW2 + ["late_war_carrier"], days=46, training=36),
    air_tpl("sbd_dauntless", "SBD Dauntless", "us_carrier_air_ww2", "bomber", "Medium", BOMBER_STATS_WW2,
            STD_STRIKE_SLOTS,
            {"MainWeapon": "sbd_dive_bomb_package", "Engine": "wright_r2600_dauntless",
             "Sensors": "carrier_operations_kit"},
            U_WW2 + ["dive_bomber"], crew=2, days=52, training=33),
    air_tpl("sb2c_helldiver", "SB2C Helldiver", "us_carrier_air_ww2", "bomber", "Medium",
            {**BOMBER_STATS_WW2, "speed": 74},
            STD_STRIKE_SLOTS,
            {"MainWeapon": "sb2c_bomb_torpedo_load", "Engine": "wright_r3350_helldiver",
             "Sensors": "carrier_operations_kit"},
            U_WW2, crew=2, days=58, training=32),
    air_tpl("tbf_avenger_strike", "TBF/TBM Avenger", "us_carrier_air_ww2", "bomber", "Medium",
            {**BOMBER_STATS_WW2, "speed": 68},
            {**STD_STRIKE_SLOTS, "SecondaryWeapon": {"max": 1}},
            {"MainWeapon": "tbf_strike_torpedo_load", "SecondaryWeapon": "mk13_aerial_torpedo",
             "Engine": "wasp_r1340_carrier_scout", "Sensors": "carrier_operations_kit"},
            U_WW2, crew=3, days=56, training=31),
    air_tpl("tbd_devastator", "TBD Devastator", "us_carrier_air_ww2", "bomber", "Medium",
            {**BOMBER_STATS_WW2, "speed": 62, "reliability": 55},
            STD_STRIKE_SLOTS,
            {"MainWeapon": "mk13_aerial_torpedo", "Engine": "wasp_r1340_carrier_scout",
             "Sensors": "carrier_operations_kit"},
            U_WW2 + ["early_war_carrier"], crew=3, days=48, training=28),

    # ═══ UK · WWII ════════════════════════════════════════════════════════════
    air_tpl("seafire_mk3", "Seafire Mk III", "uk_carrier_air_ww2", "fighter", "Light", FIGHTER_STATS_WW2,
            STD_FIGHTER_SLOTS,
            {"MainWeapon": "hispano_mk2_cannon", "SecondaryWeapon": "browning_303_battery",
             "Engine": "rolls_royce_merlin_carrier", "Sensors": "carrier_operations_kit"},
            UK_WW2, days=46, training=33),
    air_tpl("firefly_strike", "Fairey Firefly", "uk_carrier_air_ww2", "fighter", "Medium",
            {**FIGHTER_STATS_LATE_WW2, "speed": 86},
            STD_STRIKE_SLOTS,
            {"MainWeapon": "firefly_strike_load", "Engine": "rolls_royce_merlin_carrier",
             "Sensors": "carrier_operations_kit"},
            UK_WW2, crew=2, days=54, training=34),
    air_tpl("fulmar_mk2", "Fairey Fulmar", "uk_carrier_air_ww2", "fighter", "Medium",
            {**FIGHTER_STATS_WW2, "speed": 82},
            STD_FIGHTER_SLOTS,
            {"MainWeapon": "fulmar_gun_battery", "Engine": "rolls_royce_merlin_carrier",
             "Sensors": "carrier_operations_kit"},
            UK_WW2 + ["early_rn_carrier"], crew=2, days=50, training=30),
    air_tpl("swordfish_torpedo", "Fairey Swordfish", "uk_carrier_air_ww2", "bomber", "Light",
            {**BOMBER_STATS_WW2, "speed": 55, "reliability": 80},
            STD_STRIKE_SLOTS,
            {"MainWeapon": "mk12_aerial_torpedo_uk", "Engine": "bristol_pegasus_swordfish",
             "Sensors": "carrier_operations_kit"},
            UK_WW2, crew=3, days=44, training=32),
    air_tpl("barracuda_mk2", "Barracuda Mk II", "uk_carrier_air_ww2", "bomber", "Medium", BOMBER_STATS_WW2,
            STD_STRIKE_SLOTS,
            {"MainWeapon": "mk12_aerial_torpedo_uk", "Engine": "bristol_hercules_barracuda",
             "Sensors": "carrier_operations_kit"},
            UK_WW2, crew=3, days=52, training=31),
    air_tpl("albacore_torpedo", "Fairey Albacore", "uk_carrier_air_ww2", "bomber", "Medium",
            {**BOMBER_STATS_WW2, "speed": 65},
            STD_STRIKE_SLOTS,
            {"MainWeapon": "mk12_aerial_torpedo_uk", "Engine": "bristol_pegasus_swordfish",
             "Sensors": "carrier_operations_kit"},
            UK_WW2, crew=3, days=50, training=30),

    # ═══ Japan · WWII ═════════════════════════════════════════════════════════
    air_tpl("a6m5_zero_carrier", "A6M5 Zero (Carrier)", "japanese_carrier_air_ww2", "fighter", "Light",
            {**FIGHTER_STATS_WW2, "speed": 92},
            STD_FIGHTER_SLOTS,
            {"MainWeapon": "type99_mk2_cannon", "SecondaryWeapon": "type97_7_7mm_gun",
             "Engine": "sakae_radial_engine", "Sensors": "carrier_operations_kit"},
            JP_WW2, days=44, training=36),
    air_tpl("d3a_val", "D3A Val", "japanese_carrier_air_ww2", "bomber", "Medium", BOMBER_STATS_WW2,
            STD_STRIKE_SLOTS,
            {"MainWeapon": "d3a_val_dive_bomb", "Engine": "sakae_radial_engine",
             "Sensors": "carrier_operations_kit"},
            JP_WW2, crew=2, days=48, training=34),
    air_tpl("b5n_kate", "B5N Kate", "japanese_carrier_air_ww2", "bomber", "Medium",
            {**BOMBER_STATS_WW2, "speed": 66},
            STD_STRIKE_SLOTS,
            {"MainWeapon": "b5n_kate_torpedo_load", "Engine": "sakae_radial_engine",
             "Sensors": "carrier_operations_kit"},
            JP_WW2, crew=3, days=50, training=35),
    air_tpl("d4y_judy", "D4Y Judy", "japanese_carrier_air_ww2", "bomber", "Medium",
            {**BOMBER_STATS_WW2, "speed": 78},
            STD_STRIKE_SLOTS,
            {"MainWeapon": "d4y_judy_strike_load", "Engine": "sakae_radial_engine",
             "Sensors": "carrier_operations_kit"},
            JP_WW2 + ["late_war_carrier"], crew=2, days=52, training=34),
    air_tpl("b6n_jill", "B6N Jill", "japanese_carrier_air_ww2", "bomber", "Medium",
            {**BOMBER_STATS_WW2, "speed": 72},
            STD_STRIKE_SLOTS,
            {"MainWeapon": "b6n_jill_torpedo_load", "Engine": "sakae_radial_engine",
             "Sensors": "carrier_operations_kit"},
            JP_WW2 + ["late_war_carrier"], crew=3, days=52, training=34),
    air_tpl("f2a_buffalo_carrier", "F2A Buffalo", "us_carrier_air_ww2", "fighter", "Light",
            {**FIGHTER_STATS_WW2, "speed": 84, "reliability": 60},
            STD_FIGHTER_SLOTS,
            {"MainWeapon": "f2a_buffalo_gun_battery", "Engine": "wasp_r1340_carrier_scout",
             "Sensors": "carrier_operations_kit"},
            U_WW2 + ["early_war_carrier", "midway"], days=40, training=28),
    air_tpl("sea_hurricane_mk1", "Sea Hurricane Mk I", "uk_carrier_air_ww2", "fighter", "Light",
            {**FIGHTER_STATS_WW2, "speed": 86},
            STD_FIGHTER_SLOTS,
            {"MainWeapon": "hispano_mk2_cannon", "SecondaryWeapon": "browning_303_battery",
             "Engine": "rolls_royce_merlin_carrier", "Sensors": "sea_hurricane_catapult_kit"},
            UK_WW2 + ["cam_ships", "merchant_carriers"], days=44, training=31),
    air_tpl("a7m_reppu_proto", "A7M Reppū (Proto)", "japanese_carrier_air_ww2", "fighter", "Medium",
            {**FIGHTER_STATS_LATE_WW2, "speed": 95, "reliability": 50},
            STD_FIGHTER_SLOTS,
            {"MainWeapon": "type99_mk2_cannon", "Engine": "a7m_reppu_proto_engine",
             "Sensors": "carrier_operations_kit"},
            JP_WW2 + ["japanese_paper_naval"], days=60, training=30),

    # ═══ Germany · WWII (designed / prototyped) ═══════════════════════════════
    air_tpl("bf109t_carrier", "Bf 109T (Carrier)", "german_carrier_air_ww2", "fighter", "Light",
            FIGHTER_STATS_WW2,
            STD_FIGHTER_SLOTS,
            {"MainWeapon": "mg151_20_cannon", "SecondaryWeapon": "mg17_machine_gun",
             "Engine": "db_605a_engine", "Sensors": "bf109t_carrier_package"},
            DE_WW2, days=52, training=30),
    air_tpl("fi167_carrier", "Fi 167 (Carrier)", "german_carrier_air_ww2", "bomber", "Light",
            {**BOMBER_STATS_WW2, "speed": 58},
            STD_STRIKE_SLOTS,
            {"MainWeapon": "mk13_aerial_torpedo", "Engine": "fi167_carrier_scout",
             "Sensors": "bf109t_carrier_package"},
            DE_WW2 + ["german_paper_naval"], crew=2, days=55, training=28),
    air_tpl("me155_carrier_proto", "Me 155B (Proto)", "german_carrier_air_ww2", "fighter", "Light",
            {**FIGHTER_STATS_LATE_WW2, "reliability": 48},
            STD_FIGHTER_SLOTS,
            {"MainWeapon": "mk108_30mm_aircraft", "Engine": "me155_carrier_proto",
             "Sensors": "bf109t_carrier_package"},
            DE_WW2 + ["german_paper_naval"], days=65, training=28),

    # ═══ USA · Cold War / modern ════════════════════════════════════════════
    air_tpl("f9f_panther", "F9F Panther", "us_carrier_air_cold_war", "fighter", "Medium", JET_STATS_50S,
            STD_FIGHTER_SLOTS,
            {"MainWeapon": "m61a1_vulcan", "Engine": "j48_turbojet_f9f", "Sensors": "carrier_operations_kit"},
            U_CW + ["korean_war_carrier"], days=62, training=32),
    air_tpl("a1_skyraider", "A-1 Skyraider", "us_carrier_air_cold_war", "bomber", "Medium",
            {**JET_STATS_50S, "speed": 75},
            STD_STRIKE_SLOTS,
            {"MainWeapon": "a1_skyraider_loadout", "Engine": "pratt_whitney_r2800",
             "Sensors": "carrier_operations_kit"},
            U_CW, crew=1, days=58, training=33),
    air_tpl("f8e_crusader", "F-8E Crusader", "us_carrier_air_cold_war", "fighter", "Medium",
            {**JET_STATS_60S, "speed": 100},
            STD_FIGHTER_SLOTS,
            {"MainWeapon": "m61a1_vulcan", "Engine": "j57_f8_crusader", "Sensors": "carrier_operations_kit"},
            U_CW + ["vietnam_carrier"], days=68, training=35),
    air_tpl("a4_skyhawk", "A-4 Skyhawk", "us_carrier_air_cold_war", "fighter", "Light", JET_STATS_60S,
            STD_STRIKE_SLOTS,
            {"MainWeapon": "agm65_maverick", "Engine": "j52_skyhawk_engine", "Sensors": "carrier_operations_kit"},
            U_CW, days=60, training=34),
    air_tpl("a6_intruder", "A-6 Intruder", "us_carrier_air_cold_war", "bomber", "Heavy", JET_STATS_60S,
            {**STD_STRIKE_SLOTS, "SecondaryWeapon": {"max": 1}},
            {"MainWeapon": "agm65_maverick", "SecondaryWeapon": "us_1000lb_bomb_load",
             "Engine": "tf34_intruder_engine", "Sensors": "scr_520_airborne_radar"},
            U_CW, crew=2, days=75, training=36),
    air_tpl("a7_corsair_ii", "A-7 Corsair II", "us_carrier_air_cold_war", "fighter", "Medium", JET_STATS_70S,
            STD_STRIKE_SLOTS,
            {"MainWeapon": "agm65_maverick", "Engine": "j52_skyhawk_engine", "Sensors": "carrier_operations_kit"},
            U_CW + ["vietnam_carrier"], days=65, training=35),
    air_tpl("f4j_phantom_naval", "F-4J Phantom II", "us_carrier_air_cold_war", "fighter", "Heavy", JET_STATS_70S,
            {**STD_FIGHTER_SLOTS, "SecondaryWeapon": {"max": 2}},
            {"MainWeapon": "aim7_sparrow", "SecondaryWeapon": "aim9_sidewinder",
             "Engine": "pratt_j79_phantom", "Sensors": "carrier_operations_kit"},
            U_CW, crew=2, days=72, training=36),
    air_tpl("f14a_tomcat", "F-14A Tomcat", "us_carrier_air_modern", "fighter", "Heavy",
            {**JET_STATS_80S, "speed": 104},
            {**STD_FIGHTER_SLOTS, "SecondaryWeapon": {"max": 2}},
            {"MainWeapon": "aim54_phoenix", "SecondaryWeapon": "aim9_sidewinder",
             "Engine": "tf30_f14_engine", "Sensors": "carrier_operations_kit"},
            U_CW + ["modern_carrier_wing"], crew=2, days=85, training=38),
    air_tpl("fa18c_hornet", "F/A-18C Hornet", "us_carrier_air_modern", "fighter", "Medium", JET_STATS_80S,
            {**STD_FIGHTER_SLOTS, "SecondaryWeapon": {"max": 2}},
            {"MainWeapon": "aim120_amraam", "SecondaryWeapon": "aim9x_sidewinder",
             "Engine": "ge_f404_hornet", "Sensors": "carrier_operations_kit"},
            U_CW + ["modern_carrier_wing"], days=78, training=37),
    air_tpl("fa18ef_super_hornet", "F/A-18E/F Super Hornet", "us_carrier_air_modern", "fighter", "Heavy",
            JET_STATS_MODERN,
            {**STD_FIGHTER_SLOTS, "SecondaryWeapon": {"max": 2}},
            {"MainWeapon": "aim120d_amraam", "SecondaryWeapon": "aim9x_block2",
             "Engine": "ge_f414_super_hornet", "Sensors": "carrier_operations_kit"},
            U_CW + ["twenty_first_century_carrier"], crew=1, days=82, training=38),
    air_tpl("e2c_hawkeye", "E-2C Hawkeye", "us_carrier_air_modern", "awacs", "Medium",
            {**JET_STATS_70S, "speed": 85},
            STD_AEW_SLOTS,
            {"Sensors": "e2c_hawkeye_radar", "Engine": "j52_skyhawk_engine",
             "Communications": "scr_522_radio"},
            U_CW + ["carrier_aew"], crew=5, days=90, training=40),
    air_tpl("ea6b_prowler", "EA-6B Prowler", "us_carrier_air_modern", "ew_aircraft", "Medium", JET_STATS_80S,
            {**STD_FIGHTER_SLOTS, "MainWeapon": {"max": 1}},
            {"MainWeapon": "agm88_harm", "Engine": "j52_skyhawk_engine", "Sensors": "ea6b_ecm_suite"},
            U_CW + ["carrier_ew"], crew=4, days=88, training=39),
    air_tpl("s3b_viking", "S-3B Viking", "us_carrier_air_modern", "asw_aircraft", "Medium",
            {**JET_STATS_80S, "speed": 88},
            STD_STRIKE_SLOTS,
            {"MainWeapon": "mk48_torpedo", "Engine": "ge_f404_hornet", "Sensors": "s3b_viking_asw_suite"},
            U_CW + ["carrier_asw"], crew=4, days=80, training=36),
    air_tpl("av8b_harrier_ii", "AV-8B Harrier II", "us_carrier_air_modern", "fighter", "Medium", JET_STATS_80S,
            STD_FIGHTER_SLOTS,
            {"MainWeapon": "aim9x_sidewinder", "Engine": "av8b_harrier_ii_engine",
             "Sensors": "carrier_operations_kit"},
            U_CW + ["amphibious_aviation"], days=75, training=36),
    air_tpl("f35c_lightning", "F-35C Lightning II", "us_carrier_air_modern", "fighter", "Medium", STEALTH_STATS,
            STD_FIGHTER_SLOTS,
            {"MainWeapon": "aim120d_amraam", "Engine": "pratt_f135_engine", "Sensors": "f35c_carrier_package"},
            U_CW + ["twenty_first_century_carrier"], days=120, training=40),

    # ═══ UK · Cold War / modern ═══════════════════════════════════════════════
    air_tpl("phantom_fg1", "Phantom FG.1", "uk_carrier_air_cold_war", "fighter", "Heavy", JET_STATS_70S,
            {**STD_FIGHTER_SLOTS, "SecondaryWeapon": {"max": 2}},
            {"MainWeapon": "skyflash_missile", "SecondaryWeapon": "aim9_sidewinder",
             "Engine": "rolls_royce_spey_phantom", "Sensors": "carrier_operations_kit"},
            UK_WW2 + ["uk_carrier_jet"], crew=2, days=75, training=35),
    air_tpl("scimitar_f1", "Scimitar F.1", "uk_carrier_air_cold_war", "fighter", "Medium", JET_STATS_50S,
            STD_FIGHTER_SLOTS,
            {"MainWeapon": "aden_30mm_revolver", "Engine": "rolls_royce_avon_scimitar",
             "Sensors": "carrier_operations_kit"},
            UK_WW2 + ["uk_carrier_jet"], days=70, training=32),
    air_tpl("buccaneer_s2", "Buccaneer S.2", "uk_carrier_air_cold_war", "bomber", "Heavy", JET_STATS_60S,
            STD_STRIKE_SLOTS,
            {"MainWeapon": "buccaneer_maritime_strike", "Engine": "rolls_royce_mk104_buccaneer",
             "Sensors": "carrier_operations_kit"},
            UK_WW2 + ["uk_strike_carrier"], crew=2, days=78, training=34),
    air_tpl("sea_harrier_frs1", "Sea Harrier FRS.1", "uk_carrier_air_cold_war", "fighter", "Medium", JET_STATS_70S,
            STD_FIGHTER_SLOTS,
            {"MainWeapon": "aim9_sidewinder", "Engine": "pegasus_harrier_engine",
             "Sensors": "sea_harrier_frs_package"},
            UK_WW2 + ["falklands_carrier"], days=72, training=36),
    air_tpl("f35b_lightning", "F-35B Lightning II", "uk_carrier_air_modern", "fighter", "Medium", STEALTH_STATS,
            STD_FIGHTER_SLOTS,
            {"MainWeapon": "aim120d_amraam", "Engine": "pratt_f135_engine", "Sensors": "f35b_stovl_package"},
            UK_WW2 + ["queen_elizabeth_air_wing"], days=118, training=39),

    # ═══ France ═════════════════════════════════════════════════════════════════
    air_tpl("etendard_ivm", "Étendard IVM", "french_carrier_air", "fighter", "Medium", JET_STATS_60S,
            STD_STRIKE_SLOTS,
            {"MainWeapon": "us_1000lb_bomb_load", "Engine": "snecma_atar_etendard",
             "Sensors": "carrier_operations_kit"},
            FR_CV, days=65, training=33),
    air_tpl("super_etendard", "Super Étendard", "french_carrier_air", "fighter", "Medium", JET_STATS_70S,
            STD_STRIKE_SLOTS,
            {"MainWeapon": "super_etendard_strike", "Engine": "snecma_atar_etendard",
             "Sensors": "carrier_operations_kit"},
            FR_CV + ["exocet_strike"], days=70, training=35),
    air_tpl("rafale_m", "Rafale M", "french_carrier_air", "fighter", "Medium", JET_STATS_MODERN,
            {**STD_FIGHTER_SLOTS, "SecondaryWeapon": {"max": 2}},
            {"MainWeapon": "mica_air_missile", "SecondaryWeapon": "scalp_cruise_missile",
             "Engine": "rafale_package", "Sensors": "rafale_m_carrier_package"},
            FR_CV + ["cdg_air_wing"], days=85, training=38),

    # ═══ USSR / Russia ══════════════════════════════════════════════════════════
    air_tpl("yak38_forger", "Yak-38 Forger", "soviet_carrier_air", "fighter", "Light", JET_STATS_60S,
            STD_FIGHTER_SLOTS,
            {"MainWeapon": "r73_archer_missile", "Engine": "tumansky_r27_yak38",
             "Sensors": "carrier_operations_kit"},
            RU_CV, days=68, training=32),
    air_tpl("su33_flanker_d", "Su-33 Flanker-D", "russian_carrier_air", "fighter", "Heavy", JET_STATS_80S,
            {**STD_FIGHTER_SLOTS, "SecondaryWeapon": {"max": 2}},
            {"MainWeapon": "r77_adder_missile", "SecondaryWeapon": "r73_archer_missile",
             "Engine": "al31fp_su33", "Sensors": "carrier_operations_kit"},
            RU_CV + ["kuznetsov_air_wing"], days=88, training=37),
    air_tpl("mig29k", "MiG-29K", "russian_carrier_air", "fighter", "Medium", JET_STATS_MODERN,
            STD_FIGHTER_SLOTS,
            {"MainWeapon": "r77_1_adder", "Engine": "rd33mk_mig29k", "Sensors": "carrier_operations_kit"},
            RU_CV + ["vikramaditya_export"], days=82, training=36),
    air_tpl("yak141_freestyle_proto", "Yak-141 (Proto)", "russian_carrier_air", "fighter", "Medium",
            {**JET_STATS_80S, "reliability": 55},
            STD_FIGHTER_SLOTS,
            {"MainWeapon": "r73_archer_missile", "Engine": "yak141_freestyle_proto",
             "Sensors": "carrier_operations_kit"},
            RU_CV + ["stovl_prototype"], days=95, training=30),

    # ═══ China ══════════════════════════════════════════════════════════════════
    air_tpl("j15_flying_shark", "J-15 Flying Shark", "chinese_carrier_air", "fighter", "Heavy", JET_STATS_MODERN,
            {**STD_FIGHTER_SLOTS, "SecondaryWeapon": {"max": 2}},
            {"MainWeapon": "pl12_air_missile", "SecondaryWeapon": "pl15_air_missile",
             "Engine": "ws10j_j15_engine", "Sensors": "carrier_operations_kit"},
            CN_CV, days=90, training=36),
    air_tpl("j35_carrier_fighter", "J-35 (Carrier)", "chinese_carrier_air", "fighter", "Medium", STEALTH_STATS,
            STD_FIGHTER_SLOTS,
            {"MainWeapon": "pl15_air_missile", "Engine": "j35_carrier_fighter",
             "Sensors": "carrier_operations_kit"},
            CN_CV + ["fujian_air_wing"], days=115, training=38),

    # ═══ 2030s planned ══════════════════════════════════════════════════════════
    air_tpl("x47b_ucav_carrier", "X-47B (Carrier UCAV)", "us_carrier_air_planned", "uav", "Medium",
            {"speed": 95, "reliability": 80, "fuel_consumption": 22, "supply_need": 18, "armor": 8, "hardness": 20},
            {"Sensors": {"max": 2}, "Engine": {"max": 1}},
            {"Sensors": "x47b_ucav_carrier", "Engine": "ge_f404_hornet"},
            U_CW + ["ucav_carrier", "twenty_thirties_planned"], crew=0, days=100, training=35),
    air_tpl("ngad_carrier_fighter_2030", "NGAD Carrier Fighter (Proto)", "us_carrier_air_planned", "fighter",
            "Medium", STEALTH_STATS,
            STD_FIGHTER_SLOTS,
            {"MainWeapon": "aim260_jatm", "Engine": "f47_ngad_package",
             "Sensors": "ngad_carrier_proto_2030"},
            U_CW + ["sixth_gen_carrier", "twenty_thirties_planned"], days=140, training=38),
]


def main() -> None:
    TEMPLATES_DIR.mkdir(parents=True, exist_ok=True)
    existing = {p.stem for p in TEMPLATES_DIR.glob("*.json")}
    created = skipped = 0
    for tpl in TEMPLATES:
        path = TEMPLATES_DIR / f"{tpl['id']}.json"
        if tpl["id"] in existing:
            skipped += 1
            continue
        with path.open("w", encoding="utf-8") as f:
            json.dump(tpl, f, indent=2, ensure_ascii=False)
            f.write("\n")
        created += 1
        print(f"  + {path.name}")
    total = len(list(TEMPLATES_DIR.glob("*.json")))
    print(f"\nCarrier aircraft templates: {created} created, {skipped} skipped, {total} total.")


if __name__ == "__main__":
    main()
