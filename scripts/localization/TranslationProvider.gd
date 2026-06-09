## TranslationProvider.gd
## Loads and resolves translations with fallback support.
##
## Responsibilities:
## - Load translation files (JSON) for each language
## - Resolve translation keys with parameter substitution
## - Fallback to English if key missing in target language
## - Detect and report missing translations
## - Support format placeholders: {param_name}
##
## Public API:
##   get_text(key: String, params: Dictionary = {}) -> String
##   reload_language(language_code: String) -> void
##   get_missing_keys() -> Array[String]
##
## Implementation:
## - Translation files: data/localization/{lang_code}.json
## - Format: { "section.key": "Translated text" }
## - Parameters: {key_name} replaced with params["key_name"]
##
## Usage:
##   var text = TranslationProvider.get_text("menu.main.save_game")
##   var msg = TranslationProvider.get_text("message.leader_retired", {"name": leader_name})

class_name TranslationProvider
extends Node

var _translations: Dictionary = {}
var _fallback_translations: Dictionary = {}
var _missing_keys: Array[String] = []
var _current_language: String = "en"

func _ready() -> void:
	_load_all_languages()
	if typeof(LanguageManager) != TYPE_NIL:
		LanguageManager.language_changed.connect(_on_language_changed)
		_current_language = LanguageManager.get_current_language()

func get_text(key: String, params: Dictionary = {}) -> String:
	var text = _get_translation(key, _translations)
	
	if text.is_empty():
		text = _get_translation(key, _fallback_translations)
		if text.is_empty():
			_register_missing_key(key)
			return key
	
	return _interpolate_parameters(text, params)

func reload_language(language_code: String) -> void:
	_current_language = language_code
	_load_language(language_code)

func get_missing_keys() -> Array[String]:
	return _missing_keys.duplicate()

func _load_all_languages() -> void:
	_fallback_translations = _load_language_file("en")
	if typeof(LanguageManager) != TYPE_NIL:
		var current = LanguageManager.get_current_language()
		if current != "en":
			_translations = _load_language_file(current)
		else:
			_translations = _fallback_translations.duplicate()
	else:
		_translations = _fallback_translations.duplicate()

func _load_language(language_code: String) -> void:
	var translations = _load_language_file(language_code)
	if translations.is_empty():
		push_warning("Failed to load language: %s" % language_code)
		_translations = _fallback_translations.duplicate()
	else:
		_translations = translations

func _load_language_file(language_code: String) -> Dictionary:
	var file_path = "res://data/localization/%s.json" % language_code
	
	if not ResourceLoader.exists(file_path):
		push_warning("Translation file not found: %s" % file_path)
		return {}
	
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		push_error("Cannot open translation file: %s" % file_path)
		return {}
	
	var json = JSON.parse_string(file.get_as_text())
	if json == null or not json is Dictionary:
		push_error("Invalid JSON in translation file: %s" % file_path)
		return {}
	
	return json

func _get_translation(key: String, source: Dictionary) -> String:
	if key in source:
		return str(source[key])
	return ""

func _interpolate_parameters(text: String, params: Dictionary) -> String:
	var result = text
	for param_name in params.keys():
		var placeholder = "{%s}" % param_name
		result = result.replace(placeholder, str(params[param_name]))
	return result

func _register_missing_key(key: String) -> void:
	if key not in _missing_keys:
		_missing_keys.append(key)

func _on_language_changed(old_lang: String, new_lang: String) -> void:
	_current_language = new_lang
	reload_language(new_lang)
