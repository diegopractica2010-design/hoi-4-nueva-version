"""Write unit template JSON with embedded production cost fields.

All template generators should use write_unit_template() so new designs are
born with production_cost, production_category, era, and modules populated.

Equivalent inline pattern (if not using this helper):

    from production_cost_utils import calculate_production_cost, enrich_template

    template = enrich_template(template)  # category, era, modules
    template["production_cost"] = calculate_production_cost(template)
    # then json.dump(template, ...)
"""

from __future__ import annotations

import json
from pathlib import Path

from production_cost_utils import calculate_production_cost, enrich_template


def prepare_unit_template(template: dict) -> dict:
    """Add production_category, era, modules, and production_cost to a template dict."""
    tpl = enrich_template(template)
    # Explicit final pass (enrich_template already sets this; kept for clarity).
    tpl["production_cost"] = calculate_production_cost(tpl)
    return tpl


def write_unit_template(path: Path, template: dict) -> None:
    enriched = prepare_unit_template(template)
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as f:
        json.dump(enriched, f, indent=2, ensure_ascii=False)
        f.write("\n")
