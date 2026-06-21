# Diplomacy Report — Phase 6

## Summary

Added full diplomacy system: DiplomaticManager (autoload) + DiplomacyScreen UI + comprehensive tests.

## Files Created

| File | Purpose |
|------|---------|
| `scripts/diplomacy/DiplomacyManager.gd` | Autoload: war/peace/alliance/guarantee/relation management |
| `scripts/ui/DiplomacyScreen.gd` | UI: nation list, relation view, action buttons |
| `scenes/ui/DiplomacyScreen.tscn` | Scene with ItemList + 4 action buttons |
| `tests/DiplomacyTest.gd` | 5 test groups, ~25 checks |
| `DIPLOMACY_REPORT.md` | This report |

## DiplomacyManager API

| Method | Description |
|--------|-------------|
| `set_relation(a, b, value)` | Set bilateral relation (-200 to 200), clamped |
| `get_relation(a, b)` | Get current relation value |
| `modify_relation(a, b, delta)` | Modify relation by delta |
| `declare_war(a, d)` | Start war, breaks existing alliance |
| `sign_peace(a, d, winner)` | End war, declare winner |
| `is_at_war(a, b)` | Check war status (bidirectional) |
| `get_wars_for(tag)` | List active wars for a country |
| `form_alliance(a, b)` | Create alliance, +20 relation |
| `break_alliance(a, b)` | Break alliance, -30 relation |
| `has_alliance(a, b)` | Check alliance (bidirectional) |
| `give_guarantee(g, p)` | Add guarantee, +10 relation |
| `revoke_guarantee(g, p)` | Remove guarantee, -15 relation |
| `has_guarantee(g, p)` | Check guarantee exists |
| `get_guarantees_for(tag)` | List guarantees for a country |
| `get_allies(tag)` | List allied tags for a country |
| `get_status_between(a, b)` | Returns: self/war/allied/guaranteed/neutral |

## Signals

- `relation_changed(from_tag, to_tag, old_value, new_value)`
- `war_declared(attacker, defender)`
- `peace_signed(attacker, defender, winner)`
- `alliance_formed(tag_a, tag_b)`
- `alliance_broken(tag_a, tag_b)`
- `guarantee_given(guarantor, protected)`
- `guarantee_revoked(guarantor, protected)`

## Tests

| Group | Checks | What It Validates |
|-------|:------:|-------------------|
| Relations | 5 | Set/modify/get, bidirectional, range clamp |
| War/Peace | 7 | Declare, bidirectional check, peace, re-declaration |
| Alliances | 8 | Form, bidirectional check, duplicate prevention, war breaks alliance |
| Guarantees | 5 | Give, check, duplicate prevention, revoke, confirm removal |
| Status API | 5 | Neutral, allied, war, self status strings |

## Configuration

- **Relations range:** -200 to 200
- **Alliance auto-relation:** +20 on form, -30 on break
- **Guarantee auto-relation:** +10 on give, -15 on revoke
- **War breaks alliances** automatically on declaration
- **Duplicate prevention** for alliances and guarantees
- **Bidirectional key** ensures consistent lookup regardless of argument order

## Coverage Impact

| System | Tests |
|--------|:-----:|
| Diplomacy | ~25 unit tests |

✅ **Diplomacy foundation complete** — DiplomacyManager autoload, DiplomacyScreen, and comprehensive tests.
