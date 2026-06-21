extends Node
class_name LocalizationTest

static func run_all() -> bool:
	var ok = true
	ok = _test_localization_available() and ok
	ok = _test_default_language() and ok
	ok = _test_get_text_resolves() and ok
	ok = _test_language_switch() and ok
	ok = _test_available_languages() and ok
	return ok

static func _test_localization_available() -> bool:
	if typeof(Localization) == TYPE_NIL:
		print("  [FAIL] Localization facade not available")
		return false
	if typeof(LanguageManager) == TYPE_NIL:
		print("  [FAIL] LanguageManager not available")
		return false
	if typeof(TranslationProvider) == TYPE_NIL:
		print("  [FAIL] TranslationProvider not available")
		return false
	print("  [PASS] Localization, LanguageManager, TranslationProvider all loaded")
	return true

static func _test_default_language() -> bool:
	var lang = Localization.get_current_language()
	if lang.is_empty():
		print("  [FAIL] current language is empty")
		return false
	if lang != "en":
		print("  [WARN] default language is '%s' (expected 'en')" % lang)
	else:
		print("  [PASS] default language: %s" % lang)
	return true

static func _test_get_text_resolves() -> bool:
	var key = "menu.main.save_game"
	var result = Localization.get_text(key)
	if result.is_empty():
		print("  [FAIL] get_text('%s') returned empty" % key)
		return false
	if result == key:
		print("  [WARN] get_text('%s') returned raw key (untranslated)" % key)
		return true
	print("  [PASS] get_text('%s') = '%s'" % [key, result])
	return true

static func _test_language_switch() -> bool:
	var before = Localization.get_current_language()
	Localization.set_language("es")
	var after = Localization.get_current_language()
	if after != "es":
		print("  [FAIL] set_language('es') failed, current=%s" % after)
		return false
	var es_text = Localization.get_text("menu.main.save_game")
	Localization.set_language("en")
	var restored = Localization.get_current_language()
	if es_text == "save_game":
		print("  [WARN] Spanish translation same as key")
	else:
		print("  [PASS] Spanish text: '%s'" % es_text)
	if restored != "en":
		print("  [FAIL] restore language failed: %s" % restored)
		return false
	print("  [PASS] language switch en->es->en OK")
	return true

static func _test_available_languages() -> bool:
	var langs = Localization.get_available_languages()
	if langs.is_empty():
		print("  [FAIL] no available languages")
		return false
	if langs.size() < 2:
		print("  [WARN] only %d language(s): %s" % [langs.size(), str(langs)])
	else:
		print("  [PASS] %d languages available: %s" % [langs.size(), str(langs)])
	return true
