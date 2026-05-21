# scripts/ui/LeaderAssignmentScreen.gd
class_name LeaderAssignmentScreen
extends DraggablePanel

@export var country_tag: String = "GER"

@onready var title_label: Label = $TitleBar/TitleLabel
@onready var close_button: Button = $TitleBar/CloseButton

@onready var total_leaders_label: Label = (
	$MarginContainer/VBoxContainer/TopSummaryBar/TotalLeadersLabel
)
@onready var available_leaders_label: Label = (
	$MarginContainer/VBoxContainer/TopSummaryBar/AvailableLeadersLabel
)
@onready var injured_leaders_label: Label = (
	$MarginContainer/VBoxContainer/TopSummaryBar/InjuredLeadersLabel
)
@onready var captured_leaders_label: Label = (
	$MarginContainer/VBoxContainer/TopSummaryBar/CapturedLeadersLabel
)

@onready var national_positions_container: HBoxContainer = (
	$MarginContainer/VBoxContainer/NationalPositionsSection/PositionsContainer
)
@onready var available_header_row: HBoxContainer = (
	$MarginContainer/VBoxContainer/MainArea/AvailableLeadersColumn/AvailableHeaderRow
)
@onready var available_leaders_list: VBoxContainer = (
	$MarginContainer/VBoxContainer/MainArea/AvailableLeadersColumn/AvailableLeadersList/AvailableLeadersContent
)
@onready var formations_content: VBoxContainer = (
	$MarginContainer/VBoxContainer/MainArea/FormationsWithoutLeader/FormationsList/FormationsContent
)
@onready var detail_panel: PanelContainer = $MarginContainer/VBoxContainer/MainArea/DetailPanel
@onready var detail_label: Label = $MarginContainer/VBoxContainer/MainArea/DetailPanel/DetailLabel

var current_data: LeaderScreenData
var _detail_traits_box: VBoxContainer
var _selected_leader_id: String = ""

const NATIONAL_POSITIONS: Array[Dictionary] = [
	{"key": LeaderManager.POSITION_CHIEF_OF_ARMY, "label": "Chief of Army"},
	{"key": LeaderManager.POSITION_CHIEF_OF_NAVY, "label": "Chief of Navy"},
	{"key": LeaderManager.POSITION_CHIEF_OF_AIR_FORCE, "label": "Chief of Air Force"},
	{"key": LeaderManager.POSITION_CHIEF_OF_SPACE_FORCE, "label": "Chief of Space Force"},
]

const HEADER_SPECS: Array[Dictionary] = [
	{"text": "Name", "width": 180},
	{"text": "Type", "width": 120},
	{"text": "Skills", "width": 140},
	{"text": "Traits", "width": 200},
	{"text": "", "width": 0, "expand": true},
	{"text": "Assign", "width": 90},
	{"text": "Details", "width": 90},
]
const ROW_HEIGHT := 36


func _ready() -> void:
	add_to_group("leader_screen")
	drag_handle = $TitleBar
	super._ready()
	_setup_detail_panel()
	_apply_screen_theme()
	_setup_headers()
	close_button.pressed.connect(_on_close_pressed)
	refresh_screen()


func _on_close_pressed() -> void:
	queue_free()


func _apply_screen_theme() -> void:
	RetrowaveTheme.style_production_screen(self)
	RetrowaveTheme.style_title(title_label, RetrowaveTheme.CYAN)
	RetrowaveTheme.style_secondary_button(close_button)
	title_label.text = "Leader Assignment — %s" % country_tag
	RetrowaveTheme.style_summary_metric(total_leaders_label)
	RetrowaveTheme.style_summary_metric(available_leaders_label, RetrowaveTheme.SUCCESS)
	RetrowaveTheme.style_summary_metric(injured_leaders_label, RetrowaveTheme.WARNING)
	RetrowaveTheme.style_summary_metric(captured_leaders_label, RetrowaveTheme.MAGENTA)
	RetrowaveTheme.style_title($MarginContainer/VBoxContainer/NationalPositionsSection/SectionTitle)
	RetrowaveTheme.style_title(
		$MarginContainer/VBoxContainer/MainArea/AvailableLeadersColumn/AvailableLeadersTitle,
	)
	RetrowaveTheme.style_title(
		$MarginContainer/VBoxContainer/MainArea/FormationsWithoutLeader/FormationsTitle,
	)
	RetrowaveTheme.style_detail_panel(detail_panel)
	RetrowaveTheme.style_detail_label(detail_label)


func _setup_detail_panel() -> void:
	if detail_panel.get_node_or_null("DetailVBox") != null:
		_detail_traits_box = detail_panel.get_node("DetailVBox/DetailTraitsVBox") as VBoxContainer
		return

	var vbox := VBoxContainer.new()
	vbox.name = "DetailVBox"
	vbox.add_theme_constant_override("separation", 8)
	detail_panel.remove_child(detail_label)
	detail_panel.add_child(vbox)
	vbox.add_child(detail_label)

	_detail_traits_box = VBoxContainer.new()
	_detail_traits_box.name = "DetailTraitsVBox"
	_detail_traits_box.add_theme_constant_override("separation", 4)
	vbox.add_child(_detail_traits_box)


func _setup_headers() -> void:
	for child in available_header_row.get_children():
		child.queue_free()

	for spec in HEADER_SPECS:
		if bool(spec.get("expand", false)):
			var spacer := Control.new()
			spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			available_header_row.add_child(spacer)
			continue

		var label := Label.new()
		label.text = str(spec.get("text", ""))
		var width := int(spec.get("width", 100))
		if width > 0:
			label.custom_minimum_size = Vector2(width, 0)
		RetrowaveTheme.style_column_header(label)
		available_header_row.add_child(label)


func refresh_screen() -> void:
	current_data = LeaderManager.get_leader_screen_data(country_tag, false)
	_update_summary_bar()
	_populate_national_positions()
	_populate_available_leaders()
	_populate_unassigned_formations()


func _update_summary_bar() -> void:
	if current_data == null:
		return

	total_leaders_label.text = "Total Leaders: %d" % current_data.total_leaders
	available_leaders_label.text = "Available: %d" % current_data.available_leaders
	injured_leaders_label.text = "Injured: %d" % current_data.injured_leaders
	captured_leaders_label.text = "Captured: %d" % current_data.captured_leaders

	if current_data.injured_leaders > 0:
		injured_leaders_label.modulate = (
			RetrowaveTheme.WARNING if current_data.has_many_injured else Color(1.0, 0.9, 0.2)
		)
	else:
		injured_leaders_label.modulate = Color.WHITE


# =====================
# NATIONAL POSITIONS
# =====================

func _populate_national_positions() -> void:
	for child in national_positions_container.get_children():
		child.queue_free()

	for entry in NATIONAL_POSITIONS:
		var position_key: String = str(entry.get("key", ""))
		var display_name: String = str(entry.get("label", position_key))
		var leader: Leader = LeaderManager.get_country_position_leader(country_tag, position_key)
		var card: Control = _create_national_position_card(display_name, position_key, leader)
		national_positions_container.add_child(card)


func _create_national_position_card(
	display_name: String,
	position_key: String,
	leader: Leader,
) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(180, 96)
	RetrowaveTheme.style_detail_panel(panel)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 6)
	panel.add_child(vbox)

	var title := Label.new()
	title.text = display_name
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	RetrowaveTheme.style_column_header(title)
	vbox.add_child(title)

	var leader_name := Label.new()
	leader_name.text = leader.name if leader != null else "Unassigned"
	leader_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	if leader == null and position_key == LeaderManager.POSITION_CHIEF_OF_ARMY:
		leader_name.modulate = RetrowaveTheme.WARNING
	RetrowaveTheme.style_row_label(leader_name)
	vbox.add_child(leader_name)

	var change_btn := Button.new()
	change_btn.text = "Change"
	RetrowaveTheme.style_secondary_button(change_btn)
	change_btn.pressed.connect(_on_change_national_position.bind(position_key))
	vbox.add_child(change_btn)

	return panel


func _on_change_national_position(position_key: String) -> void:
	var display_name := _position_display_name(position_key)
	LeaderPickerPopup.open_picker(
		func(picker: LeaderPickerPopup) -> void:
			picker.country_tag = country_tag
			picker.position_key = position_key
			picker.dialog_title = "Assign %s" % display_name,
	)


# =====================
# AVAILABLE LEADERS
# =====================

func _populate_available_leaders() -> void:
	for child in available_leaders_list.get_children():
		child.queue_free()

	if current_data == null:
		return

	for leader_summary in current_data.leaders:
		if not str(leader_summary.get("assigned_army_id", "")).is_empty():
			continue
		if bool(leader_summary.get("is_captured", false)):
			continue
		if bool(leader_summary.get("is_injured", false)):
			continue
		available_leaders_list.add_child(_create_leader_row(leader_summary))


func _populate_unassigned_formations() -> void:
	for child in formations_content.get_children():
		child.queue_free()

	var available_formations: Array[Dictionary] = LeaderManager.get_available_formations(country_tag)
	if available_formations.is_empty():
		var note := Label.new()
		note.text = "No formations without a leader."
		note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		RetrowaveTheme.style_body_label(note)
		formations_content.add_child(note)
		return

	for formation in available_formations:
		var row := HBoxContainer.new()
		row.custom_minimum_size = Vector2(0, ROW_HEIGHT)

		var name_label := Label.new()
		name_label.text = str(formation.get("name", formation.get("formation_id", "")))
		name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		RetrowaveTheme.style_row_label(name_label)
		row.add_child(name_label)

		var type_label := Label.new()
		type_label.text = str(formation.get("type", "division"))
		RetrowaveTheme.style_body_label(type_label)
		row.add_child(type_label)

		formations_content.add_child(row)


func _create_leader_row(summary: Dictionary) -> HBoxContainer:
	var hbox := HBoxContainer.new()
	hbox.custom_minimum_size = Vector2(0, ROW_HEIGHT)
	hbox.add_theme_constant_override("separation", 8)

	var type_name: String = str(summary.get("leader_type_name", summary.get("leader_type", "")))
	hbox.add_child(_row_label(str(summary.get("name", "Unknown")), 180))
	hbox.add_child(_row_label(type_name, 120))
	hbox.add_child(
		_row_label(
			"A:%d D:%d L:%d" % [
				int(summary.get("attack_skill", 0)),
				int(summary.get("defense_skill", 0)),
				int(summary.get("logistics_skill", 0)),
			],
			140,
		)
	)

	hbox.add_child(_row_label(_format_traits_row(summary), 200))

	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.add_child(spacer)

	var assign_btn := Button.new()
	assign_btn.text = "Assign"
	assign_btn.custom_minimum_size = Vector2(90, 0)
	RetrowaveTheme.style_primary_button(assign_btn)
	assign_btn.pressed.connect(_on_assign_pressed.bind(summary))
	hbox.add_child(assign_btn)

	var details_btn := Button.new()
	details_btn.text = "Details"
	details_btn.custom_minimum_size = Vector2(90, 0)
	RetrowaveTheme.style_secondary_button(details_btn)
	details_btn.pressed.connect(_on_details_pressed.bind(summary))
	hbox.add_child(details_btn)

	return hbox


func _row_label(text: String, min_width: int) -> Label:
	var label := Label.new()
	label.text = text
	label.custom_minimum_size = Vector2(min_width, 0)
	label.clip_text = true
	RetrowaveTheme.style_row_label(label)
	return label


func _format_traits_row(summary: Dictionary) -> String:
	var display: Array = summary.get("trait_display", []) as Array
	if not display.is_empty():
		var parts: PackedStringArray = []
		for entry in display:
			if typeof(entry) != TYPE_DICTIONARY:
				continue
			var row := entry as Dictionary
			var roman: String = str(row.get("roman", ""))
			var suffix := " %s" % roman if not roman.is_empty() else ""
			parts.append("%s%s" % [row.get("name", row.get("id", "")), suffix])
		return ", ".join(parts)

	var traits: Array = summary.get("traits", []) as Array
	return ", ".join(traits)


func _on_details_pressed(summary: Dictionary) -> void:
	_selected_leader_id = str(summary.get("leader_id", ""))
	var text := "Name: %s\n" % summary.get("name", "")
	text += "Type: %s\n" % summary.get("leader_type_name", summary.get("leader_type", ""))
	text += "Atk %d | Def %d | Log %d | Plan %d | Init %d\n" % [
		int(summary.get("attack_skill", 0)),
		int(summary.get("defense_skill", 0)),
		int(summary.get("logistics_skill", 0)),
		int(summary.get("planning_skill", 0)),
		int(summary.get("initiative_skill", 0)),
	]
	text += "XP: %d | Battles: %d\n" % [
		int(summary.get("experience", 0)),
		int(summary.get("battles_fought", 0)),
	]
	detail_label.text = text
	_populate_trait_detail(summary)


func _populate_trait_detail(summary: Dictionary) -> void:
	if _detail_traits_box == null:
		return
	for child in _detail_traits_box.get_children():
		child.queue_free()

	var display: Array = summary.get("trait_display", []) as Array
	if display.is_empty():
		var note := Label.new()
		note.text = "No traits."
		RetrowaveTheme.style_body_label(note)
		_detail_traits_box.add_child(note)
		return

	var leader_xp := int(summary.get("experience", 0))
	for entry in display:
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		var row := entry as Dictionary
		var trait_row := VBoxContainer.new()
		trait_row.add_theme_constant_override("separation", 2)

		var title := Label.new()
		var level := int(row.get("level", 1))
		var max_level := int(row.get("max_level", 1))
		var roman: String = str(row.get("roman", ""))
		title.text = "%s %s (%d/%d)" % [row.get("name", ""), roman, level, max_level]
		RetrowaveTheme.style_column_header(title)
		trait_row.add_child(title)

		var desc := str(row.get("description", ""))
		var effects_text := str(row.get("effects_text", ""))
		if not desc.is_empty() or not effects_text.is_empty():
			var body := Label.new()
			body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			body.text = desc
			if not effects_text.is_empty():
				body.text += "\n" + effects_text if not desc.is_empty() else effects_text
			RetrowaveTheme.style_body_label(body)
			trait_row.add_child(body)

		if bool(row.get("can_level_up", false)):
			var cost := int(row.get("level_up_cost", 0))
			var level_btn := Button.new()
			level_btn.text = "Level Up (%d XP)" % cost
			RetrowaveTheme.style_primary_button(level_btn)
			level_btn.disabled = leader_xp < cost
			var trait_id: String = str(row.get("id", ""))
			level_btn.pressed.connect(_on_level_trait_pressed.bind(trait_id))
			trait_row.add_child(level_btn)

		_detail_traits_box.add_child(trait_row)


func _on_level_trait_pressed(trait_id: String) -> void:
	if _selected_leader_id.is_empty():
		return
	var result: Dictionary = LeaderManager.spend_xp_on_trait(_selected_leader_id, trait_id)
	if not bool(result.get("success", false)):
		push_warning("Could not level trait %s: %s" % [trait_id, result.get("reason", "")])
		return
	refresh_screen()
	var leader_summary := LeaderManager.get_leader_summary(_selected_leader_id)
	if not leader_summary.is_empty():
		_on_details_pressed(leader_summary)


func _on_assign_pressed(summary: Dictionary) -> void:
	var leader_id: String = str(summary.get("leader_id", ""))
	if leader_id.is_empty():
		return

	var picker_scene: PackedScene = load("res://scenes/ui/FormationPickerPopup.tscn")
	if picker_scene == null:
		push_warning("FormationPickerPopup.tscn not found")
		return

	var picker: FormationPickerPopup = picker_scene.instantiate() as FormationPickerPopup
	if picker == null:
		return

	picker.leader_id = leader_id
	picker.country_tag = country_tag
	picker.leader_name = str(summary.get("name", ""))
	var tree := get_tree()
	if tree != null and tree.root != null:
		tree.root.add_child(picker)


func _position_display_name(position_key: String) -> String:
	for entry in NATIONAL_POSITIONS:
		if str(entry.get("key", "")) == position_key:
			return str(entry.get("label", position_key))
	return position_key
