# scripts/scenarios/ScenarioFactorySpawner.gd
class_name ScenarioFactorySpawner
extends Node

const DEFAULT_SCENARIO := "1936"
const TOP_INDUSTRIAL_TAGS: Array[String] = ["USA", "GER", "ENG", "SOV", "JAP"]
const TOP_NAVAL_SHIPYARD_TAGS: Array[String] = ["USA", "ENG", "JAP"]
const SECOND_TIER_NAVAL_TAGS: Array[String] = ["GER", "ITA", "FRA"]
const DEFAULT_NAVAL_POWER_TAGS: Array[String] = ["USA", "ENG", "JAP", "GER", "ITA", "FRA"]
const FALLBACK_PORT_PROVINCES: Array[int] = [
	5, 9, 11, 17, 23, 26, 33, 34, 42, 55, 69, 74, 87, 96, 101, 120, 150, 205, 310,
]


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

	if not data.has("countries"):
		push_warning("ScenarioFactorySpawner: no countries block in " + path)
		return

	var factories_created := 0
	var shipyards_created := 0
	var provinces_touched := 0

	for country in _iter_countries(data):
		var country_tag := str(country.get("tag", ""))
		if country_tag.is_empty():
			continue

		var is_major_power := bool(country.get("major_power", _default_major_power(country_tag)))
		var is_naval_power := bool(country.get("naval_power", _default_naval_power(country_tag)))
		var key_provinces := _resolve_key_provinces(country)
		if key_provinces.is_empty():
			continue

		var base_factories := _base_factory_count(country, is_major_power, country_tag)
		var province_count := maxi(key_provinces.size(), 1)
		var factories_per_province := maxi(1, base_factories / province_count)

		for province_id in key_provinces:
			var created := factory_manager.register_factories_for_province(
				province_id, country_tag, factories_per_province,
			)
			factories_created += created.size()
			provinces_touched += 1

		if is_naval_power:
			for province_id in key_provinces:
				if not _province_has_port(province_id, data, scenario_loader):
					continue
				var shipyard_levels := _shipyard_levels_for_country(country_tag)
				var shipyard := factory_manager.create_shipyard_for_province(
					province_id, country_tag, shipyard_levels,
				)
				if shipyard != null:
					shipyards_created += 1

	print(
		"ScenarioFactorySpawner: %s — %d factories, %d shipyards across %d province entries"
		% [scenario_name, factories_created, shipyards_created, provinces_touched]
	)


func _iter_countries(data: Dictionary) -> Array:
	var out: Array = []
	var countries_block: Variant = data.get("countries", [])
	if typeof(countries_block) == TYPE_ARRAY:
		for country in countries_block:
			if typeof(country) == TYPE_DICTIONARY:
				out.append(country)
	elif typeof(countries_block) == TYPE_DICTIONARY:
		for tag in countries_block:
			var country: Variant = countries_block[tag]
			if typeof(country) != TYPE_DICTIONARY:
				continue
			var d: Dictionary = country as Dictionary
			if not d.has("tag"):
				d["tag"] = str(tag)
			out.append(d)
	return out


func _resolve_key_provinces(country: Dictionary) -> Array[int]:
	var key_provinces: Variant = country.get("key_provinces", [])
	if typeof(key_provinces) == TYPE_ARRAY and not (key_provinces as Array).is_empty():
		var out: Array[int] = []
		for raw_id in key_provinces as Array:
			var pid := int(raw_id)
			if pid > 0:
				out.append(pid)
		return out

	var capital := int(country.get("capital_province_id", 0))
	if capital > 0:
		return [capital]
	return []


func _base_factory_count(country: Dictionary, is_major_power: bool, country_tag: String) -> int:
	var industrial_weight := maxi(int(country.get("industrial_weight", 1)), 1)
	var base_factories := 2
	if is_major_power:
		base_factories = 6
	if country_tag in TOP_INDUSTRIAL_TAGS:
		base_factories += 3
	return base_factories * industrial_weight


func _shipyard_levels_for_country(country_tag: String) -> int:
	if country_tag in TOP_NAVAL_SHIPYARD_TAGS:
		return 5
	if country_tag in SECOND_TIER_NAVAL_TAGS:
		return 4
	return 3


func _default_major_power(country_tag: String) -> bool:
	return country_tag in TOP_INDUSTRIAL_TAGS


func _default_naval_power(country_tag: String) -> bool:
	return country_tag in DEFAULT_NAVAL_POWER_TAGS


func _province_has_port(
	province_id: int,
	scenario_data: Dictionary,
	scenario_loader: ScenarioLoader,
) -> bool:
	if scenario_loader != null and scenario_loader.provinces.has(province_id):
		var province: Province = scenario_loader.provinces[province_id]
		return province != null and province.resolve_has_port()

	var ports_block: Variant = scenario_data.get("ports", [])
	if typeof(ports_block) == TYPE_ARRAY and province_id in ports_block:
		return true

	return province_id in FALLBACK_PORT_PROVINCES


func _factory_manager() -> Node:
	var tree := Engine.get_main_loop()
	if tree == null:
		return null
	return tree.root.get_node_or_null("/root/FactoryManager")
