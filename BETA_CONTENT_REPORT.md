# Beta Content Report — Phase 12

## Summary

Added 20 historical events for the War of the Pacific (1879–1885) and improved EventManager to support multi-event JSON arrays.

## Files Created/Modified

| File | Change |
|------|--------|
| `data/events/1879/historical_1879.json` | Created — 20 rich historical events |
| `scripts/events/EventManager.gd` | Modified — supports JSON arrays (batched event files) |

## Historical Events Added

| Event | Date | Description |
|-------|:----:|-------------|
| Campaña de Tarapacá | 1879-11-01 | Chilean landing in Tarapacá, war support changes |
| Alianza Peruano-Boliviana | relation-based | Formal defensive alliance between Peru and Bolivia |
| Combate Naval de Angamos | 1879-10-08 | Capture of Huáscar, naval supremacy shift |
| Mediación Argentina | 1880-03-01 | Argentine peace mediation offer |
| Ocupación del Sur Peruano | 1880-05-01 | Chilean advance into southern Peru |
| Resistencia en la Sierra | 1880-07-01 | Cáceres organizes Andean guerrilla resistance |
| Mediación Estadounidense | 1881-01-01 | US diplomatic pressure for peace |
| Tratado de Ancón | 1883-10-20 | Peace treaty Chile-Peru, territorial cession |
| Armisticio Boliviano | 1884-04-04 | Bolivia ceasefire, loss of coastline |
| Boom del Salitre | 1880-06-01 | Nitrate economic boom in captured territories |
| Declive del Guano | 1880-01-01 | Peruvian guano revenue decline |
| Reforma Militar Chilena | 1881-03-01 | Prussian-model army reorganization |
| Tratado de Límites 1881 | 1881-07-23 | Chile-Argentina border treaty |
| Colapso del Estado Peruano | 1881-06-01 | State collapse with Lima occupied |
| Garantía Europea | 1882-01-01 | Franco-British diplomatic intervention |
| Excesos en la Guerra del Desierto | 1879-12-01 | Atrocity reports affect international relations |
| Defensa de Lima | 1880-12-01 | Trenches at San Juan and Miraflores |
| Cuestión Social del Salitre | 1883-01-01 | Nitrate worker organization, social tensions |
| Dictadura de Piérola | 1880-01-01 | Authoritarian war leadership, political division |
| Consolidación Nacional Chilena | 1885-01-01 | Post-war infrastructure boom and modernization |

## Event Features

- **Date triggers**: auto-fire on or after specific dates
- **Relation triggers**: activates based on diplomatic relations between countries
- **Conditional events**: only fire if war conditions are met (`war_exists`, `peace`, province `owner`)
- **Probability system**: each event has 20–80% chance to fire (historical variation)
- **Multiple effect types**:
  - `modifier`: temporary national modifiers (war_support, naval_supremacy, etc.)
  - `diplomacy`: automatic alliance formation
  - `peace`: forced peace settlement with declared winner
- **Non-repeatable**: historical events fire only once

## Technical Improvements

- EventManager `_load_event_file()` now supports both:
  - Single Dictionary per file (backward compatible)
  - Array of Dictionaries (batch event files)
- Events directory: `res://data/events/1879/`

✅ **Beta content complete** — 20 historical War of the Pacific events with conditional triggers, probability, and multi-type effects.
