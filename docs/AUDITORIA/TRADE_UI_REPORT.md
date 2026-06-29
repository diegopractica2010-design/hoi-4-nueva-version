# Trade UI Report — Phase 8

## Summary

Created TradeScreen exposing existing TradeManager backend through a UI with offer list, detail view, accept/reject actions, and a resource trade creation form.

## Files Created/Modified

| File | Change |
|------|--------|
| `scripts/ui/TradeScreen.gd` | Created — UI for viewing/accepting/rejecting/creating trade offers |
| `scenes/ui/TradeScreen.tscn` | Created — scene with ItemList, RichTextLabel, buttons, create panel |
| `tests/TradeTest.gd` | Created — 3 test groups, ~12 checks |
| `scripts/core/HeadlessTestRunner.gd` | Modified — added TradeTest |
| `tests/UITest.gd` | Modified — added TradeScreen to loading tests |

## TradeScreen Features

### Offer List
- Shows all active (PROPOSED) offers for the current nation
- Each entry shows: from → to, offered/requested counts, visibility
- Selection shows full offer detail in RichTextLabel:
  - Offer ID, from/to tags, status, visibility
  - Full offered items list
  - Full requested items list
  - Fairness evaluation score (via `TradeManager.evaluate_fairness()`)

### Actions
- **Accept** — calls `TradeManager.accept_offer()` (executes transfers)
- **Reject** — calls `TradeManager.reject_offer()`
- **Refresh** — re-queries offers

### Create Offer
- Toggle panel via "Crear Oferta" button
- Nation target selector (populated from `GameData.world.tags`)
- Resource type: Steel, Rubber, Oil, Aluminum, Fuel
- Quantity via SpinBox (100–10000, step 100)
- Creates PUBLIC resource-for-resource trade offer

### Signals
- `trade_screen_closed` — emitted when screen closes

## Tests

| Group | Checks | What It Validates |
|-------|:------:|-------------------|
| Screen Loading | 4 | Script loads, scene loads, methods/signal exist |
| Offer Formatting | 4 | Sample offer structure validation |
| Create Offer | 3 | TradeManager offer creation, query, fairness evaluation (if available) |

## Coverage Impact

| System | Tests |
|--------|:-----:|
| Trade UI | ~12 unit tests |
| UI screens tested | 14 → 16 (+DiplomacyScreen +TradeScreen) |

✅ **Trade UI complete** — TradeScreen exposes TradeManager backend with offer list, details, accept/reject, and resource trade creation.
