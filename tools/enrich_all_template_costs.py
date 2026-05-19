#!/usr/bin/env python3
"""Recompute and embed production_cost on all unit template JSON files."""

from __future__ import annotations

import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(Path(__file__).resolve().parent))

from production_cost_utils import enrich_template, load_production_rules

TEMPLATES_DIR = ROOT / "data" / "unit_templates"


def main() -> None:
    rules = load_production_rules()
    updated = 0
    for path in sorted(TEMPLATES_DIR.glob("*.json")):
        with path.open("r", encoding="utf-8") as f:
            tpl = json.load(f)
        enriched = enrich_template(tpl, rules)
        with path.open("w", encoding="utf-8") as f:
            json.dump(enriched, f, indent=2, ensure_ascii=False)
            f.write("\n")
        updated += 1
    print(f"Enriched production_cost on {updated} templates in {TEMPLATES_DIR}")


if __name__ == "__main__":
    main()
