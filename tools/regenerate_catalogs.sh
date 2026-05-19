#!/usr/bin/env bash
# Regenerate module/template JSON from all tools/generate_*.py scripts (additive; most skip existing).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

echo "=== Regenerating equipment & unit data ==="
for script in tools/generate_*.py; do
	echo "==> ${script}"
	python3 "${script}"
done

module_count="$(find data/modules -maxdepth 1 -name '*.json' | wc -l)"
template_count="$(find data/unit_templates -maxdepth 1 -name '*.json' | wc -l)"
echo "=== Done: ${module_count} modules, ${template_count} unit templates ==="
