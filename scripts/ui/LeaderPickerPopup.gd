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

var _leader_ids: Array[String] = []
var _filtered_ids: Array[String] = []
var _selected_leader_id: String = ""


func _ready() -> void:
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

	if not dialog_title.is_empty():
		title_label.text = dialog_title
		title = dialog_title

	_load_leaders()


func _load_leaders() -> void:
	_leader_ids.clear()
	_selected_leader_id = ""

	for leader in LeaderManager.get_leaders_for_country(country_tag):
		if leader.is_captured or leader.is_injured:
			continue
		_leader_ids.append(leader.leader_id)

	_leader_ids.sort()
	_apply_filter("")


func _apply_filter(search_text: String) -> void:
	_filtered_ids.clear()
	var needle := search_text.strip_edges().to_lower()

	for leader_id in _leader_ids:
		var leader: Leader = LeaderManager.get_leader(leader_id)
		if leader == null:
			continue
		if needle.is_empty() or needle in leader.name.to_lower() or needle in leader_id.to_lower():
			_filtered_ids.append(leader_id)

	leader_list.clear()
	for leader_id in _filtered_ids:
		var leader: Leader = LeaderManager.get_leader(leader_id)
		if leader == null:
			continue
		var suffix := ""
		if not leader.assigned_army_id.is_empty():
			suffix = " (assigned)"
		leader_list.add_item("%s — %s%s" % [leader.name, leader.leader_type, suffix], null, false)

	_selected_leader_id = ""
	confirm_button.disabled = true


func _on_search_changed(new_text: String) -> void:
	_apply_filter(new_text)


func _on_leader_selected(index: int) -> void:
	if index < 0 or index >= _filtered_ids.size():
		return
	_selected_leader_id = _filtered_ids[index]
	confirm_button.disabled = _selected_leader_id.is_empty()


func _on_confirm_pressed() -> void:
	if _selected_leader_id.is_empty():
		return
	leader_selected.emit(_selected_leader_id)
	queue_free()


func _on_cancel_pressed() -> void:
	queue_free()
