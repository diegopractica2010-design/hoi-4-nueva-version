# scripts/ui/TopInfoBar.gd
class_name TopInfoBar
extends Control

@export var player_country_tag: String = "USA"

@onready var date_time_label: Label = $ContentRow/LeftContainer/DateTimeLabel

@onready var pause_button: Button = $ContentRow/LeftContainer/TimeSpeedContainer/PauseButton
@onready var speed1_button: Button = $ContentRow/LeftContainer/TimeSpeedContainer/Speed1Button
@onready var speed2_button: Button = $ContentRow/LeftContainer/TimeSpeedContainer/Speed2Button
@onready var speed3_button: Button = $ContentRow/LeftContainer/TimeSpeedContainer/Speed3Button
@onready var speed4_button: Button = $ContentRow/LeftContainer/TimeSpeedContainer/Speed4Button

@onready var production_button: Button = $ContentRow/CenterContainer/ProductionButton
@onready var leaders_button: Button = $ContentRow/CenterContainer/LeadersButton
@onready var technology_button: Button = $ContentRow/CenterContainer/TechnologyButton
@onready var diplomacy_button: Button = $ContentRow/CenterContainer/DiplomacyButton
@onready var agents_button: Button = $ContentRow/CenterContainer/AgentsButton
@onready var map_button: Button = $ContentRow/CenterContainer/MapButton

@onready var steel_label: Label = $ContentRow/RightContainer/ResourcesContainer/SteelLabel
@onready var aluminum_label: Label = $ContentRow/RightContainer/ResourcesContainer/AluminumLabel
@onready var oil_label: Label = $ContentRow/RightContainer/ResourcesContainer/OilLabel
@onready var rubber_label: Label = $ContentRow/RightContainer/ResourcesContainer/RubberLabel

@onready var save_button: Button = $ContentRow/RightContainer/MenuContainer/SaveButton
@onready var load_button: Button = $ContentRow/RightContainer/MenuContainer/LoadButton
@onready var settings_button: Button = $ContentRow/RightContainer/MenuContainer/SettingsButton
@onready var help_button: Button = $ContentRow/RightContainer/MenuContainer/HelpButton

var current_speed: int = 1
var is_paused: bool = false


func _ready() -> void:
	_apply_theme()
	_connect_buttons()
	_sync_pause_from_time_manager()
	_update_speed_buttons()
	_update_date_time()
	_update_resources()
	if typeof(TimeManager) != TYPE_NIL:
		if not TimeManager.game_year_advanced.is_connected(_on_game_year_advanced):
			TimeManager.game_year_advanced.connect(_on_game_year_advanced)
		if not TimeManager.game_month_advanced.is_connected(_on_game_month_advanced):
			TimeManager.game_month_advanced.connect(_on_game_month_advanced)
		if not TimeManager.game_day_advanced.is_connected(_on_game_day_advanced):
			TimeManager.game_day_advanced.connect(_on_game_day_advanced)

	var timer := Timer.new()
	timer.wait_time = 1.0
	timer.timeout.connect(_on_tick)
	add_child(timer)
	timer.start()


func _apply_theme() -> void:
	RetrowaveTheme.style_top_info_bar(self)
	RetrowaveTheme.style_info_bar_label(date_time_label, RetrowaveTheme.CYAN)
	for label in [steel_label, aluminum_label, oil_label, rubber_label]:
		RetrowaveTheme.style_info_bar_label(label, RetrowaveTheme.TEXT_DIM)
	for btn in [
		production_button,
		leaders_button,
		technology_button,
		diplomacy_button,
		agents_button,
		map_button,
	]:
		RetrowaveTheme.style_nav_button(btn)
	RetrowaveTheme.style_primary_button(production_button)
	RetrowaveTheme.style_primary_button(leaders_button)
	for btn in [save_button, load_button, settings_button, help_button, pause_button]:
		RetrowaveTheme.style_secondary_button(btn)


func _connect_buttons() -> void:
	pause_button.pressed.connect(_on_pause_pressed)
	speed1_button.pressed.connect(func() -> void: _set_game_speed(1))
	speed2_button.pressed.connect(func() -> void: _set_game_speed(2))
	speed3_button.pressed.connect(func() -> void: _set_game_speed(3))
	speed4_button.pressed.connect(func() -> void: _set_game_speed(4))

	production_button.pressed.connect(_on_production_pressed)
	leaders_button.pressed.connect(_on_leaders_pressed)
	technology_button.pressed.connect(_on_technology_pressed)
	diplomacy_button.pressed.connect(_on_diplomacy_pressed)
	agents_button.pressed.connect(_on_agents_pressed)
	map_button.pressed.connect(_on_map_pressed)

	save_button.pressed.connect(_on_save_pressed)
	load_button.pressed.connect(_on_load_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	help_button.pressed.connect(_on_help_pressed)


func _on_tick() -> void:
	# Drive simulation from real time when not paused
	if typeof(TimeManager) != TYPE_NIL:
		TimeManager.advance_real_time(1.0)   # 1 real second → scaled game days

	_update_date_time()
	_update_resources()


func _set_game_speed(speed: int) -> void:
	current_speed = clampi(speed, 1, 4)
	is_paused = false
	Engine.time_scale = float(current_speed)
	_sync_time_manager_controls()
	_update_speed_buttons()
	_update_date_time()


func _update_speed_buttons() -> void:
	var buttons := [speed1_button, speed2_button, speed3_button, speed4_button]
	for i in buttons.size():
		RetrowaveTheme.style_speed_button(buttons[i], not is_paused and (i + 1) == current_speed)
	if is_paused:
		pause_button.modulate = RetrowaveTheme.MAGENTA
	else:
		pause_button.modulate = Color.WHITE


func _on_pause_pressed() -> void:
	is_paused = not is_paused
	Engine.time_scale = 0.0 if is_paused else float(current_speed)
	_sync_time_manager_controls()
	_update_speed_buttons()
	_update_date_time()


func _on_game_year_advanced(_year: int) -> void:
	_update_date_time()


func _on_game_month_advanced(_year: int, _month: int) -> void:
	_update_date_time()
	_update_resources()


func _on_game_day_advanced(_year: int, _month: int, _day: int) -> void:
	_update_date_time()


func _sync_pause_from_time_manager() -> void:
	if typeof(TimeManager) == TYPE_NIL:
		return
	is_paused = TimeManager.is_paused()


func _sync_time_manager_controls() -> void:
	if typeof(TimeManager) == TYPE_NIL:
		return
	TimeManager.set_paused(is_paused)
	TimeManager.set_time_scale(float(current_speed) if not is_paused else 0.0)


func _update_date_time() -> void:
	date_time_label.text = GameDateDisplay.format_top_bar_line(true)
	var tip := GameDateDisplay.format_top_bar_tooltip()
	date_time_label.tooltip_text = tip
	pause_button.tooltip_text = "Pause / resume simulation\n\n" + tip if not tip.is_empty() else "Pause / resume simulation"
	if is_paused:
		date_time_label.modulate = RetrowaveTheme.MAGENTA
		pause_button.tooltip_text = "Resume simulation\n\n" + tip if not tip.is_empty() else "Resume simulation"
	else:
		date_time_label.modulate = Color.WHITE


func _update_resources() -> void:
	var stockpile: Dictionary = ProductionManager.national_stockpile
	steel_label.text = "Steel: %.0f" % float(stockpile.get("steel", 0.0))
	aluminum_label.text = "Aluminum: %.0f" % float(stockpile.get("aluminum", 0.0))
	oil_label.text = "Oil: %.0f" % float(stockpile.get("oil", 0.0))
	rubber_label.text = "Rubber: %.0f" % float(stockpile.get("rubber", 0.0))


func _close_overlay_screens() -> void:
	_close_screen("ProductionAssignmentScreen")
	_close_screen("LeaderAssignmentScreen")
	_close_screen("AgentAssignmentScreen")
	_close_screen("NationalSpiritsScreen")
	_close_screen("TechnologyScreen")


func _on_production_pressed() -> void:
	_close_overlay_screens()
	_close_screen("ProductionAssignmentScreen")
	_toggle_screen(
		"ProductionAssignmentScreen",
		"res://scenes/ui/ProductionAssignmentScreen.tscn",
		func(scene: Node) -> void:
			var screen := scene as ProductionAssignmentScreen
			if screen != null:
				screen.country_tag = player_country_tag
	)


func _on_leaders_pressed() -> void:
	_close_overlay_screens()
	_close_screen("LeaderAssignmentScreen")
	_toggle_screen(
		"LeaderAssignmentScreen",
		"res://scenes/ui/LeaderAssignmentScreen.tscn",
		func(scene: Node) -> void:
			var screen := scene as LeaderAssignmentScreen
			if screen != null:
				screen.country_tag = player_country_tag
				if typeof(LeaderManager) != TYPE_NIL:
					LeaderManager.set_player_country_tag(player_country_tag)
	)


func _on_technology_pressed() -> void:
	_close_overlay_screens()
	_toggle_screen(
		"TechnologyScreen",
		"res://scenes/ui/TechnologyScreen.tscn",
		func(scene: Node) -> void:
			var screen := scene as TechnologyScreen
			if screen != null:
				screen.country_tag = player_country_tag
	)


func _on_diplomacy_pressed() -> void:
	print("Open Diplomacy Screen (TODO)")


func _on_agents_pressed() -> void:
	_close_overlay_screens()
	_close_screen("AgentAssignmentScreen")
	_toggle_screen(
		"AgentAssignmentScreen",
		"res://scenes/ui/AgentAssignmentScreen.tscn",
		func(scene: Node) -> void:
			var screen := scene as AgentAssignmentScreen
			if screen != null:
				screen.country_tag = player_country_tag
				if typeof(LeaderManager) != TYPE_NIL:
					LeaderManager.set_player_country_tag(player_country_tag)
	)


func _on_map_pressed() -> void:
	_close_overlay_screens()


func _close_screen(screen_name: String) -> void:
	var existing := get_tree().root.get_node_or_null(screen_name)
	if existing != null:
		existing.queue_free()


func _toggle_screen(screen_name: String, scene_path: String, configure: Callable) -> void:
	var existing := get_tree().root.get_node_or_null(screen_name)
	if existing != null:
		existing.queue_free()
		return

	var packed: PackedScene = load(scene_path)
	if packed == null:
		push_warning("%s not found at %s" % [screen_name, scene_path])
		return

	var scene: Node = packed.instantiate()
	if scene == null:
		return
	configure.call(scene)
	scene.name = screen_name
	get_tree().root.add_child(scene)


func _on_save_pressed() -> void:
	if typeof(SaveLoadManager) != TYPE_NIL:
		# Quick save + open manager for full control (list, delete, load other slots)
		SaveLoadManager.quicksave()
		_show_save_manager_popup()
	else:
		print("SaveLoadManager not available")


func _on_load_pressed() -> void:
	if typeof(SaveLoadManager) != TYPE_NIL:
		var ok := SaveLoadManager.load_game("quicksave")
		print("Load Game ← quicksave.json: %s" % ("OK" if ok else "FAILED"))
		# Force a UI refresh after load (date, resources, etc.)
		_update_date_time()
		_update_resources()
	else:
		print("SaveLoadManager not available")


func _on_settings_pressed() -> void:
	print("Open Settings (TODO)")


func _on_help_pressed() -> void:
	print("Open Help (TODO)")


## Basic in-code Save Manager popup (F6 or via Save button enhancement).
## Lists saves from SaveLoadManager.list_saves(), with Load / Delete actions.
## Rename is available via SaveLoadManager.rename_save() from console/script for now.
## This gives immediate usable UX without requiring a dedicated .tscn yet.
func _show_save_manager_popup() -> void:
	if typeof(SaveLoadManager) == TYPE_NIL:
		print("SaveLoadManager not ready")
		return

	# Remove any previous instance
	var existing := get_tree().root.get_node_or_null("SaveManagerPopup")
	if existing != null:
		existing.queue_free()

	var panel := Panel.new()
	panel.name = "SaveManagerPopup"
	panel.size = Vector2(520, 380)
	panel.position = Vector2(200, 120)
	panel.z_index = 100

	# Simple styling (reuses theme if possible)
	if has_node("/root/RetrowaveTheme"):
		# best effort
		pass

	var vbox := VBoxContainer.new()
	vbox.size = panel.size - Vector2(20, 20)
	vbox.position = Vector2(10, 10)
	panel.add_child(vbox)

	var title := Label.new()
	title.text = "Save Manager (F6 to close, click actions)"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	var saves := SaveLoadManager.list_saves()
	if saves.is_empty():
		var l := Label.new()
		l.text = "No saves yet. Use F5 / Save button to create 'quicksave' or 'autosave'."
		vbox.add_child(l)
	else:
		for s in saves:
			var h := HBoxContainer.new()
			var slot_label := Label.new()
			var meta := s.get("metadata", {}) as Dictionary
			var ts := str(meta.get("timestamp", ""))
			slot_label.text = "%s  (%s)" % [s.get("slot", "?"), ts.substr(0, 16) if ts.length() > 16 else ts]
			slot_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			h.add_child(slot_label)

			var load_btn := Button.new()
			load_btn.text = "Load"
			load_btn.pressed.connect(func():
				SaveLoadManager.load_game(s.get("slot", ""))
				_update_date_time()
				_update_resources()
				panel.queue_free()
			)
			h.add_child(load_btn)

			var del_btn := Button.new()
			del_btn.text = "Delete"
			del_btn.pressed.connect(func():
				SaveLoadManager.delete_save(s.get("slot", ""))
				panel.queue_free()
				_show_save_manager_popup()  # refresh
			)
			h.add_child(del_btn)

			vbox.add_child(h)

	var close_btn := Button.new()
	close_btn.text = "Close (F6)"
	close_btn.pressed.connect(func(): panel.queue_free())
	vbox.add_child(close_btn)

	get_tree().root.add_child(panel)
	print("Save Manager popup opened (%d saves)" % saves.size())


## Dev convenience keybinds (F5 = quicksave, F9 = quickload).
## These are intentionally loud in the console so you know the save/load cycle fired.
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_F5:
			if typeof(SaveLoadManager) != TYPE_NIL:
				SaveLoadManager.quicksave()
				print("F5 QuickSave triggered")
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_F9:
			if typeof(SaveLoadManager) != TYPE_NIL:
				SaveLoadManager.quickload()
				_update_date_time()
				_update_resources()
				print("F9 QuickLoad triggered")
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_F6:
			_show_save_manager_popup()
			get_viewport().set_input_as_handled()
