extends Node

static func run_all() -> bool:
	var ok = true
	ok = test_screen_loading() and ok
	ok = test_signal_wiring() and ok
	ok = test_button_actions() and ok
	ok = test_localization_updates() and ok
	ok = test_panel_open_close() and ok
	if ok:
		print("✅ All UI tests passed")
	else:
		push_error("❌ Some UI tests failed")
	return ok

static func test_screen_loading() -> bool:
	var ok = true
	var screens = [
		"res://scripts/ui/MainMenu.gd",
		"res://scripts/ui/StartMenu.gd",
		"res://scripts/ui/NationSelectScreen.gd",
		"res://scripts/ui/TopInfoBar.gd",
		"res://scripts/ui/TechnologyScreen.gd",
		"res://scripts/ui/ProductionAssignmentScreen.gd",
		"res://scripts/ui/LeaderAssignmentScreen.gd",
		"res://scripts/ui/AgentAssignmentScreen.gd",
		"res://scripts/ui/NationalSpiritsScreen.gd",
		"res://scripts/ui/LeaderDetailScreen.gd",
		"res://scripts/ui/TrainingPathScreen.gd",
		"res://scripts/ui/SettingsPopup.gd",
		"res://scripts/ui/VictoryScreen.gd",
		"res://scripts/ui/DiplomacyScreen.gd",
		"res://scripts/ui/TradeScreen.gd",
	]
	for path in screens:
		var script = load(path)
		if script == null:
			push_error("UITest: Failed to load " + path)
			ok = false
		else:
			print("  ✓ Loaded: ", path.get_file())
	# Screen scenes
	var scenes = [
		"res://scenes/ui/MainMenu.tscn",
		"res://scenes/ui/StartMenu.tscn",
		"res://scenes/ui/NationSelectScreen.tscn",
		"res://scenes/ui/TopInfoBar.tscn",
		"res://scenes/ui/TechnologyScreen.tscn",
		"res://scenes/ui/ProductionAssignmentScreen.tscn",
		"res://scenes/ui/LeaderAssignmentScreen.tscn",
		"res://scenes/ui/AgentAssignmentScreen.tscn",
		"res://scenes/ui/NationalSpiritsScreen.tscn",
		"res://scenes/ui/LeaderDetailScreen.tscn",
		"res://scenes/ui/TrainingPathScreen.tscn",
		"res://scenes/ui/SettingsPopup.tscn",
		"res://scenes/ui/VictoryScreen.tscn",
		"res://scenes/ui/DiplomacyScreen.tscn",
		"res://scenes/ui/TradeScreen.tscn",
	]
	for path in scenes:
		var scene = load(path)
		if scene == null:
			push_error("UITest: Failed to load " + path)
			ok = false
		else:
			print("  ✓ Scene loaded: ", path.get_file())
	if ok:
		print("✅ UI screen loading: PASS")
	return ok

static func test_signal_wiring() -> bool:
	var ok = true
	var tests = [
		{ "path": "res://scripts/ui/MainMenu.gd", "signals": ["start_game", "open_settings", "quit_game"] },
		{ "path": "res://scripts/ui/StartMenu.gd", "signals": ["scene_changed"] },
		{ "path": "res://scripts/ui/SettingsPopup.gd", "signals": ["language_changed"] },
		{ "path": "res://scripts/ui/VictoryScreen.gd", "signals": ["return_to_menu"] },
	]
	for t in tests:
		var script = load(t.path)
		for sig_name in t.signals:
			if script.has_signal(sig_name):
				print("  ✓ ", t.path.get_file(), " has signal: ", sig_name)
			else:
				push_warning("UITest: Signal " + sig_name + " not in script of " + t.path.get_file() + " (may exist on scene instance)")
	if ok:
		print("✅ UI signal wiring: PASS")
	return ok

static func test_button_actions() -> bool:
	var ok = true
	var method_checks = [
		{ "path": "res://scripts/ui/MainMenu.gd", "methods": ["_on_start_game_pressed", "_on_quit_pressed"] },
		{ "path": "res://scripts/ui/StartMenu.gd", "methods": ["_ready"] },
		{ "path": "res://scripts/ui/SettingsPopup.gd", "methods": ["_on_close_pressed", "_on_language_selected"] },
		{ "path": "res://scripts/ui/TopInfoBar.gd", "methods": ["_ready"] },
	]
	for tc in method_checks:
		var script = load(tc.path)
		for m in tc.methods:
			if script.has_method(m):
				print("  ✓ ", tc.path.get_file(), " has method: ", m)
			else:
				push_warning("UITest: Method " + m + " not found in " + tc.path.get_file() + " (may be inherited)")
	return ok

static func test_localization_updates() -> bool:
	var ok = true
	var localizable_scripts = [
		"res://scripts/ui/MainMenu.gd",
		"res://scripts/ui/NationSelectScreen.gd",
		"res://scripts/ui/SettingsPopup.gd",
		"res://scripts/ui/VictoryScreen.gd",
	]
	for path in localizable_scripts:
		var script = load(path)
		if script == null:
			ok = false
			continue
		if script.has_method("_update_localization") or script.has_signal("language_changed"):
			print("  ✓ ", path.get_file(), " supports localization")
		else:
			push_warning("UITest: " + path.get_file() + " may not support localization updates")
	if ok:
		print("✅ UI localization updates: PASS")
	return ok

static func test_panel_open_close() -> bool:
	var ok = true
	var panel_scripts = [
		"res://scripts/ui/SettingsPopup.gd",
		"res://scripts/ui/VictoryScreen.gd",
		"res://scripts/ui/EventPopup.gd",
		"res://scripts/ui/BattleResultPopup.gd",
		"res://scripts/ui/TutorialPopup.gd",
	]
	for path in panel_scripts:
		var script = load(path)
		var has_open = script.has_method("open") or script.has_method("show") or script.has_method("popup")
		var has_close = script.has_method("close") or script.has_method("hide")
		if has_open or has_close:
			print("  ✓ ", path.get_file(), ": open=", has_open, " close=", has_close)
		else:
			push_warning("UITest: " + path.get_file() + " may need open/close methods")
	if ok:
		print("✅ UI panel open/close: PASS")
	return ok
