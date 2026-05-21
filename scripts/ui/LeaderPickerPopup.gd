# scripts/ui/LeaderPickerPopup.gd
class_name LeaderPickerPopup
extends Window

signal leader_selected(leader_id: String)

@export var country_tag: String = "GER"
@export var position_key: String = ""
@export var dialog_title: String = "Select Leader"

@onready var title_label: Label = $MarginContainer/VBoxContainer/TitleLabel
@onready var leader_list: ItemList = $MarginContainer/VBoxContainer/LeaderList
@onready var search_edit: LineEdit = $MarginContainer/VBoxContainer/SearchEdit
@onready var confirm_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/ConfirmButton
@onready var cancel_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/CancelButton

var valid_leader_types: Array[String] = []
var _eligible_leader_ids: Array[String] = []
var selected_leader_id: String = ""


func _ready() -> void:
	visible = false
	close_requested.connect(_on_cancel_pressed)
	RetrowaveTheme.style_popup_root(self)
	RetrowaveTheme.style_title(title_label, RetrowaveTheme.CYAN)
	RetrowaveTheme.style_search(search_edit)
	search_edit.placeholder_text = "Search leaders..."
	RetrowaveTheme.style_item_list(leader_list)
	RetrowaveTheme.style_primary_button(confirm_button)
	RetrowaveTheme.style_secondary_button(cancel_button)

	confirm_button.disabled = true
	confirm_button.pressed.connect(_on_confirm_pressed)
	cancel_button.pressed.connect(_on_cancel_pressed)
	leader_list.item_selected.connect(_on_leader_selected)
	search_edit.text_changed.connect(_on_search_changed)

	_update_title()

	if not position_key.is_empty():
		valid_leader_types = LeaderManager.get_valid_leader_types_for_position(position_key)

	_load_leaders()
	call_deferred("_present_popup")


func _update_title() -> void:
	if not dialog_title.is_empty():
		title_label.text = dialog_title
		title = dialog_title
	elif not position_key.is_empty():
		var label := position_key.replace("_", " ").capitalize()
		title_label.text = "Assign %s" % label
		title = "Assign %s" % label
	else:
		title_label.text = "Select Leader"
		title = "Select Leader"


func _present_popup() -> void:
	if not is_inside_tree():
		return
	popup_centered()
	visible = true


static func open_picker(configure: Callable) -> LeaderPickerPopup:
	var scene: PackedScene = load("res://scenes/ui/LeaderPickerPopup.tscn")
	if scene == null:
		push_warning("LeaderPickerPopup.tscn not found")
		return null

	var picker: LeaderPickerPopup = scene.instantiate() as LeaderPickerPopup
	if picker == null:
		return null

	configure.call(picker)
	var tree := Engine.get_main_loop() as SceneTree
	if tree == null or tree.root == null:
		picker.queue_free()
		return null
	tree.root.add_child(picker)
	return picker


func _load_leaders() -> void:
	_eligible_leader_ids.clear()
	selected_leader_id = ""

	var leaders: Array[Leader] = LeaderManager.get_leaders_for_country(country_tag)
	var valid_types: Array[String] = []
	if not position_key.is_empty():
		valid_types = LeaderManager.get_valid_leader_types_for_position(position_key)
	else:
		valid_types = valid_leader_types

	print(
		"LeaderPickerPopup: country=%s position=%s total=%d valid_types=%s"
		% [country_tag, position_key, leaders.size(), valid_types]
	)

	var eligible_count := 0
	for leader in leaders:
		if leader.is_injured or leader.is_captured:
			continue
		if valid_types.size() > 0 and not valid_types.has(leader.leader_type):
			continue

		_eligible_leader_ids.append(leader.leader_id)
		eligible_count += 1
		print(
			"  leader: %s (%s) injured=%s captured=%s"
			% [leader.name, leader.leader_type, leader.is_injured, leader.is_captured]
		)

	print("LeaderPickerPopup: eligible after filter: %d" % eligible_count)
	_eligible_leader_ids.sort()
	_populate_list("")


func _populate_list(search_text: String) -> void:
	var needle := search_text.strip_edges().to_lower()
	leader_list.clear()
	selected_leader_id = ""
	confirm_button.disabled = true

	if _eligible_leader_ids.is_empty():
		var hint := "No eligible leaders for this position."
		if not position_key.is_empty():
			var types := LeaderManager.get_valid_leader_types_for_position(position_key)
			if not types.is_empty():
				hint = "No eligible leaders (%s)." % ", ".join(types)
		var empty_index := leader_list.add_item(hint)
		leader_list.set_item_metadata(empty_index, "")
		return

	for leader_id in _eligible_leader_ids:
		var leader: Leader = LeaderManager.get_leader(leader_id)
		if leader == null:
			continue
		if (
			not needle.is_empty()
			and needle not in leader.name.to_lower()
			and needle not in leader_id.to_lower()
		):
			continue

		var suffix := ""
		if not leader.assigned_army_id.is_empty():
			suffix = " (assigned)"
		var item_index := leader_list.add_item(
			"%s (%s)%s" % [leader.name, leader.leader_type, suffix]
		)
		leader_list.set_item_metadata(item_index, leader_id)


func _on_search_changed(new_text: String) -> void:
	_populate_list(new_text)


func _on_leader_selected(index: int) -> void:
	selected_leader_id = ""
	confirm_button.disabled = true

	if index < 0:
		return

	var metadata: Variant = leader_list.get_item_metadata(index)
	if metadata == null:
		return

	var leader_id := str(metadata)
	if leader_id.is_empty():
		return

	selected_leader_id = leader_id
	confirm_button.disabled = false


func _on_confirm_pressed() -> void:
	if selected_leader_id.is_empty():
		return

	if not position_key.is_empty():
		var check: Dictionary = LeaderManager.can_assign_national_position(
			country_tag,
			position_key,
			selected_leader_id,
		)
		if not bool(check.get("can_assign", false)):
			push_warning("Cannot assign position: %s" % check.get("reason", "unknown"))
			return

		if LeaderManager.set_country_position(country_tag, position_key, selected_leader_id, false):
			_refresh_leader_screen()
	else:
		leader_selected.emit(selected_leader_id)

	queue_free()


func _refresh_leader_screen() -> void:
	var main_screen: Node = get_tree().get_first_node_in_group("leader_screen")
	if main_screen != null and main_screen.has_method("refresh_screen"):
		main_screen.call("refresh_screen")


func _on_cancel_pressed() -> void:
	queue_free()
