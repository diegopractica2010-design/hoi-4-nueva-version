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
	_update_speed_buttons()
	_update_date_time()
	_update_resources()

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
	_update_date_time()
	_update_resources()


func _set_game_speed(speed: int) -> void:
	current_speed = clampi(speed, 1, 4)
	is_paused = false
	Engine.time_scale = float(current_speed)
	_update_speed_buttons()


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
	_update_speed_buttons()


func _update_date_time() -> void:
	# Placeholder until a game calendar system exists.
	date_time_label.text = "15 June 1939  •  14:32"


func _update_resources() -> void:
	var stockpile: Dictionary = ProductionManager.national_stockpile
	steel_label.text = "Steel: %.0f" % float(stockpile.get("steel", 0.0))
	aluminum_label.text = "Aluminum: %.0f" % float(stockpile.get("aluminum", 0.0))
	oil_label.text = "Oil: %.0f" % float(stockpile.get("oil", 0.0))
	rubber_label.text = "Rubber: %.0f" % float(stockpile.get("rubber", 0.0))


func _on_production_pressed() -> void:
	_close_screen("LeaderAssignmentScreen")
	_toggle_screen(
		"ProductionAssignmentScreen",
		"res://scenes/ui/ProductionAssignmentScreen.tscn",
		func(scene: Node) -> void:
			var screen := scene as ProductionAssignmentScreen
			if screen != null:
				screen.country_tag = player_country_tag
	)


func _on_leaders_pressed() -> void:
	_close_screen("ProductionAssignmentScreen")
	_toggle_screen(
		"LeaderAssignmentScreen",
		"res://scenes/ui/LeaderAssignmentScreen.tscn",
		func(scene: Node) -> void:
			var screen := scene as LeaderAssignmentScreen
			if screen != null:
				screen.country_tag = player_country_tag
	)


func _on_technology_pressed() -> void:
	print("Open Technology Screen (TODO)")


func _on_diplomacy_pressed() -> void:
	print("Open Diplomacy Screen (TODO)")


func _on_agents_pressed() -> void:
	print("Open Agents Screen (TODO)")


func _on_map_pressed() -> void:
	_close_screen("ProductionAssignmentScreen")
	_close_screen("LeaderAssignmentScreen")


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
	print("Save Game (TODO)")


func _on_load_pressed() -> void:
	print("Load Game (TODO)")


func _on_settings_pressed() -> void:
	print("Open Settings (TODO)")


func _on_help_pressed() -> void:
	print("Open Help (TODO)")
