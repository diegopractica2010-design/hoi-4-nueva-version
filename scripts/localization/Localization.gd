## Localization.gd
## Centralized localization API facade.
## 
## Single entry point for all localization needs. All systems use this API.
## Routes to LanguageManager and TranslationProvider.
##
## Public API:
##   get_text(key: String, params: Dictionary = {}) -> String
##   get_current_language() -> String
##   set_language(language_code: String) -> void
##   get_available_languages() -> Array[String]
##
## Signals:
##   language_changed(old_language: String, new_language: String)
##
## Usage:
##   var text = Localization.get_text("menu.main.save_game")
##   var msg = Localization.get_text("message.leader_retired", {"name": "John"})
##   Localization.set_language("es")
##   Localization.language_changed.connect(_on_language_changed)

class_name Localization
extends Node

signal language_changed(old_language: String, new_language: String)

func _ready() -> void:
	if typeof(LanguageManager) != TYPE_NIL:
		LanguageManager.language_changed.connect(_on_language_changed)

func get_text(key: String, params: Dictionary = {}) -> String:
	if typeof(TranslationProvider) == TYPE_NIL:
		return key
	return TranslationProvider.get_text(key, params)

func get_current_language() -> String:
	if typeof(LanguageManager) == TYPE_NIL:
		return "en"
	return LanguageManager.get_current_language()

func set_language(language_code: String) -> void:
	if typeof(LanguageManager) == TYPE_NIL:
		return
	LanguageManager.set_language(language_code)

func get_available_languages() -> Array[String]:
	if typeof(LanguageManager) == TYPE_NIL:
		return ["en"]
	return LanguageManager.get_available_languages()

func get_language_display_name(language_code: String) -> String:
	if typeof(LanguageManager) == TYPE_NIL:
		return language_code.to_upper()
	return LanguageManager.get_language_display_name(language_code)

func _on_language_changed(old_lang: String, new_lang: String) -> void:
	language_changed.emit(old_lang, new_lang)
