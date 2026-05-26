class_name MapTechnologyContext
extends RefCounted

## Bridge between map UI (ProvinceInsight, MapRenderer) and TechnologyManager.
## Keeps technology map/tooltip hooks in one place until build-mode overlays land.

const COLOR_TECH := "[color=#6ec8ff]"
const COLOR_MUTED := "[color=#8899aa]"


static func get_map_integration_note(country_tag: String) -> String:
	if typeof(TechnologyManager) == TYPE_NIL:
		return "Map build highlights: wire TechnologyManager when build mode is enabled."
	var tag := country_tag.strip_edges().to_upper()
	var n := TechnologyManager.get_active_research_count(tag)
	var completed := _completed_count(tag)
	return (
		"Map integration: province tooltips show production tech gates and active research. "
		+ "Planned: cyan highlight for provinces eligible to place %s (%d active, %d completed)."
		% [_build_target_placeholder(tag), n, completed]
	)


static func build_support_radio_glance_bbcode(country_tag: String) -> String:
	if typeof(TechnologyManager) == TYPE_NIL:
		return ""
	var tag := country_tag.strip_edges().to_upper()
	if tag.is_empty():
		return ""
	var plan := TechnologyManager.get_effective_planning_speed(tag)
	var recon := TechnologyManager.get_effective_reconnaissance(tag)
	if absf(plan) < 0.001 and absf(recon) < 0.001:
		return ""
	var parts: PackedStringArray = []
	if absf(plan) >= 0.001:
		parts.append("+%.0f%% planning" % (plan * 100.0))
	if absf(recon) >= 0.001:
		parts.append("+%.0f%% recon" % (recon * 100.0))
	return "%s📡 Support: %s[/color]" % [COLOR_TECH, " · ".join(parts)]


static func build_country_research_glance_bbcode(country_tag: String, compact: bool = false) -> String:
	if typeof(TechnologyManager) == TYPE_NIL:
		return ""
	var tag := country_tag.strip_edges().to_upper()
	var n := TechnologyManager.get_active_research_count(tag)
	if n <= 0:
		return ""
	var slots := TechnologyManager.get_research_slots_max(tag)
	var rp := TechnologyManager.get_daily_rp(tag)
	if compact:
		return "%s🔬 %d/%d · %.1f RP[/color]" % [COLOR_TECH, n, slots, rp]
	return "%s🔬 Research %d/%d slots · %.1f RP/day[/color]" % [COLOR_TECH, n, slots, rp]


static func build_province_production_tech_bbcode(province: Province, country_tag: String) -> String:
	if province == null or typeof(FactoryManager) == TYPE_NIL or typeof(TechnologyManager) == TYPE_NIL:
		return ""
	var tag := country_tag.strip_edges().to_upper()
	if tag.is_empty():
		return ""
	var factories := FactoryManager.get_factories_in_province(province.id)
	if factories.is_empty():
		return ""
	var locked_names := PackedStringArray()
	for factory in factories:
		if factory == null:
			continue
		var tid := str(factory.current_template_id).strip_edges()
		if tid.is_empty():
			continue
		var gate: Dictionary = TechnologyManager.get_design_availability(tag, tid)
		if bool(gate.get("available", true)):
			continue
		var name := str(gate.get("tech_name", gate.get("reason", "Tech"))).strip_edges()
		if not name.is_empty() and name not in locked_names:
			locked_names.append(name)
	if locked_names.is_empty():
		return "%s🔧 Factories: designs available[/color]" % COLOR_MUTED
	if locked_names.size() == 1:
		return "%s🔧 Factories need: %s[/color]" % [COLOR_MUTED, locked_names[0]]
	return (
		"%s🔧 Factories need: %s (+%d)[/color]"
		% [COLOR_MUTED, locked_names[0], locked_names.size() - 1]
	)


static func build_province_technology_bbcode(province: Province, country_tag: String = "") -> String:
	if province == null:
		return ""
	var tag := country_tag.strip_edges().to_upper()
	if tag.is_empty():
		tag = ProvinceInsight.country_tag_for_province(province)
	var parts: PackedStringArray = []
	var national := build_country_research_glance_bbcode(tag)
	if not national.is_empty() and _province_owned_by(province, tag):
		parts.append(national)
	var prod := build_province_production_tech_bbcode(province, tag)
	if not prod.is_empty():
		parts.append(prod)
	if _province_owned_by(province, tag):
		var support := build_support_radio_glance_bbcode(tag)
		if not support.is_empty():
			parts.append(support)
	if parts.is_empty():
		return ""
	return "  ·  ".join(parts)


static func get_build_mode_preview() -> Dictionary:
	## Placeholder for future map build mode (TechnologyScreen → map).
	return {
		"active": false,
		"target_tech_id": "",
		"target_label": "Select technology",
		"outline_color": Color(0.45, 0.85, 1.0, 0.9),
		"legend_line": "[color=#8899aa]🔬 Build mode (planned): cyan outline = valid placement[/color]",
	}


static func _province_owned_by(province: Province, country_tag: String) -> bool:
	var owner := province.owner_tag.strip_edges().to_upper()
	var ctrl := province.controller_tag.strip_edges().to_upper()
	if ctrl.is_empty():
		ctrl = owner
	return ctrl == country_tag or owner == country_tag


static func _completed_count(country_tag: String) -> int:
	var state: Dictionary = TechnologyManager.get_country_state(country_tag)
	var completed: Dictionary = state.get("completed", {}) as Dictionary
	var n := 0
	for key in completed.keys():
		if bool(completed[key]):
			n += 1
	return n


static func _build_target_placeholder(country_tag: String) -> String:
	var state: Dictionary = TechnologyManager.get_country_state(country_tag)
	var types: Array = state.get("unlocked_factory_types", []) as Array
	if types.is_empty():
		return "factories/buildings"
	return str(types[types.size() - 1])
