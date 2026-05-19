"""Write unit template JSON with embedded production cost fields."""

from __future__ import annotations

import json
from pathlib import Path

from production_cost_utils import enrich_template


def prepare_unit_template(template: dict) -> dict:
    return enrich_template(template)


def write_unit_template(path: Path, template: dict) -> None:
    enriched = enrich_template(template)
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as f:
        json.dump(enriched, f, indent=2, ensure_ascii=False)
        f.write("\n")
