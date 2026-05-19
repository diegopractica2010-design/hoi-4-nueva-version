#!/usr/bin/env python3
"""1918 scenario naval fleet: Great War era ships for every nation in data/scenarios/1918.json."""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "data"
MODULES_DIR = ROOT / "modules"
TEMPLATES_DIR = ROOT / "unit_templates"

T1918 = ["naval_1918", "ww1_naval", "great_war_naval"]

# fmt: off
MODULES: list[dict] = [
    {"id": "sms_bayern_class_bb", "name": "SMS Bayern 38cm", "category": "NavalGun", "tier": 4,
     "soft_attack": 42, "hard_attack": 48, "piercing": 45, "anti_ship": 82,
     "cost": {"steel": 35, "chromium": 8, "explosives": 14}, "production_time": 95,
     "special_flags": ["germany", "battleship", "ww1", "high_seas_fleet"],
     "description": "Bavaria-class 15-inch guns. Germany's final WWI battleship design."},
    {"id": "courbet_class_bb_france", "name": "Courbet 305mm", "category": "NavalGun", "tier": 3,
     "soft_attack": 36, "hard_attack": 40, "piercing": 38, "anti_ship": 72,
     "cost": {"steel": 30, "chromium": 6, "explosives": 12}, "production_time": 88,
     "special_flags": ["france", "battleship", "ww1", "dreadnought"],
     "description": "French super-dreadnought main battery. Jutland-era Atlantic fleet."},
    {"id": "revenge_class_bb_uk", "name": "Revenge 15\" Mk I", "category": "NavalGun", "tier": 4,
     "soft_attack": 40, "hard_attack": 45, "piercing": 44, "anti_ship": 80,
     "cost": {"steel": 32, "chromium": 7, "explosives": 13}, "production_time": 90,
     "special_flags": ["uk", "battleship", "ww1", "grand_fleet"],
     "description": "Revenge/Royal Sovereign class. Workhorse Grand Fleet battleships 1918."},
    {"id": "gangut_class_bb_russia", "name": "Gangut 12\"/52", "category": "NavalGun", "tier": 3,
     "soft_attack": 34, "hard_attack": 38, "piercing": 36, "anti_ship": 68,
     "cost": {"steel": 28, "chromium": 5, "explosives": 11}, "production_time": 85,
     "special_flags": ["russia", "soviet", "battleship", "ww1"],
     "description": "Imperial Russian dreadnought. Baltic Fleet veteran of WWI."},
    {"id": "yavuz_battlecruiser", "name": "SMS Yavuz (Goeben)", "category": "NavalGun", "tier": 4,
     "soft_attack": 38, "hard_attack": 42, "piercing": 40, "anti_ship": 78,
     "cost": {"steel": 30, "chromium": 6, "explosives": 12}, "production_time": 88,
     "special_flags": ["ottoman", "turkey", "germany", "battlecruiser", "ww1"],
     "description": "Former German Goeben. Ottoman flagship dominating the Black Sea 1914–18."},
    {"id": "nevada_class_bb_us", "name": "Nevada-class 14\"/45", "category": "NavalGun", "tier": 4,
     "soft_attack": 40, "hard_attack": 44, "piercing": 42, "anti_ship": 78,
     "cost": {"steel": 32, "chromium": 7, "explosives": 13}, "production_time": 92,
     "special_flags": ["usa", "battleship", "ww1", "all_or_nothing"],
     "description": "USN all-or-nothing armor battleship. Atlantic convoy escort by 1918."},
    {"id": "clemson_class_destroyer", "name": "Clemson-class DD", "category": "NavalGun", "tier": 3,
     "soft_attack": 18, "hard_attack": 20, "piercing": 18, "anti_ship": 40,
     "cost": {"steel": 12, "electronics": 4, "explosives": 6}, "production_time": 55,
     "special_flags": ["usa", "destroyer", "ww1", "flush_deck"],
     "description": "US flush-deck destroyer. Mass-produced for Atlantic anti-submarine warfare."},
    {"id": "ww1_coastal_patrol", "name": "WWI Coastal Patrol", "category": "NavalGun", "tier": 2,
     "soft_attack": 10, "hard_attack": 12, "piercing": 12, "anti_ship": 22,
     "cost": {"steel": 4, "electronics": 2, "explosives": 3}, "production_time": 35,
     "special_flags": ["ww1", "patrol", "colonial", "minor_navy"],
     "description": "Armed trawlers and gunboats for mandates, colonies, and minor navies."},
    {"id": "dante_alighieri_bb", "name": "Dante Alighieri 12\"", "category": "NavalGun", "tier": 3,
     "soft_attack": 32, "hard_attack": 36, "piercing": 34, "anti_ship": 65,
     "cost": {"steel": 26, "chromium": 5, "explosives": 10}, "production_time": 82,
     "special_flags": ["italy", "battleship", "ww1"],
     "description": "First Italian all-big-gun battleship. Adriatic operations against Austria-Hungary."},
    {"id": "moltke_class_bc_germany", "name": "Moltke 28cm", "category": "NavalGun", "tier": 3,
     "soft_attack": 35, "hard_attack": 38, "piercing": 36, "anti_ship": 70,
     "cost": {"steel": 28, "chromium": 6, "explosives": 11}, "production_time": 84,
     "special_flags": ["germany", "battlecruiser", "ww1"],
     "description": "German battlecruiser. Scouting force of the High Seas Fleet."},
]


def warship(
    id_: str, name: str, family: str, loadout: dict, nation: list[str],
    archetype: str = "destroyer", size: str = "Heavy", days: int = 120,
    crew: int = 300, training: int = 28, stats: dict | None = None,
) -> dict:
    base = stats or {
        "speed": 28, "reliability": 68, "fuel_consumption": 50,
        "supply_need": 65, "armor": 32, "deck_armor": 16, "hardness": 58,
    }
    if archetype == "battleship":
        base = stats or {
            "speed": 22, "reliability": 65, "fuel_consumption": 85,
            "supply_need": 110, "armor": 50, "deck_armor": 24, "hardness": 78,
        }
    elif size == "Light" or archetype == "patrol":
        base = stats or {
            "speed": 24, "reliability": 60, "fuel_consumption": 25,
            "supply_need": 30, "armor": 12, "deck_armor": 8, "hardness": 38,
        }
    slots = {
        "NavalGun": {"max": 2}, "SecondaryWeapon": {"max": 2},
        "Engine": {"max": 1}, "Armor": {"max": 1},
        "Sensors": {"max": 1}, "Communications": {"max": 1},
    }
    if archetype == "carrier":
        slots = {"Cargo": {"max": 1}, "Engine": {"max": 1}, "Armor": {"max": 1}, "Sensors": {"max": 1}}
    return {
        "id": id_, "name": name, "design_family": family,
        "base_type": "Naval", "size_category": size,
        "visual_archetype": archetype,
        "crew_required": crew, "base_training_level": training,
        "max_experience_level": 100, "base_production_days": days,
        "base_stats": base,
        "slots": slots,
        "module_loadout": loadout,
        "unlock_tech": T1918 + nation,
        "can_mount_drones": False,
        "is_vehicle": True,
    }


def sub(id_: str, name: str, family: str, loadout: dict, nation: list[str], **kw) -> dict:
    return {
        "id": id_, "name": name, "design_family": family,
        "base_type": "Submarine", "size_category": kw.get("size", "Medium"),
        "visual_archetype": "submarine",
        "crew_required": kw.get("crew", 35),
        "base_training_level": kw.get("training", 26),
        "max_experience_level": 100,
        "base_production_days": kw.get("days", 90),
        "base_stats": kw.get("stats", {
            "speed": 14, "reliability": 58, "fuel_consumption": 22,
            "supply_need": 28, "armor": 22, "hardness": 35,
        }),
        "slots": {
            "MainWeapon": {"max": 2}, "SecondaryWeapon": {"max": 1},
            "Engine": {"max": 1}, "Sensors": {"max": 1}, "Armor": {"max": 1},
        },
        "module_loadout": loadout,
        "unlock_tech": T1918 + nation,
        "can_mount_drones": False,
        "is_vehicle": True,
    }


DD = {"NavalGun": "uk_4_7inch_qf", "SecondaryWeapon": "ww1_18inch_torpedo",
      "Engine": "us_parsons_turbine", "Sensors": "naval_fire_control_mk37",
      "Communications": "wireless_set_no19"}
DD_US = {**DD, "NavalGun": "us_5inch_38_gun"}  # anachronistic but exists; use ww1_4inch for US
DD_US["NavalGun"] = "ww1_4inch_qf_mk4"
BB_UK = {"NavalGun": "uk_15inch_mk1", "Engine": "carrier_boiler_yarrow",
         "Armor": "naval_belt_armor_scheme", "Sensors": "naval_fire_control_mk37",
         "Communications": "wireless_set_no19"}
BB_GER = {"NavalGun": "sms_bayern_class_bb", "SecondaryWeapon": "g7a_torpedo_sub",
          "Engine": "german_wagner_turbine", "Armor": "naval_belt_armor_scheme",
          "Communications": "fug_16_zyf_radio"}

TEMPLATES: list[dict] = [
    # ─── Grand Fleet / High Seas Fleet ───────────────────────────────────────────
    warship("queen_elizabeth_bb_1918", "Queen Elizabeth-class", "uk_naval_1918", BB_UK,
            ["uk_naval_1918", "grand_fleet"], "battleship", "SuperHeavy", 260, 1200, 34),
    warship("revenge_class_bb_1918", "Revenge-class", "uk_naval_1918",
            {**BB_UK, "NavalGun": "revenge_class_bb_uk"}, ["uk_naval_1918", "grand_fleet"],
            "battleship", "SuperHeavy", 250, 1100),
    warship("iron_duke_bb_1918", "Iron Duke-class", "uk_naval_1918",
            {**BB_UK, "NavalGun": "uk_13_5inch_mk5"}, ["uk_naval_1918", "grand_fleet"],
            "battleship", "SuperHeavy", 240, 1000),
    warship("v_class_dd_1918", "V-class Destroyer", "uk_naval_1918", DD,
            ["uk_naval_1918", "destroyer"], "destroyer", "Light", 95, 120),
    warship("county_class_cruiser_1918", "County-class (planned)", "uk_naval_1918",
            {"NavalGun": "uk_8inch_mk8", **{k: v for k, v in DD.items() if k != "NavalGun"}},
            ["uk_naval_1918", "cruiser"], "cruiser", "Heavy", 180, 700),

    warship("bayern_class_bb_1918", "Bayern-class", "german_naval_1918", BB_GER,
            ["german_naval_1918", "high_seas_fleet"], "battleship", "SuperHeavy", 270, 1800, 32),
    warship("moltke_bc_1918", "Moltke-class", "german_naval_1918",
            {"NavalGun": "moltke_class_bc_germany", "Engine": "german_wagner_turbine",
             "Armor": "naval_belt_armor_scheme", "SecondaryWeapon": "g7a_torpedo_sub"},
            ["german_naval_1918", "battlecruiser"], "battleship", "Heavy", 220, 1400),
    warship("v_torpedo_boat_1918", "V25 Torpedo Boat", "german_naval_1918", DD,
            ["german_naval_1918", "torpedo_boat"], "destroyer", "Light", 70, 80, 24),
    sub("type_uboat_1918", "Type UB III", "german_sub_1918",
        {"MainWeapon": "submarine_torpedo_tube", "SecondaryWeapon": "g7a_torpedo_sub",
         "Engine": "holland_diesel_electric", "Armor": "pressure_hull_light"},
        ["german_naval_1918", "submarine"], crew=26, days=80),

    warship("courbet_class_bb_1918", "Courbet-class", "french_naval_1918",
            {"NavalGun": "courbet_class_bb_france", "Engine": "carrier_boiler_yarrow",
             "Armor": "naval_belt_armor_scheme", "Communications": "wireless_set_no19"},
            ["french_naval_1918"], "battleship", "SuperHeavy", 255, 1150),
    warship("contre_torpilleur_1918", "Contre-Torpilleur", "french_naval_1918", DD,
            ["french_naval_1918", "destroyer"], "destroyer", "Light", 90, 100),

    warship("nevada_class_bb_1918", "Nevada-class", "us_naval_1918",
            {"NavalGun": "nevada_class_bb_us", "Engine": "us_parsons_turbine",
             "Armor": "naval_belt_armor_scheme", "Sensors": "naval_fire_control_mk37",
             "Communications": "scr_522_radio"},
            ["us_naval_1918"], "battleship", "SuperHeavy", 265, 1300, 30),
    warship("wickes_class_dd_1918", "Wickes-class", "us_naval_1918", DD_US,
            ["us_naval_1918", "destroyer"], "destroyer", "Light", 85, 115),
    warship("clemson_class_dd_1918", "Clemson-class", "us_naval_1918",
            {"NavalGun": "clemson_class_destroyer", **{k: v for k, v in DD_US.items() if k != "NavalGun"}},
            ["us_naval_1918", "destroyer"], "destroyer", "Light", 88, 120),
    warship("hms_argus_1918", "HMS Argus", "uk_naval_1918",
            {"Cargo": "carrier_air_wing_bunker", "Engine": "carrier_boiler_yarrow",
             "Armor": "carrier_wooden_flight_deck"},
            ["uk_naval_1918", "carrier"], "carrier", "Medium", 200, 450, 26),

    warship("gangut_class_bb_1918", "Gangut-class", "soviet_naval_1918",
            {"NavalGun": "gangut_class_bb_russia", "Engine": "carrier_boiler_yarrow",
             "Armor": "naval_belt_armor_scheme"},
            ["soviet_naval_1918", "baltic_fleet"], "battleship", "Heavy", 240, 900),
    sub("bars_class_sub_1918", "Bars-class", "soviet_sub_1918",
        {"MainWeapon": "submarine_torpedo_tube", "SecondaryWeapon": "whitehead_18in_torpedo",
         "Engine": "holland_diesel_electric"},
        ["soviet_naval_1918", "submarine"], size="Light", crew=28, days=75),

    warship("dante_alighieri_1918", "Dante Alighieri", "italian_naval_1918",
            {"NavalGun": "dante_alighieri_bb", "Engine": "geared_steam_turbine_60k",
             "Armor": "naval_belt_armor_scheme"},
            ["italian_naval_1918"], "battleship", "Heavy", 230, 950),
    warship("andrea_doria_bb_1918", "Andrea Doria-class", "italian_naval_1918",
            {"NavalGun": "ita_12inch_m1914", "Engine": "geared_steam_turbine_60k",
             "Armor": "naval_belt_armor_scheme"},
            ["italian_naval_1918"], "battleship", "Heavy", 245, 1000),

    warship("ise_class_bb_1918", "Ise-class", "japanese_naval_1918",
            {"NavalGun": "ijn_14inch_type94", "SecondaryWeapon": "ww1_18inch_torpedo",
             "Engine": "ijn_kampon_turbine", "Armor": "naval_deck_armor_scheme"},
            ["japanese_naval_1918"], "battleship", "SuperHeavy", 270, 1400, 32),
    warship("kongo_bc_1918", "Kongo-class", "japanese_naval_1918",
            {"NavalGun": "ijn_14inch_type94", "Engine": "ijn_kampon_turbine",
             "Armor": "naval_belt_armor_scheme"},
            ["japanese_naval_1918", "battlecruiser"], "battleship", "Heavy", 250, 1300),
    warship("fubuki_precursor_1918", "Momo-class DD", "japanese_naval_1918",
            {"NavalGun": "ijn_12_7cm_type89", "SecondaryWeapon": "ww1_18inch_torpedo",
             "Engine": "ijn_kampon_turbine"},
            ["japanese_naval_1918", "destroyer"], "destroyer", "Light", 95, 110),

    warship("yavuz_sultan_1918", "Yavuz Sultan Selim", "ottoman_naval_1918",
            {"NavalGun": "yavuz_battlecruiser", "Engine": "german_wagner_turbine",
             "Armor": "naval_belt_armor_scheme"},
            ["ottoman_naval_1918", "turkish_naval_1918"], "battleship", "Heavy", 220, 1200),
    warship("midilli_cruiser_1918", "Midilli (Breslau)", "ottoman_naval_1918",
            {"NavalGun": "ger_11inch_skc34", "Engine": "german_wagner_turbine"},
            ["ottoman_naval_1918", "cruiser"], "cruiser", "Medium", 160, 480),

    # ─── Neutrals & dominions ────────────────────────────────────────────────────
    warship("tromp_cruiser_1918", "HNLMS Tromp (planned)", "dutch_naval_1918",
            {"NavalGun": "uk_6inch_bl_mk12", **DD},
            ["dutch_naval_1918"], "cruiser", "Medium", 150, 400),
    warship("sweden_coastal_1918", "Sverige-class Coastal BB", "swedish_naval_1918",
            {"NavalGun": "uk_12inch_mk10", "Engine": "carrier_boiler_yarrow",
             "Armor": "naval_belt_armor_scheme"},
            ["swedish_naval_1918"], "battleship", "Medium", 200, 450, 26),
    warship("norway_coastal_1918", "Norge-class Coastal", "norwegian_naval_1918",
            {"NavalGun": "uk_12inch_mk10", "Engine": "carrier_boiler_yarrow"},
            ["norwegian_naval_1918"], "battleship", "Light", 180, 380, 24),
    warship("finland_minelayer_1918", "Finnish Minelayer", "finnish_naval_1918",
            {"NavalGun": "ww1_coastal_patrol", "SecondaryWeapon": "ww1_18inch_torpedo",
             "Engine": "carrier_boiler_yarrow"},
            ["finnish_naval_1918", "patrol"], "patrol", "Light", 60, 45, 22),
    warship("danish_coastal_1918", "Danish Coastal Defense", "danish_naval_1918",
            {"NavalGun": "ww1_coastal_patrol", "Engine": "carrier_boiler_yarrow"},
            ["danish_naval_1918"], "patrol", "Light", 55, 40),

    warship("river_class_dd_1918", "River-class Destroyer", "canadian_naval_1918", DD,
            ["canadian_naval_1918", "australian_naval_1918"], "destroyer", "Light", 100, 95),
    warship("town_class_cruiser_1918", "Town-class Cruiser", "australian_naval_1918",
            {"NavalGun": "uk_6inch_bl_mk12", **DD},
            ["australian_naval_1918", "cruiser"], "cruiser", "Medium", 170, 550),
    warship("nz_patrol_1918", "NZ Naval Patrol", "new_zealand_naval_1918",
            {"NavalGun": "ww1_coastal_patrol", "Engine": "carrier_boiler_yarrow"},
            ["new_zealand_naval_1918"], "patrol", "Light", 50, 35),
    warship("saf_auxiliary_1918", "SA Naval Auxiliary", "south_african_naval_1918",
            {"NavalGun": "ww1_coastal_patrol"}, ["south_african_naval_1918"], "patrol", "Light", 48, 30),

    warship("brazil_dreadnought_1918", "São Paulo", "brazilian_naval_1918",
            {"NavalGun": "uk_12inch_mk10", "Engine": "geared_steam_turbine_60k",
             "Armor": "naval_belt_armor_scheme"},
            ["brazilian_naval_1918"], "battleship", "Heavy", 240, 900, 28),
    warship("argentina_rivadavia_1918", "Rivadavia-class", "argentine_naval_1918",
            {"NavalGun": "us_14inch_45_gun", "Engine": "us_parsons_turbine",
             "Armor": "naval_belt_armor_scheme"},
            ["argentine_naval_1918"], "battleship", "Heavy", 250, 950),
    warship("chile_almirante_1918", "Almirante Latorre", "chilean_naval_1918",
            {"NavalGun": "uk_14inch_mk7", "Engine": "us_parsons_turbine",
             "Armor": "naval_belt_armor_scheme"},
            ["chilean_naval_1918"], "battleship", "Heavy", 245, 920),
    warship("mexico_gunboat_1918", "Mexican Gunboat", "mexican_naval_1918",
            {"NavalGun": "ww1_coastal_patrol"}, ["mexican_naval_1918"], "patrol", "Light", 45, 35),

    warship("poland_coastal_1918", "Polish Coastal Flotilla", "polish_naval_1918", DD,
            ["polish_naval_1918"], "destroyer", "Light", 75, 60, 22),
    warship("ukraine_gunboat_1918", "Ukrainian Gunboat", "ukrainian_naval_1918",
            {"NavalGun": "ww1_coastal_patrol"}, ["ukrainian_naval_1918"], "patrol", "Light", 40, 30, 20),

    warship("egypt_patrol_1918", "Egyptian Patrol", "egyptian_naval_1918",
            {"NavalGun": "ww1_coastal_patrol"}, ["egyptian_naval_1918"], "patrol", "Light", 42, 28),
    warship("persia_patrol_1918", "Persian Gulf Patrol", "iranian_naval_1918",
            {"NavalGun": "ww1_coastal_patrol"}, ["iranian_naval_1918"], "patrol", "Light", 40, 25),
    warship("mandate_patrol_1918", "Mandate Patrol Craft", "mandate_naval_1918",
            {"NavalGun": "ww1_coastal_patrol"},
            ["palestine_naval_1918", "israeli_naval_1918", "syrian_naval_1918"], "patrol", "Light", 38, 22),
    warship("nigeria_patrol_1918", "Nigerian Colonial Patrol", "nigerian_naval_1918",
            {"NavalGun": "ww1_coastal_patrol"}, ["nigerian_naval_1918"], "patrol", "Light", 35, 20),
    warship("iceland_trawler_1918", "Icelandic Trawler", "icelandic_naval_1918",
            {"NavalGun": "ww1_coastal_patrol"}, ["icelandic_naval_1918"], "patrol", "Light", 32, 18),
    warship("greenland_patrol_1918", "Greenland Patrol", "greenland_naval_1918",
            {"NavalGun": "ww1_coastal_patrol"}, ["greenland_naval_1918", "danish_naval_1918"],
            "patrol", "Light", 30, 15),
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
        try:
            d = json.loads(p.read_text())
        except json.JSONDecodeError:
            continue
        for slot, mid in d.get("module_loadout", {}).items():
            if mid and mid not in mods:
                errs.append(f"{p.name}: {mid}")
    print(f"\n1918 naval: {mc} modules, {tc} templates. Missing refs: {len(errs)}")
    for e in errs:
        print(f"  ! {e}")


if __name__ == "__main__":
    main()
