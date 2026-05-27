class_name MapTechnologyContext
extends RefCounted

## Bridge between map UI (ProvinceInsight, MapRenderer) and TechnologyManager.
## Keeps technology map/tooltip hooks in one place until build-mode overlays land.
##
## Map Build Eligibility (added Phase 1):
##   Use is_design_buildable_in_province() + get_province_build_lock_reason()
##   for province-specific tech (and future dev/terrain) gates.
##   See detailed documentation on those methods.

const COLOR_TECH := "[color=#6ec8ff]"
const COLOR_MUTED := "[color=#8899aa]"


static func get_map_integration_note(country_tag: String) -> String:
	if typeof(TechnologyManager) == TYPE_NIL:
		return "Map build highlights: wire TechnologyManager when build mode is enabled."
	var tag := country_tag.strip_edges().to_upper()
	var n := TechnologyManager.get_active_research_count(tag)
	var completed := _completed_count(tag)
	var support_note := ""
	if has_support_radio_bonuses(tag):
		support_note = " Support/Radio bonuses show on map tooltips (📡) and affect supply routing."
	return (
		"Map: production gates, active research, and Support/Radio (📡) on owned provinces."
		+ support_note
		+ " Planned: cyan highlight for %s placement (%d active, %d completed)."
		% [_build_target_placeholder(tag), n, completed]
	)


static func has_support_radio_bonuses(country_tag: String) -> bool:
	if typeof(TechnologyManager) == TYPE_NIL:
		return false
	var tag := country_tag.strip_edges().to_upper()
	if tag.is_empty():
		return false
	var plan := TechnologyManager.get_effective_planning_speed(tag)
	var recon := TechnologyManager.get_effective_reconnaissance(tag)
	return absf(plan) >= 0.001 or absf(recon) >= 0.001


static func _support_bonus_parts(country_tag: String) -> PackedStringArray:
	var parts: PackedStringArray = []
	var plan := TechnologyManager.get_effective_planning_speed(country_tag)
	var recon := TechnologyManager.get_effective_reconnaissance(country_tag)
	if absf(plan) >= 0.001:
		parts.append("+%.0f%% planning" % (plan * 100.0))
	if absf(recon) >= 0.001:
		parts.append("+%.0f%% recon" % (recon * 100.0))
	return parts


static func build_support_radio_glance_bbcode(country_tag: String) -> String:
	if not has_support_radio_bonuses(country_tag):
		return ""
	var parts := _support_bonus_parts(country_tag.strip_edges().to_upper())
	return "%s📡 Support/Radio: %s[/color]" % [COLOR_TECH, " · ".join(parts)]


static func build_technology_status_chip(country_tag: String) -> String:
	## Single mode-chip token for research + Support/Radio (avoids two tech tokens).
	if typeof(TechnologyManager) == TYPE_NIL:
		return ""
	var tag := country_tag.strip_edges().to_upper()
	if tag.is_empty():
		return ""
	var n := TechnologyManager.get_active_research_count(tag)
	var has_support := has_support_radio_bonuses(tag)
	if n <= 0 and not has_support:
		return ""
	if n > 0 and has_support:
		var slots := TechnologyManager.get_research_slots_max(tag)
		var suffix := _support_bonus_plain(tag)
		if suffix.is_empty():
			return "%s🔬 %d/%d slots[/color]" % [COLOR_TECH, n, slots]
		return "%s🔬 %d/%d · %s[/color]" % [COLOR_TECH, n, slots, suffix]
	if n > 0:
		return build_country_research_glance_bbcode(tag, true)
	return build_support_radio_compact_chip(tag)


static func _support_bonus_plain(country_tag: String) -> String:
	var parts := _support_bonus_parts(country_tag)
	if parts.is_empty():
		return ""
	return "📡 " + " · ".join(parts)


static func build_support_radio_compact_chip(country_tag: String) -> String:
	if not has_support_radio_bonuses(country_tag):
		return ""
	var tag := country_tag.strip_edges().to_upper()
	var plan := TechnologyManager.get_effective_planning_speed(tag)
	var recon := TechnologyManager.get_effective_reconnaissance(tag)
	if absf(plan) >= 0.001 and absf(recon) >= 0.001:
		return "%s📡 +%.0f%% plan · +%.0f%% recon[/color]" % [
			COLOR_TECH, plan * 100.0, recon * 100.0,
		]
	if absf(plan) >= 0.001:
		return "%s📡 +%.0f%% planning[/color]" % [COLOR_TECH, plan * 100.0]
	return "%s📡 +%.0f%% recon[/color]" % [COLOR_TECH, recon * 100.0]


static func build_support_route_summary_plain(country_tag: String) -> String:
	## Short plain summary for national one-liner (no duplicate 📡 prefix).
	if not has_support_radio_bonuses(country_tag):
		return ""
	var tag := country_tag.strip_edges().to_upper()
	var plan := TechnologyManager.get_effective_planning_speed(tag)
	var recon := TechnologyManager.get_effective_reconnaissance(tag)
	var parts: PackedStringArray = []
	if absf(plan) >= 0.001:
		parts.append("reinf +%.0f%%" % (plan * 60.0))
	if absf(recon) >= 0.001:
		var cut := (1.0 - maxf(0.55, 1.0 - recon * 1.2)) * 100.0
		parts.append("interdict −%.0f%%" % cut)
	if parts.is_empty():
		return ""
	return "routes: " + " · ".join(parts)


static func build_national_support_line_bbcode(country_tag: String) -> String:
	## Chip + route effects for national situation line (one readable block).
	if not has_support_radio_bonuses(country_tag):
		return ""
	var bonus := " · ".join(_support_bonus_parts(country_tag.strip_edges().to_upper()))
	var routes := build_support_route_summary_plain(country_tag)
	var line := "📡 " + bonus
	if not routes.is_empty():
		line += " · " + routes
	return "%s%s[/color]" % [COLOR_TECH, line]


static func build_support_recovery_hint_bbcode(country_tag: String) -> String:
	if not has_support_radio_bonuses(country_tag):
		return ""
	var routes := build_support_route_summary_plain(country_tag)
	if routes.is_empty():
		return ""
	return "%s📡 Support/Radio helps recovery: %s[/color]" % [COLOR_TECH, routes]


static func build_support_supply_effect_bbcode(country_tag: String) -> String:
	## Matches SupplyManager radio hooks (reinforcement + interdiction).
	if not has_support_radio_bonuses(country_tag):
		return ""
	var tag := country_tag.strip_edges().to_upper()
	var plan := TechnologyManager.get_effective_planning_speed(tag)
	var recon := TechnologyManager.get_effective_reconnaissance(tag)
	var parts: PackedStringArray = []
	if absf(plan) >= 0.001:
		parts.append("reinforcement +%.0f%%" % (plan * 60.0))
	if absf(recon) >= 0.001:
		var cut := (1.0 - maxf(0.55, 1.0 - recon * 1.2)) * 100.0
		parts.append("route interdiction −%.0f%%" % cut)
	return "%s📡 Routes: %s[/color]" % [COLOR_TECH, " · ".join(parts)]


static func build_province_support_benefit_bbcode(province: Province, country_tag: String) -> String:
	## One line when a province is yours and national Support/Radio applies.
	if province == null or not has_support_radio_bonuses(country_tag):
		return ""
	var tag := country_tag.strip_edges().to_upper()
	if tag.is_empty() or not _province_owned_by(province, tag):
		return ""
	var parts := _support_bonus_parts(tag)
	var bonus := " · ".join(parts)
	if bonus.is_empty():
		return "%s📡 Support/Radio bonuses apply to routes through this province.[/color]" % COLOR_TECH
	var routes := build_support_route_summary_plain(tag)
	var route_bit := ""
	if not routes.is_empty():
		route_bit = " · " + routes
	return (
		"%s📡 Support/Radio (%s)%s — bonuses apply on routes through here.[/color]"
		% [COLOR_TECH, bonus, route_bit]
	)


static func build_support_radio_inspector_block(country_tag: String) -> String:
	if not has_support_radio_bonuses(country_tag):
		return ""
	var lines: PackedStringArray = []
	lines.append(build_support_radio_glance_bbcode(country_tag))
	lines.append(build_support_supply_effect_bbcode(country_tag))
	lines.append(
		"%sApplies nationally — depots and routes in your provinces benefit.[/color]" % COLOR_MUTED
	)
	return "\n".join(lines)


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
		var tid := str(factory.current_production_design).strip_edges()
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
	if parts.is_empty():
		return ""
	return "  ·  ".join(parts)


static func get_build_mode_preview(country_tag: String = "") -> Dictionary:
	var preview := {
		"active": false,
		"target_tech_id": "",
		"target_label": "Select technology",
		"outline_color": Color(0.45, 0.85, 1.0, 0.9),
		"legend_line": "[color=#8899aa]🔬 Build mode (planned): cyan outline = valid placement[/color]",
	}
	var tag := country_tag.strip_edges().to_upper()
	if tag.is_empty() or typeof(TechnologyManager) == TYPE_NIL:
		return preview
	var unlocked := TechnologyManager.get_unlocked_factory_types(tag)
	if not unlocked.is_empty():
		preview["legend_line"] = (
			"[color=#8899aa]🔬 Unlocks: [/color][color=#6ec8ff]%s[/color]"
			% ", ".join(unlocked)
		)
	return preview


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


## === Map Build Eligibility (new lightweight system) ===
## Determines whether a design (or future building) can be constructed in a specific province.
## Starts simple (tech gate only) but designed for easy extension.
##
## Core rule (Phase 1 - this session):
##   A design is buildable in a province only if the *controlling country* (from MapManager)
##   has unlocked the required technology.
##   Delegates to TechnologyManager.is_unit_design_available + get_design_availability
##   (which reads the "unit_design" unlocks from the tech trees).
##
## How to extend later (documented for future work):
##   - Province development/infra level (e.g. high-tech designs only in developed provinces)
##   - Terrain / special features (naval in ports, space in certain zones)
##   - National focuses or spirits (temporary build permissions)
##   - Factory type matching at the specific province (already partially in TM.factory_can_build_design)
##
## Usage from map / production code:
##   if MapTechnologyContext.is_design_buildable_in_province(province_id, design_id):
##       # show in picker, allow factory assignment, start production line, etc.
##
## This (combined with DesignManager tech filtering) is the single source of truth
## for "can I build this design here on the map?"
##
## See also:
##   - DesignManager._eligible_design_ids / get_tech_eligible_design_ids (filters the master list)
##   - TechnologyManager.get_design_availability + factory_can_build_design (core gates)
##   - DesignPickerPopup (already respects selectable + shows lock reasons)

static func is_design_buildable_in_province(province_id: int, design_id: String, country_tag: String = "") -> bool:
	if typeof(MapManager) == TYPE_NIL or typeof(TechnologyManager) == TYPE_NIL:
		return true

	var tag := country_tag.strip_edges().to_upper()
	if tag.is_empty():
		var p: Province = MapManager.get_province(province_id)
		if p == null:
			return false
		tag = p.controller_tag.strip_edges().to_upper()
		if tag.is_empty():
			tag = p.owner_tag.strip_edges().to_upper()
	if tag.is_empty():
		return false

	if typeof(DesignManager) != TYPE_NIL and not DesignManager.country_may_use_design(tag, design_id):
		return false

	# Core tech gate (reuses mature TechnologyManager logic)
	if not TechnologyManager.is_unit_design_available(tag, design_id):
		return false

	# Future extension hooks (currently pass-through for lightweight Phase 1):
	# - Province development / infra requirements
	# - Terrain / feature gates
	# - Factory-type restrictions at the specific province's factories
	# Example skeleton for later:
	# var p: Province = MapManager.get_province(province_id)
	# if p != null and p.development_level < required_dev_for_design(design_id):
	#     return false

	# Also respect factory-level gates if a specific factory context is available
	# (callers in picker/production already layer factory_can_build_design on top)
	return true

## Returns a human-readable lock reason for a design in a specific province (for UI tooltips).
## Falls back to TechnologyManager.get_design_availability when tech is the blocker.
static func get_province_build_lock_reason(province_id: int, design_id: String, country_tag: String = "") -> String:
	if typeof(MapManager) == TYPE_NIL or typeof(TechnologyManager) == TYPE_NIL:
		return ""

	var tag := country_tag.strip_edges().to_upper()
	if tag.is_empty():
		var p: Province = MapManager.get_province(province_id)
		if p != null:
			tag = p.controller_tag.strip_edges().to_upper()
			if tag.is_empty():
				tag = p.owner_tag.strip_edges().to_upper()

	if typeof(DesignManager) != TYPE_NIL and not DesignManager.country_may_use_design(tag, design_id):
		return "Foreign design — not in national catalog (capture or purchase required)"

	var avail := TechnologyManager.get_design_availability(tag, design_id)
	if not bool(avail.get("available", true)):
		return str(avail.get("reason", "Requires technology"))

	# Future: add province-specific reasons (dev level, terrain, etc.)
	return ""
