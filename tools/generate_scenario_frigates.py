#!/usr/bin/env python3
"""Dedicated frigate templates for every scenario nation (1918, 1936, 2026)."""

from __future__ import annotations

from template_export import write_unit_template
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "data"
TEMPLATES_DIR = ROOT / "unit_templates"
SCENARIOS_DIR = ROOT / "scenarios"

NATION_NAVAL = {
    "GER": "german_naval", "FRA": "french_naval", "ENG": "uk_naval", "USA": "us_naval",
    "SOV": "soviet_naval", "RUS": "russian_naval", "ITA": "italian_naval", "JAP": "japanese_naval",
    "TUR": "turkish_naval", "POL": "polish_naval", "UKR": "ukrainian_naval", "FIN": "finnish_naval",
    "NOR": "norwegian_naval", "SWE": "swedish_naval", "DNK": "danish_naval", "NLD": "dutch_naval",
    "SAF": "south_african_naval", "AUS": "australian_naval", "NZL": "new_zealand_naval",
    "CAN": "canadian_naval", "ARG": "argentine_naval", "BRA": "brazilian_naval",
    "MEX": "mexican_naval", "EGY": "egyptian_naval", "IRN": "iranian_naval",
    "ISR": "israeli_naval", "PAL": "palestine_naval", "NGA": "nigerian_naval",
    "SYR": "syrian_naval", "CHL": "chilean_naval", "ISL": "icelandic_naval",
    "GRL": "greenland_naval", "CHN": "chinese_naval", "IND": "indian_naval",
    "KOR": "south_korean_naval", "SPA": "spanish_naval", "SAU": "saudi_naval",
    "IDN": "indonesian_naval", "THA": "thai_naval", "MYS": "malaysian_naval",
    "PAN": "panamanian_naval", "AZE": "azerbaijani_naval", "IRQ": "iraqi_naval",
    "COL": "colombian_naval",
}

# (display name, loadout) per tag — era-specific guns
FRIGATE_1918: dict[str, tuple[str, dict]] = {
    "GER": ("SMS Brummer", {"NavalGun": "ger_10_5cm_tb", "SecondaryWeapon": "ww1_18inch_torpedo",
                            "Engine": "german_wagner_turbine", "Sensors": "naval_fire_control_mk37"}),
    "FRA": ("Arras-class Destroyer Leader", {"NavalGun": "uk_4_7inch_qf", "SecondaryWeapon": "ww1_18inch_torpedo",
              "Engine": "carrier_boiler_yarrow"}),
    "ENG": ("E-class Destroyer Leader", {"NavalGun": "uk_4_7inch_qf", "SecondaryWeapon": "ww1_18inch_torpedo",
              "Engine": "carrier_boiler_yarrow", "Sensors": "naval_fire_control_mk37"}),
    "USA": ("Wickes-class Escort", {"NavalGun": "ww1_4inch_qf_mk4", "SecondaryWeapon": "ww1_18inch_torpedo",
              "Engine": "us_parsons_turbine"}),
    "SOV": ("Novik-class Frigate", {"NavalGun": "uk_4_7inch_qf", "SecondaryWeapon": "ww1_18inch_torpedo",
              "Engine": "carrier_boiler_yarrow"}),
    "ITA": ("Pilo-class Torpedo Boat", {"NavalGun": "ger_10_5cm_tb", "SecondaryWeapon": "ww1_18inch_torpedo",
              "Engine": "carrier_boiler_yarrow"}),
    "JAP": ("Tenryū-class Light Cruiser", {"NavalGun": "ijn_12_7cm_type89", "SecondaryWeapon": "ww1_18inch_torpedo",
              "Engine": "ijn_kampon_turbine"}),
    "TUR": ("Peyk-i Şevket", {"NavalGun": "ww1_coastal_patrol", "SecondaryWeapon": "ww1_18inch_torpedo",
              "Engine": "carrier_boiler_yarrow"}),
}
FRIGATE_1936: dict[str, tuple[str, dict]] = {
    "GER": ("Type 34 Torpedo Boat", {"NavalGun": "ger_10_5cm_tb", "SecondaryWeapon": "type93_long_lance",
              "Engine": "german_wagner_turbine", "Sensors": "naval_fire_control_mk37"}),
    "FRA": ("Le Fantasque-class", {"NavalGun": "uk_4_7inch_qf", "SecondaryWeapon": "type93_long_lance",
              "Engine": "carrier_boiler_yarrow", "Sensors": "naval_fire_control_mk37"}),
    "ENG": ("Tribal-class Destroyer", {"NavalGun": "uk_4_7inch_qf", "SecondaryWeapon": "mk15_torpedo_tube",
              "Engine": "carrier_boiler_yarrow", "Sensors": "naval_fire_control_mk37"}),
    "USA": ("Porter-class Leader", {"NavalGun": "us_5inch_38_gun", "SecondaryWeapon": "mk15_torpedo_tube",
              "Engine": "us_parsons_turbine", "Sensors": "naval_fire_control_mk37"}),
    "SOV": ("Gnevny-class Destroyer", {"NavalGun": "uk_4_7inch_qf", "SecondaryWeapon": "mk15_torpedo_tube",
              "Engine": "carrier_boiler_yarrow"}),
    "ITA": ("Navigatori-class", {"NavalGun": "ijn_12_7cm_type89", "SecondaryWeapon": "type93_long_lance",
              "Engine": "ijn_kampon_turbine"}),
    "JAP": ("Fubuki-class", {"NavalGun": "ijn_12_7cm_type89", "SecondaryWeapon": "type93_long_lance",
              "Engine": "ijn_kampon_turbine", "Sensors": "naval_radar_type22"}),
    "POL": ("Grom-class", {"NavalGun": "grom_class_destroyer_poland", "SecondaryWeapon": "mk15_torpedo_tube",
              "Engine": "us_parsons_turbine"}),
}
# Default loadouts for minors / remaining nations
DD1918 = {"NavalGun": "uk_4_7inch_qf", "SecondaryWeapon": "ww1_18inch_torpedo", "Engine": "carrier_boiler_yarrow"}
DD1936 = {"NavalGun": "uk_4_7inch_qf", "SecondaryWeapon": "mk15_torpedo_tube", "Engine": "us_parsons_turbine"}
FF2026 = {"NavalGun": "us_5inch_54_mk42", "SecondaryWeapon": "harpoon_sub_launch",
          "Sensors": "fremm_frigate_suite", "AntiAir": "mim23_hawk_sam", "Engine": "geared_steam_turbine_60k"}
FF2026_RUS = {**FF2026, "NavalGun": "ger_15cm_tb", "SecondaryWeapon": "kalibr_vls_sub",
              "Sensors": "gorshkov_frigate_suite", "AntiAir": "s400_triumf"}
FF2026_CHN = {**FF2026, "SecondaryWeapon": "type055_destroyer_vls", "Sensors": "type055_destroyer_vls",
              "AntiAir": "hq9b_sam"}

ERA_TAGS = {
    "1918": ["naval_1918", "ww1_naval", "great_war_naval"],
    "1936": ["naval_1936", "interwar_naval", "pre_ww2_naval"],
    "2026": ["naval_2026", "twenty_twenties_naval"],
}


def frigate_tpl(tag: str, era: str, name: str, loadout: dict) -> dict:
    naval = NATION_NAVAL.get(tag, f"{tag.lower()}_naval")
    return {
        "id": f"{tag.lower()}_frigate_{era}",
        "name": name,
        "design_family": f"{naval}_{era}",
        "base_type": "Naval",
        "size_category": "Medium",
        "visual_archetype": "frigate",
        "crew_required": 180 if era != "1918" else 140,
        "base_training_level": 26 if era == "1918" else 30 if era == "1936" else 34,
        "max_experience_level": 100,
        "base_production_days": 100 if era == "1918" else 120 if era == "1936" else 145,
        "base_stats": {
            "speed": 28 if era == "1918" else 30 if era == "1936" else 29,
            "reliability": 66 if era == "1918" else 72 if era == "1936" else 80,
            "fuel_consumption": 45 if era != "2026" else 55,
            "supply_need": 55 if era == "1918" else 65 if era == "1936" else 72,
            "armor": 28 if era == "1918" else 32 if era == "1936" else 36,
            "deck_armor": 14 if era != "2026" else 20,
            "hardness": 55 if era == "1918" else 60 if era == "1936" else 65,
        },
        "slots": {
            "NavalGun": {"max": 1},
            "SecondaryWeapon": {"max": 2},
            "Engine": {"max": 1},
            "Sensors": {"max": 1},
            "AntiAir": {"max": 1},
            "Armor": {"max": 1},
        },
        "module_loadout": loadout,
        "unlock_tech": ERA_TAGS[era] + [naval + f"_{era}", "frigate"],
        "can_mount_drones": era == "2026",
        "is_vehicle": True,
    }


def default_name(tag: str, era: str) -> str:
    return f"{tag} Frigate ({era})"


def build_all() -> list[dict]:
    templates: list[dict] = []
    scenarios = {
        "1918": ("1918.json", FRIGATE_1918, DD1918),
        "1936": ("1936.json", FRIGATE_1936, DD1936),
        "2026": ("2026.json", {}, FF2026),
    }
    for era, (sc_file, majors, default_lo) in scenarios.items():
        tags = [c["tag"] for c in json.loads((SCENARIOS_DIR / sc_file).read_text())["countries"]]
        for tag in tags:
            if tag in majors:
                name, lo = majors[tag]
            elif era == "2026":
                if tag == "RUS":
                    lo = FF2026_RUS
                elif tag == "CHN":
                    lo = FF2026_CHN
                else:
                    lo = default_lo
                name = default_name(tag, era)
            else:
                lo = default_lo
                name = default_name(tag, era)
            templates.append(frigate_tpl(tag, era, name, lo))
    return templates


def main() -> None:
    TEMPLATES_DIR.mkdir(parents=True, exist_ok=True)
    existing = {p.stem for p in TEMPLATES_DIR.glob("*.json")}
    mods = {p.stem for p in (ROOT / "modules").glob("*.json")}
    tc = 0
    errs: list[str] = []
    for tpl in build_all():
        for slot, mid in tpl.get("module_loadout", {}).items():
            if mid and mid not in mods:
                errs.append(f"{tpl['id']}: {mid}")
        if tpl["id"] in existing:
            continue
        write_unit_template(TEMPLATES_DIR / f"{tpl['id']}.json", tpl)
        tc += 1
    print(f"Scenario frigates: {tc} templates. Missing module refs: {len(errs)}")
    for e in errs[:20]:
        print(f"  ! {e}")


if __name__ == "__main__":
    main()
