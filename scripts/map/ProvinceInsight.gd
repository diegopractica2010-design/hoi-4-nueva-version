class_name ProvinceInsight
extends RefCounted

## Formats province hover tooltips and info-panel copy from Province gameplay getters.


static func build_hover_tooltip(
	province: Province,
	selected_province_id: int = -1,
	other_province: Province = null,
) -> String:
	if province == null:
		return ""
	var lines: PackedStringArray = []
	lines.append("%s  (#%d)" % [province.name, province.id])
	lines.append(_owner_controller_line(province))
	lines.append(
		"Dev %d  ·  Infra %d  ·  VP %d"
		% [province.development_level, province.infrastructure, province.victory_points]
	)
	lines.append(_logistics_summary_line(province))
	lines.append(_combat_modifier_line(province))
	lines.append("Movement cost: %.2f" % province.get_movement_cost())
	lines.append(_depot_summary_line(province.id))

	lines.append("")
	if other_province != null and other_province.id != province.id:
		lines.append(_battle_preview_block(province, other_province, selected_province_id))
	else:
		lines.append(_local_battle_block(province))

	return "\n".join(lines)


static func build_info_logistics_text(province: Province) -> String:
	if province == null:
		return ""
	var parts: PackedStringArray = []
	parts.append(
		"Infrastructure: %d  ·  Development: %d"
		% [province.infrastructure, province.development_level]
	)
	parts.append(_logistics_summary_line(province))
	parts.append(_depot_summary_line(province.id))
	if province.resolve_has_port():
		parts.append("Coastal access: yes")
	return "\n".join(parts)


static func build_info_combat_text(
	province: Province,
	selected_province_id: int = -1,
) -> String:
	if province == null:
		return ""
	var lines: PackedStringArray = []
	lines.append(_combat_modifier_line(province))
	lines.append(_terrain_width_line(province.terrain))

	var other := _resolve_battle_counterpart(province, selected_province_id)
	if other != null:
		lines.append("")
		lines.append(_battle_preview_block(province, other, selected_province_id))
	else:
		lines.append("")
		lines.append(_local_battle_block(province))
	return "\n".join(lines)


static func get_battle_preview(
	attacker: Province,
	defender: Province,
) -> Dictionary:
	if attacker == null or defender == null:
		return {}
	var terrain := defender.terrain if not defender.terrain.is_empty() else attacker.terrain
	var resolver := CombatResolver.new()
	var rules_width := resolver.get_combat_width_for_battle(attacker.id, defender.id, terrain)
	resolver.free()

	var calc_display := CombatWidthCalculator.new()
	var terrain_mod := calc_display.get_terrain_width_modifier(terrain)
	calc_display.free()

	var prov_mult := (attacker.get_combat_width_modifier() + defender.get_combat_width_modifier()) * 0.5
	return {
		"terrain": terrain,
		"terrain_width_modifier": terrain_mod,
		"rules_engagement_width": rules_width,
		"province_width_multiplier": prov_mult,
		"estimated_effective_width": rules_width,
		"attacker_infra": attacker.infrastructure,
		"defender_infra": defender.infrastructure,
		"attacker_dev": attacker.development_level,
		"defender_dev": defender.development_level,
	}


static func _owner_controller_line(province: Province) -> String:
	var owner := province.owner_tag if not province.owner_tag.is_empty() else "—"
	var ctrl := province.controller_tag if not province.controller_tag.is_empty() else owner
	if ctrl == owner:
		return "Owner: %s" % owner
	return "Owner: %s  ·  Controller: %s" % [owner, ctrl]


static func _logistics_summary_line(province: Province) -> String:
	return (
		"Supply throughput ×%.2f  ·  Local gen +%.0f%%  ·  Logistics %.0f"
		% [
			province.get_supply_throughput_modifier(),
			province.get_local_supply_generation_modifier() * 100.0,
			province.get_logistics_quality(),
		]
	)


static func _combat_modifier_line(province: Province) -> String:
	return (
		"Width ×%.2f  ·  Org recovery ×%.2f  ·  Attrition ×%.2f"
		% [
			province.get_combat_width_modifier(),
			province.get_organization_recovery_modifier(),
			province.get_attrition_modifier(),
		]
	)


static func _terrain_width_line(terrain: String) -> String:
	var calc := CombatWidthCalculator.new()
	var mod := calc.get_terrain_width_modifier(terrain)
	calc.free()
	return "Terrain (%s) width mod: ×%.2f" % [terrain.capitalize(), mod]


static func _depot_summary_line(province_id: int) -> String:
	var sm := _supply_manager()
	if sm == null:
		return "Supply depot: (network not built)"
	var depot: ProvinceDepotState = sm.get_depot_state(province_id)
	if depot == null:
		return "Supply depot: not a hub"
	return (
		"Depot: %d%% full  ·  %.0f t/day throughput  ·  cap %.0f"
		% [int(round(depot.fill_ratio() * 100.0)), depot.throughput_capacity, depot.storage_capacity]
	)


static func _local_battle_block(province: Province) -> String:
	var preview := get_battle_preview(province, province)
	return _format_preview_header("Local engagement", preview)


static func _battle_preview_block(
	hovered: Province,
	counterpart: Province,
	selected_province_id: int,
) -> String:
	var attacker := hovered
	var defender := counterpart
	var title := "Battle preview"
	if selected_province_id == hovered.id:
		title = "If attacked from %s" % counterpart.name
		attacker = counterpart
		defender = hovered
	elif selected_province_id == counterpart.id:
		title = "If attacking %s" % hovered.name
		attacker = counterpart
		defender = hovered
	else:
		title = "%s vs %s" % [counterpart.name, hovered.name]
	var preview := get_battle_preview(attacker, defender)
	return _format_preview_header(title, preview)


static func _format_preview_header(title: String, preview: Dictionary) -> String:
	if preview.is_empty():
		return "%s: unavailable" % title
	var lines: PackedStringArray = []
	lines.append("%s" % title)
	lines.append(
		"  Engagement width: %.1f"
		% float(preview.get("estimated_effective_width", preview.get("rules_engagement_width", 0.0)))
	)
	lines.append(
		"  %s ×%.2f  ·  Infra %d vs %d  ·  Dev %d vs %d"
		% [
			str(preview.get("terrain", "plains")).capitalize(),
			float(preview.get("terrain_width_modifier", 1.0)),
			int(preview.get("attacker_infra", 0)),
			int(preview.get("defender_infra", 0)),
			int(preview.get("attacker_dev", 0)),
			int(preview.get("defender_dev", 0)),
		]
	)
	lines.append(
		"  Province width mult (avg): ×%.2f"
		% float(preview.get("province_width_multiplier", 1.0))
	)
	return "\n".join(lines)


static func _resolve_battle_counterpart(
	province: Province,
	selected_province_id: int,
) -> Province:
	if selected_province_id < 0 or selected_province_id == province.id:
		return null
	var loader := _scenario_loader()
	if loader == null or not loader.provinces.has(selected_province_id):
		return null
	if loader.adjacency != null and not loader.adjacency.are_adjacent(province.id, selected_province_id):
		return null
	return loader.provinces[selected_province_id] as Province


static func _supply_manager() -> Node:
	var tree := Engine.get_main_loop()
	if tree == null:
		return null
	return tree.root.get_node_or_null("SupplyManager")


static func _scenario_loader() -> ScenarioLoader:
	var tree := Engine.get_main_loop()
	if tree == null:
		return null
	var node: Node = tree.root.find_child("ScenarioLoader", true, false)
	return node as ScenarioLoader
