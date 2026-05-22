# scripts/ui/TrainingPathScreen.gd
class_name TrainingPathScreen
extends DraggablePanel

const XP_HIGHLIGHT_COLOR := Color(0.4, 0.95, 0.6)
const ACTIVE_PATH_COLOR := Color(0.45, 0.85, 1.0)

@export var leader_id: String = ""

@onready var screen_title_label: Label = $ContentPanel/MarginContainer/VBoxContainer/Header/TitleLabel
@onready var leader_name_label: Label = (
	$ContentPanel/MarginContainer/VBoxContainer/Header/HeaderRow/LeaderNameLabel
)
@onready var current_xp_label: Label = (
	$ContentPanel/MarginContainer/VBoxContainer/Header/HeaderRow/CurrentXPLabel
)
@onready var paths_list: VBoxContainer = (
	$ContentPanel/MarginContainer/VBoxContainer/AvailablePathsSection/PathsScroll/PathsList
)
@onready var close_button: Button = $ContentPanel/MarginContainer/VBoxContainer/Footer/CloseButton
@onready var header_close_button: Button = (
	$ContentPanel/MarginContainer/VBoxContainer/Header/HeaderRow/HeaderCloseButton
)
@onready var _section_title: Label = (
	$ContentPanel/MarginContainer/VBoxContainer/AvailablePathsSection/SectionTitle
)
@onready var _content_panel: PanelContainer = $ContentPanel

var current_leader: Leader


static func open(parent: Node, id: String) -> TrainingPathScreen:
	var scene: PackedScene = load("res://scenes/ui/TrainingPathScreen.tscn") as PackedScene
	if scene == null:
		push_warning("TrainingPathScreen.tscn not found")
		return null
	var screen: TrainingPathScreen = scene.instantiate() as TrainingPathScreen
	if screen == null:
		return null
	screen.leader_id = id
	screen.z_index = 101
	parent.add_child(screen)
	screen.refresh_screen()
	return screen


func _ready() -> void:
	drag_handle = $ContentPanel/MarginContainer/VBoxContainer/Header
	super._ready()

	if leader_id.is_empty():
		push_error("TrainingPathScreen opened without a leader_id")
		queue_free()
		return

	current_leader = LeaderManager.get_leader(leader_id)
	if current_leader == null:
		push_error("Leader not found: %s" % leader_id)
		queue_free()
		return

	_apply_theme()
	_connect_close_buttons()
	if not LeaderManager.training_path_invested.is_connected(_on_training_path_invested):
		LeaderManager.training_path_invested.connect(_on_training_path_invested)
	if not LeaderManager.training_path_switched.is_connected(_on_training_path_switched):
		LeaderManager.training_path_switched.connect(_on_training_path_switched)
	refresh_screen()


func _exit_tree() -> void:
	if typeof(LeaderManager) == TYPE_NIL:
		return
	if LeaderManager.training_path_invested.is_connected(_on_training_path_invested):
		LeaderManager.training_path_invested.disconnect(_on_training_path_invested)
	if LeaderManager.training_path_switched.is_connected(_on_training_path_switched):
		LeaderManager.training_path_switched.disconnect(_on_training_path_switched)


func _connect_close_buttons() -> void:
	for btn in [close_button, header_close_button]:
		if btn == null:
			continue
		btn.mouse_filter = Control.MOUSE_FILTER_STOP
		if btn.pressed.is_connected(_on_close_pressed):
			btn.pressed.disconnect(_on_close_pressed)
		btn.pressed.connect(_on_close_pressed)
		RetrowaveTheme.style_secondary_button(btn)

	var fallback := get_node_or_null(
		"ContentPanel/MarginContainer/VBoxContainer/Footer/CloseButton"
	) as Button
	if fallback != null and (close_button == null or fallback != close_button):
		fallback.mouse_filter = Control.MOUSE_FILTER_STOP
		if not fallback.pressed.is_connected(_on_close_pressed):
			fallback.pressed.connect(_on_close_pressed)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_on_close_pressed()
		get_viewport().set_input_as_handled()


func _on_close_pressed() -> void:
	queue_free()


func _on_training_path_invested(changed_leader_id: String, _path_id: String, _new_level: int) -> void:
	if changed_leader_id == leader_id:
		refresh_screen()


func _on_training_path_switched(changed_leader_id: String, _old_path_id: String, _new_path_id: String) -> void:
	if changed_leader_id == leader_id:
		refresh_screen()


func refresh_screen() -> void:
	if current_leader == null:
		current_leader = LeaderManager.get_leader(leader_id)
	if current_leader == null:
		return

	leader_name_label.text = current_leader.name
	current_xp_label.text = "XP Available: %d" % current_leader.experience
	current_xp_label.add_theme_color_override("font_color", XP_HIGHLIGHT_COLOR)
	_populate_available_paths()


func _apply_theme() -> void:
	RetrowaveTheme.style_production_screen(self)
	_style_content_panel()
	RetrowaveTheme.style_title(screen_title_label, RetrowaveTheme.CYAN)
	leader_name_label.add_theme_font_size_override("font_size", 20)
	RetrowaveTheme.style_body_label(leader_name_label)
	current_xp_label.add_theme_font_size_override("font_size", 17)
	RetrowaveTheme.style_body_label(current_xp_label)
	if close_button:
		RetrowaveTheme.style_secondary_button(close_button)
	if header_close_button:
		RetrowaveTheme.style_secondary_button(header_close_button)
	_section_title.add_theme_font_size_override("font_size", 14)
	_section_title.add_theme_color_override("font_color", RetrowaveTheme.CYAN)


func _style_content_panel() -> void:
	if _content_panel == null:
		return
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.08, 0.1, 0.16, 0.92)
	style.border_color = Color(0.25, 0.45, 0.65, 0.35)
	style.set_border_width_all(1)
	style.set_corner_radius_all(8)
	style.set_content_margin_all(4)
	_content_panel.add_theme_stylebox_override("panel", style)


func _populate_available_paths() -> void:
	for child in paths_list.get_children():
		child.queue_free()

	var available_paths := LeaderManager.get_available_training_paths(leader_id)
	if available_paths.is_empty():
		var empty_note := Label.new()
		empty_note.text = "No training paths available for this leader."
		empty_note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		empty_note.modulate = Color(0.65, 0.65, 0.65)
		RetrowaveTheme.style_body_label(empty_note)
		paths_list.add_child(empty_note)
		return

	for path_entry in available_paths:
		paths_list.add_child(_create_path_row(path_entry))


func _create_path_row(path: Dictionary) -> PanelContainer:
	var panel := PanelContainer.new()
	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color(0.11, 0.14, 0.2)
	panel_style.set_corner_radius_all(6)
	panel_style.set_content_margin_all(12)
	var is_active := bool(path.get("is_active", false))
	if is_active:
		panel_style.border_color = Color(0.35, 0.75, 0.95, 0.5)
		panel_style.set_border_width_all(1)
	panel.add_theme_stylebox_override("panel", panel_style)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 6)
	vbox.custom_minimum_size = Vector2(0, 110)
	panel.add_child(vbox)

	var path_name := str(path.get("name", path.get("path_id", "")))
	var path_id := str(path.get("path_id", ""))
	var current_level := int(path.get("current_level", 0))
	var max_level := int(path.get("max_level", 3))

	var header := Label.new()
	var active_tag := "  • ACTIVE" if is_active else ""
	header.text = "%s%s  —  Level %d / %d" % [path_name, active_tag, current_level, max_level]
	header.add_theme_font_size_override("font_size", 16)
	if is_active:
		header.add_theme_color_override("font_color", ACTIVE_PATH_COLOR)
	vbox.add_child(header)

	var desc := Label.new()
	desc.text = str(path.get("description", ""))
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc.add_theme_font_size_override("font_size", 12)
	desc.modulate = Color(0.75, 0.75, 0.75)
	vbox.add_child(desc)

	var effects: Dictionary = path.get("effects", {})
	if not effects.is_empty():
		var effects_label := Label.new()
		effects_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		effects_label.text = "Current Bonuses: " + _format_effects(effects)
		effects_label.add_theme_font_size_override("font_size", 11)
		effects_label.modulate = Color(0.78, 0.78, 0.82)
		vbox.add_child(effects_label)

	var next_effects: Dictionary = path.get("next_level_effects", {})
	if not next_effects.is_empty() and current_level < max_level:
		var next_label := Label.new()
		next_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		next_label.text = "Next Level: " + _format_effects(next_effects)
		next_label.add_theme_font_size_override("font_size", 11)
		next_label.modulate = XP_HIGHLIGHT_COLOR
		vbox.add_child(next_label)

	var invest_cost := LeaderManager.get_training_path_level_cost(
		current_level if is_active else 0
	)
	var invest_btn := Button.new()
	if current_level >= max_level:
		invest_btn.text = "Max Level Reached"
		invest_btn.disabled = true
	else:
		var verb := "Invest"
		if not is_active and current_leader.has_training_path():
			verb = "Adopt & Invest"
		invest_btn.text = "%s %d XP" % [verb, invest_cost]
		invest_btn.disabled = not LeaderManager.can_invest_training_path(leader_id, path_id)
		invest_btn.pressed.connect(_on_invest_pressed.bind(path_id, invest_cost))
	if invest_btn.disabled and current_level < max_level:
		invest_btn.tooltip_text = "Requires %d XP" % invest_cost
	RetrowaveTheme.style_primary_button(invest_btn)
	vbox.add_child(invest_btn)

	if (
		current_leader.has_training_path()
		and not is_active
		and LeaderManager.can_switch_training_path(leader_id, path_id)
	):
		var switch_cost := LeaderManager.get_training_path_switch_cost(leader_id, path_id)
		var switch_btn := Button.new()
		switch_btn.text = "Switch School (%d XP)" % switch_cost
		switch_btn.pressed.connect(_on_switch_pressed.bind(path_id))
		RetrowaveTheme.style_secondary_button(switch_btn)
		vbox.add_child(switch_btn)

	return panel


func _format_effects(effects: Dictionary) -> String:
	if effects.is_empty():
		return "None"
	var formatted := LeaderManager.format_trait_effects_text(effects)
	if formatted.is_empty():
		return "None"
	return formatted


func _on_invest_pressed(path_id: String, cost: int) -> void:
	if current_leader.experience < cost:
		push_warning("Not enough XP to invest in training path.")
		return
	if LeaderManager.invest_xp_in_training_path(leader_id, path_id):
		refresh_screen()
	else:
		push_warning("Could not invest in training path: %s" % path_id)


func _on_switch_pressed(path_id: String) -> void:
	if LeaderManager.switch_training_path(leader_id, path_id):
		refresh_screen()
	else:
		push_warning("Could not switch training path to: %s" % path_id)
