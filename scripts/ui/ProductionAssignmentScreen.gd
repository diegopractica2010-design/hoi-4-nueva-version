# scripts/ui/ProductionAssignmentScreen.gd
class_name ProductionAssignmentScreen
extends Control

@export var country_tag: String = "GER"

@onready var total_factories_label: Label = $TopSummaryBar/TotalFactoriesLabel
@onready var avg_efficiency_label: Label = $TopSummaryBar/AverageEfficiencyLabel
@onready var retooling_label: Label = $TopSummaryBar/RetoolingLabel
@onready var daily_output_label: Label = $TopSummaryBar/DailyOutputLabel

@onready var status_filter: OptionButton = $FilterBar/StatusFilter
@onready var type_filter: OptionButton = $FilterBar/TypeFilter
@onready var search_edit: LineEdit = $FilterBar/SearchEdit

@onready var factory_list: VBoxContainer = $MainArea/FactoryListColumn/FactoryList/FactoryListContent
@onready var detail_label: Label = $MainArea/DetailPanel/DetailLabel

var current_data: ProductionScreenData
var filtered_factories: Array[Dictionary] = []

const COL_PROVINCE := 80
const COL_DESIGN := 180
const COL_EFFICIENCY := 80
const COL_RETOOL := 60
const COL_OUTPUT := 80
const COL_BUTTON := 80
const ROW_HEIGHT := 32


func _ready() -> void:
	_setup_filters()
	status_filter.item_selected.connect(_on_filter_changed)
	type_filter.item_selected.connect(_on_filter_changed)
	search_edit.text_changed.connect(_on_filter_changed)
	if not ProductionManager.day_advanced.is_connected(_on_day_advanced):
		ProductionManager.day_advanced.connect(_on_day_advanced)
	refresh_screen()


func _exit_tree() -> void:
	if ProductionManager.day_advanced.is_connected(_on_day_advanced):
		ProductionManager.day_advanced.disconnect(_on_day_advanced)


func _on_day_advanced(_report: Dictionary) -> void:
	refresh_screen()


func refresh_screen() -> void:
	current_data = ProductionManager.get_production_screen_data(country_tag, false)
	_update_summary_bar()
	_apply_filters()


func _setup_filters() -> void:
	status_filter.clear()
	status_filter.add_item("All")
	status_filter.add_item("producing")
	status_filter.add_item("retooling")
	status_filter.add_item("idle")
	status_filter.add_item("low_efficiency")

	type_filter.clear()
	type_filter.add_item("All")
	type_filter.add_item("shipyard")
	type_filter.add_item("tank_factory")
	type_filter.add_item("aircraft_factory")
	type_filter.add_item("general_factory")


func _update_summary_bar() -> void:
	if current_data == null:
		return

	total_factories_label.text = "Factories: %d" % current_data.total_factories
	avg_efficiency_label.text = "Avg Efficiency: %.1f%%" % (current_data.average_efficiency * 100.0)
	avg_efficiency_label.modulate = _efficiency_color(current_data.average_efficiency)

	retooling_label.text = "Retooling: %d" % current_data.factories_in_retooling
	if current_data.has_many_retooling:
		retooling_label.modulate = Color.YELLOW
	else:
		retooling_label.modulate = Color.WHITE

	daily_output_label.text = "Daily Output: %.1f" % current_data.estimated_daily_output


func _apply_filters() -> void:
	filtered_factories.clear()
	if current_data == null:
		_populate_factory_list()
		return

	var status_filter_text := status_filter.get_item_text(status_filter.selected)
	var type_filter_text := type_filter.get_item_text(type_filter.selected)
	var search_text := search_edit.text.strip_edges().to_lower()

	for factory in current_data.factories:
		if not _matches_status_filter(factory, status_filter_text):
			continue
		if not _matches_type_filter(factory, type_filter_text):
			continue
		if not search_text.is_empty() and not _matches_search(factory, search_text):
			continue
		filtered_factories.append(factory)

	_populate_factory_list()


func _matches_status_filter(factory: Dictionary, status_filter_text: String) -> bool:
	if status_filter_text == "All":
		return true
	if status_filter_text == "low_efficiency":
		return float(factory.get("efficiency", 1.0)) < 0.4
	return factory.get("status", "") == status_filter_text


func _matches_type_filter(factory: Dictionary, type_filter_text: String) -> bool:
	if type_filter_text == "All":
		return true
	return factory.get("factory_type", "") == type_filter_text


func _matches_search(factory: Dictionary, search_text: String) -> bool:
	var design := str(factory.get("current_design", "")).to_lower()
	var province := str(factory.get("province_id", ""))
	return search_text in design or search_text in province


func _populate_factory_list() -> void:
	for child in factory_list.get_children():
		child.queue_free()

	for factory_summary in filtered_factories:
		factory_list.add_child(_create_factory_row(factory_summary))


func _create_factory_row(summary: Dictionary) -> HBoxContainer:
	var hbox := HBoxContainer.new()
	hbox.custom_minimum_size = Vector2(0, ROW_HEIGHT)
	hbox.add_theme_constant_override("separation", 8)

	hbox.add_child(_column_label(str(summary.get("province_id", "?")), COL_PROVINCE))

	var design_text: String = summary.get("current_design", "")
	if design_text.is_empty():
		design_text = "(idle)"
	hbox.add_child(_column_label(design_text, COL_DESIGN))

	var efficiency := float(summary.get("efficiency", 0.0))
	var eff_label := _column_label("%.1f%%" % (efficiency * 100.0), COL_EFFICIENCY)
	eff_label.modulate = _efficiency_color(efficiency)
	hbox.add_child(eff_label)

	var retool_text := "Yes" if summary.get("is_retooling", false) else "No"
	hbox.add_child(_column_label(retool_text, COL_RETOOL))
	hbox.add_child(
		_column_label("%.1f" % float(summary.get("daily_output_estimate", 0.0)), COL_OUTPUT)
	)

	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.add_child(spacer)

	var change_btn := Button.new()
	change_btn.text = "Change"
	change_btn.custom_minimum_size = Vector2(COL_BUTTON, 0)
	change_btn.pressed.connect(_on_change_pressed.bind(summary))
	hbox.add_child(change_btn)

	var details_btn := Button.new()
	details_btn.text = "Details"
	details_btn.custom_minimum_size = Vector2(COL_BUTTON, 0)
	details_btn.pressed.connect(_on_details_pressed.bind(summary))
	hbox.add_child(details_btn)

	return hbox


func _column_label(text: String, min_width: int) -> Label:
	var label := Label.new()
	label.text = text
	label.custom_minimum_size = Vector2(min_width, 0)
	label.clip_text = true
	return label


func _efficiency_color(efficiency: float) -> Color:
	if efficiency >= 0.8:
		return Color.GREEN
	if efficiency >= 0.5:
		return Color.YELLOW
	return Color.RED


func _on_details_pressed(summary: Dictionary) -> void:
	var design: String = summary.get("current_design", "")
	if design.is_empty():
		design = "(idle)"

	var text := "Factory ID: %s\n" % summary.get("factory_id", "?")
	text += "Province: %s\n" % summary.get("province_id", "?")
	text += "Type: %s\n" % summary.get("factory_type", "unknown")
	text += "Status: %s\n" % summary.get("status", "unknown")
	text += "Current Design: %s\n" % design
	text += "Efficiency: %.1f%%\n" % (float(summary.get("efficiency", 0.0)) * 100.0)
	text += "Retooling: %s\n" % ("Yes" if summary.get("is_retooling", false) else "No")
	text += "Lines: %d / %d\n" % [
		int(summary.get("assigned_lines", 0)),
		int(summary.get("max_lines", 1)),
	]
	text += "Daily Output: %.1f" % float(summary.get("daily_output_estimate", 0.0))
	detail_label.text = text


func _on_change_pressed(summary: Dictionary) -> void:
	print("Change production for factory:", summary.get("factory_id"))
	# TODO: Open design picker + show retooling warning popup


func _on_filter_changed(_value: Variant = null) -> void:
	_apply_filters()
