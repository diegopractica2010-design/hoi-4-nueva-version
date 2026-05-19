#!/usr/bin/env python3
"""Surface warship templates: carriers, battleships, cruisers, destroyers pre-WWI–2030s."""

from __future__ import annotations

from template_export import write_unit_template
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "data"
MODULES_DIR = ROOT / "modules"
TEMPLATES_DIR = ROOT / "unit_templates"

# fmt: off
MODULES: list[dict] = [
    {"id": "westinghouse_a4w_carrier_reactor", "name": "Westinghouse A4W (Carrier)", "category": "Engine", "tier": 7,
     "reliability_bonus": 14, "fuel_efficiency": 20, "speed_bonus": 8,
     "cost": {"steel": 35, "uranium": 35, "electronics": 30}, "production_time": 140,
     "special_flags": ["usa", "nuclear", "carrier", "cold_war"],
     "description": "A4W reactor plant on Nimitz and Enterprise. Unlimited range for carrier strike groups."},
    {"id": "midway_class_flight_deck", "name": "Midway-class Flight Deck", "category": "Cargo", "tier": 5,
     "reliability_bonus": 6,
     "cost": {"steel": 90, "electronics": 20, "aluminum": 25}, "production_time": 200,
     "special_flags": ["usa", "carrier", "cold_war", "angled_deck"],
     "description": "First U.S. supercarrier with angled deck and steam catapults. Postwar jet operations."},
    {"id": "forrestal_supercarrier_deck", "name": "Forrestal Supercarrier Deck", "category": "Cargo", "tier": 6,
     "reliability_bonus": 8,
     "cost": {"steel": 100, "electronics": 28, "aluminum": 30}, "production_time": 220,
     "special_flags": ["usa", "carrier", "cold_war", "supercarrier"],
     "description": "First purpose-built U.S. supercarrier class. Steam catapult and large air wing."},
    {"id": "clemenceau_catapult_deck", "name": "Clemenceau Catapult Deck", "category": "Cargo", "tier": 5,
     "reliability_bonus": 5,
     "cost": {"steel": 85, "electronics": 22, "aluminum": 22}, "production_time": 195,
     "special_flags": ["france", "carrier", "catapult", "cold_war"],
     "description": "French CATOBAR carrier operating Super Étendard and later Rafale M."},
    {"id": "cvn_x_carrier_proto", "name": "CVN(X) Carrier Proto", "category": "Cargo", "tier": 9,
     "reliability_bonus": 10,
     "cost": {"steel": 130, "electronics": 70, "aluminum": 45, "uranium": 18}, "production_time": 280,
     "special_flags": ["usa", "carrier", "prototype", "twenty_thirties", "emals"],
     "description": "Planned U.S. carrier successor to Ford with advanced EMALS and reduced crew."},
    {"id": "type055_cruiser_vls", "name": "Type 055 Cruiser VLS", "category": "SecondaryWeapon", "tier": 7,
     "soft_attack": 48, "hard_attack": 52, "piercing": 42, "anti_ship": 88, "air_attack": 35,
     "cost": {"steel": 18, "electronics": 40, "explosives": 25}, "production_time": 95,
     "special_flags": ["china", "cruiser", "vls", "twenty_tens"],
     "description": "112-cell VLS on Renhai-class cruiser. Area air defense and anti-ship strike."},
    {"id": "mk41_vls_destroyer", "name": "Mk 41 VLS", "category": "SecondaryWeapon", "tier": 6,
     "soft_attack": 42, "hard_attack": 48, "piercing": 38, "anti_ship": 82, "air_attack": 30,
     "cost": {"steel": 14, "electronics": 35, "explosives": 20}, "production_time": 85,
     "special_flags": ["usa", "nato", "vls", "destroyer"],
     "description": "Standard U.S. and allied naval vertical launch system for SM-2/6 and Tomahawk."},
    {"id": "zumwalt_stealth_hull", "name": "Zumwalt Stealth Hull", "category": "Armor", "tier": 7,
     "armor_bonus": 38, "top_armor_bonus": 32, "reliability_bonus": 4,
     "cost": {"steel": 45, "titanium": 12, "electronics": 25}, "production_time": 110,
     "special_flags": ["usa", "destroyer", "stealth", "twenty_tens"],
     "description": "Tumblehome destroyer hull with reduced radar cross-section and advanced gun system."},
]


def _naval(
    id_: str, name: str, family: str, archetype: str, loadout: dict, unlock: list[str],
    size: str = "Heavy", days: int = 180, training: int = 32, crew: int = 500,
    stats: dict | None = None, slots: dict | None = None,
) -> dict:
    base = stats or {
        "speed": 28, "reliability": 72, "fuel_consumption": 60,
        "supply_need": 80, "armor": 35, "deck_armor": 20, "hardness": 65,
    }
    default_slots = {
        "NavalGun": {"max": 2}, "SecondaryWeapon": {"max": 2},
        "Engine": {"max": 1}, "Armor": {"max": 1},
        "Sensors": {"max": 2}, "AntiAir": {"max": 1},
    }
    return {
        "id": id_, "name": name, "design_family": family,
        "base_type": "Naval", "size_category": size,
        "visual_archetype": archetype,
        "crew_required": crew, "base_training_level": training,
        "max_experience_level": 100, "base_production_days": days,
        "base_stats": base,
        "slots": slots or default_slots,
        "module_loadout": loadout,
        "unlock_tech": unlock,
        "can_mount_drones": False,
        "is_vehicle": True,
    }


def cv(
    id_: str, name: str, family: str, loadout: dict, unlock: list[str],
    days: int = 240, crew: int = 2000, training: int = 34,
    stats: dict | None = None, size: str = "Heavy",
) -> dict:
    s = stats or {
        "speed": 30, "reliability": 75, "fuel_consumption": 90,
        "supply_need": 110, "armor": 30, "deck_armor": 22, "hardness": 62,
    }
    return _naval(
        id_, name, family, "carrier", loadout, unlock,
        size=size, days=days, crew=crew, training=training, stats=s,
        slots={
            "Armor": {"max": 1}, "Engine": {"max": 1}, "Cargo": {"max": 1},
            "Sensors": {"max": 2}, "AntiAir": {"max": 2},
        },
    )


def bb(
    id_: str, name: str, family: str, guns: str, unlock: list[str],
    secondary: str = "mk15_torpedo_tube", engine: str = "us_parsons_turbine",
    days: int = 280, crew: int = 1500, stats: dict | None = None,
) -> dict:
    s = stats or {
        "speed": 26, "reliability": 70, "fuel_consumption": 100,
        "supply_need": 130, "armor": 58, "deck_armor": 32, "hardness": 88,
    }
    return _naval(
        id_, name, family, "battleship",
        {"NavalGun": guns, "SecondaryWeapon": secondary, "Engine": engine,
         "Armor": "naval_belt_armor_scheme", "Sensors": "naval_fire_control_mk37",
         "Communications": "scr_522_radio"},
        unlock, size="SuperHeavy", days=days, crew=crew, training=36, stats=s,
        slots={
            "NavalGun": {"max": 2}, "SecondaryWeapon": {"max": 2},
            "Engine": {"max": 1}, "Armor": {"max": 1},
            "Communications": {"max": 1}, "Sensors": {"max": 1},
        },
    )


def ca(
    id_: str, name: str, family: str, guns: str, unlock: list[str],
    secondary: str = "mk15_torpedo_tube", engine: str = "us_parsons_turbine",
    sensors: str = "naval_fire_control_mk37", days: int = 200, crew: int = 700,
    stats: dict | None = None,
) -> dict:
    s = stats or {
        "speed": 30, "reliability": 74, "fuel_consumption": 65,
        "supply_need": 85, "armor": 40, "deck_armor": 18, "hardness": 70,
    }
    return _naval(
        id_, name, family, "cruiser",
        {"NavalGun": guns, "SecondaryWeapon": secondary, "Engine": engine,
         "Armor": "naval_belt_armor_scheme", "Sensors": sensors},
        unlock, size="Heavy", days=days, crew=crew, stats=s,
    )


def dd(
    id_: str, name: str, family: str, loadout: dict, unlock: list[str],
    days: int = 120, crew: int = 300, training: int = 30,
    stats: dict | None = None, size: str = "Light",
) -> dict:
    s = stats or {
        "speed": 34, "reliability": 76, "fuel_consumption": 45,
        "supply_need": 55, "armor": 22, "deck_armor": 12, "hardness": 55,
    }
    return _naval(
        id_, name, family, "destroyer", loadout, unlock,
        size=size, days=days, crew=crew, training=training, stats=s,
    )


TEMPLATES: list[dict] = [
    # ═══ CARRIERS · Interwar / WWI ═══════════════════════════════════════════════
    cv("hms_argus_carrier", "HMS Argus", "uk_naval_interwar",
       {"Cargo": "carrier_air_wing_bunker", "Engine": "carrier_boiler_yarrow",
        "Armor": "carrier_wooden_flight_deck", "Sensors": "naval_fire_control_mk37"},
       ["uk_carriers", "interwar_naval", "first_carrier"], days=200, crew=450, training=28,
       stats={"speed": 20, "reliability": 65, "fuel_consumption": 55, "supply_need": 70,
              "armor": 18, "deck_armor": 12, "hardness": 45}),
    cv("hms_hermes_carrier", "HMS Hermes", "uk_naval_interwar",
       {"Cargo": "carrier_air_wing_bunker", "Engine": "geared_steam_turbine_60k",
        "Armor": "carrier_wooden_flight_deck", "AntiAir": "carrier_aa_20mm_oerlikon"},
       ["uk_carriers", "interwar_naval"], days=220, crew=700, training=30),
    cv("hosho_carrier", "Hōshō", "japanese_naval_interwar",
       {"Cargo": "carrier_air_wing_bunker", "Engine": "ijn_kampon_turbine",
        "Armor": "carrier_wooden_flight_deck", "Sensors": "naval_radar_type22"},
       ["japanese_carriers", "interwar_naval"], size="Medium", days=180, crew=550, training=32),
    cv("bearn_carrier", "Béarn", "french_naval_interwar",
       {"Cargo": "carrier_air_wing_bunker", "Engine": "carrier_boiler_yarrow",
        "Armor": "carrier_wooden_flight_deck", "AntiAir": "carrier_aa_20mm_oerlikon"},
       ["french_carriers", "interwar_naval"], days=250, crew=900, training=29),

    # ═══ CARRIERS · WWII fleet & light ═════════════════════════════════════════
    cv("lexington_class_carrier", "Lexington-class", "us_naval_ww2",
       {"Cargo": "carrier_air_wing_bunker", "Engine": "geared_steam_turbine_60k",
        "Armor": "carrier_wooden_flight_deck", "Sensors": "sg_surface_radar",
        "AntiAir": "carrier_aa_bofors_40mm"},
       ["us_carriers", "interwar_naval", "fleet_carriers"], days=260, crew=2100),
    cv("ranger_carrier", "USS Ranger (CV-4)", "us_naval_ww2",
       {"Cargo": "carrier_air_wing_bunker", "Engine": "geared_steam_turbine_60k",
        "Armor": "carrier_wooden_flight_deck", "AntiAir": "carrier_aa_20mm_oerlikon"},
       ["us_carriers", "interwar_naval"], size="Medium", days=220, crew=1800),
    cv("shokaku_class_carrier", "Shōkaku-class", "japanese_naval_ww2",
       {"Cargo": "carrier_air_wing_bunker", "Engine": "ijn_kampon_turbine",
        "Armor": "carrier_wooden_flight_deck", "Sensors": "naval_radar_type22",
        "AntiAir": "carrier_aa_20mm_oerlikon"},
       ["japanese_carriers", "kido_butai"], days=270, crew=2000, training=36),
    cv("soryu_class_carrier", "Soryu-class", "japanese_naval_ww2",
       {"Cargo": "carrier_air_wing_bunker", "Engine": "ijn_kampon_turbine",
        "Armor": "carrier_wooden_flight_deck", "AntiAir": "carrier_aa_20mm_oerlikon"},
       ["japanese_carriers", "kido_butai"], size="Medium", days=250, crew=1100),
    cv("taiho_carrier", "Taihō", "japanese_naval_ww2",
       {"Cargo": "carrier_air_wing_bunker", "Engine": "ijn_kampon_turbine",
        "Armor": "carrier_armored_flight_deck", "Sensors": "naval_radar_type22",
        "AntiAir": "carrier_aa_bofors_40mm"},
       ["japanese_carriers", "late_war"], days=280, crew=2400, training=37),
    cv("shinano_carrier", "Shinano", "japanese_naval_ww2",
       {"Cargo": "carrier_air_wing_bunker", "Engine": "ijn_kampon_turbine",
        "Armor": "carrier_armored_flight_deck", "AntiAir": "carrier_aa_bofors_40mm"},
       ["japanese_carriers", "converted_battleship"], size="SuperHeavy", days=320, crew=2400),
    cv("junyo_class_carrier", "Jun'yō-class", "japanese_naval_ww2",
       {"Cargo": "carrier_air_wing_bunker", "Engine": "ijn_kampon_turbine",
        "Armor": "carrier_wooden_flight_deck", "AntiAir": "carrier_aa_20mm_oerlikon"},
       ["japanese_carriers", "converted_cruiser"], size="Medium", days=240, crew=1200),
    cv("independence_class_cve", "Independence-class CVE", "us_naval_ww2",
       {"Cargo": "escort_carrier_hanger", "Engine": "geared_steam_turbine_60k",
        "Sensors": "sk_surface_radar", "AntiAir": "carrier_aa_20mm_oerlikon"},
       ["us_escort_carriers", "light_carrier"], size="Medium", days=100, crew=900, training=30),
    cv("colossus_class_carrier", "Colossus-class", "uk_naval_ww2",
       {"Cargo": "carrier_air_wing_bunker", "Engine": "carrier_boiler_yarrow",
        "Armor": "carrier_armored_flight_deck", "Sensors": "type281_surface_radar",
        "AntiAir": "carrier_aa_bofors_40mm"},
       ["uk_carriers", "light_carrier"], size="Medium", days=180, crew=1100),
    cv("aquila_carrier", "Aquila", "italian_naval_ww2",
       {"Cargo": "carrier_air_wing_bunker", "Engine": "geared_steam_turbine_60k",
        "Armor": "carrier_wooden_flight_deck", "AntiAir": "carrier_aa_20mm_oerlikon"},
       ["italian_carriers", "german_paper_naval"], days=300, crew=1400, training=28),

    # ═══ CARRIERS · Cold War ═══════════════════════════════════════════════════
    cv("midway_class_carrier", "Midway-class", "us_naval_cold_war",
       {"Cargo": "midway_class_flight_deck", "Engine": "geared_steam_turbine_60k",
        "Armor": "carrier_armored_flight_deck", "Sensors": "an_sps6_air_search",
        "AntiAir": "carrier_aa_bofors_40mm"},
       ["us_carriers", "cold_war_naval", "supercarrier"], size="SuperHeavy", days=300, crew=4100),
    cv("forrestal_class_carrier", "Forrestal-class", "us_naval_cold_war",
       {"Cargo": "forrestal_supercarrier_deck", "Engine": "geared_steam_turbine_60k",
        "Armor": "carrier_armored_flight_deck", "Sensors": "an_sps6_air_search",
        "AntiAir": "mim23_hawk_sam"},
       ["us_carriers", "cold_war_naval", "supercarrier"], size="SuperHeavy", days=310, crew=4500),
    cv("kitty_hawk_class_carrier", "Kitty Hawk-class", "us_naval_cold_war",
       {"Cargo": "forrestal_supercarrier_deck", "Engine": "geared_steam_turbine_60k",
        "Armor": "carrier_armored_flight_deck", "Sensors": "an_sps6_air_search",
        "AntiAir": "mim23_hawk_sam"},
       ["us_carriers", "cold_war_naval", "vietnam"], days=290, crew=4200),
    cv("enterprise_cvn65", "USS Enterprise (CVN-65)", "us_naval_cold_war",
       {"Cargo": "forrestal_supercarrier_deck", "Engine": "westinghouse_a4w_carrier_reactor",
        "Armor": "carrier_armored_flight_deck", "Sensors": "an_sps6_air_search",
        "AntiAir": "mim23_hawk_sam"},
       ["us_carriers", "nuclear_carrier", "cold_war_naval"], size="SuperHeavy", days=320, crew=4600),
    cv("clemenceau_class_carrier", "Clemenceau-class", "french_naval_cold_war",
       {"Cargo": "clemenceau_catapult_deck", "Engine": "carrier_boiler_yarrow",
        "Armor": "carrier_armored_flight_deck", "Sensors": "type281_surface_radar",
        "AntiAir": "roland_sam"},
       ["french_carriers", "cold_war_naval"], days=270, crew=1800),
    cv("centaur_class_carrier", "Centaur-class", "uk_naval_cold_war",
       {"Cargo": "carrier_air_wing_bunker", "Engine": "carrier_boiler_yarrow",
        "Armor": "carrier_armored_flight_deck", "Sensors": "type281_surface_radar",
        "AntiAir": "sea_dart_sam"},
       ["uk_carriers", "cold_war_naval"], size="Medium", days=240, crew=1500),

    # ═══ CARRIERS · 2030s planned ════════════════════════════════════════════════
    cv("cvn_x_prototype", "CVN(X) (Prototype)", "us_naval_planned",
       {"Cargo": "cvn_x_carrier_proto", "Engine": "westinghouse_a4w_carrier_reactor",
        "Sensors": "aegis_spy1_radar", "AntiAir": "aegis_bmd_package"},
       ["us_carriers", "prototype", "twenty_thirties"], days=320, crew=1800, training=42),

    # ═══ BATTLESHIPS · WWI / Interwar ════════════════════════════════════════════
    bb("iron_duke_class_bb", "Iron Duke-class", "uk_naval_ww1",
       "uk_13_5inch_mk5", ["uk_battleships", "ww1_naval", "dreadnought"],
       engine="carrier_boiler_yarrow", days=240, crew=1000,
       stats={"speed": 21, "reliability": 68, "fuel_consumption": 85, "supply_need": 100,
              "armor": 50, "deck_armor": 22, "hardness": 78}),
    bb("nagato_class_battleship", "Nagato-class", "japanese_naval_interwar",
       "ijn_14inch_type94", ["japanese_battleships", "interwar_naval"],
       secondary="type93_long_lance", engine="ijn_kampon_turbine", days=300, crew=1400,
       stats={"speed": 27, "reliability": 72, "fuel_consumption": 95, "supply_need": 125,
              "armor": 56, "deck_armor": 30, "hardness": 85}),
    bb("colorado_class_battleship", "Colorado-class", "us_naval_interwar",
       "us_16inch_45_gun", ["us_battleships", "interwar_naval"], days=290, crew=1200),
    bb("andrea_doria_class_bb", "Andrea Doria-class", "italian_naval_ww1",
       "ita_12inch_m1914", ["italian_battleships", "ww1_naval"],
       engine="geared_steam_turbine_60k", days=260, crew=1100),

    # ═══ BATTLESHIPS · WWII ══════════════════════════════════════════════════════
    bb("north_carolina_class_bb", "North Carolina-class", "us_naval_ww2",
       "us_16inch_45_gun", ["us_battleships", "treaty_escalator"],
       engine="geared_steam_turbine_60k", days=300, crew=1800),
    bb("south_dakota_class_bb", "South Dakota-class", "us_naval_ww2",
       "us_16inch_45_gun", ["us_battleships", "ww2_naval"],
       engine="geared_steam_turbine_60k", days=290, crew=1900),
    bb("iowa_class_battleship", "Iowa-class", "us_naval_ww2",
       "us_16inch_50_gun", ["us_battleships", "fast_battleship"],
       engine="iowa_class_turbine_212k", days=310, crew=2200,
       stats={"speed": 32, "reliability": 78, "fuel_consumption": 110, "supply_need": 140,
              "armor": 60, "deck_armor": 35, "hardness": 92}),
    bb("king_george_v_class_bb", "King George V-class", "uk_naval_ww2",
       "uk_14inch_mk7", ["uk_battleships", "ww2_naval"],
       engine="carrier_boiler_yarrow", days=280, crew=1500),
    bb("nelson_class_battleship", "Nelson-class", "uk_naval_interwar",
       "us_16inch_45_gun", ["uk_battleships", "treaty_battleship"],
       engine="carrier_boiler_yarrow", days=300, crew=1400),
    bb("renown_class_battlecruiser", "Renown-class", "uk_naval_ww2",
       "uk_15inch_mk1", ["uk_battlecruisers", "ww2_naval"],
       engine="geared_steam_turbine_60k", days=260, crew=1200,
       stats={"speed": 30, "reliability": 70, "fuel_consumption": 90, "supply_need": 110,
              "armor": 48, "deck_armor": 24, "hardness": 80}),
    bb("scharnhorst_class_bb", "Scharnhorst-class", "german_naval_ww2",
       "ger_11inch_skc34", ["german_battleships", "ww2_naval"],
       secondary="g7a_torpedo", engine="german_wagner_turbine", days=270, crew=1800),
    bb("tirpitz_battleship", "Tirpitz", "german_naval_ww2",
       "ger_15inch_skc34", ["german_battleships", "atlantic_raider"],
       secondary="g7a_torpedo", engine="german_wagner_turbine", days=300, crew=2200),
    bb("vittorio_veneto_bb", "Vittorio Veneto", "italian_naval_ww2",
       "ita_12inch_m1914", ["italian_battleships", "ww2_naval"],
       engine="geared_steam_turbine_60k", days=280, crew=1900),
    bb("richelieu_battleship", "Richelieu", "french_naval_ww2",
       "fra_13_4inch_m1934", ["french_battleships", "ww2_naval"],
       engine="geared_steam_turbine_60k", days=290, crew=1700),
    bb("dunkerque_class_bb", "Dunkerque-class", "french_naval_interwar",
       "fra_13_4inch_m1934", ["french_battleships", "treaty_battleship"],
       engine="geared_steam_turbine_60k", days=270, crew=1300),
    bb("kongo_class_battlecruiser", "Kongo-class", "japanese_naval_ww2",
       "ijn_14inch_type94", ["japanese_battleships", "battlecruiser"],
       secondary="type93_long_lance", engine="ijn_kampon_turbine", days=280, crew=1400,
       stats={"speed": 30, "reliability": 68, "fuel_consumption": 95, "supply_need": 120,
              "armor": 52, "deck_armor": 26, "hardness": 82}),
    bb("fuso_class_battleship", "Fusō-class", "japanese_naval_ww2",
       "ijn_14inch_type94", ["japanese_battleships", "ww2_naval"],
       secondary="type93_long_lance", engine="ijn_kampon_turbine", days=300, crew=1600),

    # ═══ CRUISERS · WWII ═════════════════════════════════════════════════════════
    ca("baltimore_class_cruiser", "Baltimore-class", "us_naval_ww2",
       "us_8inch_55_gun", ["us_cruisers", "ww2_naval"], days=210, crew=1700),
    ca("cleveland_class_cruiser", "Cleveland-class", "us_naval_ww2",
       "us_6inch_47_gun", ["us_cruisers", "light_cruiser", "ww2_naval"],
       days=190, crew=1200,
       stats={"speed": 32, "reliability": 76, "fuel_consumption": 58, "supply_need": 75,
              "armor": 35, "deck_armor": 16, "hardness": 65}),
    ca("brooklyn_class_cruiser", "Brooklyn-class", "us_naval_ww2",
       "us_6inch_47_gun", ["us_cruisers", "interwar_naval"], days=200, crew=1100),
    ca("portland_class_cruiser", "Portland-class", "us_naval_ww2",
       "us_8inch_55_gun", ["us_cruisers", "ww2_naval"], days=205, crew=900),
    ca("county_class_cruiser", "County-class", "uk_naval_interwar",
       "uk_8inch_mk8", ["uk_cruisers", "interwar_naval"],
       engine="carrier_boiler_yarrow", days=220, crew=700),
    ca("town_class_cruiser", "Town-class", "uk_naval_ww2",
       "uk_6inch_bl_mk12", ["uk_cruisers", "ww2_naval"],
       engine="carrier_boiler_yarrow", days=200, crew=750),
    ca("hipper_class_cruiser", "Admiral Hipper-class", "german_naval_ww2",
       "us_8inch_55_gun", ["german_cruisers", "ww2_naval"],
       secondary="g7a_torpedo", engine="german_wagner_turbine", days=230, crew=1600),
    ca("mogami_class_cruiser", "Mogami-class", "japanese_naval_ww2",
       "ijn_8inch_type3", ["japanese_cruisers", "ww2_naval"],
       secondary="type93_long_lance", engine="ijn_kampon_turbine", days=220, crew=850),
    ca("zara_class_cruiser", "Zara-class", "italian_naval_ww2",
       "ita_12inch_m1914", ["italian_cruisers", "ww2_naval"],
       engine="geared_steam_turbine_60k", days=215, crew=800,
       stats={"speed": 32, "reliability": 70, "fuel_consumption": 62, "supply_need": 78,
              "armor": 42, "deck_armor": 20, "hardness": 72}),

    # ═══ CRUISERS · Cold War / Modern ════════════════════════════════════════════
    ca("des_moines_class_cruiser", "Des Moines-class", "us_naval_cold_war",
       "us_8inch_55_gun", ["us_cruisers", "cold_war_naval", "autoloading"],
       sensors="an_sps6_air_search", days=230, crew=1700),
    ca("alaska_class_cb", "Alaska-class", "us_naval_ww2",
       "uk_12inch_mk10", ["us_cruisers", "large_cruiser"], days=250, crew=1500,
       stats={"speed": 31, "reliability": 74, "fuel_consumption": 80, "supply_need": 95,
              "armor": 48, "deck_armor": 22, "hardness": 75}),
    ca("ticonderoga_class_cruiser", "Ticonderoga-class", "us_naval_cold_war",
       "us_5inch_54_mk42", ["us_cruisers", "aegis", "cold_war_naval"],
       secondary="mk41_vls_destroyer", sensors="aegis_spy1_radar", days=220, crew=380,
       stats={"speed": 30, "reliability": 82, "fuel_consumption": 70, "supply_need": 90,
              "armor": 42, "deck_armor": 25, "hardness": 70}),
    ca("kirov_class_battlecruiser", "Kirov-class", "russian_naval_cold_war",
       "us_5inch_54_mk42", ["russian_cruisers", "cold_war_naval"],
       secondary="kalibr_vls_sub", engine="vm_reactor_soviet", sensors="type281_surface_radar",
       days=280, crew=710,
       stats={"speed": 32, "reliability": 65, "fuel_consumption": 85, "supply_need": 100,
              "armor": 50, "deck_armor": 28, "hardness": 78}),
    ca("slava_class_cruiser", "Slava-class", "russian_naval_cold_war",
       "us_8inch_55_gun", ["russian_cruisers", "cold_war_naval"],
       secondary="kalibr_vls_sub", engine="geared_steam_turbine_60k", days=240, crew=480),
    ca("type055_cruiser", "Type 055 Renhai", "chinese_naval_modern",
       "us_5inch_54_mk42", ["chinese_cruisers", "twenty_tens"],
       secondary="type055_cruiser_vls", sensors="type055_destroyer_vls",
       engine="geared_steam_turbine_60k", days=210, crew=280,
       stats={"speed": 30, "reliability": 80, "fuel_consumption": 72, "supply_need": 88,
              "armor": 44, "deck_armor": 26, "hardness": 72}),

    # ═══ DESTROYERS · WWI ════════════════════════════════════════════════════════
    dd("wickes_class_destroyer", "Wickes-class", "us_naval_ww1",
       {"NavalGun": "ww1_4inch_qf_mk4", "SecondaryWeapon": "ww1_18inch_torpedo",
        "Engine": "us_parsons_turbine", "Sensors": "naval_fire_control_mk37"},
       ["us_destroyers", "ww1_naval"], days=90, crew=120, training=24,
       stats={"speed": 35, "reliability": 65, "fuel_consumption": 35, "supply_need": 40,
              "armor": 12, "deck_armor": 8, "hardness": 42}),
    dd("v_class_destroyer", "V-class Destroyer", "uk_naval_ww1",
       {"NavalGun": "uk_4_7inch_qf", "SecondaryWeapon": "ww1_18inch_torpedo",
        "Engine": "carrier_boiler_yarrow", "Sensors": "naval_fire_control_mk37"},
       ["uk_destroyers", "ww1_naval"], days=95, crew=110, training=24),

    # ═══ DESTROYERS · WWII ═════════════════════════════════════════════════════════
    dd("tribal_class_destroyer", "Tribal-class", "uk_naval_ww2",
       {"NavalGun": "uk_4_7inch_qf", "SecondaryWeapon": "mk15_torpedo_tube",
        "Engine": "carrier_boiler_yarrow", "Sensors": "type281_surface_radar",
        "AntiAir": "carrier_aa_bofors_40mm"},
       ["uk_destroyers", "ww2_naval"], days=130, crew=260),
    dd("fubuki_class_destroyer", "Fubuki-class", "japanese_naval_ww2",
       {"NavalGun": "ijn_12_7cm_type89", "SecondaryWeapon": "type93_long_lance",
        "Engine": "ijn_kampon_turbine", "Sensors": "naval_radar_type22"},
       ["japanese_destroyers", "ww2_naval", "special_type"], days=125, crew=220, training=34),
    dd("kagero_class_destroyer", "Kagero-class", "japanese_naval_ww2",
       {"NavalGun": "ijn_12_7cm_type89", "SecondaryWeapon": "type93_long_lance",
        "Engine": "ijn_kampon_turbine", "Sensors": "naval_radar_type22"},
       ["japanese_destroyers", "ww2_naval"], days=128, crew=240),
    dd("sumner_class_destroyer", "Sumner-class", "us_naval_ww2",
       {"NavalGun": "us_5inch_38_gun", "SecondaryWeapon": "mk15_torpedo_tube",
        "Engine": "geared_steam_turbine_60k", "Sensors": "naval_fire_control_mk37"},
       ["us_destroyers", "ww2_naval"], days=120, crew=320),
    dd("gearing_class_destroyer", "Gearing-class", "us_naval_ww2",
       {"NavalGun": "us_5inch_38_gun", "SecondaryWeapon": "mk15_torpedo_tube",
        "Engine": "geared_steam_turbine_60k", "Sensors": "sg_surface_radar",
        "AntiAir": "carrier_aa_bofors_40mm"},
       ["us_destroyers", "ww2_naval", "cold_war_naval"], days=125, crew=340),

    # ═══ DESTROYERS · Cold War / Modern / 2030s ══════════════════════════════════
    dd("spruance_class_destroyer", "Spruance-class", "us_naval_cold_war",
       {"NavalGun": "us_5inch_54_mk42", "SecondaryWeapon": "mk41_vls_destroyer",
        "Engine": "geared_steam_turbine_60k", "Sensors": "an_sps6_air_search",
        "AntiAir": "mim23_hawk_sam"},
       ["us_destroyers", "cold_war_naval"], size="Heavy", days=160, crew=340),
    dd("arleigh_burke_destroyer", "Arleigh Burke-class", "us_naval_modern",
       {"NavalGun": "us_5inch_54_mk42", "SecondaryWeapon": "mk41_vls_destroyer",
        "Engine": "geared_steam_turbine_60k", "Sensors": "aegis_spy1_radar",
        "AntiAir": "aegis_bmd_package"},
       ["us_destroyers", "aegis", "twenty_tens"], size="Heavy", days=175, crew=320, training=38),
    dd("type052d_destroyer", "Type 052D Luyang III", "chinese_naval_modern",
       {"NavalGun": "us_5inch_54_mk42", "SecondaryWeapon": "type055_destroyer_vls",
        "Engine": "geared_steam_turbine_60k", "Sensors": "type055_destroyer_vls",
        "AntiAir": "hq9b_sam"},
       ["chinese_destroyers", "twenty_tens"], size="Heavy", days=165, crew=280, training=36),
    dd("type45_destroyer", "Type 45 Daring", "uk_naval_modern",
       {"NavalGun": "uk_4_5inch_mk6", "SecondaryWeapon": "aster30_sam",
        "Engine": "geared_steam_turbine_60k", "Sensors": "sea_viper_sam",
        "AntiAir": "sea_viper_sam"},
       ["uk_destroyers", "twenty_tens"], size="Heavy", days=170, crew=190, training=37),
    dd("horizon_class_destroyer", "Horizon-class", "european_naval_modern",
       {"NavalGun": "uk_4_5inch_mk6", "SecondaryWeapon": "aster30_sam",
        "Engine": "geared_steam_turbine_60k", "Sensors": "aster30_sam",
        "AntiAir": "aster30_sam"},
       ["french_destroyers", "italian_destroyers", "twenty_tens"], size="Heavy", days=168, crew=200),
    dd("sovremenny_class_destroyer", "Sovremenny-class", "russian_naval_modern",
       {"NavalGun": "ger_15cm_tb", "SecondaryWeapon": "kalibr_vls_sub",
        "Engine": "geared_steam_turbine_60k", "Sensors": "type281_surface_radar",
        "AntiAir": "s300_pmu_sam"},
       ["russian_destroyers", "twenty_tens"], size="Heavy", days=160, crew=300),
    dd("kongo_class_destroyer", "Kongo-class", "japanese_naval_modern",
       {"NavalGun": "us_5inch_54_mk42", "SecondaryWeapon": "mk41_vls_destroyer",
        "Engine": "geared_steam_turbine_60k", "Sensors": "aegis_spy1_radar",
        "AntiAir": "aegis_bmd_package"},
       ["japanese_destroyers", "aegis", "twenty_tens"], size="Heavy", days=172, crew=300),
    dd("zumwalt_class_destroyer", "Zumwalt-class", "us_naval_modern",
       {"NavalGun": "railgun_naval_proto", "SecondaryWeapon": "mk41_vls_destroyer",
        "Engine": "geared_steam_turbine_60k", "Sensors": "ddgx_combat_system",
        "Armor": "zumwalt_stealth_hull", "AntiAir": "aegis_bmd_package"},
       ["us_destroyers", "stealth", "twenty_tens"], size="Heavy", days=185, crew=175, training=38),
    dd("type26_frigate", "Type 26 Frigate", "uk_naval_modern",
       {"NavalGun": "uk_4_5inch_mk6", "SecondaryWeapon": "mk41_vls_destroyer",
        "Engine": "geared_steam_turbine_60k", "Sensors": "type26_frigate_package",
        "AntiAir": "sea_viper_sam"},
       ["uk_destroyers", "frigate", "twenty_tens"], size="Medium", days=150, crew=118),
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
        write_unit_template(path, tpl)
        tc += 1
        print(f"  + template {tpl['id']}.json")
    mods = {p.stem for p in MODULES_DIR.glob("*.json")}
    errs = []
    for p in TEMPLATES_DIR.glob("*.json"):
        d = json.loads(p.read_text())
        for slot, mid in d.get("module_loadout", {}).items():
            if mid not in mods:
                errs.append(f"{p.name}: {slot} -> {mid}")
    print(f"\nSurface naval: {mc} modules, {tc} templates. Missing refs: {len(errs)}")
    for e in errs:
        print(f"  ! {e}")


if __name__ == "__main__":
    main()
