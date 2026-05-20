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
var _province_lookup: Callable = Callable()


func _ready() -> void:
	_load_rules()


func set_province_lookup(callable: Callable) -> void:
	_province_lookup = callable


func get_province(province_id: int) -> Province:
	if _province_lookup.is_valid():
		var result: Variant = _province_lookup.call(province_id)
		return result as Province
	return null


func province_has_port(province_id: int) -> bool:
	var province := get_province(province_id)
	return ProductionNavalRules.province_allows_shipyard(province)


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
	_invalidate_production_cache_for_owner(factory.owner_tag)


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
	_invalidate_production_cache_for_owner(f.owner_tag)


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
		_invalidate_production_cache_for_owner(old_owner)
		if new_owner != old_owner:
			_invalidate_production_cache_for_owner(new_owner)
		factory_captured.emit(fid, old_owner, new_owner)


func advance_repair_for_province(province_id: int, days: float, supply_connected: bool) -> void:
	if not province_to_factories.has(province_id):
		return
	for fid in province_to_factories[province_id]:
		var f: Factory = factories.get(fid)
		if f == null:
			continue
		var was_damaged := f.current_damage > 0.0
		f.advance_repair(days, supply_connected, rules)
		if was_damaged and f.current_damage <= 0.0:
			_invalidate_production_cache_for_owner(f.owner_tag)
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
		if f == null:
			continue
		var old_retooling := f.is_retooling
		f.advance_retooling(days)
		if old_retooling != f.is_retooling or f.is_retooling:
			_invalidate_production_cache_for_owner(f.owner_tag)


func assign_production_line_to_factory(factory_id: int, line_id: String) -> bool:
	var f: Factory = factories.get(factory_id)
	if f == null:
		return false
	if f.has_assigned_line(line_id):
		return true
	if not f.can_add_more_lines():
		push_warning(
			"FactoryManager: factory %d at max production lines (%d)"
			% [factory_id, f.max_production_lines],
		)
		return false
	f.assigned_lines.append(line_id)
	return true


func get_default_max_lines_for_type(factory_type: String) -> int:
	var type_rules: Dictionary = rules.get("factory_types", {}).get(factory_type, {})
	if typeof(type_rules) == TYPE_DICTIONARY and type_rules.has("max_production_lines"):
		return int(type_rules.get("max_production_lines", 1))
	return 1


func create_factory_for_province(
	province_id: int,
	owner_tag: String,
	factory_id: int = 0,
	factory_type: String = "standard",
	max_production_lines: int = -1,
) -> Factory:
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
	new_factory.factory_type = factory_type
	new_factory.max_production_lines = (
		max_production_lines if max_production_lines > 0 else get_default_max_lines_for_type(factory_type)
	)
	new_factory.current_damage = 0.0
	new_factory.is_seized = false
	register_factory(new_factory)
	return new_factory


func create_shipyard_for_province(province_id: int, owner_tag: String, levels: int = 4) -> Factory:
	if not province_has_port(province_id):
		push_warning(
			"FactoryManager: cannot build shipyard in province %d (no port / coastal access)"
			% province_id
		)
		return null
	return create_factory_for_province(province_id, owner_tag, 0, "shipyard", levels)


func convert_factory_to_shipyard(factory_id: int, levels: int = 4) -> bool:
	var factory := get_factory(factory_id)
	if factory == null:
		return false
	if not province_has_port(factory.province_id):
		push_warning(
			"FactoryManager: cannot convert factory %d to shipyard (province %d has no port)"
			% [factory_id, factory.province_id]
		)
		return false
	if factory.factory_type == "shipyard":
		return true
	factory.factory_type = "shipyard"
	factory.max_production_lines = (
		levels if levels > 0 else get_default_max_lines_for_type("shipyard")
	)
	_invalidate_production_cache_for_owner(factory.owner_tag)
	print(
		"Factory %d converted to shipyard (max lines: %d)"
		% [factory_id, factory.max_production_lines]
	)
	return true


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


func _invalidate_production_cache_for_owner(owner_tag: String) -> void:
	if owner_tag.is_empty():
		return
	var production_mgr := get_node_or_null("/root/ProductionManager")
	if production_mgr != null and production_mgr.has_method("invalidate_production_cache"):
		production_mgr.invalidate_production_cache(owner_tag)
