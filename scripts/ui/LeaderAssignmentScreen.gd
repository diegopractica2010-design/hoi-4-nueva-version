# scripts/ui/LeaderAssignmentScreen.gd
class_name LeaderAssignmentScreen
extends Control

@export var country_tag: String = "GER"

@onready var total_leaders_label: Label = $TopSummaryBar/TotalLeadersLabel
@onready var available_leaders_label: Label = $TopSummaryBar/AvailableLeadersLabel
@onready var injured_leaders_label: Label = $TopSummaryBar/InjuredLeadersLabel
@onready var captured_leaders_label: Label = $TopSummaryBar/CapturedLeadersLabel

@onready var national_positions_container: HBoxContainer = (
	$NationalPositionsSection/PositionsContainer
)
@onready var available_header_row: HBoxContainer = $MainArea/AvailableLeadersColumn/AvailableHeaderRow
@onready var available_leaders_list: VBoxContainer = (
	$MainArea/AvailableLeadersColumn/AvailableLeadersList/AvailableLeadersContent
)
@onready var formations_content: VBoxContainer = (
	$MainArea/FormationsWithoutLeader/FormationsList/FormationsContent
)
@onready var detail_panel: PanelContainer = $MainArea/DetailPanel
@onready var detail_label: Label = $MainArea/DetailPanel/DetailLabel

var current_data: LeaderScreenData
var _pending_position_key: String = ""
var _pending_assign_leader_id: String = ""

const NATIONAL_POSITIONS: Array[Dictionary] = [
	{
		"key": LeaderManager.POSITION_CHIEF_OF_ARMY,
		"label": "Chief of Army",
	},
	{
		"key": LeaderManager.POSITION_CHIEF_OF_NAVY,
		"label": "Chief of Navy",
	},
	{
		"key": LeaderManager.POSITION_CHIEF_OF_AIR_FORCE,
		"label": "Chief of Air Force",
	},
	{
		"key": LeaderManager.POSITION_CHIEF_OF_SPACE_FORCE,
		"label": "Chief of Space Force",
	},
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
	_apply_screen_theme()
	_setup_headers()
	refresh_screen()


func _apply_screen_theme() -> void:
	RetrowaveTheme.style_production_screen(self)
	RetrowaveTheme.style_summary_metric(total_leaders_label)
	RetrowaveTheme.style_summary_metric(available_leaders_label, RetrowaveTheme.SUCCESS)
	RetrowaveTheme.style_summary_metric(injured_leaders_label, RetrowaveTheme.WARNING)
	RetrowaveTheme.style_summary_metric(captured_leaders_label, RetrowaveTheme.MAGENTA)
	RetrowaveTheme.style_title($NationalPositionsSection/SectionTitle)
	RetrowaveTheme.style_title($MainArea/AvailableLeadersColumn/AvailableLeadersTitle)
	RetrowaveTheme.style_title($MainArea/FormationsWithoutLeader/FormationsTitle)
	RetrowaveTheme.style_detail_panel(detail_panel)
	RetrowaveTheme.style_detail_label(detail_label)


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
	_pending_position_key = position_key
	var display_name := _position_display_name(position_key)
	_open_leader_picker(
		"Assign %s" % display_name,
		position_key,
		_on_national_position_leader_picked,
	)


func _on_national_position_leader_picked(leader_id: String) -> void:
	if _pending_position_key.is_empty():
		return

	var check: Dictionary = LeaderManager.can_assign_national_position(
		country_tag,
		_pending_position_key,
		leader_id,
	)
	if not bool(check.get("can_assign", false)):
		push_warning("Cannot assign position: %s" % check.get("reason", "unknown"))
		_pending_position_key = ""
		return

	if LeaderManager.set_country_position(country_tag, _pending_position_key, leader_id, false):
		refresh_screen()
	_pending_position_key = ""


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
		note.text = "No divisions without a leader."
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

	var traits: Array = summary.get("traits", []) as Array
	hbox.add_child(_row_label(", ".join(traits), 200))

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


func _on_details_pressed(summary: Dictionary) -> void:
	var traits: Array = summary.get("traits", []) as Array
	var text := "Name: %s\n" % summary.get("name", "")
	text += "Type: %s\n" % summary.get("leader_type_name", summary.get("leader_type", ""))
	text += "Attack: %d | Defense: %d | Logistics: %d | Planning: %d\n" % [
		int(summary.get("attack_skill", 0)),
		int(summary.get("defense_skill", 0)),
		int(summary.get("logistics_skill", 0)),
		int(summary.get("planning_skill", 0)),
	]
	text += "Traits: %s\n" % ", ".join(traits)
	text += "Experience: %d | Battles: %d" % [
		int(summary.get("experience", 0)),
		int(summary.get("battles_fought", 0)),
	]
	detail_label.text = text


func _on_assign_pressed(summary: Dictionary) -> void:
	var leader_id: String = str(summary.get("leader_id", ""))
	if leader_id.is_empty():
		return

	var available_formations: Array[Dictionary] = LeaderManager.get_available_formations(country_tag)
	if available_formations.is_empty():
		print("No available formations found for ", country_tag)
		return

	print("=== Available Formations ===")
	for formation in available_formations:
		print(
			"- %s (%s) [%s]"
			% [
				formation.get("name", ""),
				formation.get("formation_id", ""),
				formation.get("type", ""),
			]
		)

	var first_formation: Dictionary = available_formations[0]
	var success: bool = LeaderManager.assign_leader_to_formation(
		leader_id,
		str(first_formation.get("formation_id", "")),
	)

	if success:
		print("Assigned leader to: ", first_formation.get("name", ""))
		refresh_screen()
	else:
		print("Failed to assign leader.")


func _open_formation_picker(leader_name: String, available_formations: Array[Dictionary]) -> void:
	var popup := Window.new()
	popup.title = "Assign %s to Formation" % leader_name
	popup.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN
	popup.size = Vector2i(420, 360)
	RetrowaveTheme.style_popup_root(popup)

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 16)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_right", 16)
	margin.add_theme_constant_override("margin_bottom", 16)
	popup.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_child(vbox)

	var hint := Label.new()
	hint.text = "Select a division to assign this leader to:"
	RetrowaveTheme.style_body_label(hint)
	vbox.add_child(hint)

	var list := ItemList.new()
	list.size_flags_vertical = Control.SIZE_EXPAND_FILL
	RetrowaveTheme.style_item_list(list)
	for formation in available_formations:
		list.add_item(str(formation.get("name", formation.get("formation_id", ""))))
	vbox.add_child(list)

	var buttons := HBoxContainer.new()
	buttons.alignment = BoxContainer.ALIGNMENT_END
	vbox.add_child(buttons)

	var confirm := Button.new()
	confirm.text = "Assign"
	RetrowaveTheme.style_primary_button(confirm)
	confirm.disabled = true
	buttons.add_child(confirm)

	var cancel := Button.new()
	cancel.text = "Cancel"
	RetrowaveTheme.style_secondary_button(cancel)
	buttons.add_child(cancel)

	list.item_selected.connect(func(_index: int) -> void: confirm.disabled = false)
	confirm.pressed.connect(
		func() -> void:
			var idx := list.get_selected_items()
			if idx.is_empty():
				return
			var formation_id: String = str(
				available_formations[idx[0]].get("formation_id", ""),
			)
			if LeaderManager.assign_leader_to_army(_pending_assign_leader_id, formation_id):
				refresh_screen()
			_pending_assign_leader_id = ""
			popup.queue_free(),
	)
	cancel.pressed.connect(popup.queue_free)
	popup.close_requested.connect(popup.queue_free)

	get_tree().root.add_child(popup)
	popup.popup_centered()


func _open_leader_picker(
	title_text: String,
	position_key: String,
	on_selected: Callable,
) -> void:
	var scene: PackedScene = load("res://scenes/ui/LeaderPickerPopup.tscn")
	if scene == null:
		push_warning("LeaderPickerPopup.tscn not found")
		return

	var picker: LeaderPickerPopup = scene.instantiate() as LeaderPickerPopup
	if picker == null:
		return

	picker.dialog_title = title_text
	picker.country_tag = country_tag
	picker.position_key = position_key
	picker.leader_selected.connect(on_selected)
	get_tree().root.add_child(picker)
	picker.popup_centered()


func _position_display_name(position_key: String) -> String:
	for entry in NATIONAL_POSITIONS:
		if str(entry.get("key", "")) == position_key:
			return str(entry.get("label", position_key))
	return position_key
