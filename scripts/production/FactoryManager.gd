# scripts/production/FactoryManager.gd
class_name FactoryManager
extends Node

signal factory_captured(factory_id: int, old_owner: String, new_owner: String)
signal factory_repaired(factory_id: int)
signal factory_damaged(factory_id: int, damage_amount: float)

@export var factory_rules_path: String = "res://data/production/factory_rules.json"

var factories: Dictionary = {}  # factory_id (int) -> Factory
var province_to_factories: Dictionary = {}  # province_id (int) -> Array[int] factory_ids

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
	if factory == null or factory.factory_id == 0:
		return
	factories[factory.factory_id] = factory
	var pid := factory.province_id
	if not province_to_factories.has(pid):
		province_to_factories[pid] = []
	var ids: Array = province_to_factories[pid]
	if factory.factory_id not in ids:
		ids.append(factory.factory_id)


func get_factory(factory_id: int) -> Factory:
	return factories.get(factory_id)


func get_factories_in_province(province_id: int) -> Array[Factory]:
	var result: Array[Factory] = []
	if not province_to_factories.has(province_id):
		return result
	for fid in province_to_factories[province_id]:
		var f: Factory = factories.get(fid)
		if f != null:
			result.append(f)
	return result


func apply_damage_to_factory(factory_id: int, damage: float) -> void:
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


func get_factory_efficiency(factory_id: int) -> float:
	var f: Factory = factories.get(factory_id)
	if f != null:
		return f.get_production_efficiency()
	return 1.0


func advance_retooling_for_province(province_id: int, days: float) -> void:
	if not province_to_factories.has(province_id):
		return
	for fid in province_to_factories[province_id]:
		var f: Factory = factories.get(fid)
		if f != null:
			f.advance_retooling(days)


func assign_production_line_to_factory(factory_id: int, line_id: String) -> bool:
	var f: Factory = factories.get(factory_id)
	if f == null:
		return false
	if line_id not in f.assigned_lines:
		f.assigned_lines.append(line_id)
		return true
	return false


func create_factory_for_province(province_id: int, owner_tag: String, factory_id: int = 0) -> Factory:
	var fid := factory_id
	if fid == 0:
		fid = _allocate_factory_id(province_id)
	elif Factory.province_from_id(fid) != province_id:
		push_warning(
			"FactoryManager: factory_id %d does not match province_id %d; allocating new id"
			% [fid, province_id],
		)
		fid = _allocate_factory_id(province_id)
	if fid == 0:
		return null

	var new_factory := Factory.new()
	new_factory.factory_id = fid
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
		if f != null:
			created.append(f)
	return created


func _allocate_factory_id(province_id: int) -> int:
	var used: Dictionary = {}
	if province_to_factories.has(province_id):
		for fid in province_to_factories[province_id]:
			used[fid] = true
	for slot in range(1, Factory.MAX_SLOTS_PER_PROVINCE + 1):
		var candidate := Factory.make_id(province_id, slot)
		if not used.has(candidate) and not factories.has(candidate):
			return candidate
	push_warning("FactoryManager: no free factory slot in province %d" % province_id)
	return 0
