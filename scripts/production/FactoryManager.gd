# scripts/production/FactoryManager.gd
class_name FactoryManager
extends Node

signal factory_captured(factory_id: String, old_owner: String, new_owner: String)
signal factory_repaired(factory_id: String)
signal factory_damaged(factory_id: String, damage_amount: float)

@export var factory_rules_path: String = "res://data/production/factory_rules.json"

var factories: Dictionary = {}  # factory_id -> Factory
var province_to_factories: Dictionary = {}  # province_id (int) -> Array[String] factory_ids

var rules: Dictionary = {}


func _ready() -> void:
	_load_rules()


func _load_rules() -> void:
	rules = {}
	if not ResourceLoader.exists(factory_rules_path):
		push_warning("FactoryManager: rules file missing: ", factory_rules_path)
		return
	var file := FileAccess.open(factory_rules_path, FileAccess.READ)
	if file == null:
		return
	var parser := JSON.new()
	if parser.parse(file.get_as_text()) == OK and typeof(parser.data) == TYPE_DICTIONARY:
		rules = parser.data
	else:
		push_warning("FactoryManager: invalid JSON at ", factory_rules_path)


func register_factory(factory: Factory) -> void:
	if factory == null or factory.factory_id.is_empty():
		return
	factories[factory.factory_id] = factory
	var pid := factory.province_id
	if not province_to_factories.has(pid):
		province_to_factories[pid] = []
	var ids: Array = province_to_factories[pid]
	if factory.factory_id not in ids:
		ids.append(factory.factory_id)


func get_factories_in_province(province_id: int) -> Array[Factory]:
	var result: Array[Factory] = []
	if not province_to_factories.has(province_id):
		return result
	for fid in province_to_factories[province_id]:
		var f: Factory = factories.get(fid)
		if f != null:
			result.append(f)
	return result


func apply_damage_to_factory(factory_id: String, damage: float) -> void:
	var f: Factory = factories.get(factory_id)
	if f == null:
		return
	f.apply_damage(damage)
	factory_damaged.emit(factory_id, damage)


func capture_province_factories(province_id: int, new_owner: String, is_annexed: bool = false) -> void:
	if not province_to_factories.has(province_id):
		return
	for fid in province_to_factories[province_id]:
		var f: Factory = factories.get(fid)
		if f == null:
			continue
		var old_owner := f.owner_tag
		f.owner_tag = new_owner
		f.is_seized = true
		f.is_annexed = is_annexed
		f.start_repair()
		factory_captured.emit(fid, old_owner, new_owner)


func advance_repair_for_province(province_id: int, days: float, supply_connected: bool) -> void:
	if not province_to_factories.has(province_id):
		return
	for fid in province_to_factories[province_id]:
		var f: Factory = factories.get(fid)
		if f == null:
			continue
		var damage_before := f.current_damage
		f.advance_repair(days, supply_connected, rules)
		if damage_before > 0.0 and f.current_damage <= 0.0:
			factory_repaired.emit(fid)


func get_factory_efficiency(factory_id: String) -> float:
	var f: Factory = factories.get(factory_id)
	if f != null:
		return f.current_efficiency
	return 1.0


func assign_production_line_to_factory(factory_id: String, line_id: String) -> bool:
	var f: Factory = factories.get(factory_id)
	if f == null:
		return false
	if line_id not in f.assigned_lines:
		f.assigned_lines.append(line_id)
		return true
	return false


func create_factory_for_province(province_id: int, owner_tag: String, factory_id: String = "") -> Factory:
	var new_factory := Factory.new()
	new_factory.factory_id = factory_id if factory_id != "" else "factory_%d_%d" % [province_id, Time.get_unix_time_from_system()]
	new_factory.province_id = province_id
	new_factory.owner_tag = owner_tag
	new_factory.current_damage = 0.0
	new_factory.is_seized = false
	register_factory(new_factory)
	return new_factory


func get_or_create_province_component(province_node: Node, province_id: int) -> ProvinceFactoryComponent:
	var comp: ProvinceFactoryComponent = province_node.get_node_or_null("ProvinceFactoryComponent") as ProvinceFactoryComponent
	if comp == null:
		comp = ProvinceFactoryComponent.new()
		comp.name = "ProvinceFactoryComponent"
		comp.province_id = province_id
		province_node.add_child(comp)
	return comp


func register_factories_for_province(province_id: int, owner_tag: String, count: int = 1) -> Array[Factory]:
	var created: Array[Factory] = []
	for i in count:
		var f := create_factory_for_province(province_id, owner_tag)
		created.append(f)
	return created
