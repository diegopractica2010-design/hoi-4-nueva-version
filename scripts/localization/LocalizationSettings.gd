## LocalizationSettings.gd
## Saves and loads user language preference to persistent storage.
##
## Responsibilities:
## - Save language preference to disk (user://localization.cfg)
## - Load language preference on startup
## - Handle missing or corrupted preference files gracefully
## - Use ConfigFile for safe, human-readable storage
##
## Public API:
##   save_language_preference(language_code: String) -> void
##   load_language_preference() -> String  # Returns language code or empty string
##
## Storage:
## - File: user://localization.cfg
## - Section: [preferences]
## - Key: language = "en" | "es"
##
## Usage:
##   LocalizationSettings.save_language_preference("es")
##   var lang = LocalizationSettings.load_language_preference()

# NOTA: Sin class_name a propósito. Se registra como autoload llamado
# "LocalizationSettings"; un class_name homónimo causaría conflicto en Godot 4.
extends Node

const SETTINGS_FILE = "user://localization.cfg"
const SETTINGS_SECTION = "preferences"
const LANGUAGE_KEY = "language"

func save_language_preference(language_code: String) -> void:
	var config = ConfigFile.new()
	
	if FileAccess.file_exists(SETTINGS_FILE):
		var load_error = config.load(SETTINGS_FILE)
		if load_error != OK:
			push_warning("Could not load existing localization settings, creating new file")
			config = ConfigFile.new()
	
	config.set_value(SETTINGS_SECTION, LANGUAGE_KEY, language_code)
	
	var save_error = config.save(SETTINGS_FILE)
	if save_error != OK:
		push_error("Failed to save localization settings: %s" % error_string(save_error))
		return
	
	print("Language preference saved: %s" % language_code)

func load_language_preference() -> String:
	var config = ConfigFile.new()
	
	if not FileAccess.file_exists(SETTINGS_FILE):
		return ""
	
	var load_error = config.load(SETTINGS_FILE)
	if load_error != OK:
		push_warning("Could not load localization settings: %s" % error_string(load_error))
		return ""
	
	var language = config.get_value(SETTINGS_SECTION, LANGUAGE_KEY, "")
	return str(language)
