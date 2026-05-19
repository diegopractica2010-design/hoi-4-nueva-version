"""Shared production point cost calculation for template generators."""

from __future__ import annotations

import json
from pathlib import Path

RULES_PATH = Path(__file__).resolve().parents[1] / "data" / "production" / "production_cost_rules.json"

_DEFAULT_RULES: dict | None = None


def load_production_rules() -> dict:
    global _DEFAULT_RULES
    if _DEFAULT_RULES is not None:
        return _DEFAULT_RULES
    if RULES_PATH.exists():
        with RULES_PATH.open("r", encoding="utf-8") as f:
            _DEFAULT_RULES = json.load(f)
    else:
        _DEFAULT_RULES = {}
    return _DEFAULT_RULES


def extract_modules(template: dict) -> list[str]:
    if "modules" in template and isinstance(template["modules"], list):
        out: list[str] = []
        for mod in template["modules"]:
            if isinstance(mod, str) and mod:
                out.append(mod)
            elif isinstance(mod, dict):
                mid = str(mod.get("module_id", mod.get("id", "")))
                if mid:
                    out.append(mid)
        if out:
            return out

    loadout = template.get("module_loadout", {})
    if isinstance(loadout, dict):
        return [str(v) for v in loadout.values() if v]
    return []


def infer_category(template: dict) -> str:
    cat = template.get("production_category") or template.get("category", "")
    if cat:
        return _normalize_category(str(cat))

    tid = str(template.get("id", "")).lower()
    arch = str(template.get("visual_archetype", "")).lower()
    size = str(template.get("size_category", "")).lower()
    bt = str(template.get("base_type", "")).lower()
    name = str(template.get("name", "")).lower()

    if any(k in tid for k in ("icbm", "rocket", "missile", "ballistic")):
        return "rocket"
    if bt == "submarine" or "submarine" in arch or "ssn" in tid or "ssbn" in tid:
        return "submarine"
    if "carrier" in tid or "carrier" in name or "lhd" in tid or "cvb" in tid:
        return "carrier"
    if "battleship" in tid or "battleship" in name or tid.endswith("_bb") or "_bb" in tid:
        return "battleship"
    if "cruiser" in tid or "cruiser" in name or "_ca" in tid:
        return "cruiser"
    if bt == "naval":
        return "destroyer"
    if bt == "air":
        if "bomber" in tid or "bomber" in arch or "strategic" in name:
            return "bomber"
        return "fighter"
    if bt == "armored":
        if size == "heavy" or "heavy" in tid:
            return "heavy_tank"
        if size == "light" or "light_tank" in arch:
            return "light_tank"
        return "medium_tank"
    if bt == "land":
        if any(k in tid for k in ("truck", "transport", "cargo")):
            return "light_tank"
        if any(k in tid for k in ("infantry", "rifle")):
            return "infantry_equipment"
        if "mbt" in tid or "tank" in tid:
            return "medium_tank"
        return "light_tank"
    if "space" in bt or "orbital" in tid:
        return "space"
    return "medium_tank"


def infer_era(template: dict) -> str:
    era = template.get("era") or template.get("production_era", "")
    if era:
        return str(era)

    base_stats = template.get("base_stats", {})
    if isinstance(base_stats, dict):
        era_override = base_stats.get("production_era", "")
        if era_override:
            return str(era_override)

    tid = str(template.get("id", "")).lower()
    family = str(template.get("design_family", "")).lower()

    if any(k in tid for k in ("2030", "2040")) or "space" in family or "orbital" in tid:
        return "future"
    if any(k in tid for k in ("2026", "2020", "2010", "2000")):
        return "modern"
    if any(k in tid for k in ("1990", "1980", "1970")) or "sixties" in family:
        return "late_cold_war"
    if "1960" in tid or "1950" in tid or "cold_war" in family:
        return "early_cold_war"
    if any(k in tid for k in ("1945", "1944", "1943", "1942", "1940")):
        return "ww2"
    if "1936" in tid or "1939" in tid or "interwar" in family:
        return "interwar"
    if "1918" in tid or "ww1" in family or "great_war" in family:
        return "ww1"
    if "ww2" in family or "world_war_2" in family or "naval_ww2" in family:
        return "ww2"
    if "cold_war" in family:
        return "early_cold_war"
    if "2026" in family or "2030" in family or "modern" in family:
        return "modern"
    if "space" in family:
        return "future"

    days = float(template.get("base_production_days", template.get("production_days", 60)))
    if days >= 280:
        return "modern"
    if days >= 200:
        return "late_cold_war"
    if days >= 140:
        return "early_cold_war"
    if days >= 90:
        return "ww2"
    if days >= 55:
        return "interwar"
    return "ww1"


def infer_module_cost_key(module_id: str, category: str = "") -> str:
    mid = module_id.lower()
    cat = category.lower()

    if "stealth" in mid or "low_observable" in mid:
        return "stealth_coating"
    if any(k in mid for k in ("missile", "sam", "aam", "torpedo", "icbm")):
        return "missile_system"
    if any(k in mid for k in ("radar", "sonar", "asw")):
        return "radar"
    if any(k in mid for k in ("fire_control", "fcs", "director")):
        return "fire_control"
    if any(k in mid for k in ("computer", "electronics", "ew", "ecm")):
        return "advanced_electronics"
    if any(k in mid for k in ("engine", "turbine", "propulsion")):
        return "engine"
    if any(k in mid for k in ("armor", "belt", "plate")):
        return "armor_plate"
    if any(k in mid for k in ("gun", "cannon", "howitzer", "rifle")):
        return "gun"

    if "weapon" in cat or cat in ("mainweapon", "secondaryweapon"):
        return "gun"
    if "engine" in cat:
        return "engine"
    if "armor" in cat:
        return "armor_plate"
    if "sensor" in cat or "fire" in cat:
        return "fire_control"
    if "electronic" in cat:
        return "advanced_electronics"
    return "default"


def module_production_cost(module_id: str, rules: dict, tier: int = 1) -> float:
    module_costs = rules.get("module_costs", {})
    tier_rules = rules.get("module_tier_scaling", {})
    per_tier = float(tier_rules.get("per_tier_bonus", 0.12))
    key = infer_module_cost_key(module_id)
    base = float(module_costs.get(key, module_costs.get("default", 6.0)))
    tier_mult = 1.0 + max(tier - 1, 0) * per_tier
    return base * tier_mult


def calculate_complexity_penalty(module_count: int, rules: dict) -> float:
    penalty_rule = rules.get("complexity_penalty", {})
    free_modules = int(penalty_rule.get("free_modules", 4))
    per_extra = float(
        penalty_rule.get(
            "per_module_after_4",
            penalty_rule.get("per_module_after", 0.08),
        )
    )
    extra = max(0, module_count - free_modules)
    return extra * per_extra


def calculate_production_cost(template: dict, rules: dict | None = None) -> float:
    if rules is None:
        rules = load_production_rules()

    if float(template.get("production_cost", 0) or 0) > 0 and template.get("_cost_locked"):
        return float(template["production_cost"])

    category = infer_category(template)
    era = infer_era(template)
    modules = extract_modules(template)
    complexity = float(template.get("production_complexity", template.get("complexity", 1.0)))

    base_costs = rules.get("base_costs", {})
    era_mults = rules.get("era_multipliers", {})

    base = float(base_costs.get(category, base_costs.get("default", 100.0)))
    era_mult = float(era_mults.get(era, 1.0))

    module_total = sum(module_production_cost(mid, rules) for mid in modules)
    penalty = calculate_complexity_penalty(len(modules), rules)

    final_cost = (base + module_total) * era_mult * (1.0 + penalty) * max(complexity, 0.1)
    return round(final_cost, 1)


def enrich_template(template: dict, rules: dict | None = None) -> dict:
    """Return template dict with production_category, era, modules, production_cost."""
    if rules is None:
        rules = load_production_rules()

    # Strip cached derived fields so inference always runs fresh.
    tpl = {k: v for k, v in template.items() if k not in ("production_category", "era", "modules", "production_cost")}
    tpl["production_category"] = infer_category(tpl)
    tpl["era"] = infer_era(tpl)
    tpl["modules"] = extract_modules(tpl)
    tpl["production_cost"] = calculate_production_cost(tpl, rules)
    return tpl


def _normalize_category(category: str) -> str:
    cat = category.lower()
    if cat in ("light_vehicle", "vehicle"):
        return "light_tank"
    return cat
