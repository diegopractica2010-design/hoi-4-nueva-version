#!/usr/bin/env python3
"""Naval prototypes, paper designs, and cancelled projects — pre-WWI through 2030s."""

from __future__ import annotations

from template_export import write_unit_template
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "data"
MODULES_DIR = ROOT / "modules"
TEMPLATES_DIR = ROOT / "unit_templates"

P = ["naval_prototype", "paper_navy"]  # base unlock tags

# fmt: off
MODULES: list[dict] = [
    {"id": "montana_class_bb_design", "name": "Montana-class BB Design", "category": "NavalGun", "tier": 6,
     "soft_attack": 55, "hard_attack": 62, "piercing": 58, "anti_ship": 95,
     "cost": {"steel": 45, "chromium": 12, "explosives": 20}, "production_time": 120,
     "special_flags": ["usa", "battleship", "prototype", "ww2", "paper"],
     "description": "USN 12-gun super-battleship design cancelled 1942. Would have exceeded Iowa firepower."},
    {"id": "h39_h_class_bb_design", "name": "H-39 Battleship Design", "category": "NavalGun", "tier": 6,
     "soft_attack": 52, "hard_attack": 60, "piercing": 56, "anti_ship": 92,
     "cost": {"steel": 42, "chromium": 10, "explosives": 18}, "production_time": 115,
     "special_flags": ["germany", "battleship", "prototype", "ww2", "paper"],
     "description": "German H-class with 16-inch guns. Keels laid but never completed."},
    {"id": "a150_super_yamato_design", "name": "A-150 Super-Yamato Design", "category": "Armor", "tier": 7,
     "armor_bonus": 72, "top_armor_bonus": 45, "reliability_penalty": -8,
     "cost": {"steel": 80, "chromium": 20, "titanium": 8}, "production_time": 150,
     "special_flags": ["japan", "battleship", "prototype", "ww2", "paper"],
     "description": "Planned 20-inch gunned super-battleship. Cancelled 1942 in favor of carriers."},
    {"id": "malta_class_carrier_design", "name": "Malta-class Carrier Design", "category": "Cargo", "tier": 5,
     "reliability_bonus": 5,
     "cost": {"steel": 95, "electronics": 18, "aluminum": 22}, "production_time": 210,
     "special_flags": ["uk", "carrier", "prototype", "ww2", "paper"],
     "description": "RN armored fleet carrier design. Cancelled for resources."},
    {"id": "uss_united_states_cvb", "name": "USS United States (CVB) Design", "category": "Cargo", "tier": 6,
     "reliability_bonus": 6,
     "cost": {"steel": 100, "electronics": 22, "aluminum": 28}, "production_time": 225,
     "special_flags": ["usa", "carrier", "prototype", "cold_war", "paper"],
     "description": "USN flush-deck supercarrier cancelled 1949. Influenced Forrestal layout."},
    {"id": "sovetsky_soyuz_bb_design", "name": "Sovetsky Soyuz BB Design", "category": "NavalGun", "tier": 5,
     "soft_attack": 48, "hard_attack": 55, "piercing": 52, "anti_ship": 88,
     "cost": {"steel": 40, "chromium": 10, "explosives": 16}, "production_time": 110,
     "special_flags": ["ussr", "battleship", "prototype", "ww2", "paper"],
     "description": "Soviet 16-inch battleship class. Construction halted by war."},
    {"id": "stalingrad_bc_design", "name": "Stalingrad BC Design", "category": "NavalGun", "tier": 5,
     "soft_attack": 46, "hard_attack": 52, "piercing": 50, "anti_ship": 85,
     "cost": {"steel": 38, "chromium": 9, "explosives": 14}, "production_time": 105,
     "special_flags": ["ussr", "battlecruiser", "prototype", "cold_war", "paper"],
     "description": "Soviet large battlecruiser with 12-inch guns. Cancelled after Stalin's death."},
    {"id": "sea_control_ship_1970s", "name": "Sea Control Ship (1970s)", "category": "Cargo", "tier": 4,
     "reliability_bonus": 2,
     "cost": {"steel": 55, "electronics": 15, "aluminum": 12}, "production_time": 140,
     "special_flags": ["usa", "carrier", "prototype", "cold_war", "vtol"],
     "description": "Small carrier concept for ASW and sea control. Precursor to LHA/LHD thinking."},
    {"id": "cva01_carrier_design", "name": "CVA-01 Carrier Design", "category": "Cargo", "tier": 5,
     "reliability_bonus": 4,
     "cost": {"steel": 90, "electronics": 25, "aluminum": 24}, "production_time": 200,
     "special_flags": ["uk", "carrier", "prototype", "cold_war", "paper"],
     "description": "British CATOBAR carrier cancelled 1966. Led to Invincible STOVL path."},
    {"id": "ulyanovsk_carrier_proto", "name": "Ulyanovsk Carrier Proto", "category": "Cargo", "tier": 6,
     "reliability_bonus": 5,
     "cost": {"steel": 105, "electronics": 30, "aluminum": 28, "uranium": 6}, "production_time": 230,
     "special_flags": ["ussr", "russia", "carrier", "prototype", "catapult"],
     "description": "Soviet nuclear carrier with catapults. Hull scrapped incomplete 1992."},
    {"id": "shtorm_carrier_2030", "name": "Project Shtorm (2030)", "category": "Cargo", "tier": 8,
     "reliability_bonus": 6,
     "cost": {"steel": 120, "electronics": 55, "aluminum": 35, "uranium": 12}, "production_time": 260,
     "special_flags": ["russia", "carrier", "prototype", "twenty_thirties", "planned"],
     "description": "Russian 100,000-ton nuclear supercarrier design. Uncertain funding timeline."},
    {"id": "type83_destroyer_planned", "name": "Type 83 Destroyer (Planned)", "category": "Sensors", "tier": 8,
     "reliability_bonus": 10,
     "cost": {"steel": 12, "electronics": 55, "aluminum": 10}, "production_time": 100,
     "special_flags": ["uk", "destroyer", "prototype", "twenty_thirties", "planned"],
     "description": "Future Royal Navy air-defense destroyer replacing Type 45."},
    {"id": "ddg_x_frigate_planned", "name": "DDG(X) Frigate Package", "category": "Sensors", "tier": 8,
     "reliability_bonus": 8,
     "cost": {"steel": 10, "electronics": 50, "aluminum": 12}, "production_time": 95,
     "special_flags": ["usa", "frigate", "prototype", "twenty_thirties"],
     "description": "Planned large USN surface combatant succeeding Burke and Constellation."},
]


def _naval(
    id_: str, name: str, family: str, archetype: str, loadout: dict, unlock: list[str],
    size: str = "Heavy", days: int = 200, training: int = 28, crew: int = 800,
    stats: dict | None = None, slots: dict | None = None,
) -> dict:
    base = stats or {
        "speed": 26, "reliability": 60, "fuel_consumption": 70,
        "supply_need": 90, "armor": 40, "deck_armor": 22, "hardness": 65,
    }
    default_slots = {
        "NavalGun": {"max": 2}, "SecondaryWeapon": {"max": 2},
        "Engine": {"max": 1}, "Armor": {"max": 1}, "Sensors": {"max": 1},
    }
    carrier_slots = {
        "Armor": {"max": 1}, "Engine": {"max": 1}, "Cargo": {"max": 1},
        "Sensors": {"max": 1}, "AntiAir": {"max": 1},
    }
    return {
        "id": id_, "name": name, "design_family": family,
        "base_type": "Naval", "size_category": size,
        "visual_archetype": archetype,
        "crew_required": crew, "base_training_level": training,
        "max_experience_level": 100, "base_production_days": days,
        "base_stats": base,
        "slots": slots or (carrier_slots if archetype == "carrier" else default_slots),
        "module_loadout": loadout,
        "unlock_tech": unlock,
        "can_mount_drones": False,
        "is_vehicle": True,
    }


def cv_proto(id_: str, name: str, family: str, cargo: str, unlock_extra: list[str], **kw) -> dict:
    return _naval(
        id_, name, family, "carrier",
        {"Cargo": cargo, "Engine": kw.get("engine", "geared_steam_turbine_60k"),
         "Armor": kw.get("armor", "carrier_wooden_flight_deck"),
         "Sensors": kw.get("sensors", "naval_fire_control_mk37"),
         "AntiAir": kw.get("antiair", "carrier_aa_20mm_oerlikon")},
        P + unlock_extra, size=kw.get("size", "Heavy"), days=kw.get("days", 280),
        crew=kw.get("crew", 1800), training=kw.get("training", 30),
        stats=kw.get("stats"),
    )


def bb_proto(id_: str, name: str, family: str, guns: str, unlock_extra: list[str], **kw) -> dict:
    return _naval(
        id_, name, family, "battleship",
        {"NavalGun": guns, "Engine": kw.get("engine", "geared_steam_turbine_60k"),
         "Armor": kw.get("armor", "a150_super_yamato_design"),
         "SecondaryWeapon": kw.get("secondary", "mk15_torpedo_tube"),
         "Sensors": kw.get("sensors", "naval_fire_control_mk37")},
        P + unlock_extra, size="SuperHeavy", days=kw.get("days", 320),
        crew=kw.get("crew", 2000), training=32,
        stats=kw.get("stats", {"speed": 24, "reliability": 55, "fuel_consumption": 105,
                               "supply_need": 140, "armor": 62, "deck_armor": 34, "hardness": 90}),
    )


def dd_proto(id_: str, name: str, family: str, loadout: dict, unlock_extra: list[str], **kw) -> dict:
    return _naval(
        id_, name, family, "destroyer", loadout, P + unlock_extra,
        size=kw.get("size", "Heavy"), days=kw.get("days", 180), crew=kw.get("crew", 400),
        training=kw.get("training", 28),
        stats=kw.get("stats"),
    )


TEMPLATES: list[dict] = [
    # ═══ Interwar / WWI paper ════════════════════════════════════════════════════
    cv_proto("lexington_bc_1920", "Lexington-class (BC design)", "us_naval_paper",
             "carrier_air_wing_bunker", ["us_naval_paper", "interwar_naval", "battlecruiser"],
             engine="geared_steam_turbine_60k", armor="carrier_armored_flight_deck",
             days=260, crew=2000,
             stats={"speed": 33, "reliability": 68, "fuel_consumption": 88, "supply_need": 100,
                    "armor": 32, "deck_armor": 20, "hardness": 60}),
    cv_proto("amagi_class_bc", "Amagi-class (BC design)", "japanese_naval_paper",
             "carrier_air_wing_bunker", ["japanese_naval_paper", "interwar_naval"],
             engine="ijn_kampon_turbine", days=270, crew=1600),
    cv_proto("g3_battlecruiser_uk", "G3 Battlecruiser (Paper)", "uk_naval_paper",
             "carrier_air_wing_bunker", ["uk_naval_paper", "interwar_naval"],
             engine="carrier_boiler_yarrow", armor="naval_belt_armor_scheme",
             days=300, crew=1800, size="SuperHeavy",
             stats={"speed": 32, "reliability": 62, "fuel_consumption": 95, "supply_need": 120,
                    "armor": 48, "deck_armor": 24, "hardness": 75}),
    _naval("joffre_class_carrier", "Joffre-class (Paper)", "french_naval_paper", "carrier",
           {"Cargo": "carrier_air_wing_bunker", "Engine": "carrier_boiler_yarrow",
            "Armor": "carrier_wooden_flight_deck", "AntiAir": "carrier_aa_20mm_oerlikon"},
           P + ["french_naval_paper", "interwar_naval"], days=290, crew=1500),

    # ═══ WWII paper battleships & carriers ═══════════════════════════════════════
    bb_proto("montana_class_bb", "Montana-class (Paper)", "us_naval_paper",
             "montana_class_bb_design", ["us_naval_paper", "ww2_naval", "super_battleship"],
             armor="naval_belt_armor_scheme", engine="iowa_class_turbine_212k", days=340, crew=2800),
    bb_proto("h39_h_class_bb", "H-39 (Paper)", "german_naval_paper",
             "h39_h_class_bb_design", ["german_naval_paper", "ww2_naval"],
             secondary="g7a_torpedo", engine="german_wagner_turbine", armor="naval_belt_armor_scheme"),
    bb_proto("a150_super_yamato", "A-150 Super Yamato (Paper)", "japanese_naval_paper",
             "ijn_18inch_type94", ["japanese_naval_paper", "ww2_naval"],
             armor="a150_super_yamato_design", engine="ijn_kampon_turbine", days=380, crew=3000,
             stats={"speed": 25, "reliability": 58, "fuel_consumption": 120, "supply_need": 160,
                    "armor": 70, "deck_armor": 40, "hardness": 95}),
    bb_proto("sovetsky_soyuz_bb", "Sovetsky Soyuz (Paper)", "soviet_naval_paper",
             "sovetsky_soyuz_bb_design", ["soviet_naval_paper", "ww2_naval"],
             engine="geared_steam_turbine_60k", armor="naval_belt_armor_scheme"),
    cv_proto("malta_class_carrier", "Malta-class (Paper)", "uk_naval_paper",
             "malta_class_carrier_design", ["uk_naval_paper", "ww2_naval"],
             armor="carrier_armored_flight_deck", sensors="type281_surface_radar", days=300),
    cv_proto("h44_supercarrier_us", "H-44 Supercarrier (Paper)", "us_naval_paper",
             "forrestal_supercarrier_deck", ["us_naval_paper", "ww2_naval"],
             armor="carrier_armored_flight_deck", days=350, crew=5000, size="SuperHeavy",
             stats={"speed": 28, "reliability": 58, "fuel_consumption": 110, "supply_need": 140,
                    "armor": 35, "deck_armor": 28, "hardness": 68}),
    _naval("o_class_battlecruiser", "O-class Battlecruiser (Paper)", "german_naval_paper", "cruiser",
           {"NavalGun": "ger_11inch_skc34", "SecondaryWeapon": "g7a_torpedo",
            "Engine": "german_wagner_turbine", "Armor": "naval_belt_armor_scheme"},
           P + ["german_naval_paper", "ww2_naval"], size="Heavy", days=240, crew=1600),
    _naval("m_class_cruiser_paper", "M-class Cruiser (Paper)", "german_naval_paper", "cruiser",
           {"NavalGun": "us_8inch_55_gun", "Engine": "german_wagner_turbine",
            "Armor": "naval_deck_armor_scheme"},
           P + ["german_naval_paper", "ww2_naval"], days=200, crew=900),

    # ═══ Cold War cancelled ══════════════════════════════════════════════════════
    cv_proto("uss_united_states_cvb", "USS United States (CVB)", "us_naval_paper",
             "uss_united_states_cvb", ["us_naval_paper", "cold_war_naval"],
             armor="carrier_armored_flight_deck", engine="geared_steam_turbine_60k", days=310),
    bb_proto("stalingrad_class_bc", "Stalingrad-class (Paper)", "soviet_naval_paper",
             "stalingrad_bc_design", ["soviet_naval_paper", "cold_war_naval"],
             engine="vm_reactor_soviet", armor="naval_belt_armor_scheme", days=280, crew=1800,
             stats={"speed": 32, "reliability": 58, "fuel_consumption": 90, "supply_need": 110,
                    "armor": 50, "deck_armor": 26, "hardness": 78}),
    _naval("kronstadt_bc_paper", "Kronstadt-class (Paper)", "soviet_naval_paper", "cruiser",
           {"NavalGun": "stalingrad_bc_design", "Engine": "geared_steam_turbine_60k",
            "Armor": "naval_belt_armor_scheme"},
           P + ["soviet_naval_paper", "cold_war_naval"], days=250, crew=1200),
    cv_proto("cva01_carrier", "CVA-01 (Paper)", "uk_naval_paper",
             "cva01_carrier_design", ["uk_naval_paper", "cold_war_naval"],
             armor="carrier_armored_flight_deck", sensors="an_sps6_air_search", days=280),
    cv_proto("sea_control_ship", "Sea Control Ship", "us_naval_paper",
             "sea_control_ship_1970s", ["us_naval_paper", "cold_war_naval", "vtol"],
             size="Medium", days=160, crew=600,
             stats={"speed": 24, "reliability": 65, "fuel_consumption": 50, "supply_need": 65,
                    "armor": 20, "deck_armor": 14, "hardness": 48}),
    dd_proto("strike_cruiser_csgn", "Strike Cruiser (CSGN)", "us_naval_paper",
             {"NavalGun": "us_5inch_54_mk42", "SecondaryWeapon": "tomahawk_cruise_missile",
              "Engine": "westinghouse_s5w_reactor", "Sensors": "an_sps6_air_search",
              "AntiAir": "mim23_hawk_sam"},
             ["us_naval_paper", "cold_war_naval", "nuclear_cruiser"], size="Heavy", days=260, crew=560),
    cv_proto("ulyanovsk_carrier", "Ulyanovsk (Incomplete)", "soviet_naval_paper",
             "ulyanovsk_carrier_proto", ["soviet_naval_paper", "russian_naval_paper"],
             engine="vm_reactor_soviet", armor="carrier_armored_flight_deck", days=300, crew=2500),

    # ═══ 2000s–2030s planned ═════════════════════════════════════════════════════
    cv_proto("shtorm_class_carrier", "Project Shtorm (Planned)", "russian_naval_planned",
             "shtorm_carrier_2030", ["russian_naval_planned", "twenty_thirties"],
             engine="vm_reactor_soviet", armor="carrier_armored_flight_deck",
             sensors="aesa_radar_gen1", antiair="s400_triumf", days=320, crew=2800, training=38),
    dd_proto("type83_destroyer_planned", "Type 83 (Planned)", "uk_naval_planned",
             {"NavalGun": "uk_4_5inch_mk6", "SecondaryWeapon": "mk41_vls_destroyer",
              "Sensors": "type83_destroyer_planned", "AntiAir": "sea_viper_sam",
              "Engine": "geared_steam_turbine_60k"},
             ["uk_naval_planned", "twenty_thirties"], days=200, crew=200, training=38),
    dd_proto("ddg_x_frigate_planned", "DDG(X) Large Combatant", "us_naval_planned",
             {"SecondaryWeapon": "mk41_vls_destroyer", "Sensors": "ddg_x_frigate_planned",
              "AntiAir": "aegis_bmd_package", "Armor": "zumwalt_stealth_hull"},
             ["us_naval_planned", "twenty_thirties"], days=210, crew=250, training=40),
    _naval("europe_patrol_corvette_2030", "European Patrol Corvette (Proto)", "european_naval_planned",
           "destroyer",
           {"NavalGun": "ger_15cm_tb", "Sensors": "aesa_radar_gen1", "AntiAir": "iris_t_slm",
            "Engine": "fuel_cell_aip_212"},
           P + ["european_naval_planned", "twenty_thirties", "multinational"], size="Light",
           days=120, crew=80, training=34,
           stats={"speed": 30, "reliability": 78, "fuel_consumption": 25, "supply_need": 35,
                  "armor": 18, "deck_armor": 10, "hardness": 45}),
    cv_proto("indigenous_carrier_turkey", "TCG Anadolu Follow-on CV (Planned)", "turkish_naval_planned",
             "cvn_x_carrier_proto", ["turkish_naval_planned", "twenty_thirties"],
             size="Medium", days=240, crew=1200,
             stats={"speed": 26, "reliability": 62, "fuel_consumption": 70, "supply_need": 85,
                    "armor": 28, "deck_armor": 20, "hardness": 55}),
    _naval("japanese_13dd_destroyer", "13DDX (Planned)", "japanese_naval_planned", "destroyer",
           {"NavalGun": "us_5inch_54_mk42", "SecondaryWeapon": "mk41_vls_destroyer",
            "Sensors": "aesa_radar_gen1", "AntiAir": "type055_destroyer_vls",
            "Engine": "geared_steam_turbine_60k"},
           P + ["japanese_naval_planned", "twenty_thirties"], days=195, crew=220, training=38),
    _naval("indian_vishal_carrier", "INS Vishal (Planned)", "indian_naval_planned", "carrier",
           {"Cargo": "ins_vikrant_carrier_core", "Engine": "westinghouse_a4w_carrier_reactor",
            "Sensors": "aesa_radar_gen1", "AntiAir": "barak8_sam"},
           P + ["indian_naval_planned", "twenty_thirties"], days=280, crew=2000, training=36),
    _naval("german_meko_carrier_proto", "MEKO Carrier Concept (Proto)", "german_naval_planned", "carrier",
           {"Cargo": "clemenceau_catapult_deck", "Engine": "fuel_cell_aip_212",
            "Sensors": "aesa_radar_gen1", "AntiAir": "iris_t_slm"},
           P + ["german_naval_planned", "twenty_thirties"], size="Medium", days=220, crew=900),
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
                errs.append(f"{p.name}: {slot} -> {mid}")
    print(f"\nNaval prototypes: {mc} modules, {tc} templates. Missing refs: {len(errs)}")
    for e in errs:
        print(f"  ! {e}")


if __name__ == "__main__":
    main()
