# scripts/scenarios/ScenarioFactorySpawner.gd
class_name ScenarioFactorySpawner
extends Node

const DEFAULT_SCENARIO := "1936"
const FALLBACK_PORT_PROVINCES: Array[int] = [5, 9, 11, 17, 33, 34, 42, 69]


func spawn_factories_for_scenario(
	scenario_name: String = DEFAULT_SCENARIO,
	scenario_loader: ScenarioLoader = null,
) -> void:
	var path := "res://data/scenarios/%s.json" % scenario_name
	if not ResourceLoader.exists(path):
		push_warning("ScenarioFactorySpawner: scenario file not found: " + path)
		return

	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_warning("ScenarioFactorySpawner: could not open: " + path)
		return

	var parsed: Variant = JSON.parse_string(file.get_as_text())
	file.close()
	if typeof(parsed) != TYPE_DICTIONARY:
		push_warning("ScenarioFactorySpawner: invalid JSON at " + path)
		return

	var data: Dictionary = parsed
	var factory_manager := _factory_manager()
	if factory_manager == null:
		push_warning("ScenarioFactorySpawner: FactoryManager autoload not available")
		return

	if scenario_loader != null:
		factory_manager.set_province_lookup(func(province_id: int) -> Province:
			return scenario_loader.provinces.get(province_id) as Province
		)

	var spawn_provinces := _collect_spawn_provinces(data, scenario_loader)
	var factories_created := 0
	var shipyards_created := 0

	for entry in spawn_provinces:
		var province_id := int(entry.get("province_id", 0))
		var owner_tag := str(entry.get("owner_tag", ""))
		if province_id <= 0 or owner_tag.is_empty():
			continue

		var factory_count := int(entry.get("factory_count", 2))
		var created := factory_manager.register_factories_for_province(
			province_id, owner_tag, maxi(factory_count, 1)
		)
		factories_created += created.size()

		if _province_has_port(province_id, scenario_loader):
			var shipyard := factory_manager.create_shipyard_for_province(province_id, owner_tag, 3)
			if shipyard != null:
				shipyards_created += 1

	print(
		"ScenarioFactorySpawner: %s — %d factories, %d shipyards across %d provinces"
		% [scenario_name, factories_created, shipyards_created, spawn_provinces.size()]
	)


func _collect_spawn_provinces(data: Dictionary, loader: ScenarioLoader) -> Array:
	var out: Array = []
	var seen: Dictionary = {}

	var countries_block: Variant = data.get("countries", [])
	if typeof(countries_block) == TYPE_ARRAY:
		for country in countries_block:
			if typeof(country) != TYPE_DICTIONARY:
				continue
			_add_country_spawn_entries(country as Dictionary, loader, out, seen)
	elif typeof(countries_block) == TYPE_DICTIONARY:
		for tag in countries_block:
			var country: Variant = countries_block[tag]
			if typeof(country) != TYPE_DICTIONARY:
				continue
			var d: Dictionary = country as Dictionary
			if not d.has("tag"):
				d["tag"] = str(tag)
			_add_country_spawn_entries(d, loader, out, seen)

	var provinces_block: Variant = data.get("provinces", [])
	if typeof(provinces_block) == TYPE_ARRAY:
		for p_data in provinces_block:
			if typeof(p_data) != TYPE_DICTIONARY:
				continue
			var p: Dictionary = p_data as Dictionary
			var pid := int(p.get("id", 0))
			if pid <= 0 or seen.has(pid):
				continue
			var factories := int(p.get("factories", 0))
			if factories < 25:
				continue
			var owner := str(p.get("owner_tag", p.get("controller_tag", "")))
			if owner.is_empty():
				continue
			seen[pid] = true
			out.append({
				"province_id": pid,
				"owner_tag": owner,
				"factory_count": clampi(factories / 25, 1, 4),
			})

	return out


func _add_country_spawn_entries(
	country: Dictionary,
	loader: ScenarioLoader,
	out: Array,
	seen: Dictionary,
) -> void:
	var tag := str(country.get("tag", ""))
	if tag.is_empty():
		return

	var key_provinces: Variant = country.get("key_provinces", [])
	if typeof(key_provinces) == TYPE_ARRAY:
		for raw_id in key_provinces:
			_append_spawn(out, seen, int(raw_id), tag, 2)
	elif country.has("capital_province_id"):
		_append_spawn(out, seen, int(country.get("capital_province_id", 0)), tag, 2)


func _append_spawn(out: Array, seen: Dictionary, province_id: int, owner_tag: String, count: int) -> void:
	if province_id <= 0 or seen.has(province_id):
		return
	seen[province_id] = true
	out.append({
		"province_id": province_id,
		"owner_tag": owner_tag,
		"factory_count": count,
	})


func _province_has_port(province_id: int, loader: ScenarioLoader) -> bool:
	if loader != null and loader.provinces.has(province_id):
		var province: Province = loader.provinces[province_id]
		return province != null and province.resolve_has_port()
	return province_id in FALLBACK_PORT_PROVINCES


func _factory_manager() -> FactoryManager:
	var tree := Engine.get_main_loop()
	if tree == null:
		return null
	return tree.root.get_node_or_null("/root/FactoryManager") as FactoryManager
