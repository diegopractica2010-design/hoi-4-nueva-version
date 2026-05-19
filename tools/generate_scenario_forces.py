#!/usr/bin/env python3
"""Land and air unit templates for every nation in 1918, 1936, and 2026 scenarios."""

from __future__ import annotations

from template_export import write_unit_template
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "data"
MODULES_DIR = ROOT / "modules"
TEMPLATES_DIR = ROOT / "unit_templates"
SCENARIOS_DIR = ROOT / "scenarios"

# Shared WW1 / interwar export loadouts (existing modules only)
WW1_FTR = {"MainWeapon": "lewis_gun_mount", "Engine": "liberty_l12_engine"}
WW1_LT = {
    "MainWeapon": "m1916_37mm_tank_gun",
    "SecondaryWeapon": "hotchkiss_8mm_mount",
    "Engine": "renault_4cyl_ft_engine",
}
WW1_HT = {
    "MainWeapon": "qf_6pdr_ww1_hotchkiss",
    "SecondaryWeapon": "vickers_machine_gun",
    "Engine": "daimler_knight_engine",
}
INTERWAR_FTR = {"MainWeapon": "lewis_gun_mount", "Engine": "liberty_l12_engine"}
INTERWAR_LT = {
    "MainWeapon": "bofors_37mm_at",
    "Engine": "spa_diesel_v8_engine",
}
INTERWAR_TT = {
    "MainWeapon": "sa_18_37mm_tank_gun",
    "Engine": "fiat_spa_cv33_engine",
}
EXPORT_2026_FTR = {"MainWeapon": "aim120d_amraam", "Engine": "pratt_f135_engine"}
EXPORT_2026_MBT = {
    "MainWeapon": "m256a1_120mm_gun",
    "Engine": "agt1500_turbine",
    "Armor": "m1a2c_sep_v3_armor",
    "Sensors": "hunter_killer_fcs",
}
EXPORT_2026_MBT_LEO = {
    "MainWeapon": "rh120_l55_gun",
    "Engine": "mtu_mb873_engine",
    "Armor": "leopard2a7_package",
    "Sensors": "hunter_killer_fcs",
}
EXPORT_2026_FTR_F16 = {
    "MainWeapon": "aim120c_amraam",
    "Engine": "ge_f404_hornet",
}

# fmt: off
MODULES: list[dict] = [
    {"id": "interwar_export_fighter_suite", "name": "Interwar Export Fighter Suite",
     "category": "Sensors", "tier": 2, "reliability_bonus": 3,
     "cost": {"steel": 2, "electronics": 8, "aluminum": 6}, "production_time": 40,
     "special_flags": ["interwar", "export", "fighter"],
     "description": "Licensed fabric biplane fighter avionics for minor air forces."},
    {"id": "scenario_export_mbt_2026", "name": "2026 Export MBT Package",
     "category": "Armor", "tier": 6, "armor_bonus": 24, "top_armor_bonus": 16, "reliability_bonus": 4,
     "cost": {"steel": 40, "electronics": 18, "tungsten": 8}, "production_time": 100,
     "special_flags": ["export", "twenty_twenties", "mbt"],
     "description": "Standard Western export armor and FCS kit for allied MBT sales."},
]

# (tag) -> (fighter_id_suffix, fighter_name, fighter_loadout, armor_id_suffix, armor_name, armor_loadout, armor_size)
# Suffixes are appended to tag lower + era, e.g. usa_fighter_1918
FORCES_1918: dict[str, tuple] = {
    "GER": ("Fokker D.VII", {"MainWeapon": "spandau_lmg_08", "Engine": "mercedes_diii_engine"},
            "A7V Sturmpanzerwagen", {"MainWeapon": "kwk_57mm_a7v_gun", "SecondaryWeapon": "mg08_machine_gun", "Engine": "daimler_knight_engine"}, "Heavy"),
    "FRA": ("SPAD S.XIII", {"MainWeapon": "vickers_machine_gun", "SecondaryWeapon": "hotchkiss_8mm_mount", "Engine": "hispano_suiza_8a_engine"},
            "Renault FT", WW1_LT, "Light"),
    "ENG": ("Sopwith Camel", {"MainWeapon": "vickers_machine_gun", "Engine": "rolls_royce_eagle_engine"},
            "Mark IV", WW1_HT, "Heavy"),
    "USA": ("Thomas-Morse S-4", WW1_FTR,
            "M1917 Light Tank", WW1_LT, "Light"),
    "SOV": ("Nieuport 17", WW1_FTR,
            "Mk V Heavy Tank (British Supply)", WW1_HT, "Heavy"),
    "ITA": ("Ansaldo A.1 Balilla", WW1_FTR,
            "Fiat 3000", WW1_LT, "Light"),
    "JAP": ("Nieuport-Delage NiD 29", WW1_FTR,
            "Ko-Gata (Renault FT)", WW1_LT, "Light"),
    "TUR": ("Rumpler C.IV (License)", WW1_FTR,
            "Büssing A5P Armored Car", WW1_LT, "Light"),
    "POL": ("Fokker D.VII (Polish)", {"MainWeapon": "spandau_lmg_08", "Engine": "mercedes_diii_engine"},
            "Renault FT (Polish)", WW1_LT, "Light"),
    "UKR": ("Nieuport 17 (Ukrainian)", WW1_FTR, "Austin Armored Car", WW1_LT, "Light"),
    "FIN": ("Thulin Type D", WW1_FTR, "Renault FT (Finnish)", WW1_LT, "Light"),
    "NOR": ("Sopwith Camel (Norwegian)", {"MainWeapon": "vickers_machine_gun", "Engine": "rolls_royce_eagle_engine"},
            "Mark IV (Norwegian)", WW1_HT, "Heavy"),
    "SWE": ("Fiat CR.14 (License)", WW1_FTR, "Strv m/21", WW1_LT, "Light"),
    "DNK": ("Sopwith Camel (Danish)", {"MainWeapon": "vickers_machine_gun", "Engine": "rolls_royce_eagle_engine"},
            "Renault FT (Danish)", WW1_LT, "Light"),
    "NLD": ("Fokker D.VII (Dutch)", {"MainWeapon": "spandau_lmg_08", "Engine": "mercedes_diii_engine"},
            "Renault FT (Dutch)", WW1_LT, "Light"),
    "SAF": ("SE5a (Imperial Gift)", {"MainWeapon": "vickers_machine_gun", "Engine": "rolls_royce_eagle_engine"},
            "Mark IV (South African)", WW1_HT, "Heavy"),
    "AUS": ("Sopwith Camel (Australian)", {"MainWeapon": "vickers_machine_gun", "Engine": "rolls_royce_eagle_engine"},
            "Mark IV (Australian)", WW1_HT, "Heavy"),
    "NZL": ("SE5a (NZEF)", {"MainWeapon": "vickers_machine_gun", "Engine": "rolls_royce_eagle_engine"},
            "Mark IV (NZEF)", WW1_HT, "Heavy"),
    "CAN": ("Sopwith Camel (Canadian)", {"MainWeapon": "vickers_machine_gun", "Engine": "rolls_royce_eagle_engine"},
            "Mark IV (Canadian)", WW1_HT, "Heavy"),
    "ARG": ("Morane-Saulnier MS.35", WW1_FTR, "Renault FT (Argentine)", WW1_LT, "Light"),
    "BRA": ("Nieuport 21", WW1_FTR, "Renault FT (Brazilian)", WW1_LT, "Light"),
    "MEX": ("Nieuport 28", WW1_FTR, "Renault FT (Mexican)", WW1_LT, "Light"),
    "EGY": ("Airco DH.9", WW1_FTR, "Rolls Armored Car", WW1_LT, "Light"),
    "IRN": ("Nieuport 17 (Persian)", WW1_FTR, "Crossley Armored Car", WW1_LT, "Light"),
    "ISR": ("Royal Aircraft Factory B.E.2", WW1_FTR, "Mandate Armored Lorry", WW1_LT, "Light"),
    "PAL": ("Mandate Patrol Aircraft", WW1_FTR, "Mandate Armored Lorry", WW1_LT, "Light"),
    "NGA": ("Colonial Recon Biplane", WW1_FTR, "Mandate Armored Lorry", WW1_LT, "Light"),
    "SYR": ("Mandate Patrol Aircraft", WW1_FTR, "Mandate Armored Lorry", WW1_LT, "Light"),
    "CHL": ("Bristol M.1 (Chilean)", WW1_FTR, "Renault FT (Chilean)", WW1_LT, "Light"),
    "ISL": ("Danish Naval Biplane", WW1_FTR, "Coastal Armored Truck", WW1_LT, "Light"),
    "GRL": ("Greenland Patrol Biplane", WW1_FTR, "Coastal Armored Truck", WW1_LT, "Light"),
}

FORCES_1936: dict[str, tuple] = {
    "GER": ("Bf 109B", {"MainWeapon": "mg17_machine_gun", "Engine": "jumo_211_engine"},
            "Panzer III Ausf. A", {"MainWeapon": "kwk_38_50mm_gun", "Engine": "maybach_hl120_trm", "Communications": "fug_16_zyf_radio"}, "Medium"),
    "FRA": ("Morane-Saulnier M.S.406", {"MainWeapon": "vickers_machine_gun", "Engine": "gnome_rhone_14n"},
            "Renault R35", {"MainWeapon": "sa_18_37mm_tank_gun", "Engine": "renault_4cyl_ft_engine"}, "Light"),
    "ENG": ("Hawker Hurricane (Proto)", {"MainWeapon": "hispano_mk2_cannon", "Engine": "merlin_xx_engine"},
            "Matilda I", {"MainWeapon": "qf_6pdr_gun", "Engine": "bedford_twin_six_engine"}, "Medium"),
    "USA": ("P-36 Hawk", {"MainWeapon": "lewis_gun_mount", "Engine": "wright_r1820_cyclone"},
            "M2A2 Light Tank", {"MainWeapon": "m1916_37mm_tank_gun", "Engine": "liberty_l12_engine"}, "Light"),
    "SOV": ("I-16 Type 10", {"MainWeapon": "mg17_machine_gun", "Engine": "wright_r1820_cyclone"},
            "BT-7", {"MainWeapon": "45mm_m1937_gun", "Engine": "v2_diesel_engine", "Suspension": "christie_suspension_bt"}, "Light"),
    "ITA": ("CR.32", {"MainWeapon": "vickers_machine_gun", "Engine": "gnome_rhone_14n"},
            "L3/33 Tankette", INTERWAR_TT, "Light"),
    "JAP": ("Ki-10 Perry", {"MainWeapon": "type99_mk2_cannon", "Engine": "jumo_211_engine"},
            "Type 95 Ha-Go", {"MainWeapon": "45mm_m1937_gun", "Engine": "v2_diesel_engine"}, "Light"),
    "POL": ("PZL P.11", {"MainWeapon": "lewis_gun_mount", "Engine": "liberty_l12_engine"},
            "7TP", {"MainWeapon": "bofors_37mm_at", "Engine": "spa_diesel_v8_engine"}, "Light"),
    "UKR": ("I-15 (Ukrainian)", {"MainWeapon": "mg17_machine_gun", "Engine": "wright_r1820_cyclone"},
            "T-26", {"MainWeapon": "45mm_m1937_gun", "Engine": "v2_diesel_engine"}, "Light"),
    "FIN": ("Fokker D.XXI", INTERWAR_FTR, "Vickers 6-Ton", INTERWAR_LT, "Light"),
    "NOR": ("Gloster Gladiator", {"MainWeapon": "hispano_mk2_cannon", "Engine": "merlin_xx_engine"},
            "Landsverk L-120", INTERWAR_LT, "Light"),
    "SWE": ("J 8 Gladiator", {"MainWeapon": "hispano_mk2_cannon", "Engine": "merlin_xx_engine"},
            "Strv m/38", INTERWAR_LT, "Light"),
    "DNK": ("Gloster Gladiator (Danish)", {"MainWeapon": "hispano_mk2_cannon", "Engine": "merlin_xx_engine"},
            "Landsverk L-60", INTERWAR_LT, "Light"),
    "NLD": ("Fokker D.XXI (Dutch)", INTERWAR_FTR, "Pantserwagen DAF", INTERWAR_LT, "Light"),
    "SAF": ("Hawker Fury (SAAF)", {"MainWeapon": "hispano_mk2_cannon", "Engine": "merlin_xx_engine"},
            "Vickers 6-Ton", INTERWAR_LT, "Light"),
    "AUS": ("CAC Wirraway", INTERWAR_FTR, "Vickers 6-Ton", INTERWAR_LT, "Light"),
    "NZL": ("Gloster Gladiator (RNZAF)", {"MainWeapon": "hispano_mk2_cannon", "Engine": "merlin_xx_engine"},
            "Vickers 6-Ton", INTERWAR_LT, "Light"),
    "CAN": ("Hawker Hurricane (RCAF)", {"MainWeapon": "hispano_mk2_cannon", "Engine": "merlin_xx_engine"},
            "Vickers 6-Ton", INTERWAR_LT, "Light"),
    "ARG": ("FMA D.21", INTERWAR_FTR, "Vickers 6-Ton", INTERWAR_LT, "Light"),
    "BRA": ("Waco C.3 (Brazilian)", INTERWAR_FTR, "L3/33 Tankette", INTERWAR_TT, "Light"),
    "MEX": ("TBD-1 Export Fighter", INTERWAR_FTR, "Carden-Loyd Tankette", INTERWAR_TT, "Light"),
    "EGY": ("Avro 504 (Egyptian)", INTERWAR_FTR, "Crossley Armored Car", INTERWAR_LT, "Light"),
    "IRN": ("Hawker Hind (Persian)", INTERWAR_FTR, "Crossley Armored Car", INTERWAR_LT, "Light"),
    "ISR": ("Mandate Trainer Fighter", INTERWAR_FTR, "Mandate Armored Car", INTERWAR_LT, "Light"),
    "PAL": ("Mandate Trainer Fighter", INTERWAR_FTR, "Mandate Armored Car", INTERWAR_LT, "Light"),
    "NGA": ("Colonial Trainer", INTERWAR_FTR, "Mandate Armored Car", INTERWAR_LT, "Light"),
    "SYR": ("Mandate Trainer Fighter", INTERWAR_FTR, "Mandate Armored Car", INTERWAR_LT, "Light"),
    "CHL": ("Hawker Osprey (Chilean)", INTERWAR_FTR, "Vickers 6-Ton", INTERWAR_LT, "Light"),
    "ISL": ("Danish Naval Fighter", INTERWAR_FTR, "Coastal Armored Truck", INTERWAR_LT, "Light"),
    "GRL": ("Greenland Patrol Aircraft", INTERWAR_FTR, "Coastal Armored Truck", INTERWAR_LT, "Light"),
}

FORCES_2026: dict[str, tuple] = {
    "USA": ("F-35A Block 4", EXPORT_2026_FTR | {"Sensors": "f35_block4_package"},
            "M1A2 SEP v4", {"MainWeapon": "m256a1_120mm_gun", "Engine": "agt1500_turbine", "Armor": "m1a2_sep_v4_armor", "Sensors": "trophy_aps_usa", "Cargo": "m829a4_apfsds"}, "Heavy"),
    "CHN": ("J-20A", {"MainWeapon": "pl15e_missile", "Engine": "j20a_operational"},
            "Type 99A", {"MainWeapon": "zpt98_125mm_gun", "Engine": "ws10b_engine", "Armor": "type99a_phase3_armor"}, "Heavy"),
    "RUS": ("Su-35S", {"MainWeapon": "r77_1_adder", "Engine": "su35_package"},
            "T-90M", {"MainWeapon": "2a46m5_125mm_gun", "Engine": "v46_6m_diesel", "Armor": "t90m_armor_package"}, "Heavy"),
    "GER": ("Eurofighter Typhoon", {"MainWeapon": "aim120d_amraam", "Engine": "eurofighter_typhoon"},
            "Leopard 2A7V", EXPORT_2026_MBT_LEO, "Heavy"),
    "ENG": ("Typhoon FGR4", {"MainWeapon": "aim120d_amraam", "Engine": "eurofighter_typhoon"},
            "Challenger 2 TES", {"MainWeapon": "l30_120mm_rifled", "Engine": "perkins_cv12_engine", "Armor": "challenger2_dorchester_mk2", "Cargo": "du_apfsds_gen4"}, "Heavy"),
    "FRA": ("Rafale F4", {"MainWeapon": "mica_ng_missile", "Engine": "rafale_package", "Sensors": "rafale_f4_package"},
            "Leclerc XXI", {"MainWeapon": "cn120_26_leclerc_gun", "Engine": "leclerc_hispano_engine", "Armor": "leclerc_xei_armor"}, "Heavy"),
    "JAP": ("F-35A (JASDF)", EXPORT_2026_FTR | {"Sensors": "f35_block4_package"},
            "Type 10", {"MainWeapon": "zpt98_125mm_gun", "Engine": "ws10b_engine", "Armor": "type100_mbt_proto"}, "Heavy"),
    "IND": ("Tejas Mk1A", {"MainWeapon": "astra_mk1_missile", "Engine": "tejas_naval_proto_package"},
            "Arjun Mk1A", {"MainWeapon": "rh120_l44_gun", "Engine": "mtu_mb873_engine", "Armor": "scenario_export_mbt_2026"}, "Heavy"),
    "ISR": ("F-35I Adir Block 4", {"MainWeapon": "aim120d_amraam", "Engine": "pratt_f135_engine", "Sensors": "f35i_adir_package"},
            "Merkava Mk 4 Barak", {"MainWeapon": "merkava_mk4m_120mm", "Engine": "merkava_avds_engine", "Armor": "merkava_mk4_barak"}, "Heavy"),
    "IRN": ("F-14AM Tomcat", {"MainWeapon": "aim54_phoenix", "Engine": "tf30_f14_engine"},
            "T-72S", {"MainWeapon": "2a46m_125mm_gun", "Engine": "v46_6m_diesel", "Armor": "t72b_kontakt5"}, "Medium"),
    "KOR": ("KF-21 Boramae", {"MainWeapon": "meteor_missile", "Engine": "ge_f414_super_hornet"},
            "K2 Black Panther", {"MainWeapon": "rh120_l55_gun", "Engine": "mtu_mb873_engine", "Armor": "scenario_export_mbt_2026"}, "Heavy"),
    "MEX": ("F-16C Block 52+", EXPORT_2026_FTR_F16,
            "M1A2C (Export)", EXPORT_2026_MBT, "Heavy"),
    "BRA": ("Gripen E", {"MainWeapon": "meteor_missile", "Engine": "ge_f414_super_hornet"},
            "Leopard 2A4 (Brazilian)", {"MainWeapon": "rh120_l44_gun", "Engine": "mtu_mb873_engine", "Armor": "leopard2a4_armor"}, "Heavy"),
    "ITA": ("Eurofighter Typhoon (AMI)", {"MainWeapon": "aim120d_amraam", "Engine": "eurofighter_typhoon"},
            "C1 Ariete", {"MainWeapon": "rh120_l44_gun", "Engine": "mtu_mb873_engine", "Armor": "scenario_export_mbt_2026"}, "Heavy"),
    "SPA": ("Eurofighter Typhoon (Spain)", {"MainWeapon": "aim120d_amraam", "Engine": "eurofighter_typhoon"},
            "Leopard 2E", {"MainWeapon": "rh120_l55_gun", "Engine": "mtu_mb873_engine", "Armor": "leopard2a6_armor"}, "Heavy"),
    "TUR": ("F-16C Block 70", EXPORT_2026_FTR_F16,
            "Altay", {"MainWeapon": "rh120_l55_gun", "Engine": "mtu_mb873_engine", "Armor": "scenario_export_mbt_2026"}, "Heavy"),
    "SAU": ("F-15SA", {"MainWeapon": "aim120d_amraam", "Engine": "pratt_f100_f15"},
            "M1A2S Abrams", EXPORT_2026_MBT, "Heavy"),
    "POL": ("F-35A (Polish)", EXPORT_2026_FTR | {"Sensors": "f35_block4_package"},
            "Leopard 2PL", {"MainWeapon": "rh120_l55_gun", "Engine": "mtu_mb873_engine", "Armor": "leopard2a6_armor"}, "Heavy"),
    "UKR": ("F-16C (Ukrainian)", EXPORT_2026_FTR_F16,
            "T-84 Oplot-M", {"MainWeapon": "2a46m5_125mm_gun", "Engine": "v46_6m_diesel", "Armor": "t72b_kontakt5"}, "Heavy"),
    "EGY": ("Rafale (Egyptian)", {"MainWeapon": "mica_ng_missile", "Engine": "rafale_package"},
            "M1A1 Abrams (Egyptian)", {"MainWeapon": "m256a1_120mm_gun", "Engine": "agt1500_turbine", "Armor": "m1a2_sep_v2_armor"}, "Heavy"),
    "IDN": ("F-16C (TNI-AU)", EXPORT_2026_FTR_F16,
            "Leopard 2RI", {"MainWeapon": "rh120_l44_gun", "Engine": "mtu_mb873_engine", "Armor": "leopard2a4_armor"}, "Heavy"),
    "THA": ("Gripen C/D", {"MainWeapon": "meteor_missile", "Engine": "ge_f414_super_hornet"},
            "VT-4", {"MainWeapon": "zpt98_125mm_gun", "Engine": "ws10b_engine", "Armor": "type99a_armor"}, "Heavy"),
    "MYS": ("FA-50 Block 20", {"MainWeapon": "aim120c_amraam", "Engine": "ge_f404_hornet"},
            "PT-91M Pendekar", {"MainWeapon": "2a46m_125mm_gun", "Engine": "v46_6m_diesel", "Armor": "t72b_kontakt5"}, "Medium"),
    "CAN": ("CF-18 Hornet (RCAF)", {"MainWeapon": "aim120c_amraam", "Engine": "ge_f404_hornet"},
            "Leopard 2A4M (Canadian)", {"MainWeapon": "rh120_l44_gun", "Engine": "mtu_mb873_engine", "Armor": "leopard2a4_armor"}, "Heavy"),
    "NOR": ("F-35A (RNoAF)", EXPORT_2026_FTR | {"Sensors": "f35_block4_package"},
            "Leopard 2A4NO", {"MainWeapon": "rh120_l44_gun", "Engine": "mtu_mb873_engine", "Armor": "leopard2a4_armor"}, "Heavy"),
    "SWE": ("JAS 39E Gripen", {"MainWeapon": "meteor_missile", "Engine": "ge_f414_super_hornet"},
            "Strv 122", {"MainWeapon": "rh120_l44_gun", "Engine": "mtu_mb873_engine", "Armor": "leopard2a5_wedge_armor"}, "Heavy"),
    "DNK": ("F-35A (RDAF)", EXPORT_2026_FTR | {"Sensors": "f35_block4_package"},
            "Leopard 2A7DK", EXPORT_2026_MBT_LEO, "Heavy"),
    "FIN": ("F/A-18C (Finnish)", {"MainWeapon": "aim120c_amraam", "Engine": "ge_f404_hornet"},
            "Leopard 2A6FIN", {"MainWeapon": "rh120_l55_gun", "Engine": "mtu_mb873_engine", "Armor": "leopard2a6_armor"}, "Heavy"),
    "NZL": ("F/A-18C (RNZAF)", {"MainWeapon": "aim120c_amraam", "Engine": "ge_f404_hornet"},
            "NZLAV (LAV III)", {"MainWeapon": "m242_bushmaster", "Engine": "bedford_twin_six_engine", "Armor": "scenario_export_mbt_2026"}, "Light"),
    "ISL": ("F-35A (Icelandic NATO)", EXPORT_2026_FTR | {"Sensors": "f35_block4_package"},
            "Icelandic Patrol LAV", {"MainWeapon": "m242_bushmaster", "Engine": "bedford_twin_six_engine"}, "Light"),
    "PAN": ("T-6 Texan II (Panamanian)", {"MainWeapon": "lewis_gun_mount", "Engine": "wright_r1820_cyclone"},
            "M113A3 (Panama)", {"MainWeapon": "m242_bushmaster", "Engine": "bedford_twin_six_engine"}, "Light"),
    "GRL": ("Greenland Patrol Helo Wing", {"MainWeapon": "lewis_gun_mount", "Engine": "wright_r1820_cyclone"},
            "Patrol LAV", {"MainWeapon": "m242_bushmaster", "Engine": "bedford_twin_six_engine"}, "Light"),
    "AZE": ("MiG-29 (Azerbaijani)", {"MainWeapon": "r77_1_adder", "Engine": "rd33_mig29_engine"},
            "T-72 (Azerbaijani)", {"MainWeapon": "2a46m_125mm_gun", "Engine": "v46_6m_diesel", "Armor": "t72b_kontakt5"}, "Medium"),
    "IRQ": ("F-16C (Iraqi)", EXPORT_2026_FTR_F16,
            "M1A1M (Iraqi)", {"MainWeapon": "m256a1_120mm_gun", "Engine": "agt1500_turbine", "Armor": "m1a2_sep_v2_armor"}, "Heavy"),
    "SYR": ("MiG-29 (Syrian)", {"MainWeapon": "r77_1_adder", "Engine": "rd33_mig29_engine"},
            "T-72 (Syrian)", {"MainWeapon": "2a46m_125mm_gun", "Engine": "v46_6m_diesel", "Armor": "t72b_kontakt5"}, "Medium"),
    "NGA": ("Alpha Jet (Nigerian)", {"MainWeapon": "aim9_sidewinder", "Engine": "ge_f404_hornet"},
            "VT-4 (Nigerian)", {"MainWeapon": "zpt98_125mm_gun", "Engine": "ws10b_engine", "Armor": "type99a_armor"}, "Heavy"),
    "COL": ("Kfir C10", {"MainWeapon": "python5_missile", "Engine": "kfir_j79_engine"},
            "M113A3 (Colombian)", {"MainWeapon": "m242_bushmaster", "Engine": "bedford_twin_six_engine"}, "Light"),
}
# fmt: on

NATION_TAGS = {
    "GER": ["german_army", "germany"],
    "FRA": ["french_army", "france"],
    "ENG": ["uk_army", "british", "united_kingdom"],
    "USA": ["us_army", "usa", "american"],
    "SOV": ["soviet_army", "soviet", "russia"],
    "RUS": ["russian_army", "russia"],
    "ITA": ["italian_army", "italy"],
    "JAP": ["japanese_army", "japan"],
    "TUR": ["turkish_army", "turkey", "ottoman"],
    "POL": ["polish_army", "poland"],
    "UKR": ["ukrainian_army", "ukraine"],
    "FIN": ["finnish_army", "finland"],
    "NOR": ["norwegian_army", "norway"],
    "SWE": ["swedish_army", "sweden"],
    "DNK": ["danish_army", "denmark"],
    "NLD": ["dutch_army", "netherlands"],
    "SAF": ["south_african_army", "south_africa"],
    "AUS": ["australian_army", "australia"],
    "NZL": ["new_zealand_army", "new_zealand"],
    "CAN": ["canadian_army", "canada"],
    "ARG": ["argentine_army", "argentina"],
    "BRA": ["brazilian_army", "brazil"],
    "MEX": ["mexican_army", "mexico"],
    "EGY": ["egyptian_army", "egypt"],
    "IRN": ["iranian_army", "iran", "persia"],
    "ISR": ["israeli_army", "israel"],
    "PAL": ["palestinian_army", "palestine", "mandate"],
    "NGA": ["nigerian_army", "nigeria"],
    "SYR": ["syrian_army", "syria"],
    "CHL": ["chilean_army", "chile"],
    "ISL": ["icelandic_army", "iceland"],
    "GRL": ["greenland_army", "greenland"],
    "CHN": ["chinese_army", "china"],
    "IND": ["indian_army", "india"],
    "KOR": ["south_korean_army", "korea"],
    "SPA": ["spanish_army", "spain"],
    "SAU": ["saudi_army", "saudi_arabia"],
    "IDN": ["indonesian_army", "indonesia"],
    "THA": ["thai_army", "thailand"],
    "MYS": ["malaysian_army", "malaysia"],
    "PAN": ["panamanian_army", "panama"],
    "AZE": ["azerbaijani_army", "azerbaijan"],
    "IRQ": ["iraqi_army", "iraq"],
    "COL": ["colombian_army", "colombia"],
}

ERA_CONFIG = {
    "1918": {
        "forces": FORCES_1918,
        "unlock": ["forces_1918", "army_1918", "air_1918", "ww1_army", "ww1_air"],
        "fighter_stats": {"speed": 68, "reliability": 62, "fuel_consumption": 7, "supply_need": 6, "armor": 6, "hardness": 16},
        "armor_light": {"speed": 18, "reliability": 65, "fuel_consumption": 5, "supply_need": 6, "armor": 18, "top_armor": 10, "hardness": 52},
        "armor_heavy": {"speed": 10, "reliability": 48, "fuel_consumption": 7, "supply_need": 10, "armor": 30, "top_armor": 14, "hardness": 58},
        "armor_medium": {"speed": 14, "reliability": 55, "fuel_consumption": 6, "supply_need": 8, "armor": 24, "top_armor": 12, "hardness": 55},
        "f_days": 36, "a_days": 45,
    },
    "1936": {
        "forces": FORCES_1936,
        "unlock": ["forces_1936", "army_1936", "air_1936", "interwar_army", "interwar_air"],
        "fighter_stats": {"speed": 82, "reliability": 68, "fuel_consumption": 9, "supply_need": 7, "armor": 10, "hardness": 22},
        "armor_light": {"speed": 28, "reliability": 68, "fuel_consumption": 6, "supply_need": 8, "armor": 24, "top_armor": 14, "hardness": 64},
        "armor_heavy": {"speed": 22, "reliability": 62, "fuel_consumption": 10, "supply_need": 14, "armor": 42, "top_armor": 22, "hardness": 78},
        "armor_medium": {"speed": 30, "reliability": 65, "fuel_consumption": 8, "supply_need": 11, "armor": 36, "top_armor": 18, "hardness": 72},
        "f_days": 42, "a_days": 52,
    },
    "2026": {
        "forces": FORCES_2026,
        "unlock": ["forces_2026", "army_2026", "air_2026", "twenty_twenties_army", "twenty_twenties_air"],
        "fighter_stats": {"speed": 108, "reliability": 78, "fuel_consumption": 20, "supply_need": 18, "armor": 10, "hardness": 28},
        "armor_light": {"speed": 38, "reliability": 78, "fuel_consumption": 10, "supply_need": 12, "armor": 42, "top_armor": 28, "hardness": 72},
        "armor_heavy": {"speed": 32, "reliability": 84, "fuel_consumption": 18, "supply_need": 24, "armor": 82, "top_armor": 60, "hardness": 96},
        "armor_medium": {"speed": 34, "reliability": 80, "fuel_consumption": 14, "supply_need": 18, "armor": 58, "top_armor": 40, "hardness": 85},
        "f_days": 120, "a_days": 125,
    },
}


def slug(s: str) -> str:
    return s.lower().replace(" ", "_").replace("(", "").replace(")", "").replace("-", "_").replace("/", "_")


def fighter_tpl(
    id_: str, name: str, family: str, loadout: dict, nation: list[str], unlock: list[str],
    stats: dict, days: int, era: str,
) -> dict:
    slots: dict = {"MainWeapon": {"max": 2 if era == "2026" else 1}, "Engine": {"max": 1}}
    if era == "2026":
        slots["Sensors"] = {"max": 1}
    elif era == "1918":
        pass
    else:
        slots["SecondaryWeapon"] = {"max": 1}
    return {
        "id": id_, "name": name, "design_family": family,
        "base_type": "Air", "size_category": "Light" if era != "2026" else "Medium",
        "visual_archetype": "fighter",
        "crew_required": 1,
        "base_training_level": 20 if era == "1918" else 28 if era == "1936" else 38,
        "max_experience_level": 100,
        "base_production_days": days,
        "base_stats": stats,
        "slots": slots,
        "module_loadout": loadout,
        "unlock_tech": unlock + nation,
        "can_mount_drones": era == "2026",
        "is_vehicle": True,
    }


def armor_tpl(
    id_: str, name: str, family: str, loadout: dict, nation: list[str], unlock: list[str],
    stats: dict, size: str, days: int, era: str,
) -> dict:
    archetype = "light_tank" if size == "Light" else "heavy_tank" if size == "Heavy" else "medium_tank"
    slots: dict = {"MainWeapon": {"max": 1}, "Engine": {"max": 1}}
    if "SecondaryWeapon" in loadout:
        slots["SecondaryWeapon"] = {"max": 2}
    if era in ("1936", "2026"):
        if era == "2026":
            slots["Armor"] = {"max": 1}
            slots["Sensors"] = {"max": 1}
            if size == "Heavy":
                slots["Cargo"] = {"max": 1}
        if "Suspension" in loadout:
            slots["Suspension"] = {"max": 1}
        if "Communications" in loadout:
            slots["Communications"] = {"max": 1}
    return {
        "id": id_, "name": name, "design_family": family,
        "base_type": "Armored", "size_category": size,
        "visual_archetype": archetype,
        "crew_required": 4 if size == "Heavy" else 3 if size == "Medium" else 2,
        "base_training_level": 12 if era == "1918" else 22 if era == "1936" else 36,
        "max_experience_level": 100,
        "base_production_days": days,
        "base_stats": stats,
        "slots": slots,
        "module_loadout": loadout,
        "unlock_tech": unlock + nation,
        "can_mount_drones": False,
        "is_vehicle": True,
    }


def build_templates(era: str) -> list[dict]:
    cfg = ERA_CONFIG[era]
    unlock = cfg["unlock"]
    templates: list[dict] = []
    for tag, spec in cfg["forces"].items():
        f_name, f_load, a_name, a_load, a_size = spec
        nation = NATION_TAGS.get(tag, [tag.lower()])
        fam = f"{nation[0]}_{era}"
        f_id = f"{tag.lower()}_fighter_{era}"
        a_id = f"{tag.lower()}_mbt_{era}" if era == "2026" and a_size != "Light" else f"{tag.lower()}_armor_{era}"
        stats_f = cfg["fighter_stats"]
        stats_a = cfg[f"armor_{a_size.lower()}"]
        templates.append(fighter_tpl(
            f_id, f_name, f"{fam}_air", f_load, nation, unlock, stats_f, cfg["f_days"], era,
        ))
        templates.append(armor_tpl(
            a_id, a_name, f"{fam}_armor", a_load, nation, unlock, stats_a, a_size, cfg["a_days"], era,
        ))
    return templates


def load_scenario_tags(scenario_file: str) -> list[str]:
    data = json.loads((SCENARIOS_DIR / scenario_file).read_text())
    return [c["tag"] for c in data["countries"]]


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

    all_templates: list[dict] = []
    for era in ("1918", "1936", "2026"):
        all_templates.extend(build_templates(era))

    for tpl in all_templates:
        if tpl["id"] in existing_t:
            continue
        path = TEMPLATES_DIR / f"{tpl['id']}.json"
        write_unit_template(path, tpl)
        tc += 1
        print(f"  + template {tpl['id']}.json")

    mods = {p.stem for p in MODULES_DIR.glob("*.json")}
    errs: list[str] = []
    for p in TEMPLATES_DIR.glob("*.json"):
        try:
            d = json.loads(p.read_text())
        except json.JSONDecodeError:
            continue
        for slot, mid in d.get("module_loadout", {}).items():
            if mid and mid not in mods:
                errs.append(f"{p.name}: {slot} -> {mid}")

    for era, scenario in [("1918", "1918.json"), ("1936", "1936.json"), ("2026", "2026.json")]:
        tags = load_scenario_tags(scenario)
        missing = [t for t in tags if t not in ERA_CONFIG[era]["forces"]]
        if missing:
            print(f"  ! {era} config missing nations: {missing}")

    print(f"\nScenario forces: {mc} modules, {tc} templates. Missing module refs: {len(errs)}")
    for e in errs[:30]:
        print(f"  ! {e}")
    if len(errs) > 30:
        print(f"  ... +{len(errs) - 30} more")


if __name__ == "__main__":
    main()
