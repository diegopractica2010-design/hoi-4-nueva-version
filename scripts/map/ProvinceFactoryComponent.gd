# scripts/map/ProvinceFactoryComponent.gd
## Per-province factory list; registers with [FactoryManager] autoload.
##
## Example (map/scenario loader, province_id is int):
##   var comp = FactoryManager.get_or_create_province_component(province_node, 42)
##   var f = FactoryManager.create_factory_for_province(42, "GER")  # factory_id e.g. 4201
##   comp.add_factory(f)
class_name ProvinceFactoryComponent
extends Node

@export var province_id: int = 0
@export var max_factories: int = 5

var factories: Array[Factory] = []


func _ready() -> void:
	if province_id == 0:
		push_warning("ProvinceFactoryComponent has no province_id set")


func add_factory(factory: Factory) -> void:
	if factory == null:
		return
	if factories.size() >= max_factories:
		push_warning("Province %d already at max factories" % province_id)
		return
	if factory.province_id == 0:
		factory.province_id = province_id
	factories.append(factory)
	var mgr := _factory_manager()
	if mgr:
		mgr.register_factory(factory)


func get_factories() -> Array[Factory]:
	return factories


func get_active_factories() -> Array[Factory]:
	return factories.filter(func(f: Factory) -> bool: return f.current_damage < 100.0)


func capture_all_factories(new_owner: String, is_annexed: bool = false) -> void:
	var mgr := _factory_manager()
	if mgr and mgr.has_method("capture_province_factories"):
		mgr.capture_province_factories(province_id, new_owner, is_annexed)
		return
	for f in factories:
		var old := f.owner_tag
		f.owner_tag = new_owner
		f.is_seized = true
		f.is_annexed = is_annexed
		f.start_repair()
		if mgr:
			mgr.factory_captured.emit(f.factory_id, old, new_owner)


func _factory_manager() -> Node:
	return get_node_or_null("/root/FactoryManager")
