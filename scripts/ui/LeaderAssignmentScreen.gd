# scripts/ui/LeaderAssignmentScreen.gd
class_name LeaderAssignmentScreen
extends Control

@export var country_tag: String = "GER"

@onready var total_leaders_label: Label = $TopSummaryBar/TotalLeadersLabel
@onready var available_leaders_label: Label = $TopSummaryBar/AvailableLeadersLabel
@onready var injured_leaders_label: Label = $TopSummaryBar/InjuredLeadersLabel
@onready var captured_leaders_label: Label = $TopSummaryBar/CapturedLeadersLabel

@onready var chief_of_army_button: Button = $NationalPositionsSection/ChiefOfArmyButton
@onready var chief_of_navy_button: Button = $NationalPositionsSection/ChiefOfNavyButton
@onready var chief_of_air_force_button: Button = $NationalPositionsSection/ChiefOfAirForceButton
@onready var chief_of_space_force_button: Button = $NationalPositionsSection/ChiefOfSpaceForceButton

@onready var available_header_row: HBoxContainer = $MainArea/AvailableLeadersColumn/AvailableHeaderRow
@onready var available_leaders_list: VBoxContainer = (
	$MainArea/AvailableLeadersColumn/AvailableLeadersList/AvailableLeadersContent
)
@onready var formations_content: VBoxContainer = (
	$MainArea/FormationsColumn/FormationsList/FormationsContent
)
@onready var detail_panel: PanelContainer = $MainArea/DetailPanel
@onready var detail_label: Label = $MainArea/DetailPanel/DetailLabel

var current_data: LeaderScreenData

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
	_connect_position_buttons()
	refresh_screen()


func _apply_screen_theme() -> void:
	RetrowaveTheme.style_production_screen(self)
	RetrowaveTheme.style_summary_metric(total_leaders_label)
	RetrowaveTheme.style_summary_metric(available_leaders_label, RetrowaveTheme.SUCCESS)
	RetrowaveTheme.style_summary_metric(injured_leaders_label, RetrowaveTheme.WARNING)
	RetrowaveTheme.style_summary_metric(captured_leaders_label, RetrowaveTheme.MAGENTA)
	RetrowaveTheme.style_detail_panel(detail_panel)
	RetrowaveTheme.style_detail_label(detail_label)
	RetrowaveTheme.style_title($MainArea/AvailableLeadersColumn/AvailableLeadersTitle)
	RetrowaveTheme.style_title($MainArea/FormationsColumn/FormationsTitle)
	for btn in [
		chief_of_army_button,
		chief_of_navy_button,
		chief_of_air_force_button,
		chief_of_space_force_button,
	]:
		RetrowaveTheme.style_secondary_button(btn)


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


func _connect_position_buttons() -> void:
	chief_of_army_button.pressed.connect(
		_on_position_pressed.bind(LeaderManager.POSITION_CHIEF_OF_ARMY),
	)
	chief_of_navy_button.pressed.connect(
		_on_position_pressed.bind(LeaderManager.POSITION_CHIEF_OF_NAVY),
	)
	chief_of_air_force_button.pressed.connect(
		_on_position_pressed.bind(LeaderManager.POSITION_CHIEF_OF_AIR_FORCE),
	)
	chief_of_space_force_button.pressed.connect(
		_on_position_pressed.bind(LeaderManager.POSITION_CHIEF_OF_SPACE_FORCE),
	)


func refresh_screen() -> void:
	current_data = LeaderManager.get_leader_screen_data(country_tag, false)
	_update_summary_bar()
	_update_national_positions()
	_populate_available_leaders()
	_populate_formations_placeholder()


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


func _update_national_positions() -> void:
	if current_data == null:
		return

	_set_position_button(
		chief_of_army_button,
		"Chief of Army",
		LeaderManager.POSITION_CHIEF_OF_ARMY,
	)
	_set_position_button(
		chief_of_navy_button,
		"Chief of Navy",
		LeaderManager.POSITION_CHIEF_OF_NAVY,
	)
	_set_position_button(
		chief_of_air_force_button,
		"Chief of Air Force",
		LeaderManager.POSITION_CHIEF_OF_AIR_FORCE,
	)
	_set_position_button(
		chief_of_space_force_button,
		"Chief of Space Force",
		LeaderManager.POSITION_CHIEF_OF_SPACE_FORCE,
	)


func _set_position_button(button: Button, title: String, position_id: String) -> void:
	var leader_id: String = str(current_data.national_positions.get(position_id, ""))
	if leader_id.is_empty():
		button.text = "%s: (vacant)" % title
		if position_id == LeaderManager.POSITION_CHIEF_OF_ARMY and current_data.has_no_chief_of_army:
			button.modulate = RetrowaveTheme.WARNING
		else:
			button.modulate = Color.WHITE
		return

	var leader: Leader = LeaderManager.get_leader(leader_id)
	var leader_name: String = leader.name if leader != null else leader_id
	button.text = "%s: %s" % [title, leader_name]
	button.modulate = RetrowaveTheme.CYAN


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


func _populate_formations_placeholder() -> void:
	for child in formations_content.get_children():
		child.queue_free()

	var note := Label.new()
	note.text = "Formation assignment list (TODO)"
	note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	RetrowaveTheme.style_body_label(note)
	formations_content.add_child(note)


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
	var traits_text: String = ", ".join(traits)
	hbox.add_child(_row_label(traits_text, 200))

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
	print("Assign leader:", summary.get("name"))
	# TODO: Open a list of formations to assign this leader to


func _on_position_pressed(position_id: String) -> void:
	print("Manage national position:", position_id, " (TODO picker)")
