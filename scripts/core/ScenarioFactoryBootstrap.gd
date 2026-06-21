class_name ScenarioFactoryBootstrap
extends RefCounted

const TOP_INDUSTRIAL_TAGS: Array[String] = ["USA", "GER", "ENG", "SOV", "JAP"]
const TOP_NAVAL_SHIPYARD_TAGS: Array[String] = ["USA", "ENG", "JAP"]
const SECOND_TIER_NAVAL_TAGS: Array[String] = ["GER", "ITA", "FRA"]
const DEFAULT_NAVAL_POWER_TAGS: Array[String] = ["USA", "ENG", "JAP", "GER", "ITA", "FRA"]


static func spawn_factories(
	scenario_name: String,
	scenario_data: Dictionary,
	scenario_loader: ScenarioLoader,
) -> void:
	var factory_manager := _factory_manager()
	if factory_manager == null:
		push_warning("ScenarioFactoryBootstrap: FactoryManager autoload not available")
		return

	if scenario_loader != null:
		factory_manager.set_province_lookup(func(province_id: int) -> Province:
			return scenario_loader.provinces.get(province_id) as Province
		)

	var entries := _iter_countries(scenario_data)
	if entries.is_empty():
		push_warning("ScenarioFactoryBootstrap: no countries available for " + scenario_name)
		return

	var factories_created := 0
	var shipyards_created := 0
	var provinces_touched := 0

	for country in entries:
		var country_tag := str(country.get("tag", "")).strip_edges().to_upper()
		if country_tag.is_empty():
			continue

		var is_major_power := bool(country.get("major_power", _default_major_power(country_tag)))
		var is_naval_power := bool(country.get("naval_power", _default_naval_power(country_tag)))
		var key_provinces := _resolve_key_provinces(country)
		if key_provinces.is_empty():
			continue

		var base_factories := _base_factory_count(country, is_major_power, country_tag)
		var province_count := maxi(key_provinces.size(), 1)
		var factories_per_province: int = maxi(1, int(float(base_factories) / float(province_count)))

		for province_id in key_provinces:
			var created: Array[Factory] = factory_manager.register_factories_for_province(
				province_id,
				country_tag,
				factories_per_province,
			)
			factories_created += created.size()
			provinces_touched += 1

		if is_naval_power:
			for province_id in key_provinces:
				if not _province_has_port(province_id, scenario_loader):
					continue
				var shipyard: Factory = factory_manager.create_shipyard_for_province(
					province_id,
					country_tag,
					_shipyard_levels_for_country(country_tag),
				)
				if shipyard != null:
					shipyards_created += 1

	print(
		"ScenarioFactoryBootstrap: %s - %d factories, %d shipyards across %d province entries"
		% [scenario_name, factories_created, shipyards_created, provinces_touched]
	)


static func _iter_countries(data: Dictionary) -> Array[Dictionary]:
	var out: Array[Dictionary] = []
	var countries_block: Variant = data.get("countries", [])
	if typeof(countries_block) == TYPE_ARRAY:
		for country in countries_block as Array:
			if typeof(country) == TYPE_DICTIONARY:
				out.append(country as Dictionary)
	elif typeof(countries_block) == TYPE_DICTIONARY:
		for tag in (countries_block as Dictionary).keys():
			var country: Variant = (countries_block as Dictionary)[tag]
			if typeof(country) != TYPE_DICTIONARY:
				continue
			var d: Dictionary = (country as Dictionary).duplicate(true)
			if not d.has("tag"):
				d["tag"] = str(tag)
			out.append(d)
	return out


static func _resolve_key_provinces(country: Dictionary) -> Array[int]:
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


static func _base_factory_count(country: Dictionary, is_major_power: bool, country_tag: String) -> int:
	var industrial_weight := maxi(int(country.get("industrial_weight", 1)), 1)
	var base_factories := 2
	if is_major_power:
		base_factories = 6
	if country_tag in TOP_INDUSTRIAL_TAGS:
		base_factories += 3
	return base_factories * industrial_weight


static func _shipyard_levels_for_country(country_tag: String) -> int:
	if country_tag in TOP_NAVAL_SHIPYARD_TAGS:
		return 5
	if country_tag in SECOND_TIER_NAVAL_TAGS:
		return 4
	return 3


static func _default_major_power(country_tag: String) -> bool:
	return country_tag in TOP_INDUSTRIAL_TAGS


static func _default_naval_power(country_tag: String) -> bool:
	return country_tag in DEFAULT_NAVAL_POWER_TAGS


static func _province_has_port(province_id: int, scenario_loader: ScenarioLoader) -> bool:
	if scenario_loader != null and scenario_loader.provinces.has(province_id):
		var province: Province = scenario_loader.provinces[province_id]
		return province != null and province.resolve_has_port()
	return false


static func _factory_manager() -> Node:
	var tree := Engine.get_main_loop()
	if tree == null:
		return null
	return tree.root.get_node_or_null("FactoryManager")
