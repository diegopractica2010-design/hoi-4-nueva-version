# DATA AUDIT — Phase 0

## Overview
- **Total data files:** 3,679
- **Format:** Primarily JSON
- **Root:** `data/` with 21 subdirectories

## Data Directories
| Directory | Purpose |
|-----------|---------|
| agents/ | Agent definitions, traits |
| ai/ | AI strategy files |
| combat/ | Combat modifiers, terrain tables |
| countries/ | Country definitions |
| diplomacy/ | Diplomatic actions, relations |
| economy/ | Economic modifiers, trade goods |
| events/ | Event chains |
| formations/ | Unit formation templates |
| gameplay/ | Game rules, defines |
| leaders/ | Leader rosters (1879, 1918, 1936, 2026) |
| localization/ | Localization JSON (en.json, es.json) |
| modules/ | Equipment module definitions |
| national/ | National focuses, spirits |
| naval/ | Naval unit definitions |
| production/ | Production lines, costs |
| provinces/ | Province base data, geometry |
| reference/ | Reference tables |
| scenarios/ | Scenario definitions (1879 primary) |
| supply/ | Supply rules, consumption |
| technology/ | Technology tree |
| unit_templates/ | Unit design templates |

## Known Issues
1. **1879 scenario.json** — Only 17 of 847 provinces have overrides; GER/FRA/ENG/USA owners are scaffolding placeholders (documented via _audit_note)
2. **legacy_hoi2/** — 549 HOI2 AI files (549 files, deleted from disk and git tracking per FIX #18)
3. **Multiple scenario years** (1918, 1936, 2026) exist but only 1879 is playable (per ARCHITECTURE.md policy)
4. **Localization JSON** — 43 keys each in en.json/es.json; SettingsPopup.gd still has hardcoded "Ajustes" string

## Data Integrity Checks Needed
- Province ownership validation for all 847 provinces
- Leader roster completeness for 1879
- Country tag consistency across all data files
- Resource distribution validation for 1879 borders
