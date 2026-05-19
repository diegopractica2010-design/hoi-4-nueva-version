class_name SupplyMenuPanel
extends SupplyOverlayPanel

## Supply overlay: route preview, depot stockpiles, throughput, attrition cargo.

@export var depot_label: Label
@export var attrition_label: Label
@export var mode_option: OptionButton

var _on_mode_changed: Callable = Callable()


func _ready() -> void:
	super._ready()
	if mode_option and not mode_option.item_selected.is_connected(_on_mode_item_selected):
		mode_option.item_selected.connect(_on_mode_item_selected)


func setup_mode_selector() -> void:
	if mode_option == null:
		return
	mode_option.clear()
	mode_option.add_item("Auto (best)", 0)
	mode_option.set_item_metadata(0, "")
	mode_option.add_item("Land convoy", 1)
	mode_option.set_item_metadata(1, "land")
	mode_option.add_item("Sealift", 2)
	mode_option.set_item_metadata(2, "sea")
	mode_option.add_item("Airlift", 3)
	mode_option.set_item_metadata(3, "air")


func get_selected_routing_mode() -> String:
	if mode_option == null or mode_option.selected < 0:
		return ""
	return str(mode_option.get_item_metadata(mode_option.selected))


func show_supply_state(
	plan: SupplyRoutePlan,
	depot: ProvinceDepotState,
	attrition_cargo: Dictionary,
	reroute_mode: bool,
) -> void:
	show_plan(plan, reroute_mode)
	if depot_label and depot != null:
		depot_label.text = (
			"Depot P%d: %.0f / %.0f t (%.0f%%) | in %.0f | out %.0f | cap %.0f t/day"
			% [
				depot.province_id,
				depot.stockpile,
				depot.storage_capacity,
				depot.fill_ratio() * 100.0,
				depot.inbound_per_day,
				depot.outbound_per_day,
				depot.throughput_capacity,
			]
		)
	elif depot_label:
		depot_label.text = "No depot at selected province"
	if attrition_label:
		attrition_label.text = (
			"Attrition cargo queue: %.0f t (crew %.0f, equip %.0f, supply %.0f)"
			% [
				float(attrition_cargo.get("total_tons", 0.0)),
				float(attrition_cargo.get("crew_tons", 0.0)),
				float(attrition_cargo.get("equipment_tons", 0.0)),
				float(attrition_cargo.get("supply_tons", 0.0)),
			]
		)


func set_mode_callback(cb: Callable) -> void:
	_on_mode_changed = cb


func _on_mode_item_selected(_index: int) -> void:
	if _on_mode_changed.is_valid():
		_on_mode_changed.call(get_selected_routing_mode())
