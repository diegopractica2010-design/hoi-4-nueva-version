#!/usr/bin/env python3
"""1936 scenario naval fleet: interwar ships for every nation in data/scenarios/1936.json."""

from __future__ import annotations

from template_export import write_unit_template
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "data"
MODULES_DIR = ROOT / "modules"
TEMPLATES_DIR = ROOT / "unit_templates"

T1936 = ["naval_1936", "interwar_naval", "pre_ww2_naval"]

# fmt: off
MODULES: list[dict] = [
    {"id": "deutschland_panzerschiff", "name": "Deutschland 28cm", "category": "NavalGun", "tier": 4,
     "soft_attack": 32, "hard_attack": 36, "piercing": 34, "anti_ship": 68,
     "cost": {"steel": 28, "chromium": 6, "explosives": 10}, "production_time": 85,
     "special_flags": ["germany", "panzerschiff", "interwar", "treaty"],
     "description": "Pocket battleship armament. Commerce raiding doctrine under Versailles limits."},
    {"id": "grom_class_destroyer_poland", "name": "Grom-class Destroyer", "category": "NavalGun", "tier": 4,
     "soft_attack": 20, "hard_attack": 22, "piercing": 20, "anti_ship": 45,
     "cost": {"steel": 14, "electronics": 8, "explosives": 7}, "production_time": 62,
     "special_flags": ["poland", "destroyer", "interwar"],
     "description": "Polish destroyer built in UK. Fast Baltic escort on eve of WWII."},
    {"id": "le_fantasque_destroyer", "name": "Le Fantasque 13.8cm", "category": "NavalGun", "tier": 4,
     "soft_attack": 22, "hard_attack": 24, "piercing": 22, "anti_ship": 48,
     "cost": {"steel": 14, "electronics": 10, "explosives": 8}, "production_time": 65,
     "special_flags": ["france", "destroyer", "interwar", "super_destroyer"],
     "description": "French super-destroyer. Among fastest warships in the world in 1936."},
    {"id": "marat_class_bb_soviet", "name": "Marat 12\"/52", "category": "NavalGun", "tier": 3,
     "soft_attack": 34, "hard_attack": 38, "piercing": 36, "anti_ship": 70,
     "cost": {"steel": 28, "chromium": 5, "explosives": 11}, "production_time": 82,
     "special_flags": ["soviet", "battleship", "interwar", "modernized"],
     "description": "Modernized Gangut/Marat class. Baltic and Black Sea fleets 1936."},
    {"id": "zara_class_cruiser_1936", "name": "Zara 203mm", "category": "NavalGun", "tier": 4,
     "soft_attack": 30, "hard_attack": 34, "piercing": 32, "anti_ship": 65,
     "cost": {"steel": 26, "chromium": 6, "explosives": 10}, "production_time": 80,
     "special_flags": ["italy", "cruiser", "interwar", "treaty"],
     "description": "Heavily armored Italian treaty cruiser. Regia Marina prestige design."},
    {"id": "brooklyn_cruiser_us", "name": "Brooklyn 6\"/47", "category": "NavalGun", "tier": 4,
     "soft_attack": 28, "hard_attack": 32, "piercing": 30, "anti_ship": 62,
     "cost": {"steel": 24, "electronics": 8, "explosives": 9}, "production_time": 78,
     "special_flags": ["usa", "cruiser", "interwar", "light_cruiser"],
     "description": "US light cruiser with 15-gun broadside. Pacific fleet expansion."},
    {"id": "leander_cruiser_uk", "name": "Leander 6\"", "category": "NavalGun", "tier": 4,
     "soft_attack": 26, "hard_attack": 30, "piercing": 28, "anti_ship": 58,
     "cost": {"steel": 22, "electronics": 6, "explosives": 8}, "production_time": 75,
     "special_flags": ["uk", "australia", "cruiser", "interwar"],
     "description": "Commonwealth light cruiser for trade protection and fleet screening."},
    {"id": "interwar_coastal_patrol", "name": "Interwar Coastal Patrol", "category": "NavalGun", "tier": 2,
     "soft_attack": 12, "hard_attack": 14, "piercing": 14, "anti_ship": 26,
     "cost": {"steel": 5, "electronics": 6, "explosives": 4}, "production_time": 42,
     "special_flags": ["interwar", "patrol", "colonial"],
     "description": "Gunboats and sloops for mandates and minor navies between the wars."},
]


def warship(
    id_: str, name: str, family: str, loadout: dict, nation: list[str],
    archetype: str = "destroyer", size: str = "Heavy", days: int = 130,
    crew: int = 320, training: int = 30, stats: dict | None = None,
) -> dict:
    base = stats or {
        "speed": 30, "reliability": 72, "fuel_consumption": 55,
        "supply_need": 70, "armor": 34, "deck_armor": 18, "hardness": 62,
    }
    if archetype == "battleship":
        base = stats or {
            "speed": 26, "reliability": 68, "fuel_consumption": 88,
            "supply_need": 115, "armor": 52, "deck_armor": 28, "hardness": 80,
        }
    elif archetype == "carrier":
        base = stats or {
            "speed": 28, "reliability": 70, "fuel_consumption": 75,
            "supply_need": 95, "armor": 28, "deck_armor": 18, "hardness": 58,
        }
    elif size == "Light" or archetype == "patrol":
        base = stats or {
            "speed": 26, "reliability": 65, "fuel_consumption": 28,
            "supply_need": 35, "armor": 16, "deck_armor": 10, "hardness": 42,
        }
    slots = {
        "NavalGun": {"max": 2}, "SecondaryWeapon": {"max": 2},
        "Engine": {"max": 1}, "Armor": {"max": 1},
        "Sensors": {"max": 1}, "AntiAir": {"max": 1},
    }
    if archetype == "carrier":
        slots = {"Cargo": {"max": 1}, "Engine": {"max": 1}, "Sensors": {"max": 1}, "AntiAir": {"max": 1}}
    return {
        "id": id_, "name": name, "design_family": family,
        "base_type": "Naval", "size_category": size,
        "visual_archetype": archetype,
        "crew_required": crew, "base_training_level": training,
        "max_experience_level": 100, "base_production_days": days,
        "base_stats": base,
        "slots": slots,
        "module_loadout": loadout,
        "unlock_tech": T1936 + nation,
        "can_mount_drones": False,
        "is_vehicle": True,
    }


def sub(id_: str, name: str, family: str, loadout: dict, nation: list[str], **kw) -> dict:
    return {
        "id": id_, "name": name, "design_family": family,
        "base_type": "Submarine", "size_category": kw.get("size", "Medium"),
        "visual_archetype": "submarine",
        "crew_required": kw.get("crew", 40),
        "base_training_level": kw.get("training", 28),
        "max_experience_level": 100,
        "base_production_days": kw.get("days", 110),
        "base_stats": kw.get("stats", {
            "speed": 18, "reliability": 65, "fuel_consumption": 28,
            "supply_need": 35, "armor": 28, "hardness": 40,
        }),
        "slots": {
            "MainWeapon": {"max": 2}, "SecondaryWeapon": {"max": 1},
            "Engine": {"max": 1}, "Sensors": {"max": 1}, "Armor": {"max": 1},
        },
        "module_loadout": loadout,
        "unlock_tech": T1936 + nation,
        "can_mount_drones": False,
        "is_vehicle": True,
    }


DD = {"NavalGun": "uk_4_7inch_qf", "SecondaryWeapon": "mk15_torpedo_tube",
      "Engine": "us_parsons_turbine", "Sensors": "naval_fire_control_mk37"}
DD_GER = {**DD, "Engine": "german_wagner_turbine", "Communications": "fug_16_zyf_radio"}
DD_JPN = {**DD, "NavalGun": "ijn_12_7cm_type89", "SecondaryWeapon": "type93_long_lance",
          "Engine": "ijn_kampon_turbine", "Sensors": "naval_radar_type22"}

TEMPLATES: list[dict] = [
    # ─── Major powers ────────────────────────────────────────────────────────────
    warship("queen_elizabeth_bb_1936", "Queen Elizabeth-class", "uk_naval_1936",
            {"NavalGun": "uk_15inch_mk1", "Engine": "carrier_boiler_yarrow",
             "Armor": "naval_belt_armor_scheme", "Sensors": "naval_fire_control_mk37"},
            ["uk_naval_1936"], "battleship", "SuperHeavy", 250, 1150, 34),
    warship("renown_bc_1936", "Renown-class", "uk_naval_1936",
            {"NavalGun": "uk_15inch_mk1", "Engine": "geared_steam_turbine_60k",
             "Armor": "naval_belt_armor_scheme"},
            ["uk_naval_1936", "battlecruiser"], "battleship", "Heavy", 220, 1200),
    warship("county_class_1936", "County-class Cruiser", "uk_naval_1936",
            {"NavalGun": "uk_8inch_mk8", **DD},
            ["uk_naval_1936", "cruiser"], "cruiser", "Heavy", 190, 680),
    warship("tribal_class_1936", "Tribal-class Destroyer", "uk_naval_1936",
            {**DD, "AntiAir": "carrier_aa_bofors_40mm"},
            ["uk_naval_1936", "destroyer"], "destroyer", "Light", 125, 260, 32),

    warship("deutschland_class_1936", "Deutschland-class", "german_naval_1936",
            {"NavalGun": "deutschland_panzerschiff", "Engine": "german_wagner_turbine",
             "Armor": "naval_belt_armor_scheme", "SecondaryWeapon": "g7a_torpedo_sub"},
            ["german_naval_1936", "panzerschiff"], "battleship", "Heavy", 200, 1100, 30),
    warship("scharnhorst_class_1936", "Scharnhorst-class", "german_naval_1936",
            {"NavalGun": "ger_11inch_skc34", "Engine": "german_wagner_turbine",
             "Armor": "naval_belt_armor_scheme", "SecondaryWeapon": "g7a_torpedo_sub"},
            ["german_naval_1936"], "battleship", "Heavy", 230, 1800, 33),
    sub("type_viia_uboat_1936", "Type VIIA U-boat", "german_sub_1936",
        {"MainWeapon": "submarine_torpedo_tube", "SecondaryWeapon": "g7a_torpedo_sub",
         "Engine": "man_m6v40_uboat_diesel", "Armor": "pressure_hull_light"},
        ["german_naval_1936", "submarine"], crew=44, days=100),
    warship("z_class_destroyer_1936", "Z1 Leberecht Maass", "german_naval_1936", DD_GER,
            ["german_naval_1936", "destroyer"], "destroyer", "Light", 115, 310, 31),

    warship("dunkerque_class_1936", "Dunkerque-class", "french_naval_1936",
            {"NavalGun": "fra_13_4inch_m1934", "Engine": "geared_steam_turbine_60k",
             "Armor": "naval_belt_armor_scheme"},
            ["french_naval_1936"], "battleship", "Heavy", 240, 1350, 32),
    warship("le_fantasque_1936", "Le Fantasque-class", "french_naval_1936",
            {"NavalGun": "le_fantasque_destroyer", **{k: v for k, v in DD.items() if k != "NavalGun"}},
            ["french_naval_1936", "destroyer"], "destroyer", "Light", 110, 220, 33),

    warship("northampton_class_1936", "Northampton-class", "us_naval_1936",
            {"NavalGun": "us_8inch_55_gun", **DD},
            ["us_naval_1936", "cruiser"], "cruiser", "Heavy", 195, 720),
    warship("brooklyn_class_1936", "Brooklyn-class", "us_naval_1936",
            {"NavalGun": "brooklyn_cruiser_us", **DD},
            ["us_naval_1936", "cruiser"], "cruiser", "Heavy", 185, 680),
    warship("colorado_class_1936", "Colorado-class", "us_naval_1936",
            {"NavalGun": "us_16inch_45_gun", "Engine": "us_parsons_turbine",
             "Armor": "naval_belt_armor_scheme"},
            ["us_naval_1936"], "battleship", "SuperHeavy", 260, 1250),
    warship("lexington_class_cv_1936", "Lexington-class CV", "us_naval_1936",
            {"Cargo": "carrier_air_wing_bunker", "Engine": "geared_steam_turbine_60k",
             "Armor": "carrier_armored_flight_deck", "Sensors": "sg_surface_radar"},
            ["us_naval_1936", "carrier"], "carrier", "Heavy", 240, 2100, 34),
    warship("fletcher_precursor_1936", "Porter-class DD", "us_naval_1936",
            {"NavalGun": "us_5inch_38_gun", **DD},
            ["us_naval_1936", "destroyer"], "destroyer", "Light", 120, 280),

    warship("marat_class_1936", "Marat-class", "soviet_naval_1936",
            {"NavalGun": "marat_class_bb_soviet", "Engine": "carrier_boiler_yarrow",
             "Armor": "naval_belt_armor_scheme"},
            ["soviet_naval_1936"], "battleship", "Heavy", 235, 950),
    warship("kirov_class_1936", "Kirov-class", "soviet_naval_1936",
            {"NavalGun": "us_8inch_55_gun", "Engine": "geared_steam_turbine_60k",
             "SecondaryWeapon": "mk15_torpedo_tube"},
            ["soviet_naval_1936", "cruiser"], "cruiser", "Heavy", 200, 750),
    sub("shchuka_sub_1936", "Shchuka-class", "soviet_sub_1936",
        {"MainWeapon": "submarine_torpedo_tube", "SecondaryWeapon": "g7a_torpedo_sub",
         "Engine": "holland_diesel_electric"},
        ["soviet_naval_1936", "submarine"], size="Medium", crew=40, days=95),

    warship("zara_class_1936", "Zara-class", "italian_naval_1936",
            {"NavalGun": "zara_class_cruiser_1936", "Engine": "geared_steam_turbine_60k",
             "Armor": "naval_belt_armor_scheme"},
            ["italian_naval_1936", "cruiser"], "cruiser", "Heavy", 200, 780, 32),
    warship("vittorio_veneto_bb_1936", "Vittorio Veneto (building)", "italian_naval_1936",
            {"NavalGun": "ita_12inch_m1914", "Engine": "geared_steam_turbine_60k",
             "Armor": "naval_belt_armor_scheme"},
            ["italian_naval_1936"], "battleship", "Heavy", 280, 1600, 30),
    warship("navigatori_destroyer_1936", "Navigatori-class DD", "italian_naval_1936",
            {"NavalGun": "ger_15cm_tb", "SecondaryWeapon": "mk15_torpedo_tube",
             "Engine": "geared_steam_turbine_60k"},
            ["italian_naval_1936", "destroyer"], "destroyer", "Light", 118, 240),

    warship("kongo_class_1936", "Kongo-class", "japanese_naval_1936",
            {"NavalGun": "ijn_14inch_type94", "Engine": "ijn_kampon_turbine",
             "Armor": "naval_belt_armor_scheme"},
            ["japanese_naval_1936", "battlecruiser"], "battleship", "Heavy", 245, 1400, 35),
    warship("fuso_class_1936", "Fusō-class", "japanese_naval_1936",
            {"NavalGun": "ijn_14inch_type94", "Engine": "ijn_kampon_turbine",
             "Armor": "naval_deck_armor_scheme"},
            ["japanese_naval_1936"], "battleship", "SuperHeavy", 260, 1500),
    warship("mogami_class_1936", "Mogami-class", "japanese_naval_1936",
            {"NavalGun": "ijn_8inch_type3", **DD_JPN},
            ["japanese_naval_1936", "cruiser"], "cruiser", "Heavy", 195, 850, 34),
    warship("fubuki_class_1936", "Fubuki-class", "japanese_naval_1936", DD_JPN,
            ["japanese_naval_1936", "destroyer"], "destroyer", "Light", 120, 240, 34),
    warship("akagi_carrier_1936", "Akagi", "japanese_naval_1936",
            {"Cargo": "carrier_air_wing_bunker", "Engine": "ijn_kampon_turbine",
             "Armor": "carrier_wooden_flight_deck", "Sensors": "naval_radar_type22"},
            ["japanese_naval_1936", "carrier"], "carrier", "Heavy", 260, 2000, 36),

    warship("grom_class_1936", "Grom-class", "polish_naval_1936",
            {"NavalGun": "grom_class_destroyer_poland", **{k: v for k, v in DD.items() if k != "NavalGun"}},
            ["polish_naval_1936", "destroyer"], "destroyer", "Light", 105, 180, 30),
    sub("orpzel_sub_1936", "ORP Orzeł", "polish_sub_1936",
        {"MainWeapon": "submarine_torpedo_tube", "SecondaryWeapon": "g7a_torpedo_sub",
         "Engine": "holland_diesel_electric"},
        ["polish_naval_1936", "submarine"], crew=32, days=90),

    # ─── Commonwealth & neutrals ─────────────────────────────────────────────────
    warship("leander_class_1936", "Leander-class", "australian_naval_1936",
            {"NavalGun": "leander_cruiser_uk", **DD},
            ["australian_naval_1936", "new_zealand_naval_1936", "cruiser"], "cruiser", "Medium", 175, 600),
    warship("canadian_destroyer_1936", "Canadian River-class", "canadian_naval_1936", DD,
            ["canadian_naval_1936", "destroyer"], "destroyer", "Light", 115, 140),
    warship("de_ruyter_1936", "De Ruyter-class", "dutch_naval_1936",
            {"NavalGun": "uk_6inch_bl_mk12", **DD},
            ["dutch_naval_1936", "cruiser"], "cruiser", "Medium", 165, 420, 28),
    warship("sweden_coastal_1936", "Gotland (hybrid)", "swedish_naval_1936",
            {"NavalGun": "uk_6inch_bl_mk12", "Cargo": "carrier_air_wing_bunker",
             "Engine": "carrier_boiler_yarrow"},
            ["swedish_naval_1936"], "cruiser", "Medium", 170, 500, 28),
    warship("norway_coastal_1936", "Norge-class", "norwegian_naval_1936",
            {"NavalGun": "uk_12inch_mk10", "Engine": "carrier_boiler_yarrow"},
            ["norwegian_naval_1936"], "battleship", "Light", 175, 380),
    warship("finland_coastal_1936", "Väinämöinen", "finnish_naval_1936",
            {"NavalGun": "uk_8inch_mk8", "Engine": "carrier_boiler_yarrow",
             "Armor": "naval_belt_armor_scheme"},
            ["finnish_naval_1936"], "cruiser", "Medium", 160, 420, 28),
    warship("danish_coastal_1936", "Niels Juel", "danish_naval_1936",
            {"NavalGun": "uk_6inch_bl_mk12", **DD},
            ["danish_naval_1936", "cruiser"], "cruiser", "Medium", 155, 380),

    warship("argentina_rivadavia_1936", "Rivadavia-class", "argentine_naval_1936",
            {"NavalGun": "us_14inch_45_gun", "Engine": "us_parsons_turbine",
             "Armor": "naval_belt_armor_scheme"},
            ["argentine_naval_1936"], "battleship", "Heavy", 240, 900),
    warship("brazil_cruiser_1936", "Bahia-class Cruiser", "brazilian_naval_1936",
            {"NavalGun": "uk_6inch_bl_mk12", **DD},
            ["brazilian_naval_1936", "cruiser"], "cruiser", "Medium", 160, 550),
    warship("chile_almirante_1936", "Almirante Latorre", "chilean_naval_1936",
            {"NavalGun": "uk_14inch_mk7", "Engine": "us_parsons_turbine",
             "Armor": "naval_belt_armor_scheme"},
            ["chilean_naval_1936"], "battleship", "Heavy", 235, 900),
    warship("mexico_gunboat_1936", "Mexican Gunboat", "mexican_naval_1936",
            {"NavalGun": "interwar_coastal_patrol"}, ["mexican_naval_1936"], "patrol", "Light", 50, 40),
    warship("south_africa_auxiliary_1936", "SA Naval Auxiliary", "south_african_naval_1936",
            {"NavalGun": "interwar_coastal_patrol"}, ["south_african_naval_1936"], "patrol", "Light", 48, 35),

    warship("egypt_patrol_1936", "Egyptian Patrol", "egyptian_naval_1936",
            {"NavalGun": "interwar_coastal_patrol"}, ["egyptian_naval_1936"], "patrol", "Light", 45, 30),
    warship("persia_sloop_1936", "Persian Gulf Sloop", "iranian_naval_1936",
            {"NavalGun": "interwar_coastal_patrol"}, ["iranian_naval_1936"], "patrol", "Light", 42, 28),
    warship("mandate_patrol_1936", "Mandate Patrol", "mandate_naval_1936",
            {"NavalGun": "interwar_coastal_patrol"},
            ["palestine_naval_1936", "israeli_naval_1936", "syrian_naval_1936"], "patrol", "Light", 40, 25),
    warship("ukraine_patrol_1936", "Black Sea Patrol", "ukrainian_naval_1936",
            {"NavalGun": "interwar_coastal_patrol"}, ["ukrainian_naval_1936"], "patrol", "Light", 38, 22),
    warship("nigeria_patrol_1936", "Nigerian Colonial Patrol", "nigerian_naval_1936",
            {"NavalGun": "interwar_coastal_patrol"}, ["nigerian_naval_1936"], "patrol", "Light", 36, 20),
    warship("iceland_coastguard_1936", "Icelandic Coast Guard", "icelandic_naval_1936",
            {"NavalGun": "interwar_coastal_patrol"}, ["icelandic_naval_1936"], "patrol", "Light", 34, 18),
    warship("greenland_patrol_1936", "Greenland Patrol", "greenland_naval_1936",
            {"NavalGun": "interwar_coastal_patrol"}, ["greenland_naval_1936", "danish_naval_1936"],
            "patrol", "Light", 32, 16),
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
        try:
            d = json.loads(p.read_text())
        except json.JSONDecodeError:
            continue
        for slot, mid in d.get("module_loadout", {}).items():
            if mid and mid not in mods:
                errs.append(f"{p.name}: {mid}")
    print(f"\n1936 naval: {mc} modules, {tc} templates. Missing refs: {len(errs)}")
    for e in errs:
        print(f"  ! {e}")


if __name__ == "__main__":
    main()
