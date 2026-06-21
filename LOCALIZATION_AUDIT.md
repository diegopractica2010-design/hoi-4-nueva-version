# LOCALIZATION AUDIT — Phase 0

## System Architecture
- **4 autoload singletons:** Localization, LocalizationSettings, LanguageManager, TranslationProvider
- **2 JSON files:** `data/localization/en.json`, `data/localization/es.json`
- **API:** `Localization.get_text(key: String, params: Dictionary = {})`

## Key Coverage (en.json / es.json)
Found 43 keys total, covering:
- `language.name.*` — Language display names
- `menu.main.*` — Main menu (new_game, load_game, save_game, settings, quit, continue, credits)
- `menu.settings.*` — Settings screen (title, language, audio, graphics, back, apply)
- `common.*` — Common UI (yes, no, ok, cancel, confirm, close, loading, error)
- `hud.*` — HUD labels (date, pause, speed, political_power, manpower, factories)
- `tooltip.province.*` — Province tooltips (population, owner, factory output)
- `message.*` — Game messages (leader_retired, game_saved, game_loaded, trade_completed)

## Applied in code (per FIX #13)
- StartMenu.gd — All buttons use Localization.get_text()
- MainMenu.gd — All menu options use Localization.get_text()
- TopInfoBar.gd — Fallback menu uses Localization.get_text()

## Remaining Hardcoded Strings
- SettingsPopup.gd:39 — `title.text = "Ajustes"` (not in scope of FIX #13)

## Missing Keys (gaps detected)
- No key for `"Volver al menú principal"` (currently mapped to `menu.main.quit`)
- No key for `"Guardar como..."` (currently mapped to `menu.main.save_game`)
- No key for `"Ayuda / Acerca de"`
- No key for Settings popup title
- No province info panel labels localized
- No battle/military UI strings localized
