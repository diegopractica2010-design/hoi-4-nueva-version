# scripts/ui/DesignPickerPopup.gd
class_name DesignPickerPopup
extends Window

@export var factory_id: int = 0
@export var country_tag: String = "GER"

@onready var title_label: Label = $MarginContainer/VBoxContainer/TitleLabel
@onready var design_list: ItemList = $MarginContainer/VBoxContainer/DesignList
@onready var search_edit: LineEdit = $MarginContainer/VBoxContainer/SearchEdit
@onready var confirm_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/ConfirmButton
@onready var cancel_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/CancelButton
@onready var lock_hint_label: Label = $MarginContainer/VBoxContainer/LockHintLabel

var all_designs: Array[String] = []
var filtered_designs: Array[String] = []
var selected_design: String = ""


func _ready() -> void:
	title = "Select Production Design"
	close_requested.connect(_on_cancel_pressed)

	RetrowaveTheme.style_popup_root(self)
	RetrowaveTheme.style_title(title_label, RetrowaveTheme.CYAN)
	RetrowaveTheme.style_search(search_edit)
	RetrowaveTheme.style_item_list(design_list)
	RetrowaveTheme.style_primary_button(confirm_button)
	RetrowaveTheme.style_secondary_button(cancel_button)
	RetrowaveTheme.style_body_label(lock_hint_label)
	lock_hint_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	lock_hint_label.add_theme_color_override("font_color", RetrowaveTheme.TEXT_DIM)

	title_label.text = "Select New Production Design"
	search_edit.placeholder_text = "Search designs..."
	lock_hint_label.text = "Locked designs require completed research (Technology screen)."

	_load_design_catalog()
	confirm_button.disabled = true
	confirm_button.pressed.connect(_on_confirm_pressed)
	cancel_button.pressed.connect(_on_cancel_pressed)
	design_list.item_selected.connect(_on_design_selected)
	search_edit.text_changed.connect(_on_search_changed)


func _load_design_catalog() -> void:
	all_designs.clear()
	selected_design = ""

	var factory: Factory = null
	if FactoryManager != null:
		factory = FactoryManager.get_factory(factory_id)

	if GameData.design_data != null:
		for template_id in GameData.design_data.templates.keys():
			var template: UnitTemplate = GameData.design_data.get_template(template_id)
			if template == null or template.is_infantry_equipment():
				continue
			var design_id := str(template_id)
			if factory != null and ProductionNavalRules.is_naval_design(design_id):
				if not ProductionNavalRules.factory_can_build_naval(factory):
					continue
			all_designs.append(design_id)

	all_designs.sort()
	_apply_search_filter(search_edit.text)


func _design_list_label(design_id: String) -> String:
	var display := design_id
	if GameData.design_data != null:
		var template: UnitTemplate = GameData.design_data.get_template(design_id)
		if template != null and not str(template.name).is_empty():
			display = "%s (%s)" % [template.name, design_id]

	if typeof(TechnologyManager) == TYPE_NIL:
		return display

	var availability: Dictionary = TechnologyManager.get_design_availability(country_tag, design_id)
	if bool(availability.get("available", true)):
		return display
	return "%s  🔒 %s" % [display, availability.get("reason", "Locked")]


func _is_design_selectable(design_id: String) -> bool:
	if typeof(TechnologyManager) == TYPE_NIL:
		return true
	var factory: Factory = null
	if FactoryManager != null:
		factory = FactoryManager.get_factory(factory_id)
	var gate := TechnologyManager.factory_can_build_design(country_tag, factory, design_id)
	return bool(gate.get("allowed", true))


func _on_search_changed(new_text: String) -> void:
	_apply_search_filter(new_text)


func _apply_search_filter(query: String) -> void:
	design_list.clear()
	filtered_designs.clear()
	selected_design = ""

	var needle := query.strip_edges().to_lower()
	for design_id in all_designs:
		var label := _design_list_label(design_id)
		if not needle.is_empty() and not label.to_lower().contains(needle):
			continue
		filtered_designs.append(design_id)
		var idx := design_list.add_item(label)
		if not _is_design_selectable(design_id):
			design_list.set_item_disabled(idx, true)

	if filtered_designs.is_empty():
		design_list.add_item("(No matching designs)")
	confirm_button.disabled = true
	_update_lock_hint()


func _update_lock_hint() -> void:
	if selected_design.is_empty():
		lock_hint_label.text = "Locked designs require completed research (Technology screen)."
		return
	var availability: Dictionary = TechnologyManager.get_design_availability(
		country_tag,
		selected_design,
	) if typeof(TechnologyManager) != TYPE_NIL else {"available": true}
	if bool(availability.get("available", true)):
		lock_hint_label.text = "Ready to assign. Retooling time depends on design similarity."
	else:
		lock_hint_label.text = str(availability.get("reason", "Locked by technology."))


func _on_design_selected(index: int) -> void:
	if index < 0 or index >= filtered_designs.size():
		selected_design = ""
		confirm_button.disabled = true
		_update_lock_hint()
		return
	selected_design = filtered_designs[index]
	confirm_button.disabled = not _is_design_selectable(selected_design)
	_update_lock_hint()


func _on_confirm_pressed() -> void:
	if selected_design.is_empty() or not _is_design_selectable(selected_design):
		return

	var warning_scene: PackedScene = load("res://scenes/ui/RetoolingWarningPopup.tscn")
	if warning_scene == null:
		push_warning("RetoolingWarningPopup.tscn not found")
		return

	var warning: RetoolingWarningPopup = warning_scene.instantiate() as RetoolingWarningPopup
	if warning == null:
		return

	warning.factory_id = factory_id
	warning.new_design = selected_design
	get_tree().root.add_child(warning)
	warning.popup_centered()
	queue_free()


func _on_cancel_pressed() -> void:
	queue_free()
