#!/usr/bin/env python3
"""Land-launched missiles, SAM/ABM, and mobile rocket launcher vehicles by era.

Modeling conventions (see also generate_transport_cargo_naval.py):
- MainWeapon: offensive rockets, SRBM/IRBM/ICBM warheads, MLRS pods (mount on launcher chassis or transport trucks).
- AntiAir: Patriot, Iron Dome, THAAD, Hawk, S-300 family — point/theater defense batteries.
- SecondaryWeapon: extra launch cells on ships or heavy TEL secondary racks.
- Launcher templates: Land / is_vehicle=true with open MainWeapon (+ optional AntiAir) slots.
- Era gating via unlock_tech on templates and special_flags on modules.
"""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "data"
MODULES_DIR = ROOT / "modules"
TEMPLATES_DIR = ROOT / "unit_templates"

# fmt: off
MODULES: list[dict] = [
    # ── WW2 rocket artillery ───────────────────────────────────────────────────
    {"id": "bm13_katyusha_rack", "name": "BM-13 Katyusha", "category": "MainWeapon", "tier": 3,
     "soft_attack": 95, "hard_attack": 25, "piercing": 15, "air_attack": 4,
     "cost": {"steel": 8, "explosives": 18, "rubber": 4}, "production_time": 35,
     "special_flags": ["soviet", "rocket_artillery", "ww2", "mountable_on_transport"],
     "description": "16-rail truck-mounted rocket salvo. Soviet 'Stalin's organ' saturation fires."},
    {"id": "nebelwerfer_150mm", "name": "15 cm Nebelwerfer 41", "category": "MainWeapon", "tier": 3,
     "soft_attack": 88, "hard_attack": 22, "piercing": 12,
     "cost": {"steel": 10, "explosives": 16}, "production_time": 38,
     "special_flags": ["germany", "rocket_artillery", "ww2", "mountable_on_transport"],
     "description": "German six-barrel chemical/smoke rocket launcher on half-track or truck."},
    {"id": "m8_calliope_rocket", "name": "4.5\" M8 Rocket Launcher", "category": "MainWeapon", "tier": 3,
     "soft_attack": 75, "hard_attack": 20, "piercing": 14,
     "cost": {"steel": 6, "explosives": 14, "aluminum": 4}, "production_time": 32,
     "special_flags": ["usa", "rocket_artillery", "ww2", "mountable_on_transport"],
     "description": "Sherman-mounted 'Calliope' rocket rack for bunker and infantry suppression."},
    # ── Cold War SRBM / tactical ─────────────────────────────────────────────
    {"id": "scud_b_srbm", "name": "R-17 Scud-B", "category": "MainWeapon", "tier": 5,
     "soft_attack": 130, "hard_attack": 55, "piercing": 45, "air_attack": 6,
     "cost": {"steel": 22, "electronics": 35, "explosives": 60}, "production_time": 95,
     "special_flags": ["soviet", "ballistic", "srbm", "seventies", "mountable_on_transport"],
     "description": "Export ballistic missile on MAZ TEL. Gulf War and regional conflicts staple."},
    {"id": "atacms_tactical", "name": "ATACMS", "category": "MainWeapon", "tier": 6,
     "soft_attack": 115, "hard_attack": 50, "piercing": 40,
     "cost": {"steel": 12, "electronics": 40, "explosives": 45}, "production_time": 88,
     "special_flags": ["usa", "ballistic", "tactical", "eighties", "mountable_on_transport"],
     "description": "Army tactical missile for M270. Deep strike vs logistics and air defenses."},
    {"id": "pershing_ii_mrbm", "name": "Pershing II", "category": "MainWeapon", "tier": 6,
     "soft_attack": 140, "hard_attack": 65, "piercing": 55,
     "cost": {"steel": 18, "electronics": 48, "explosives": 55}, "production_time": 105,
     "special_flags": ["usa", "ballistic", "mrbm", "eighties"],
     "description": "Euromissile crisis system. Terminal guidance vs hardened targets in Europe."},
    {"id": "lance_srbm", "name": "MGM-52 Lance", "category": "MainWeapon", "tier": 5,
     "soft_attack": 100, "hard_attack": 45, "piercing": 35,
     "cost": {"steel": 14, "electronics": 30, "explosives": 40}, "production_time": 80,
     "special_flags": ["usa", "ballistic", "srbm", "seventies"],
     "description": "NATO division-level nuclear-capable SRBM replaced by ATACMS."},
    {"id": "bm21_grad_122mm", "name": "BM-21 Grad", "category": "MainWeapon", "tier": 4,
     "soft_attack": 105, "hard_attack": 35, "piercing": 22,
     "cost": {"steel": 10, "explosives": 28, "electronics": 6}, "production_time": 55,
     "special_flags": ["soviet", "rocket_artillery", "sixties", "mountable_on_transport"],
     "description": "40-tube 122 mm truck rocket artillery. Most widely exported MLRS pattern."},
    {"id": "fajr5_rocket", "name": "Fajr-5", "category": "MainWeapon", "tier": 5,
     "soft_attack": 98, "hard_attack": 38, "piercing": 25,
     "cost": {"steel": 9, "explosives": 32, "electronics": 8}, "production_time": 60,
     "special_flags": ["iran", "rocket_artillery", "two_thousands", "mountable_on_transport"],
     "description": "333 mm Iranian heavy rocket for strategic bombardment."},
    # ── ICBM / strategic (Cold War → modern) ─────────────────────────────────
    {"id": "minuteman_1_icbm", "name": "LGM-30A Minuteman I", "category": "MainWeapon", "tier": 6,
     "soft_attack": 200, "hard_attack": 90, "piercing": 70, "air_attack": 10,
     "cost": {"steel": 40, "electronics": 80, "explosives": 90, "chromium": 12}, "production_time": 180,
     "special_flags": ["usa", "icbm", "sixties", "strategic"],
     "description": "First solid-fuel U.S. ICBM in silos. Cold War triad leg."},
    {"id": "minuteman_3_icbm", "name": "LGM-30G Minuteman III", "category": "MainWeapon", "tier": 7,
     "soft_attack": 240, "hard_attack": 110, "piercing": 85, "air_attack": 12,
     "cost": {"steel": 42, "electronics": 95, "explosives": 95, "chromium": 14}, "production_time": 200,
     "special_flags": ["usa", "icbm", "seventies", "strategic"],
     "description": "MIRV-capable silo ICBM. Still anchors U.S. land-based deterrent."},
    {"id": "rt2pm_topol_icbm", "name": "RT-2PM Topol", "category": "MainWeapon", "tier": 7,
     "soft_attack": 230, "hard_attack": 105, "piercing": 80,
     "cost": {"steel": 38, "electronics": 88, "explosives": 88}, "production_time": 195,
     "special_flags": ["soviet", "icbm", "eighties", "strategic", "mountable_on_transport"],
     "description": "Road-mobile single-warhead ICBM. Survives first strike via dispersion."},
    {"id": "rs24_yars_icbm", "name": "RS-24 Yars", "category": "MainWeapon", "tier": 8,
     "soft_attack": 260, "hard_attack": 120, "piercing": 95,
     "cost": {"steel": 40, "electronics": 105, "explosives": 100}, "production_time": 210,
     "special_flags": ["russia", "icbm", "two_thousands", "strategic", "mountable_on_transport"],
     "description": "MIRV mobile ICBM replacing Topol. Core of modern Russian ground deterrent."},
    {"id": "df21_css5_mrbm", "name": "DF-21 (CSS-5)", "category": "MainWeapon", "tier": 7,
     "soft_attack": 150, "hard_attack": 70, "piercing": 58, "anti_ship": 80,
     "cost": {"steel": 20, "electronics": 55, "explosives": 60}, "production_time": 115,
     "special_flags": ["china", "ballistic", "mrbm", "two_thousands", "asbm", "mountable_on_transport"],
     "description": "Medium-range ballistic missile. DF-21D variant threatens carrier strike groups."},
    {"id": "df31_icbm", "name": "DF-31", "category": "MainWeapon", "tier": 7,
     "soft_attack": 235, "hard_attack": 108, "piercing": 82,
     "cost": {"steel": 36, "electronics": 92, "explosives": 90}, "production_time": 200,
     "special_flags": ["china", "icbm", "two_thousands", "strategic", "mountable_on_transport"],
     "description": "Chinese road-mobile ICBM. Survivable second-strike system."},
    {"id": "df41_icbm", "name": "DF-41", "category": "MainWeapon", "tier": 8,
     "soft_attack": 270, "hard_attack": 125, "piercing": 98,
     "cost": {"steel": 42, "electronics": 110, "explosives": 105}, "production_time": 220,
     "special_flags": ["china", "icbm", "twenty_twenties", "strategic", "mountable_on_transport"],
     "description": "MIRV ICBM with intercontinental range. Parade debut 2019."},
    {"id": "agni_v_irbm", "name": "Agni-V", "category": "MainWeapon", "tier": 7,
     "soft_attack": 220, "hard_attack": 100, "piercing": 78,
     "cost": {"steel": 32, "electronics": 85, "explosives": 85}, "production_time": 190,
     "special_flags": ["india", "irbm", "twenty_tens", "strategic", "mountable_on_transport"],
     "description": "Indian MIRV-capable IRBM approaching ICBM class ranges."},
    # ── Modern MLRS / HIMARS ───────────────────────────────────────────────────
    {"id": "gmlrs_rocket_pod", "name": "GMLRS", "category": "MainWeapon", "tier": 7,
     "soft_attack": 125, "hard_attack": 48, "piercing": 38,
     "cost": {"steel": 10, "electronics": 35, "explosives": 40}, "production_time": 75,
     "special_flags": ["usa", "rocket_artillery", "two_thousands", "precision", "mountable_on_transport"],
     "description": "GPS-guided 227 mm rocket for M270/HIMARS. 70+ km precision fires."},
    {"id": "m142_himars_system", "name": "M142 HIMARS", "category": "MainWeapon", "tier": 7,
     "soft_attack": 130, "hard_attack": 50, "piercing": 40,
     "cost": {"steel": 28, "electronics": 45, "explosives": 42, "aluminum": 8}, "production_time": 95,
     "special_flags": ["usa", "rocket_artillery", "two_thousands", "mountable_on_transport"],
     "description": "Wheeled six-pack launcher. Shares GMLRS/ATACMS/PrSM family munitions."},
    {"id": "bm30_smerch_300mm", "name": "BM-30 Smerch", "category": "MainWeapon", "tier": 6,
     "soft_attack": 140, "hard_attack": 45, "piercing": 35,
     "cost": {"steel": 14, "explosives": 50, "electronics": 12}, "production_time": 90,
     "special_flags": ["soviet", "rocket_artillery", "eighties", "mountable_on_transport"],
     "description": "12-tube 300 mm heavy MLRS. Area denial and counter-battery."},
    {"id": "tos1a_thermobaric", "name": "TOS-1A Buratino", "category": "MainWeapon", "tier": 6,
     "soft_attack": 150, "hard_attack": 30, "piercing": 20,
     "cost": {"steel": 22, "explosives": 55, "electronics": 15}, "production_time": 100,
     "special_flags": ["russia", "rocket_artillery", "two_thousands", "thermobaric"],
     "description": "T-72 chassis flamethrower rocket system. Devastating urban fires."},
    # ── SAM / ABM (Patriot, Iron Dome, THAAD, Arrow) ───────────────────────────
    {"id": "mim104e_patriot_pac3", "name": "MIM-104E PAC-3", "category": "AntiAir", "tier": 8,
     "soft_attack": 12, "hard_attack": 10, "air_attack": 98, "anti_air": 100,
     "cost": {"steel": 30, "electronics": 60, "explosives": 22}, "production_time": 130,
     "special_flags": ["usa", "sam", "tmd", "two_thousands", "patriot"],
     "description": "Patriot PAC-3 MSE. Hit-to-kill vs TBMs and maneuvering aircraft."},
    {"id": "thaad_interceptor", "name": "THAAD", "category": "AntiAir", "tier": 8,
     "soft_attack": 10, "hard_attack": 8, "air_attack": 95, "anti_air": 98,
     "cost": {"steel": 28, "electronics": 65, "explosives": 18}, "production_time": 140,
     "special_flags": ["usa", "sam", "tmd", "two_thousands", "thaad"],
     "description": "Terminal High Altitude Area Defense. Exo-atmospheric intercept of SRBMs."},
    {"id": "arrow3_interceptor", "name": "Arrow 3", "category": "AntiAir", "tier": 8,
     "soft_attack": 8, "hard_attack": 6, "air_attack": 94, "anti_air": 96,
     "cost": {"steel": 26, "electronics": 58, "explosives": 16}, "production_time": 125,
     "special_flags": ["israel", "sam", "tmd", "twenty_twenties", "arrow"],
     "description": "Exo-atmospheric interceptor. Upper tier of Israeli layered missile defense."},
    {"id": "hq9_sam_battery", "name": "HQ-9", "category": "AntiAir", "tier": 7,
     "soft_attack": 14, "hard_attack": 12, "air_attack": 88, "anti_air": 90,
     "cost": {"steel": 26, "electronics": 52, "explosives": 18}, "production_time": 115,
     "special_flags": ["china", "sam", "two_thousands"],
     "description": "Chinese long-range SAM analogous to S-300/Patriot. Export to Pakistan and others."},
    {"id": "nasams_launcher", "name": "NASAMS", "category": "AntiAir", "tier": 7,
     "soft_attack": 12, "hard_attack": 10, "air_attack": 82, "anti_air": 85,
     "cost": {"steel": 18, "electronics": 42, "explosives": 12}, "production_time": 90,
     "special_flags": ["norway", "sam", "two_thousands", "export"],
     "description": "Networked AMRAAM ground launcher. Protects cities and critical sites."},
    # ── Launcher chassis (mount points for trucks — Cargo holds spare rockets) ───
    {"id": "mlrs_launcher_chassis", "name": "MLRS Launcher Chassis", "category": "Suspension", "tier": 5,
     "reliability_bonus": 4, "speed_bonus": 2,
     "cost": {"steel": 18, "rubber": 6}, "production_time": 50,
     "special_flags": ["usa", "launcher_chassis", "tracked"],
     "description": "M270 tracked carrier without rocket pod. Accepts GMLRS/ATACMS modules."},
    {"id": "wheeled_mlrs_chassis", "name": "Wheeled MLRS Chassis", "category": "Suspension", "tier": 6,
     "reliability_bonus": 6, "speed_bonus": 6,
     "cost": {"steel": 14, "rubber": 8, "aluminum": 4}, "production_time": 48,
     "special_flags": ["usa", "launcher_chassis", "wheeled"],
     "description": "FMTV-derived HIMARS carrier. High mobility precision fires."},
    {"id": "truck_rocket_mount", "name": "Truck Rocket Mount", "category": "Suspension", "tier": 3,
     "reliability_bonus": 2, "speed_bonus": 4,
     "cost": {"steel": 8, "rubber": 4}, "production_time": 30,
     "special_flags": ["rocket_artillery", "mountable_on_transport", "truck"],
     "description": "Generic stake-bed truck frame for BM-13/BM-21 class rocket racks."},
    {"id": "mlrs_reload_trailer", "name": "MLRS Reload Trailer", "category": "Cargo", "tier": 4,
     "reliability_bonus": 3,
     "cost": {"steel": 12, "rubber": 4, "explosives": 8}, "production_time": 40,
     "special_flags": ["rocket_artillery", "reload", "mountable_on_transport"],
     "description": "Ammunition reload trailer for MLRS/HIMARS and SAM TEL resupply."},
    {"id": "caterpillar_c7_engine", "name": "Caterpillar C7", "category": "Engine", "tier": 5,
     "reliability_bonus": 7, "fuel_efficiency": 4, "speed_bonus": 4,
     "cost": {"steel": 10, "rubber": 3}, "production_time": 42,
     "special_flags": ["usa", "truck", "wheeled"],
     "description": "Common tactical truck engine for HIMARS, LAV, and support vehicles."},
]
# fmt: on

LAUNCHER_TEMPLATES: list[dict] = [
    # WW2
    {"id": "bm13_katyusha_launcher", "name": "BM-13 Katyusha", "family": "soviet_rocket_ww2",
     "weapon": "bm13_katyusha_rack", "chassis": "truck_rocket_mount", "engine": "v2_diesel_engine",
     "unlock": ["ww2_rocket_artillery", "soviet_missiles"], "days": 42, "training": 18,
     "stats": {"speed": 22, "reliability": 65, "fuel_consumption": 6, "supply_need": 12, "armor": 8, "hardness": 25}},
    {"id": "nebelwerfer_battery", "name": "Nebelwerfer Battery", "family": "german_rocket_ww2",
     "weapon": "nebelwerfer_150mm", "chassis": "truck_rocket_mount", "engine": "maybach_hl120_trm",
     "unlock": ["ww2_rocket_artillery", "german_missiles"], "days": 45, "training": 20},
    {"id": "m8_calliope_launcher", "name": "T34 Calliope", "family": "us_rocket_ww2",
     "weapon": "m8_calliope_rocket", "chassis": "christie_suspension_bt", "engine": "ford_gaa_v8_engine",
     "unlock": ["ww2_rocket_artillery", "us_missiles"], "days": 48, "training": 22},
    # Cold War
    {"id": "bm21_grad_launcher", "name": "BM-21 Grad", "family": "soviet_rocket_cold_war",
     "weapon": "bm21_grad_122mm", "chassis": "truck_rocket_mount", "engine": "v2_diesel_engine",
     "unlock": ["cold_war_rocket_artillery", "soviet_missiles"], "days": 55, "training": 24},
    {"id": "m270_mlrs_launcher", "name": "M270 MLRS", "family": "us_rocket_cold_war",
     "weapon": "m270_mlrs", "chassis": "mlrs_launcher_chassis", "engine": "agt1500_turbine",
     "unlock": ["cold_war_rocket_artillery", "us_missiles"], "days": 85, "training": 30,
     "stats": {"speed": 28, "reliability": 75, "fuel_consumption": 14, "supply_need": 20, "armor": 18, "hardness": 45}},
    {"id": "scud_tel_launcher", "name": "Scud TEL", "family": "soviet_ballistic_cold_war",
     "weapon": "scud_b_srbm", "chassis": "truck_rocket_mount", "engine": "v2_diesel_engine",
     "unlock": ["cold_war_ballistic", "soviet_missiles"], "days": 95, "training": 32},
    {"id": "pershing_ii_battery", "name": "Pershing II Battery", "family": "us_ballistic_cold_war",
     "weapon": "pershing_ii_mrbm", "chassis": "wheeled_mlrs_chassis", "engine": "agt1500_turbine",
     "unlock": ["cold_war_ballistic", "us_missiles"], "days": 105, "training": 34},
    # Modern
    {"id": "m142_himars_launcher", "name": "M142 HIMARS", "family": "us_rocket_modern",
     "weapon": "m142_himars_system", "chassis": "wheeled_mlrs_chassis", "engine": "caterpillar_c7_engine",
     "unlock": ["modern_rocket_artillery", "us_missiles", "twenty_twenties_missiles"], "days": 90, "training": 32,
     "extra_weapon": "gmlrs_rocket_pod"},
    {"id": "bm30_smerch_launcher", "name": "BM-30 Smerch", "family": "russian_rocket_modern",
     "weapon": "bm30_smerch_300mm", "chassis": "mlrs_launcher_chassis", "engine": "v46_6m_diesel",
     "unlock": ["modern_rocket_artillery", "russian_missiles"], "days": 100, "training": 30},
    {"id": "iskander_tel", "name": "Iskander TEL", "family": "russian_ballistic_modern",
     "weapon": "iskander_srbm", "chassis": "wheeled_mlrs_chassis", "engine": "v46_6m_diesel",
     "unlock": ["modern_ballistic", "russian_missiles", "twenty_twenties_missiles"], "days": 110, "training": 34},
    {"id": "tos1a_launcher", "name": "TOS-1A", "family": "russian_rocket_modern",
     "weapon": "tos1a_thermobaric", "chassis": "mlrs_launcher_chassis", "engine": "v46_6m_diesel",
     "unlock": ["modern_rocket_artillery", "russian_missiles"], "days": 105, "training": 28},
    # SAM batteries
    {"id": "patriot_battery", "name": "Patriot Battery", "family": "us_sam_modern",
     "aa": "mim104e_patriot_pac3", "chassis": "wheeled_mlrs_chassis", "engine": "agt1500_turbine",
     "unlock": ["modern_sam", "us_missiles", "tmd"], "days": 120, "training": 36, "archetype": "sam_battery"},
    {"id": "patriot_battery_1985", "name": "Patriot Battery (PAC-1)", "family": "us_sam_cold_war",
     "aa": "mim104_patriot", "chassis": "wheeled_mlrs_chassis", "engine": "agt1500_turbine",
     "unlock": ["cold_war_sam", "us_missiles"], "days": 115, "training": 34, "archetype": "sam_battery"},
    {"id": "iron_dome_battery", "name": "Iron Dome Battery", "family": "israeli_sam_modern",
     "aa": "iron_dome_interceptor", "chassis": "wheeled_mlrs_chassis", "engine": "merkava_avds_engine",
     "unlock": ["modern_sam", "israeli_missiles", "tmd"], "days": 100, "training": 35, "archetype": "sam_battery"},
    {"id": "thaad_battery", "name": "THAAD Battery", "family": "us_sam_modern",
     "aa": "thaad_interceptor", "chassis": "wheeled_mlrs_chassis", "engine": "agt1500_turbine",
     "unlock": ["modern_sam", "us_missiles", "tmd", "twenty_twenties_missiles"], "days": 140, "training": 38, "archetype": "sam_battery"},
    {"id": "arrow3_battery", "name": "Arrow 3 Battery", "family": "israeli_sam_modern",
     "aa": "arrow3_interceptor", "chassis": "wheeled_mlrs_chassis", "engine": "merkava_avds_engine",
     "unlock": ["modern_sam", "israeli_missiles", "tmd"], "days": 125, "training": 36, "archetype": "sam_battery"},
    {"id": "david_sling_battery", "name": "David's Sling Battery", "family": "israeli_sam_modern",
     "aa": "david_sling_interceptor", "chassis": "wheeled_mlrs_chassis", "engine": "merkava_avds_engine",
     "unlock": ["modern_sam", "israeli_missiles", "tmd"], "days": 110, "training": 34, "archetype": "sam_battery"},
    {"id": "s400_battery", "name": "S-400 Battery", "family": "russian_sam_modern",
     "aa": "s400_triumf", "chassis": "mlrs_launcher_chassis", "engine": "v46_6m_diesel",
     "unlock": ["modern_sam", "russian_missiles"], "days": 115, "training": 32, "archetype": "sam_battery"},
    {"id": "hq9_battery", "name": "HQ-9 Battery", "family": "chinese_sam_modern",
     "aa": "hq9_sam_battery", "chassis": "truck_rocket_mount", "engine": "ws10b_engine",
     "unlock": ["modern_sam", "chinese_missiles"], "days": 110, "training": 30, "archetype": "sam_battery"},
    {"id": "hawk_battery_1960", "name": "MIM-23 Hawk Battery", "family": "us_sam_cold_war",
     "aa": "mim23_hawk_sam", "chassis": "truck_rocket_mount", "engine": "liberty_l12_engine",
     "unlock": ["cold_war_sam", "us_missiles"], "days": 90, "training": 28, "archetype": "sam_battery"},
    # ICBM (fixed / semi-mobile)
    {"id": "minuteman_3_silo", "name": "Minuteman III Silo", "family": "us_icbm_modern",
     "weapon": "minuteman_3_icbm", "chassis": "mlrs_launcher_chassis", "engine": "redstone_engine",
     "unlock": ["strategic_missiles", "us_missiles", "icbm"], "days": 200, "training": 40, "archetype": "icbm_silo", "size": "Heavy"},
    {"id": "yars_icbm_tel", "name": "Yars TEL", "family": "russian_icbm_modern",
     "weapon": "rs24_yars_icbm", "chassis": "wheeled_mlrs_chassis", "engine": "v46_6m_diesel",
     "unlock": ["strategic_missiles", "russian_missiles", "icbm", "twenty_twenties_missiles"], "days": 210, "training": 38, "archetype": "icbm_launcher"},
    {"id": "df41_icbm_tel", "name": "DF-41 TEL", "family": "chinese_icbm_modern",
     "weapon": "df41_icbm", "chassis": "wheeled_mlrs_chassis", "engine": "ws10b_engine",
     "unlock": ["strategic_missiles", "chinese_missiles", "icbm", "twenty_twenties_missiles"], "days": 215, "training": 36, "archetype": "icbm_launcher"},
    {"id": "df31_icbm_tel", "name": "DF-31 TEL", "family": "chinese_icbm_modern",
     "weapon": "df31_icbm", "chassis": "wheeled_mlrs_chassis", "engine": "ws10b_engine",
     "unlock": ["strategic_missiles", "chinese_missiles", "icbm"], "days": 200, "training": 34, "archetype": "icbm_launcher"},
    {"id": "agni_v_tel", "name": "Agni-V TEL", "family": "indian_icbm_modern",
     "weapon": "agni_v_irbm", "chassis": "wheeled_mlrs_chassis", "engine": "mtu_mb873_engine",
     "unlock": ["strategic_missiles", "indian_missiles"], "days": 195, "training": 32, "archetype": "icbm_launcher"},
]


def launcher_tpl(spec: dict) -> dict:
    archetype = spec.get("archetype", "rocket_launcher")
    is_sam = archetype == "sam_battery"
    stats = spec.get("stats", {
        "speed": 26, "reliability": 72, "fuel_consumption": 10,
        "supply_need": 16, "armor": 12, "hardness": 35,
    })
    slots = {
        "Engine": {"max": 1},
        "Suspension": {"max": 1},
        "Cargo": {"max": 1},
        "Sensors": {"max": 1},
    }
    loadout = {"Engine": spec["engine"], "Suspension": spec["chassis"], "Sensors": "hunter_killer_fcs"}
    if is_sam:
        slots["AntiAir"] = {"max": 2}
        loadout["AntiAir"] = spec["aa"]
        loadout["Cargo"] = "mlrs_reload_trailer"
    else:
        slots["MainWeapon"] = {"max": 2}
        loadout["MainWeapon"] = spec["weapon"]
        if spec.get("extra_weapon"):
            loadout["SecondaryWeapon"] = spec["extra_weapon"]
            slots["SecondaryWeapon"] = {"max": 1}
        loadout["Cargo"] = "mlrs_reload_trailer"
    return {
        "id": spec["id"],
        "name": spec["name"],
        "design_family": spec["family"],
        "base_type": "Land",
        "size_category": spec.get("size", "Medium"),
        "visual_archetype": archetype,
        "crew_required": 4 if not is_sam else 6,
        "base_training_level": spec.get("training", 28),
        "max_experience_level": 100,
        "base_production_days": spec.get("days", 80),
        "base_stats": stats,
        "slots": slots,
        "module_loadout": loadout,
        "unlock_tech": spec["unlock"],
        "can_mount_drones": False,
        "is_vehicle": True,
    }


def main() -> None:
    MODULES_DIR.mkdir(parents=True, exist_ok=True)
    TEMPLATES_DIR.mkdir(parents=True, exist_ok=True)
    existing_m = {p.stem for p in MODULES_DIR.glob("*.json")}
    existing_t = {p.stem for p in TEMPLATES_DIR.glob("*.json")}
    mc = tc = 0
    for mod in MODULES:
        if mod["id"] in existing_m:
            continue
        with (MODULES_DIR / f"{mod['id']}.json").open("w", encoding="utf-8") as f:
            json.dump(mod, f, indent=2, ensure_ascii=False)
            f.write("\n")
        mc += 1
    for spec in LAUNCHER_TEMPLATES:
        tpl = launcher_tpl(spec)
        if tpl["id"] in existing_t:
            continue
        with (TEMPLATES_DIR / f"{tpl['id']}.json").open("w", encoding="utf-8") as f:
            json.dump(tpl, f, indent=2, ensure_ascii=False)
            f.write("\n")
        tc += 1
    mods = {p.stem for p in MODULES_DIR.glob("*.json")}
    errs = []
    for spec in LAUNCHER_TEMPLATES:
        tpl = launcher_tpl(spec)
        for slot, mid in tpl.get("module_loadout", {}).items():
            if mid and mid not in mods:
                errs.append(f"{tpl['id']}: {mid}")
    print(f"Missile/launcher: {mc} modules, {tc} templates. Missing refs: {len(errs)}")
    for e in errs:
        print(f"  ! {e}")


if __name__ == "__main__":
    main()
