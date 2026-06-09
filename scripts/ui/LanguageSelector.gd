## LanguageSelector.gd
## UI control for selecting the active game language at runtime.
##
## Responsibilities:
## - Populate an OptionButton with all available languages
## - Switch language immediately when the user picks an option
## - Reflect the current language as the selected item
## - Stay in sync if the language changes elsewhere
##
## Routing:
## - Reads/writes language through the Localization facade
## - Falls back to LanguageManager if Localization is not present
##
## Usage:
##   Drop LanguageSelector.tscn into any settings/menu screen.
##   No extra wiring required; it self-populates on _ready().

class_name LanguageSelector
extends OptionButton

func _ready() -> void:
	_populate_languages()
	_select_current_language()
	item_selected.connect(_on_item_selected)
	_connect_language_changed()

func _populate_languages() -> void:
	clear()
	for language_code in _get_available_languages():
		var display_name = _get_display_name(language_code)
		add_item(display_name)
		set_item_metadata(get_item_count() - 1, language_code)

func _select_current_language() -> void:
	var current = _get_current_language()
	for index in range(get_item_count()):
		if get_item_metadata(index) == current:
			select(index)
			return

func _on_item_selected(index: int) -> void:
	var language_code = get_item_metadata(index)
	if language_code == null:
		return
	_set_language(str(language_code))

func _on_language_changed(_old_language: String, _new_language: String) -> void:
	_select_current_language()

func _connect_language_changed() -> void:
	if typeof(Localization) != TYPE_NIL:
		Localization.language_changed.connect(_on_language_changed)
	elif typeof(LanguageManager) != TYPE_NIL:
		LanguageManager.language_changed.connect(_on_language_changed)

# --- Routing helpers (Localization facade with LanguageManager fallback) ---

func _get_available_languages() -> Array[String]:
	if typeof(Localization) != TYPE_NIL:
		return Localization.get_available_languages()
	if typeof(LanguageManager) != TYPE_NIL:
		return LanguageManager.get_available_languages()
	return ["en"]

func _get_current_language() -> String:
	if typeof(Localization) != TYPE_NIL:
		return Localization.get_current_language()
	if typeof(LanguageManager) != TYPE_NIL:
		return LanguageManager.get_current_language()
	return "en"

func _get_display_name(language_code: String) -> String:
	if typeof(Localization) != TYPE_NIL:
		return Localization.get_language_display_name(language_code)
	if typeof(LanguageManager) != TYPE_NIL:
		return LanguageManager.get_language_display_name(language_code)
	return language_code.to_upper()

func _set_language(language_code: String) -> void:
	if typeof(Localization) != TYPE_NIL:
		Localization.set_language(language_code)
	elif typeof(LanguageManager) != TYPE_NIL:
		LanguageManager.set_language(language_code)
