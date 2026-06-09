## LanguageManager.gd
## Manages current language, language switching, and persistence.
## 
## Responsibilities:
## - Track current language (English, Spanish, extensible)
## - Emit signal when language changes
## - Persist language choice to disk via LocalizationSettings
## - Provide fallback language (English)
## - Support runtime language switching without restart
##
## Public API:
##   get_current_language() -> String          # "en", "es"
##   set_language(lang: String) -> void         # Switch language
##   get_available_languages() -> Array[String] # ["en", "es"]
##   get_language_display_name(lang: String) -> String
##
## Signals:
##   language_changed(old_lang: String, new_lang: String)
##
## Usage:
##   LanguageManager.set_language("es")
##   LanguageManager.language_changed.connect(_on_language_changed)

# NOTA: Sin class_name a propósito. Se registra como autoload llamado
# "LanguageManager"; un class_name con el mismo nombre causaría conflicto en Godot 4.
extends Node

const AVAILABLE_LANGUAGES = ["en", "es"]
const FALLBACK_LANGUAGE = "en"

var _current_language: String = FALLBACK_LANGUAGE

signal language_changed(old_language: String, new_language: String)

func _ready() -> void:
	_load_saved_language()
	if _current_language not in AVAILABLE_LANGUAGES:
		_current_language = FALLBACK_LANGUAGE

func get_current_language() -> String:
	return _current_language

func set_language(language_code: String) -> void:
	if language_code not in AVAILABLE_LANGUAGES:
		push_warning("Language '%s' not available. Available: %s" % [language_code, AVAILABLE_LANGUAGES])
		return
	
	if language_code == _current_language:
		return
	
	var old_lang = _current_language
	_current_language = language_code
	_save_language_preference()
	language_changed.emit(old_lang, _current_language)

func get_available_languages() -> Array[String]:
	return AVAILABLE_LANGUAGES.duplicate()

func get_language_display_name(language_code: String) -> String:
	match language_code:
		"en":
			return "English"
		"es":
			return "Español"
		_:
			return language_code.to_upper()

func get_fallback_language() -> String:
	return FALLBACK_LANGUAGE

func _load_saved_language() -> void:
	if typeof(LocalizationSettings) == TYPE_NIL:
		_current_language = FALLBACK_LANGUAGE
		return
	
	var saved_lang = LocalizationSettings.load_language_preference()
	if saved_lang and saved_lang in AVAILABLE_LANGUAGES:
		_current_language = saved_lang
	else:
		_current_language = FALLBACK_LANGUAGE

func _save_language_preference() -> void:
	if typeof(LocalizationSettings) == TYPE_NIL:
		return
	LocalizationSettings.save_language_preference(_current_language)
