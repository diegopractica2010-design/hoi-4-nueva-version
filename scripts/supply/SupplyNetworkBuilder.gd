class_name SupplyNetworkBuilder
extends RefCounted

## Builds per-province supply hubs from map layers, capitals, and player depot flags.


static func build(
	provinces: Dictionary,
	countries: Dictionary,
	city_layer: Dictionary,
	player_depot_ids: Array[int],
	rules: SupplyRules,
) -> Dictionary:
	var hubs: Dictionary = {}
	var capitals := _capital_by_tag(countries)

	for pid_var in provinces:
		var province: Province = provinces[pid_var]
		if province == null:
			continue
		var hub := _hub_from_province(province, city_layer, capitals, player_depot_ids, rules)
		if hub != null:
			hubs[province.id] = hub
	return hubs


static func _capital_by_tag(countries: Dictionary) -> Dictionary:
	var out: Dictionary = {}
	for entry in countries.values():
		if entry is Country:
			var c := entry as Country
			if c.capital_province_id > 0:
				out[c.tag] = c.capital_province_id
		elif typeof(entry) == TYPE_DICTIONARY:
			var tag := str((entry as Dictionary).get("tag", ""))
			var cap := int((entry as Dictionary).get("capital_province_id", 0))
			if not tag.is_empty() and cap > 0:
				out[tag] = cap
	return out


static func _hub_from_province(
	province: Province,
	city_layer: Dictionary,
	capitals: Dictionary,
	player_depot_ids: Array[int],
	rules: SupplyRules,
) -> ProvinceSupplyHub:
	var hub := ProvinceSupplyHub.new()
	hub.province_id = province.id
	hub.owner_tag = province.controller_tag if not province.controller_tag.is_empty() else province.owner_tag
	hub.infrastructure = province.infrastructure
	hub.development_level = province.development_level

	var cap_rules := rules.get_block("depot_capacity")
	var port_lvl := 0
	var air_lvl := 0
	var space_lvl := 0
	var industry := 0

	var pid_key := str(province.id)
	if city_layer.has(pid_key):
		var entry: Dictionary = city_layer[pid_key]
		for city_var in entry.get("cities", []):
			if typeof(city_var) != TYPE_DICTIONARY:
				continue
			var city: Dictionary = city_var
			port_lvl = maxi(port_lvl, int(city.get("port_level", 0)))
			air_lvl = maxi(air_lvl, int(city.get("airport_level", 0)))
			industry += int(city.get("industry_slots", 0))

	port_lvl = maxi(port_lvl, province.get_feature_level("port"))
	air_lvl = maxi(air_lvl, province.get_feature_level("airport"))
	space_lvl = maxi(space_lvl, province.get_feature_level("spaceport"))

	hub.port_level = port_lvl
	hub.airport_level = air_lvl
	hub.spaceport_level = space_lvl
	hub.industry_slots = industry

	if capitals.get(hub.owner_tag, -1) == province.id or province.has_feature("capital"):
		hub.kinds.append(ProvinceSupplyHub.DepotKind.CAPITAL)
	if port_lvl > 0 or province.has_feature("port"):
		hub.kinds.append(ProvinceSupplyHub.DepotKind.PORT)
	if air_lvl > 0 or province.has_feature("airport"):
		hub.kinds.append(ProvinceSupplyHub.DepotKind.AIRPORT)
	if space_lvl > 0 or province.has_feature("spaceport"):
		hub.kinds.append(ProvinceSupplyHub.DepotKind.SPACEPORT)
	if industry > 0 or province.factories > 0:
		hub.kinds.append(ProvinceSupplyHub.DepotKind.CITY)

	if province.id in player_depot_ids:
		hub.is_player_depot = true
		hub.kinds.append(ProvinceSupplyHub.DepotKind.PLAYER)

	if hub.kinds.is_empty():
		return null

	hub.storage_capacity = _compute_capacity(hub, cap_rules)
	return hub


static func _compute_capacity(hub: ProvinceSupplyHub, cap_rules: Dictionary) -> float:
	var cap := float(cap_rules.get("player_depot_base", 12000.0))
	if hub.has_kind(ProvinceSupplyHub.DepotKind.CAPITAL):
		cap = float(cap_rules.get("capital_base", 50000.0))
	if hub.is_player_depot:
		cap += float(cap_rules.get("player_depot_base", 12000.0)) * 0.5
	cap += float(hub.infrastructure) * float(cap_rules.get("infrastructure_per_level", 450.0))
	cap += float(hub.port_level) * float(cap_rules.get("port_per_level", 8000.0))
	cap += float(hub.airport_level) * float(cap_rules.get("airport_per_level", 6000.0))
	cap += float(hub.spaceport_level) * float(cap_rules.get("spaceport_per_level", 12000.0))
	cap += float(hub.industry_slots) * float(cap_rules.get("city_industry_slot", 350.0))
	return cap
