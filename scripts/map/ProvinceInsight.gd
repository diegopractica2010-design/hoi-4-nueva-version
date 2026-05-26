class_name ProvinceInsight
extends RefCounted

## Formats province hover tooltips, inspector panels, and supply notes from Province + ProvinceEffects.

const PROVINCE_MODIFIER_KEYS: Array[String] = [
	"supply_throughput",
	"local_supply",
	"combat_width",
	"organization_recovery",
	"attrition_reduction",
	"interdiction_resistance",
	"reinforcement_speed",
	"logistics_quality",
	"supply_consumption",
	"attrition",
	"interdiction",
	"logistics",
]

const COLOR_HEADER := "[color=#6eb5ff]"
const COLOR_BASE := "[color=#a8b4c8]"
const COLOR_EFFECTIVE := "[color=#7dffb2]"
const COLOR_NATIONAL := "[color=#e8a0ff]"
const COLOR_WARN := "[color=#ff9a6e]"
const COLOR_MUTED := "[color=#8899aa]"
const COLOR_PROVINCE := "[color=#a8c4e8]"
const COLOR_DIVIDER := "[color=#4a5568]"
const COLOR_TECH := "[color=#6ec8ff]"

## Maps ProvinceEffects national_modifiers keys to readable labels.
const NATIONAL_KEY_LABELS: Dictionary = {
	"supply_throughput": "Supply throughput",
	"local_supply": "Local supply generation",
	"combat_width": "Combat width",
	"organization_recovery": "Organization recovery",
	"attrition_reduction": "Attrition reduction",
	"interdiction_resistance": "Interdiction resistance",
	"reinforcement_speed": "Reinforcement speed",
	"logistics_quality": "Logistics quality",
	"supply_consumption": "Supply consumption",
}


static func build_hover_tooltip(
	province: Province,
	selected_province_id: int = -1,
	other_province: Province = null,
	supply_overlay_active: bool = false,
	hover_supply_role: String = "",
	is_compare_candidate: bool = false,
	is_contested: bool = false,
	has_agent_network: bool = false,
) -> String:
	var report := build_province_report(province, selected_province_id, other_province)
	report["supply_overlay_active"] = supply_overlay_active
	report["selected_province_id"] = selected_province_id
	report["other_province"] = other_province
	report["hover_supply_role"] = hover_supply_role
	report["is_compare_candidate"] = is_compare_candidate
	report["is_contested"] = is_contested or is_province_contested(province)
	report["has_agent_network"] = has_agent_network or has_active_agent_network(province)
	var tag := country_tag_for_province(province)
	var chip := build_tooltip_mode_chip_for_state(
		supply_overlay_active,
		other_province != null,
		selected_province_id == province.id,
		hover_supply_role,
		is_compare_candidate,
		bool(report["is_contested"]),
		bool(report["has_agent_network"]),
		tag,
	)
	var body := format_report_tooltip(report)
	if chip.is_empty():
		return body
	return chip + "\n" + body


static func build_inspector_text(
	province: Province,
	selected_province_id: int = -1,
) -> String:
	return build_inspector_full_bbcode(province, selected_province_id)


static func build_inspector_full_bbcode(
	province: Province,
	selected_province_id: int = -1,
) -> String:
	var report := build_province_report(province, selected_province_id, null)
	if report.is_empty():
		return ""
	var pe: ProvinceEffects = report["province_effects"]
	var lines: PackedStringArray = []
	var compare_hdr := build_inspector_compare_header(province, selected_province_id)
	if not compare_hdr.is_empty():
		lines.append(compare_hdr)
		lines.append("")
	var dual_glance := build_dual_situation_glance_bbcode(province)
	if not dual_glance.is_empty():
		lines.append("%sSituation: %s[/color]" % [COLOR_HEADER, dual_glance])
	var glance := build_province_glance_bbcode(province, pe, 5, not dual_glance.is_empty())
	if not glance.is_empty():
		lines.append("%sAt a glance: %s[/color]" % [COLOR_HEADER, glance])
		lines.append("")
	lines.append("%sModifier breakdown[/color]" % COLOR_HEADER)
	lines.append(_modifier_legend_bbcode())
	lines.append("")
	var situation_sec := build_inspector_situation_section(province)
	if not situation_sec.is_empty():
		lines.append(situation_sec)
		lines.append("")
	var tech_sec := build_inspector_technology_section(province, str(report.get("country_tag", "")))
	if not tech_sec.is_empty():
		lines.append(tech_sec)
		lines.append("")
	lines.append("%s── Logistics & supply ──[/color]" % COLOR_HEADER)
	lines.append(_stat_column_legend_bbcode())
	for row in report.get("logistics_rows", []) as Array:
		lines.append(_bbcode_stat_line_layered(row))
	lines.append(_depot_bbcode_line(province.id))
	var routes := build_routes_through_province_bbcode(province.id, str(report.get("country_tag", "")))
	if not routes.is_empty():
		lines.append(routes)
	lines.append("")
	lines.append(build_inspector_national_section(province, pe))
	lines.append("")
	lines.append("%s── Combat ──[/color]" % COLOR_HEADER)
	lines.append(_stat_column_legend_bbcode())
	for row in report.get("combat_rows", []) as Array:
		lines.append(_bbcode_stat_line_layered(row))
	lines.append(
		"%sMovement cost: %.2f[/color]" % [COLOR_MUTED, float(report.get("movement_cost", 1.0))]
	)
	var battle := str(report.get("battle_block", ""))
	if not battle.is_empty():
		lines.append("")
		lines.append(battle)
	return "\n".join(lines)


static func get_province_effects_for(province: Province, country_tag: String = "") -> ProvinceEffects:
	if province == null:
		return null
	var tag := country_tag.strip_edges().to_upper()
	if tag.is_empty():
		tag = country_tag_for_province(province)
	if typeof(MapManager) != TYPE_NIL and MapManager.has_method("get_province_effects"):
		var via_manager: ProvinceEffects = MapManager.get_province_effects(province.id, tag)
		if via_manager != null:
			return via_manager
	# Last resort fallback ONLY. MapManager.get_province_effects is the single source of truth
	# (combines base dev/infra + national spirits + temporary modifiers).
	# This raw call is deprecated.
	return ProvinceEffects.for_country_province(province, tag)


static func build_at_a_glance_logistics(province: Province) -> String:
	var pe := get_province_effects_for(province)
	return (
		"Effective: throughput ×%.2f · local gen +%.0f%% · interdict resist ×%.2f · reinf ×%.2f"
		% [
			pe.get_effective_throughput_multiplier(),
			pe.get_effective_local_supply_generation() * 100.0,
			pe.get_effective_interdiction_resistance(),
			pe.get_effective_reinforcement_speed(),
		]
	)


static func build_at_a_glance_combat(province: Province) -> String:
	var pe := get_province_effects_for(province)
	return (
		"Effective: width ×%.2f · org recovery ×%.2f · attrition ×%.2f"
		% [
			pe.get_effective_combat_width_multiplier(),
			pe.get_effective_organization_recovery(),
			pe.get_effective_attrition_multiplier(),
		]
	)


static func build_combat_summary_for_inspector(
	province: Province,
	selected_province_id: int = -1,
) -> String:
	var lines: PackedStringArray = []
	lines.append(build_at_a_glance_combat(province))
	var other := _resolve_battle_counterpart(province, selected_province_id)
	if other != null:
		var attacker := province
		var defender := other
		if selected_province_id == province.id:
			attacker = other
			defender = province
		elif selected_province_id == other.id:
			attacker = other
			defender = province
		var preview := get_battle_preview(attacker, defender)
		if not preview.is_empty():
			lines.append(
				"vs %s: engagement width %.1f (%s)"
				% [
					other.name,
					float(preview.get("estimated_effective_width", 0.0)),
					str(preview.get("terrain", "plains")).capitalize(),
				]
			)
			var pe_def := get_province_effects_for(defender)
			if pe_def != null:
				lines.append(
					"Defender modifiers: width ×%.2f · org ×%.2f"
					% [
						pe_def.get_effective_combat_width_multiplier(),
						pe_def.get_effective_organization_recovery(),
					]
				)
	elif selected_province_id >= 0 and selected_province_id != province.id:
		lines.append("Tip: select an adjacent province to see an attack/defense preview.")
	return "\n".join(lines)


static func build_national_rollup_bbcode(pe: ProvinceEffects) -> String:
	if pe == null or pe.national_modifiers.is_empty():
		return "%s── National layer ──[/color]\n%s  None affecting this province.[/color]" % [COLOR_HEADER, COLOR_MUTED]
	var lines: PackedStringArray = []
	lines.append("%s── National layer (combined) ──[/color]" % COLOR_HEADER)
	var keys: Array = pe.national_modifiers.keys()
	keys.sort()
	for key in keys:
		var v := float(pe.national_modifiers[key])
		if absf(v) < 0.0001:
			continue
		var label := str(NATIONAL_KEY_LABELS.get(str(key), str(key).replace("_", " ").capitalize()))
		var value_text := _format_national_value(v)
		var sign_color := COLOR_EFFECTIVE if v > 0 else COLOR_WARN
		if str(key) in ["supply_consumption", "attrition"]:
			sign_color = COLOR_EFFECTIVE if v < 0 else COLOR_WARN
		lines.append("  %s• %s: %s%s[/color]" % [COLOR_NATIONAL, label, sign_color, value_text])
	return "\n".join(lines)


static func build_routes_through_province_bbcode(
	province_id: int,
	country_tag: String = "",
	max_listed: int = 0,
) -> String:
	var sm := _supply_manager()
	if sm == null:
		return ""
	var tag := country_tag.strip_edges().to_upper()
	var player := str(sm.player_tag).strip_edges().to_upper() if sm.get("player_tag") else tag
	var lines: PackedStringArray = []
	var count := 0
	for plan_var in sm.get_all_routes():
		if not (plan_var is SupplyRoutePlan):
			continue
		var plan := plan_var as SupplyRoutePlan
		if province_id not in plan.province_path:
			continue
		count += 1
		var role := "waypoint"
		var role_icon := "○"
		if plan.source_province_id == province_id:
			role = "source"
			role_icon = "⊙"
		elif plan.target_province_id == province_id:
			role = "destination"
			role_icon = "⊛"
		lines.append(
			"  %s%s %s: %s → %s · %s · interdict %.0f%% · reinf ×%.2f[/color]"
			% [
				COLOR_MUTED,
				role_icon,
				role,
				_province_short_name(plan.source_province_id),
				_province_short_name(plan.target_province_id),
				plan.routing_mode,
				plan.interdiction_chance * 100.0,
				plan.reinforcement_modifier,
			]
		)
	if count == 0:
		return ""
	var header := "%s── Supply routes (%d) ──[/color]" % [COLOR_HEADER, count]
	lines.insert(0, header)
	if max_listed > 0 and count > max_listed:
		var trimmed: PackedStringArray = [lines[0]]
		for i in range(1, mini(lines.size(), max_listed + 1)):
			trimmed.append(lines[i])
		trimmed.append("%s  … +%d more route(s)[/color]" % [COLOR_MUTED, count - max_listed])
		return "\n".join(trimmed)
	return "\n".join(lines)


static func build_tooltip_mode_chip_for_state(
	supply_overlay: bool,
	compare_active: bool,
	is_selected_province: bool,
	supply_role: String = "",
	is_compare_candidate: bool = false,
	is_contested: bool = false,
	has_agent_network: bool = false,
	country_tag: String = "",
	max_tokens: int = 4,
) -> String:
	var tokens: PackedStringArray = []
	if compare_active:
		tokens.append("%s⚔ Compare[/color]" % COLOR_WARN)
	elif is_compare_candidate:
		tokens.append("%s○ Compare neighbor[/color]" % COLOR_WARN)
	elif is_selected_province:
		tokens.append("%s◆ Selected[/color]" % COLOR_HEADER)
	var situation_icon := ""
	if is_contested and has_agent_network:
		situation_icon = "⚑◎"
	elif is_contested:
		situation_icon = "⚑"
	elif has_agent_network:
		situation_icon = "◎"
	if supply_overlay and not situation_icon.is_empty():
		tokens.append("%s📦 Supply · %s[/color]" % [COLOR_EFFECTIVE, situation_icon])
	elif supply_overlay:
		tokens.append("%s📦 Supply (L)[/color]" % COLOR_EFFECTIVE)
	elif situation_icon == "⚑◎":
		tokens.append("%s⚑◎ Contested + agent[/color]" % COLOR_WARN)
	elif situation_icon == "⚑":
		tokens.append("%s⚑ Contested[/color]" % COLOR_WARN)
	elif situation_icon == "◎":
		tokens.append("%s◎ Agent[/color]" % COLOR_NATIONAL)
	if not country_tag.is_empty():
		var use_compact := tokens.size() >= 2
		var research := MapTechnologyContext.build_country_research_glance_bbcode(country_tag, use_compact)
		if not research.is_empty():
			tokens.append(research)
	if not supply_role.is_empty() and tokens.size() < max_tokens:
		tokens.append("%s%s[/color]" % [COLOR_MUTED, _supply_role_label(supply_role)])
	if tokens.is_empty():
		return ""
	if tokens.size() <= max_tokens:
		return "  ·  ".join(tokens)
	var shown: PackedStringArray = []
	for i in range(mini(tokens.size(), max_tokens)):
		shown.append(tokens[i])
	shown.append("%s+%d[/color]" % [COLOR_MUTED, tokens.size() - max_tokens])
	return "  ·  ".join(shown)


static func _supply_role_label(role: String) -> String:
	match role:
		"active":
			return "◆ supply selected"
		"preview":
			return "~ reroute preview"
		"route":
			return "— supply route"
		"hub":
			return "◇ depot hub"
		_:
			return role


static func build_supply_role_hint_bbcode(province_id: int, role: String) -> String:
	if role.is_empty():
		return ""
	return "%sMap role: %s %s[/color]" % [COLOR_MUTED, _supply_role_icon(role), _supply_role_label(role)]


static func _supply_role_icon(role: String) -> String:
	match role:
		"active":
			return "◆"
		"preview":
			return "~"
		"route":
			return "—"
		"hub":
			return "◇"
		_:
			return "·"


static func build_inspector_conflict_section(province: Province) -> String:
	if not is_province_contested(province):
		return ""
	var lines: PackedStringArray = []
	lines.append("%s── Conflict / control ──[/color]" % COLOR_HEADER)
	lines.append(build_conflict_status_bbcode(province))
	lines.append(
		"%sMap: diagonal stripes mark owner ≠ controller provinces.[/color]" % COLOR_MUTED
	)
	return "\n".join(lines)


static func build_overlay_layers_summary_bbcode(
	supply_overlay_active: bool = false,
	contested_count: int = -1,
	agent_network_count: int = -1,
	player_tag: String = "",
) -> String:
	var n_contested := contested_count if contested_count >= 0 else count_contested_provinces()
	var n_agent := agent_network_count if agent_network_count >= 0 else count_agent_networks({}, player_tag)
	var layers: PackedStringArray = []
	if n_contested > 0:
		layers.append("%s▨ %d contested[/color]" % [COLOR_WARN, n_contested])
	if n_agent > 0:
		layers.append("%s◎ %d agent[/color]" % [COLOR_NATIONAL, n_agent])
	if supply_overlay_active:
		layers.append("%s● supply fill[/color]" % COLOR_EFFECTIVE)
	var tech_preview := MapTechnologyContext.get_build_mode_preview()
	if bool(tech_preview.get("active", false)):
		layers.append("%s🔬 build (planned)[/color]" % COLOR_TECH)
	if layers.is_empty():
		return ""
	var stack := " → ".join(layers)
	if n_contested > 0 and n_agent > 0 and supply_overlay_active:
		stack += "  %s(all three on)[/color]" % COLOR_MUTED
	var footer := "[color=#8899aa]· pulsing outlines on top[/color]"
	var tech_line := str(tech_preview.get("legend_line", ""))
	if not tech_line.is_empty():
		footer = tech_line + "  " + footer
	return "[color=#8899aa]Layers:[/color] " + stack + "  " + footer


static func build_compact_layers_summary_bbcode(
	supply_overlay_active: bool = false,
	contested_count: int = -1,
	agent_network_count: int = -1,
	dual_situation_count: int = -1,
) -> String:
	var n_contested := contested_count if contested_count >= 0 else count_contested_provinces()
	var n_agent := agent_network_count if agent_network_count >= 0 else count_agent_networks({})
	var n_dual := dual_situation_count if dual_situation_count >= 0 else count_dual_situation_provinces()
	var parts: PackedStringArray = []
	if n_contested > 0:
		parts.append("%s▨%d[/color]" % [COLOR_WARN, n_contested])
	if n_agent > 0:
		parts.append("%s◎%d[/color]" % [COLOR_NATIONAL, n_agent])
	if supply_overlay_active:
		parts.append("%s●L[/color]" % COLOR_EFFECTIVE)
	if parts.is_empty():
		return ""
	var line := "  ·  ".join(parts)
	if n_dual > 0:
		line += "  %s⚑◎×%d[/color]" % [COLOR_WARN, n_dual]
	line += "  %s↑ outlines[/color]" % COLOR_MUTED
	return "%sLayers:[/color] " % COLOR_MUTED + line


static func build_map_supply_mode_hint_plain(
	contested_count: int = -1,
	agent_network_count: int = -1,
	dual_count: int = -1,
	selected_province_id: int = -1,
) -> String:
	var n_c := contested_count if contested_count >= 0 else count_contested_provinces()
	var n_a := agent_network_count if agent_network_count >= 0 else count_agent_networks({})
	var n_d := dual_count if dual_count >= 0 else count_dual_situation_provinces()
	var bits: PackedStringArray = ["📦 Supply overlay (L)"]
	if n_c > 0:
		bits.append("⚑ %d contested" % n_c)
	if n_a > 0:
		bits.append("◎ %d agent" % n_a)
	if n_d > 0:
		bits.append("⚑◎ %d both" % n_d)
	if selected_province_id >= 0:
		bits.append("⚔ compare via ○ neighbors")
	return " · ".join(bits)


static func build_inspector_technology_section(province: Province, country_tag: String = "") -> String:
	var block := MapTechnologyContext.build_province_technology_bbcode(province, country_tag)
	if block.is_empty():
		return ""
	var lines: PackedStringArray = []
	lines.append("%s── Technology / production ──[/color]" % COLOR_HEADER)
	lines.append(block)
	lines.append(
		"%sOpen Technology screen for research slots and build unlocks.[/color]" % COLOR_MUTED
	)
	return "\n".join(lines)


static func build_province_situation_tags(province: Province) -> String:
	if province == null:
		return ""
	var tags: PackedStringArray = []
	if is_province_contested(province) and has_active_agent_network(province):
		tags.append("%s⚑◎[/color]" % COLOR_WARN)
	elif is_province_contested(province):
		tags.append("%s⚑[/color]" % COLOR_WARN)
	elif has_active_agent_network(province):
		tags.append("%s◎[/color]" % COLOR_NATIONAL)
	var tag := country_tag_for_province(province)
	if not tag.is_empty() and typeof(TechnologyManager) != TYPE_NIL:
		if TechnologyManager.get_active_research_count(tag) > 0 and _province_matches_country(province, tag):
			tags.append("%s🔬[/color]" % COLOR_TECH)
	return "".join(tags)


static func _province_matches_country(province: Province, country_tag: String) -> bool:
	var tag := country_tag.strip_edges().to_upper()
	var owner := province.owner_tag.strip_edges().to_upper()
	var ctrl := province.controller_tag.strip_edges().to_upper()
	if ctrl.is_empty():
		ctrl = owner
	return owner == tag or ctrl == tag


static func build_compare_situation_note(attacker: Province, defender: Province) -> String:
	var parts: PackedStringArray = []
	var a_tags := build_province_situation_tags(attacker)
	var d_tags := build_province_situation_tags(defender)
	if not a_tags.is_empty():
		parts.append("%sAttacker %s: %s[/color]" % [COLOR_MUTED, attacker.name, a_tags])
	if not d_tags.is_empty():
		parts.append("%sDefender %s: %s[/color]" % [COLOR_MUTED, defender.name, d_tags])
	var prod_note := _compare_production_tech_note(attacker, defender)
	if not prod_note.is_empty():
		parts.append(prod_note)
	if parts.is_empty():
		return ""
	return "\n".join(parts)


static func _compare_production_tech_note(attacker: Province, defender: Province) -> String:
	var notes: PackedStringArray = []
	var a_prod := MapTechnologyContext.build_province_production_tech_bbcode(
		attacker, country_tag_for_province(attacker),
	)
	var d_prod := MapTechnologyContext.build_province_production_tech_bbcode(
		defender, country_tag_for_province(defender),
	)
	if not a_prod.is_empty():
		notes.append("%sAttacker: %s[/color]" % [COLOR_MUTED, a_prod])
	if not d_prod.is_empty():
		notes.append("%sDefender: %s[/color]" % [COLOR_MUTED, d_prod])
	return "\n".join(notes)


static func count_dual_situation_provinces(provinces: Dictionary = {}) -> int:
	var n := 0
	var source := provinces
	if source.is_empty() and typeof(MapManager) != TYPE_NIL:
		source = MapManager.get_all_provinces()
	for pid_var in source.keys():
		var p: Province = source[pid_var] as Province
		if p != null and is_province_contested(p) and has_active_agent_network(p):
			n += 1
	return n


static func build_supply_overlay_quick_key_bbcode(
	contested_count: int = -1,
	agent_network_count: int = -1,
	dual_count: int = -1,
) -> String:
	var n_contested := contested_count if contested_count >= 0 else count_contested_provinces()
	var n_agent := agent_network_count if agent_network_count >= 0 else count_agent_networks({})
	var n_dual := dual_count if dual_count >= 0 else count_dual_situation_provinces()
	if n_contested <= 0 and n_agent <= 0:
		return (
			"[color=#8899aa]Quick key (L):[/color] "
			+ COLOR_EFFECTIVE
			+ "●[/color] depot fill · pulsing outlines"
		)
	var parts := (
		COLOR_WARN
		+ "▨[/color] stripes → "
		+ COLOR_NATIONAL
		+ "◎[/color] rings → "
		+ COLOR_EFFECTIVE
		+ "●[/color] fill"
	)
	var tail := " · outlines on top"
	if n_dual > 0:
		tail += " · " + COLOR_WARN + "⚑◎[/color] %d both" % n_dual
	return "[color=#8899aa]Quick key (L):[/color] " + parts + tail


static func build_supply_legend_bbcode(
	selected_province_id: int = -1,
	compare_candidate_count: int = 0,
	hover_province_id: int = -1,
	hover_supply_role: String = "",
	contested_count: int = -1,
	agent_network_count: int = -1,
	player_tag: String = "",
	dual_situation_count: int = -1,
) -> String:
	var lines: PackedStringArray = []
	var n_contested := contested_count if contested_count >= 0 else count_contested_provinces()
	var n_agent := agent_network_count if agent_network_count >= 0 else count_agent_networks({}, player_tag)
	var n_dual := dual_situation_count if dual_situation_count >= 0 else count_dual_situation_provinces()
	var quick := build_supply_overlay_quick_key_bbcode(n_contested, n_agent, n_dual)
	if not quick.is_empty():
		lines.append(quick)
		lines.append("")
	var compact := build_compact_layers_summary_bbcode(true, n_contested, n_agent, n_dual)
	if not compact.is_empty():
		lines.append(compact)
	var multi_overlay := n_contested > 0 and n_agent > 0
	if not multi_overlay:
		lines.append("")
		var stack := build_overlay_layers_summary_bbcode(true, n_contested, n_agent, player_tag)
		if not stack.is_empty():
			lines.append(stack)
			lines.append("")
		var conflict_line := build_conflict_legend_line(n_contested)
		var agent_line := build_agent_legend_line(agent_network_count, player_tag)
		if not conflict_line.is_empty():
			lines.append(conflict_line)
		if not agent_line.is_empty():
			lines.append(agent_line)
		if n_contested > 0 or n_agent > 0:
			lines.append(
				"[color=#8899aa]Hover: brighter stripes/rings · outlines pulse above layers[/color]"
			)
	elif n_dual > 0:
		lines.append(
			"%s⚑◎ %d provinces: stripes + ring overlap · blended hover/selection outline[/color]"
			% [COLOR_WARN, n_dual]
		)
	var tech_legend := str(MapTechnologyContext.get_build_mode_preview().get("legend_line", ""))
	if not tech_legend.is_empty():
		lines.append(tech_legend)
	lines.append(
		"[color=#9eb8d8]L on[/color]  "
		+ "[color=#8899aa]● fill[/color] "
		+ "[color=#7dffb2]high[/color]/[color=#e8c04a]mid[/color]/[color=#ff9a6e]low[/color]  "
		+ "[color=#8899aa]◇ hub · — route · ~ preview · ◆ selected[/color]"
	)
	if selected_province_id >= 0:
		var sel_name := _province_short_name(selected_province_id)
		lines.append(
			"[color=#8899aa]⚔ [/color][color=#ffb85a]○[/color][color=#8899aa] faint = adjacent to %s (%d) · bold orange = active compare[/color]"
			% [sel_name, compare_candidate_count]
		)
	else:
		lines.append(
			"[color=#8899aa]Select a province · hover adjacent neighbor for combat preview[/color]"
		)
	if hover_province_id >= 0:
		var hover_line := ""
		if not hover_supply_role.is_empty():
			hover_line = (
				"[color=#8899aa]Hover: %s %s (%s)"
				% [_supply_role_icon(hover_supply_role), _province_short_name(hover_province_id), _supply_role_label(hover_supply_role)]
			)
		else:
			hover_line = "[color=#8899aa]Hover: %s" % _province_short_name(hover_province_id)
		var fill := depot_fill_ratio(hover_province_id)
		if fill >= 0.0:
			hover_line += " · depot %d%%" % int(round(fill * 100.0))
		var hp := _province_by_id(hover_province_id)
		if hp != null:
			var dual := build_dual_situation_glance_bbcode(hp)
			if not dual.is_empty():
				hover_line += " · " + dual
			elif is_province_contested(hp):
				hover_line += " · %s⚑ contested[/color]" % COLOR_WARN
			elif has_active_agent_network(hp):
				hover_line += " · %s◎ agent[/color]" % COLOR_NATIONAL
		hover_line += "[/color]"
		lines.append(hover_line)
	return "\n".join(lines)


static func build_map_compare_hint_plain(
	selected_province_id: int,
	candidate_count: int,
	hover_province_id: int = -1,
	hover_is_candidate: bool = false,
) -> String:
	if selected_province_id < 0:
		return ""
	var name := _province_short_name(selected_province_id)
	if hover_is_candidate and hover_province_id >= 0:
		var hover_p := _province_by_id(hover_province_id)
		var extra := ""
		if hover_p != null:
			if is_province_contested(hover_p) and has_active_agent_network(hover_p):
				extra += " · ⚑◎ contested + agent"
			elif is_province_contested(hover_p):
				extra += " · ⚑ contested"
			elif has_active_agent_network(hover_p):
				extra += " · ◎ agent"
		return (
			"⚔ %s selected — hovering %s (○ neighbor)%s · click to lock compare"
			% [name, _province_short_name(hover_province_id), extra]
		)
	return (
		"⚔ %s selected — hover ○-outlined neighbor (%d) for combat preview"
		% [name, candidate_count]
	)


static func build_supply_overlay_bbcode(
	plan: SupplyRoutePlan,
	province: Province,
	player_tag: String,
	top_depots_text: String = "",
) -> String:
	var lines: PackedStringArray = []
	var title := "⟳ Reroute preview" if plan.is_player_override else "⛟ Supply route"
	lines.append("%s%s[/color]" % [COLOR_HEADER, title])
	if plan.path_length() > 0:
		lines.append(
			"%s⛟ %s → %s · %s · %d hops[/color]"
			% [
				COLOR_MUTED,
				_province_short_name(plan.source_province_id),
				_province_short_name(plan.target_province_id),
				plan.routing_mode,
				plan.path_length(),
			]
		)
	lines.append(
		"%sRoute effect: reinf ×%.2f · interdiction %.0f%% · %.1f days[/color]"
		% [
			COLOR_MUTED,
			plan.reinforcement_modifier,
			plan.interdiction_chance * 100.0,
			plan.total_days,
		]
	)
	for line in plan.summary_lines():
		lines.append("%s%s[/color]" % [COLOR_MUTED, line])
	if plan.path_length() > 0:
		var path_names := PackedStringArray()
		for pid_var in plan.province_path:
			path_names.append(_province_short_name(int(pid_var)))
		lines.append("%sPath: %s[/color]" % [COLOR_MUTED, " → ".join(path_names)])
	for line in build_route_modifier_lines(plan.province_path, player_tag):
		if line.begins_with("["):
			lines.append(line)
		else:
			lines.append("%s%s[/color]" % [COLOR_MUTED, line])
	if province != null:
		lines.append("")
		lines.append("%s── Hub modifiers (%s) ──[/color]" % [COLOR_HEADER, province.name])
		if is_province_contested(province):
			lines.append(build_conflict_status_bbcode(province))
		var pe := get_province_effects_for(province, player_tag)
		lines.append(build_compact_effective_summary(pe))
		var supply_line := build_supply_logistics_one_liner(pe)
		if not supply_line.is_empty():
			lines.append(supply_line)
		lines.append(_depot_bbcode_line(province.id))
		lines.append(_stat_column_legend_bbcode())
		for row in _logistics_rows(pe):
			lines.append(_bbcode_stat_line_layered(row))
		var badge := build_national_sources_badge(province)
		if not badge.is_empty():
			lines.append(badge)
			var sources := build_national_sources_grouped_compact(province, 3)
			if not sources.is_empty():
				lines.append(sources)
	if not top_depots_text.is_empty():
		lines.append("")
		lines.append("%s%s[/color]" % [COLOR_HEADER, top_depots_text])
	return "\n".join(lines)


static func build_info_logistics_text(province: Province) -> String:
	var tag := country_tag_for_province(province)
	var pe := get_province_effects_for(province, tag)  # MapManager preferred path
	var lines: PackedStringArray = []
	lines.append("Infrastructure: %d  ·  Development: %d" % [province.infrastructure, province.development_level])
	for row in _logistics_rows(pe):
		lines.append(_plain_stat_line(row))
	lines.append(_depot_summary_line(province.id))
	if province.resolve_has_port():
		lines.append("Coastal access: yes")
	return "\n".join(lines)


static func build_info_combat_text(
	province: Province,
	selected_province_id: int = -1,
) -> String:
	var tag := country_tag_for_province(province)
	var pe := get_province_effects_for(province, tag)   # MapManager preferred
	var lines: PackedStringArray = []
	for row in _combat_rows(pe):
		lines.append(_plain_stat_line(row))
	lines.append(_terrain_width_line(province.terrain))
	var other := _resolve_battle_counterpart(province, selected_province_id)
	lines.append("")
	if other != null:
		lines.append(_battle_preview_block(province, other, selected_province_id))
	else:
		lines.append(_local_battle_block(province))
	return "\n".join(lines)


static func build_national_effects_bbcode(province: Province) -> String:
	var tag := country_tag_for_province(province)
	if tag.is_empty():
		return "%sNo controlling country — national modifiers unavailable.[/color]" % COLOR_MUTED
	var lines: PackedStringArray = []
	lines.append("%sNational effects (%s)[/color]" % [COLOR_HEADER, tag])
	for line in _national_spirit_lines(tag):
		lines.append(line)
	for line in _temporary_effect_lines(tag):
		lines.append(line)
	var agent_line := _agent_network_line(province.id, tag)
	if not agent_line.is_empty():
		lines.append(agent_line)
	if lines.size() <= 1:
		lines.append("%s  No province-relevant national modifiers active.[/color]" % COLOR_MUTED)
	return "\n".join(lines)


static func build_route_modifier_lines(path: Array, player_tag: String) -> PackedStringArray:
	var lines := PackedStringArray()
	if path.is_empty() or player_tag.is_empty():
		return lines
	var tag := player_tag.strip_edges().to_upper()
	lines.append("%sRoute province modifiers (national applied):[/color]" % COLOR_HEADER)
	var count := 0
	for pid_var in path:
		var pid := int(pid_var)
		var p := _province_by_id(pid)
		if p == null or country_tag_for_province(p) != tag:
			continue
		var pe: ProvinceEffects = null
		if typeof(MapManager) != TYPE_NIL and MapManager.has_method("get_province_effects"):
			pe = MapManager.get_province_effects(pid, tag)
		if pe == null:
			pe = get_province_effects_for(p, tag)
		var nat_note := ""
		if not pe.national_modifiers.is_empty():
			var reinf := float(pe.national_modifiers.get("reinforcement_speed", 0.0))
			if absf(reinf) >= 0.0001:
				nat_note = " (nat reinf %+0.0f%%)" % (reinf * 100.0)
		lines.append(
			"%s  %s: reinf ×%.2f · interdict ×%.2f%s[/color]"
			% [
				COLOR_MUTED,
				p.name,
				pe.get_effective_reinforcement_speed(),
				pe.get_effective_interdiction_resistance(),
				nat_note,
			]
		)
		count += 1
		if count >= 6:
			lines.append(
				"%s  … +%d more provinces on path[/color]" % [COLOR_MUTED, path.size() - count]
			)
			break
	return lines


static func depot_fill_ratio(province_id: int) -> float:
	var sm := _supply_manager()
	if sm == null:
		return -1.0
	var depot: ProvinceDepotState = sm.get_depot_state(province_id)
	if depot == null:
		return -1.0
	return depot.fill_ratio()


static func is_province_contested(province: Province) -> bool:
	if province == null:
		return false
	if province.controller_tag.is_empty():
		return false
	return province.owner_tag != province.controller_tag


static func get_active_agent_network(province: Province) -> AgentNetwork:
	if province == null or typeof(AgentManager) == TYPE_NIL:
		return null
	var tag := country_tag_for_province(province)
	var net: AgentNetwork = AgentManager.get_network(province.id)
	if net == null or not net.is_active():
		return null
	if net.controlling_country.strip_edges().to_upper() != tag:
		return null
	return net


static func has_active_agent_network(province: Province) -> bool:
	return get_active_agent_network(province) != null


static func count_agent_networks(provinces: Dictionary = {}, country_tag: String = "") -> int:
	if typeof(AgentManager) == TYPE_NIL:
		return 0
	var tag := country_tag.strip_edges().to_upper()
	if not tag.is_empty():
		var n := 0
		for net in AgentManager.get_networks_for_country(tag):
			if net != null and net.is_active():
				n += 1
		return n
	var total := 0
	for pid_var in provinces.keys():
		var net: AgentNetwork = AgentManager.get_network(int(pid_var))
		if net != null and net.is_active():
			total += 1
	return total


static func build_agent_glance_bbcode(province: Province) -> String:
	var net := get_active_agent_network(province)
	if net == null:
		return ""
	var focus := str(net.focus).replace("_", " ")
	return (
		"%s◎ Agent %s · str %.0f · %d ops · eff %.0f%%[/color]"
		% [COLOR_NATIONAL, focus, net.strength, net.local_operatives, net.get_effectiveness() * 100.0]
	)


static func build_agent_legend_line(agent_count: int = -1, country_tag: String = "") -> String:
	var n := agent_count
	if n < 0:
		n = count_agent_networks({}, country_tag)
	if n <= 0:
		return ""
	return (
		"[color=#8899aa]◎ Agents: [/color][color=#a78bfa]○[/color][color=#8899aa] rings = %d active network%s (strength at centroid)[/color]"
		% [n, "s" if n != 1 else ""]
	)


static func build_inspector_agent_section(province: Province) -> String:
	var net := get_active_agent_network(province)
	if net == null:
		return ""
	var lines: PackedStringArray = []
	lines.append("%s── Agent network ──[/color]" % COLOR_HEADER)
	lines.append(build_agent_glance_bbcode(province))
	lines.append(
		"%sMap: purple ring size reflects effectiveness; contested neighbors reduce it.[/color]"
		% COLOR_MUTED
	)
	return "\n".join(lines)


static func count_contested_provinces(provinces: Dictionary = {}) -> int:
	if typeof(MapManager) != TYPE_NIL and MapManager.has_method("get_contested_provinces"):
		return MapManager.get_contested_provinces().size()
	var n := 0
	for pid_var in provinces.keys():
		var p: Province = provinces[pid_var] as Province
		if p != null and is_province_contested(p):
			n += 1
	return n


static func build_conflict_status_bbcode(province: Province) -> String:
	if not is_province_contested(province):
		return ""
	var owner := province.owner_tag if not province.owner_tag.is_empty() else "—"
	var ctrl := province.controller_tag
	return (
		"%s⚑ Contested — owner %s · held by %s[/color]"
		% [COLOR_WARN, owner, ctrl]
	)


static func build_control_glance_bbcode(province: Province) -> String:
	if province == null:
		return ""
	var owner := province.owner_tag if not province.owner_tag.is_empty() else "—"
	if is_province_contested(province):
		return (
			"%sOwner %s  ·  %s⚑ Held by %s[/color]"
			% [COLOR_MUTED, owner, COLOR_WARN, province.controller_tag]
		)
	return "%sOwner: %s[/color]" % [COLOR_MUTED, owner]


static func build_province_glance_bbcode(
	province: Province,
	pe: ProvinceEffects = null,
	max_parts: int = 4,
	omit_contested_agent: bool = false,
) -> String:
	if province == null:
		return ""
	var parts: PackedStringArray = []
	var dual_active := is_province_contested(province) and has_active_agent_network(province)
	if is_province_contested(province) and not (omit_contested_agent and dual_active):
		parts.append(
			"%s⚑ %s holds (owner %s)[/color]"
			% [COLOR_WARN, province.controller_tag, province.owner_tag]
		)
	var fill := depot_fill_ratio(province.id)
	if fill >= 0.0:
		var icon := "✓"
		if fill < 0.35:
			icon = "⚠"
		elif fill < 0.65:
			icon = "◐"
		parts.append("%s%s Depot %d%%[/color]" % [COLOR_MUTED, icon, int(round(fill * 100.0))])
	var agent_line := build_agent_glance_bbcode(province)
	if not agent_line.is_empty() and not (omit_contested_agent and dual_active):
		parts.append(agent_line)
	var tag := country_tag_for_province(province)
	if not tag.is_empty() and typeof(NationalSpiritManager) != TYPE_NIL:
		var spirit_n := _national_spirit_lines(tag).size()
		var temp_n := _temporary_effect_lines(tag).size()
		if spirit_n > 0 or temp_n > 0:
			var nat_parts: PackedStringArray = []
			if spirit_n > 0:
				nat_parts.append("%d◆" % spirit_n)
			if temp_n > 0:
				nat_parts.append("%d⏱" % temp_n)
			parts.append("%sNational %s[/color]" % [COLOR_NATIONAL, " ".join(nat_parts)])
	if pe != null:
		parts.append(
			"%s×%.2f supply · ×%.2f width[/color]"
			% [COLOR_MUTED, pe.get_effective_throughput_multiplier(), pe.get_effective_combat_width_multiplier()]
		)
	var prod := MapTechnologyContext.build_province_production_tech_bbcode(province, tag)
	if not prod.is_empty():
		parts.append(prod)
	if parts.is_empty():
		return ""
	return build_province_glance_compact(parts, max_parts)


static func build_province_glance_compact(parts: PackedStringArray, max_parts: int = 4) -> String:
	if parts.is_empty():
		return ""
	if parts.size() <= max_parts:
		return "  ·  ".join(parts)
	var shown: PackedStringArray = []
	for i in range(mini(parts.size(), max_parts)):
		shown.append(parts[i])
	shown.append("%s+%d more[/color]" % [COLOR_MUTED, parts.size() - max_parts])
	return "  ·  ".join(shown)


static func build_dual_situation_glance_bbcode(province: Province) -> String:
	if province == null:
		return ""
	var contested := is_province_contested(province)
	var agent := has_active_agent_network(province)
	if not contested or not agent:
		return ""
	var ctrl := province.controller_tag
	var owner := province.owner_tag if not province.owner_tag.is_empty() else "—"
	var net := get_active_agent_network(province)
	var agent_bit := ""
	if net != null:
		agent_bit = " · ◎ %s str %.0f" % [str(net.focus).replace("_", " "), net.strength]
	return (
		"%s⚑◎ %s holds %s (owner %s)%s[/color]"
		% [COLOR_WARN, ctrl, province.name, owner, agent_bit]
	)


static func build_inspector_situation_section(province: Province) -> String:
	if province == null:
		return ""
	var contested := is_province_contested(province)
	var agent := has_active_agent_network(province)
	if not contested and not agent:
		return ""
	var lines: PackedStringArray = []
	if contested and agent:
		lines.append("%s── Situation: contested + agent ──[/color]" % COLOR_HEADER)
		lines.append(build_conflict_status_bbcode(province))
		lines.append(build_agent_glance_bbcode(province))
		var nat_badge := build_national_sources_badge(province)
		if not nat_badge.is_empty():
			lines.append("%sNational (same view): %s[/color]" % [COLOR_MUTED, nat_badge])
		var support := MapTechnologyContext.build_support_radio_glance_bbcode(
			country_tag_for_province(province),
		)
		if not support.is_empty():
			lines.append(support)
		lines.append(
			"%sMap: ▨ stripes + ◎ ring + supply fill (L); blended hover outline.[/color]" % COLOR_MUTED
		)
	elif contested:
		return build_inspector_conflict_section(province)
	else:
		return build_inspector_agent_section(province)
	return "\n".join(lines)


static func build_conflict_map_hint_plain(contested_count: int = -1) -> String:
	var n := contested_count
	if n < 0:
		n = count_contested_provinces()
	if n <= 0:
		return ""
	return "⚑ %d contested province%s — diagonal stripes on map" % [n, "s" if n != 1 else ""]


static func build_conflict_legend_line(contested_count: int = -1) -> String:
	var n := contested_count
	if n < 0:
		n = count_contested_provinces()
	if n <= 0:
		return ""
	return (
		"[color=#8899aa]⚑ Conflict: [/color][color=#ff7a7a]▨[/color][color=#8899aa] stripes = %d contested (owner ≠ controller)[/color]"
		% n
	)


static func country_tag_for_province(province: Province) -> String:
	if province == null:
		return ""
	if not province.controller_tag.is_empty():
		return province.controller_tag.strip_edges().to_upper()
	return province.owner_tag.strip_edges().to_upper()


static func build_province_report(
	province: Province,
	selected_province_id: int = -1,
	other_province: Province = null,
) -> Dictionary:
	if province == null:
		return {}
	var tag := country_tag_for_province(province)
	var pe: ProvinceEffects = get_province_effects_for(province, tag)
	return {
		"province": province,
		"country_tag": tag,
		"province_effects": pe,
		"logistics_rows": _logistics_rows(pe),
		"combat_rows": _combat_rows(pe),
		"depot_line": _depot_summary_line(province.id),
		"depot_fill": depot_fill_ratio(province.id),
		"movement_cost": province.get_movement_cost(),
		"national_rollup": build_national_rollup_bbcode(pe),
		"national_bbcode": build_national_effects_bbcode(province),
		"routes_bbcode": build_routes_through_province_bbcode(province.id, tag),
		"battle_block": _battle_block_for(province, selected_province_id, other_province),
		"supply_overlay_active": false,
	}


static func format_report_tooltip(report: Dictionary) -> String:
	if report.is_empty():
		return ""
	var p: Province = report["province"]
	var pe: ProvinceEffects = report.get("province_effects") as ProvinceEffects
	var lines: PackedStringArray = []
	var tags := build_province_situation_tags(p)
	var title := "%s%s (#%d)[/color]" % [COLOR_HEADER, p.name, p.id]
	if not tags.is_empty():
		title += " " + tags
	lines.append(title)
	var banner := build_tooltip_context_banner(report)
	if not banner.is_empty():
		lines.append(banner)
	lines.append(build_control_glance_bbcode(p))
	var dual := build_dual_situation_glance_bbcode(p)
	if not dual.is_empty():
		lines.append(dual)
	var nat_line := build_national_situation_one_liner(p, pe)
	if not nat_line.is_empty():
		lines.append(nat_line)
	var tag := str(report.get("country_tag", ""))
	var support_line := MapTechnologyContext.build_support_radio_glance_bbcode(tag)
	if not support_line.is_empty():
		lines.append(support_line)
	var glance := build_province_glance_bbcode(p, pe, 4, not dual.is_empty())
	if not glance.is_empty():
		lines.append(glance)
	lines.append(
		"%sDev %d  ·  Infra %d  ·  VP %d  ·  %s[/color]"
		% [COLOR_MUTED, p.development_level, p.infrastructure, p.victory_points, p.terrain.capitalize()]
	)
	if pe != null:
		lines.append(build_compact_effective_summary(pe))
		if bool(report.get("supply_overlay_active", false)):
			var log_line := build_supply_logistics_one_liner(pe)
			if not log_line.is_empty():
				lines.append(log_line)
	lines.append(_depot_bbcode_line(p.id))
	if bool(report.get("supply_overlay_active", false)):
		var layer_sum := build_compact_layers_summary_bbcode(
			true,
			count_contested_provinces(),
			count_agent_networks({}, str(report.get("country_tag", ""))),
			count_dual_situation_provinces(),
		)
		if not layer_sum.is_empty():
			lines.append(layer_sum)
		lines.append(build_supply_map_hint_bbcode(p.id))
		var role := str(report.get("hover_supply_role", ""))
		if not role.is_empty():
			lines.append(build_supply_role_hint_bbcode(p.id, role))
	var routes := build_routes_through_province_bbcode(
		p.id, str(report.get("country_tag", "")), 2,
	)
	if not routes.is_empty():
		lines.append(routes)
	var all_rows: Array = []
	all_rows.append_array(report.get("logistics_rows", []) as Array)
	all_rows.append_array(report.get("combat_rows", []) as Array)
	var impact := _top_impact_rows(all_rows, 4)
	if not impact.is_empty():
		lines.append("")
		lines.append("%s── Key modifiers ──[/color]" % COLOR_HEADER)
		lines.append(_stat_column_legend_bbcode())
		for row in impact:
			lines.append(_bbcode_stat_line_layered(row))
	var badge := build_national_sources_badge(p)
	if pe != null:
		var nat_impact := build_national_impact_compact(pe, 2)
		if not nat_impact.is_empty():
			lines.append(nat_impact)
	if not badge.is_empty():
		lines.append(badge)
		lines.append(build_national_sources_grouped_compact(p, 2))
	var battle := str(report.get("battle_block", ""))
	if not battle.is_empty():
		lines.append("")
		lines.append(battle)
	lines.append(
		"%sMovement cost: %.2f  ·  Click for full breakdown[/color]"
		% [COLOR_MUTED, float(report.get("movement_cost", 1.0))]
	)
	return "\n".join(lines)


static func format_report_inspector(report: Dictionary, selected_province_id: int = -1) -> String:
	var p: Province = report.get("province") as Province
	if p == null:
		return ""
	return build_inspector_full_bbcode(p, selected_province_id)


# --- Stat rows ---

static func _logistics_rows(pe: ProvinceEffects) -> Array[Dictionary]:
	return [
		_make_mult_row("Supply throughput", pe.province.get_supply_throughput_modifier(), pe.get_effective_throughput_multiplier(), pe, "supply_throughput"),
		_make_add_row("Local supply gen", pe.province.get_local_supply_generation_modifier(), pe.get_effective_local_supply_generation(), pe, "local_supply", true),
		_make_mult_row("Interdiction resist", pe.province.get_interdiction_resistance_modifier(), pe.get_effective_interdiction_resistance(), pe, "interdiction_resistance"),
		_make_mult_row("Reinforcement", pe.province.get_reinforcement_speed_modifier(), pe.get_effective_reinforcement_speed(), pe, "reinforcement_speed"),
		_make_score_row("Logistics quality", pe.province.get_logistics_quality(), pe.get_effective_logistics_quality(), pe, "logistics_quality"),
	]


static func _combat_rows(pe: ProvinceEffects) -> Array[Dictionary]:
	return [
		_make_mult_row("Combat width", pe.province.get_combat_width_modifier(), pe.get_effective_combat_width_multiplier(), pe, "combat_width"),
		_make_mult_row("Org recovery", pe.province.get_organization_recovery_modifier(), pe.get_effective_organization_recovery(), pe, "organization_recovery"),
		_make_mult_row("Attrition", pe.province.get_attrition_modifier(), pe.get_effective_attrition_multiplier(), pe, "attrition_reduction", true),
	]


static func _make_mult_row(
	label: String,
	base: float,
	effective: float,
	pe: ProvinceEffects,
	nat_key: String,
	lower_is_better: bool = false,
) -> Dictionary:
	var nat_v := float(pe.national_modifiers.get(nat_key, 0.0))
	return {
		"label": label,
		"base": base,
		"effective": effective,
		"kind": "mult",
		"nat_key": nat_key,
		"national_value": nat_v,
		"nat_delta": _national_delta_text(pe, nat_key),
		"improved": _is_improved(base, effective, lower_is_better),
	}


static func _make_add_row(
	label: String,
	base: float,
	effective: float,
	pe: ProvinceEffects,
	nat_key: String,
	as_percent: bool = false,
) -> Dictionary:
	var nat_v := float(pe.national_modifiers.get(nat_key, 0.0))
	return {
		"label": label,
		"base": base,
		"effective": effective,
		"kind": "add",
		"as_percent": as_percent,
		"nat_key": nat_key,
		"national_value": nat_v,
		"nat_delta": _national_delta_text(pe, nat_key),
		"improved": effective > base + 0.0001,
	}


static func _make_score_row(
	label: String,
	base: float,
	effective: float,
	pe: ProvinceEffects,
	nat_key: String,
) -> Dictionary:
	var nat_v := float(pe.national_modifiers.get(nat_key, 0.0))
	return {
		"label": label,
		"base": base,
		"effective": effective,
		"kind": "score",
		"nat_key": nat_key,
		"national_value": nat_v,
		"nat_delta": _national_delta_text(pe, nat_key),
		"improved": effective > base + 0.05,
	}


static func _national_delta_text(pe: ProvinceEffects, key: String) -> String:
	var v := float(pe.national_modifiers.get(key, 0.0))
	if absf(v) < 0.0001:
		return ""
	if absf(v) < 1.0:
		return "nat %+0.0f%%" % (v * 100.0)
	return "nat %+0.2f" % v


static func _is_improved(base: float, effective: float, lower_is_better: bool) -> bool:
	if lower_is_better:
		return effective < base - 0.0001
	return effective > base + 0.0001


static func _modifier_legend_bbcode() -> String:
	return (
		"%sLayered stats: %sProvince base[/color] → %sNational[/color] → %sEffective[/color]"
		% [COLOR_MUTED, COLOR_PROVINCE, COLOR_NATIONAL, COLOR_EFFECTIVE]
	)


static func _stat_column_legend_bbcode() -> String:
	return (
		"%sStat  |  %sProvince[/color]  |  %sNational[/color]  |  %sEffective[/color]"
		% [COLOR_MUTED, COLOR_PROVINCE, COLOR_NATIONAL, COLOR_EFFECTIVE]
	)


static func build_tooltip_context_banner(report: Dictionary) -> String:
	var p: Province = report.get("province") as Province
	if p == null:
		return ""
	var parts: PackedStringArray = []
	var sel := int(report.get("selected_province_id", -1))
	var other: Province = report.get("other_province") as Province
	if sel >= 0 and sel == p.id:
		parts.append("%s◇ Hover ○-outlined neighbor for ⚔ preview[/color]" % COLOR_MUTED)
	elif sel >= 0:
		if other != null:
			parts.append("%s⚔ vs %s[/color]" % [COLOR_WARN, other.name])
			parts.append("%s↳ bold orange outline on partner[/color]" % COLOR_MUTED)
		elif bool(report.get("is_compare_candidate", false)):
			var hint := "%s○ Neighbor of %s — click for locked compare[/color]" % [
				COLOR_WARN, _province_short_name(sel),
			]
			if (
				bool(report.get("is_contested", false))
				and bool(report.get("has_agent_network", false))
			):
				hint += "  ·  %s⚑◎ contested + agent[/color]" % COLOR_WARN
			elif bool(report.get("is_contested", false)):
				hint += "  ·  %s⚑ contested[/color]" % COLOR_WARN
			elif bool(report.get("has_agent_network", false)):
				hint += "  ·  %s◎ agent[/color]" % COLOR_NATIONAL
			parts.append(hint)
		else:
			parts.append(build_non_adjacent_compare_hint(p, sel))
	if parts.is_empty():
		return ""
	return "  ·  ".join(parts)


static func build_non_adjacent_compare_hint(hover_province: Province, selected_province_id: int) -> String:
	var neighbor_names := _adjacent_province_names(selected_province_id, 4)
	if neighbor_names.is_empty():
		return "%s◇ Selection not adjacent to this province[/color]" % COLOR_MUTED
	return (
		"%s◇ Not adjacent — hover %s for ⚔ preview[/color]"
		% [COLOR_MUTED, ", ".join(neighbor_names)]
	)


static func _adjacent_province_names(province_id: int, limit: int = 4) -> PackedStringArray:
	var names := PackedStringArray()
	var adj: AdjacencySystem = null
	if typeof(MapManager) != TYPE_NIL and MapManager.has_method("get_adjacency_system"):
		adj = MapManager.get_adjacency_system()
	if adj == null:
		var loader := _scenario_loader()
		if loader != null:
			adj = loader.adjacency
	if adj == null:
		return names
	for nid in adj.get_neighbors(province_id):
		var p := _province_by_id(int(nid))
		if p != null and not p.name.is_empty():
			names.append(p.name)
		if names.size() >= limit:
			break
	return names


static func build_inspector_national_section(province: Province, pe: ProvinceEffects) -> String:
	var lines: PackedStringArray = []
	lines.append("%s── National effects ──[/color]" % COLOR_HEADER)
	lines.append(
		"%s◆ spirits · ⏱ timed · ◎ agents — sources then combined totals[/color]" % COLOR_MUTED
	)
	var badge := build_national_sources_badge(province)
	if not badge.is_empty():
		lines.append(badge)
	if pe != null:
		var impact := build_national_impact_compact(pe, 4)
		if not impact.is_empty():
			lines.append(impact)
	var grouped := build_national_sources_grouped_compact(province, 4)
	if not grouped.is_empty():
		lines.append("%s  Active sources[/color]" % COLOR_MUTED)
		lines.append(grouped)
	if pe != null and not pe.national_modifiers.is_empty():
		lines.append("")
		lines.append(build_national_rollup_bbcode(pe))
	elif badge.is_empty():
		lines.append("%s  No province-relevant national modifiers.[/color]" % COLOR_MUTED)
	return "\n".join(lines)


static func build_supply_logistics_one_liner(pe: ProvinceEffects) -> String:
	if pe == null:
		return ""
	return (
		"%s⛟ Supply — throughput ×%.2f · interdict resist ×%.2f · local gen %+.0f%%[/color]"
		% [
			COLOR_MUTED,
			pe.get_effective_throughput_multiplier(),
			pe.get_effective_interdiction_resistance(),
			pe.get_effective_local_supply_generation() * 100.0,
		]
	)


static func build_national_situation_one_liner(province: Province, pe: ProvinceEffects = null) -> String:
	if province == null:
		return ""
	var badge := build_national_sources_badge(province)
	if badge.is_empty() and pe == null:
		return ""
	var impact := ""
	if pe != null:
		impact = build_national_impact_compact(pe, 2)
	if badge.is_empty() and impact.is_empty():
		return ""
	if impact.is_empty():
		return "%sNational: %s[/color]" % [COLOR_NATIONAL, badge]
	return "%sNational: %s · %s[/color]" % [COLOR_NATIONAL, badge, impact]


static func build_national_impact_compact(pe: ProvinceEffects, max_keys: int = 2) -> String:
	if pe == null or pe.national_modifiers.is_empty():
		return ""
	var scored: Array[Dictionary] = []
	for key in pe.national_modifiers.keys():
		var v := float(pe.national_modifiers[key])
		if absf(v) < 0.0001:
			continue
		scored.append({"key": str(key), "value": v, "abs": absf(v)})
	scored.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		return float(a.get("abs", 0.0)) > float(b.get("abs", 0.0))
	)
	if scored.is_empty():
		return ""
	var parts: PackedStringArray = []
	for i in range(mini(scored.size(), max_keys)):
		var entry: Dictionary = scored[i]
		var label := str(NATIONAL_KEY_LABELS.get(entry.get("key", ""), str(entry.get("key", ""))))
		parts.append("%s%s %s[/color]" % [COLOR_NATIONAL, label, _format_national_value(float(entry.get("value", 0.0)))])
	var extra := scored.size() - max_keys
	var suffix := ""
	if extra > 0:
		suffix = "  %s(+%d in inspector)[/color]" % [COLOR_MUTED, extra]
	return "%s◆ National impact: %s%s[/color]" % [COLOR_NATIONAL, " · ".join(parts), suffix]


static func build_compact_effective_summary(pe: ProvinceEffects) -> String:
	if pe == null:
		return ""
	return (
		"%sEffective — supply ×%.2f · reinf ×%.2f · width ×%.2f · org ×%.2f[/color]"
		% [
			COLOR_MUTED,
			pe.get_effective_throughput_multiplier(),
			pe.get_effective_reinforcement_speed(),
			pe.get_effective_combat_width_multiplier(),
			pe.get_effective_organization_recovery(),
		]
	)


static func build_national_sources_badge(province: Province) -> String:
	var tag := country_tag_for_province(province)
	if tag.is_empty():
		return ""
	var spirit_n := _national_spirit_lines(tag).size()
	var temp_n := _temporary_effect_lines(tag).size()
	var has_agent := not _agent_network_line(province.id, tag).is_empty()
	if spirit_n == 0 and temp_n == 0 and not has_agent:
		return "%sNational: no province-relevant effects[/color]" % COLOR_MUTED
	var parts: PackedStringArray = []
	if spirit_n > 0:
		parts.append("%d spirit%s" % [spirit_n, "s" if spirit_n != 1 else ""])
	if temp_n > 0:
		parts.append("%d timed" % temp_n)
	if has_agent:
		parts.append("agent network")
	return "%s◆ National: %s[/color]" % [COLOR_NATIONAL, " · ".join(parts)]


static func build_national_sources_grouped_compact(province: Province, max_per_group: int = 2) -> String:
	var tag := country_tag_for_province(province)
	if tag.is_empty():
		return ""
	var spirits := _national_spirit_lines(tag)
	var temps := _temporary_effect_lines(tag)
	var agent := _agent_network_line(province.id, tag)
	var blocks: PackedStringArray = []
	if not spirits.is_empty():
		blocks.append("%s  ◆ Spirits (%d)[/color]" % [COLOR_NATIONAL, spirits.size()])
		for i in range(mini(spirits.size(), max_per_group)):
			blocks.append(spirits[i])
		if spirits.size() > max_per_group:
			blocks.append("%s    … +%d more[/color]" % [COLOR_MUTED, spirits.size() - max_per_group])
	if not temps.is_empty():
		blocks.append("%s  ⏱ Timed effects (%d)[/color]" % [COLOR_WARN, temps.size()])
		for i in range(mini(temps.size(), max_per_group)):
			blocks.append(temps[i])
		if temps.size() > max_per_group:
			blocks.append("%s    … +%d more[/color]" % [COLOR_MUTED, temps.size() - max_per_group])
	if not agent.is_empty():
		blocks.append("%s  ◎ Agent network[/color]" % COLOR_NATIONAL)
		blocks.append(agent)
	if blocks.is_empty():
		return ""
	return "\n".join(blocks)


static func build_national_sources_compact_limited(province: Province, max_lines: int = 3) -> String:
	var tag := country_tag_for_province(province)
	if tag.is_empty():
		return ""
	var lines: PackedStringArray = []
	for line in _national_spirit_lines(tag):
		lines.append(line)
	for line in _temporary_effect_lines(tag):
		lines.append(line)
	var agent := _agent_network_line(province.id, tag)
	if not agent.is_empty():
		lines.append(agent)
	if lines.is_empty():
		return ""
	var total := lines.size()
	if total > max_lines:
		var kept: PackedStringArray = []
		for i in range(max_lines):
			kept.append(lines[i])
		kept.append("%s  … +%d more in inspector[/color]" % [COLOR_MUTED, total - max_lines])
		return "\n".join(kept)
	return "\n".join(lines)


static func _top_impact_rows(rows: Array, max_count: int = 4) -> Array:
	var scored: Array[Dictionary] = []
	for row_var in rows:
		if typeof(row_var) != TYPE_DICTIONARY:
			continue
		var row: Dictionary = row_var
		var score := absf(float(row.get("national_value", 0.0)))
		if bool(row.get("improved", false)):
			score += 0.25
		if absf(float(row.get("effective", 1.0)) - float(row.get("base", 1.0))) > 0.05:
			score += 0.15
		scored.append({"row": row, "score": score})
	scored.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		return float(a.get("score", 0.0)) > float(b.get("score", 0.0))
	)
	var out: Array = []
	for i in range(mini(scored.size(), max_count)):
		out.append(scored[i]["row"])
	return out


static func build_national_sources_compact(province: Province) -> String:
	var tag := country_tag_for_province(province)
	if tag.is_empty():
		return ""
	var lines: PackedStringArray = []
	for line in _national_spirit_lines(tag):
		lines.append(line)
	for line in _temporary_effect_lines(tag):
		lines.append(line)
	var agent := _agent_network_line(province.id, tag)
	if not agent.is_empty():
		lines.append(agent)
	if lines.is_empty():
		return ""
	var header := "%s── Affecting this province ──[/color]" % COLOR_HEADER
	lines.insert(0, header)
	return "\n".join(lines)


static func build_inspector_compare_header(
	province: Province,
	selected_province_id: int = -1,
) -> String:
	if selected_province_id < 0 or selected_province_id == province.id:
		return ""
	var other := _resolve_battle_counterpart(province, selected_province_id)
	if other == null:
		return (
			"%s◇ Province #%d selected — select an adjacent province for combat comparison.[/color]"
			% [COLOR_MUTED, selected_province_id]
		)
	return "%s⚔ Comparing with %s — battle preview below.[/color]" % [COLOR_WARN, other.name]


static func build_supply_map_hint_bbcode(province_id: int) -> String:
	var fill := depot_fill_ratio(province_id)
	var sm := _supply_manager()
	var role := "no depot"
	if fill >= 0.0:
		if fill < 0.35:
			role = "critical depot"
		elif fill < 0.65:
			role = "strained depot"
		else:
			role = "healthy depot"
	var route_note := ""
	if sm != null:
		for plan_var in sm.get_all_routes():
			if plan_var is SupplyRoutePlan and province_id in (plan_var as SupplyRoutePlan).province_path:
				route_note = " · on active supply route"
				break
	return (
		"%s📦 Tint: %s (%d%%)%s  |  ◇ hub  — route  ◆ selected  · ~ preview[/color]"
		% [COLOR_MUTED, role, int(round(maxf(fill, 0.0) * 100.0)), route_note]
	)


static func _bbcode_stat_line_layered(row: Dictionary) -> String:
	var label := str(row.get("label", ""))
	var nat_val := float(row.get("national_value", 0.0))
	var improved: bool = row.get("improved", false)
	var eff_color := COLOR_EFFECTIVE if improved else COLOR_BASE
	var nat_text := _format_national_value(nat_val)
	if nat_text == "—" and not str(row.get("nat_delta", "")).is_empty():
		nat_text = str(row.get("nat_delta", "")).replace("nat ", "")
	var delta_hint := ""
	if improved:
		delta_hint = " %s▲[/color]" % COLOR_EFFECTIVE
	elif absf(nat_val) >= 0.0001 and not improved:
		delta_hint = " %s▼[/color]" % COLOR_WARN
	return (
		"%s%s[/color]  |  %s%s[/color]  |  %s%s[/color]  |  %s%s[/color]%s"
		% [
			COLOR_BASE,
			label,
			COLOR_PROVINCE,
			_format_base_value(row),
			COLOR_NATIONAL,
			nat_text,
			eff_color,
			_format_effective_value(row),
			delta_hint,
		]
	)


static func _format_base_value(row: Dictionary) -> String:
	match str(row.get("kind", "mult")):
		"add":
			if row.get("as_percent", false):
				return "%+.0f%%" % (float(row.get("base", 0.0)) * 100.0)
			return "%.2f" % float(row.get("base", 0.0))
		"score":
			return "%.0f" % float(row.get("base", 0.0))
		_:
			return "×%.2f" % float(row.get("base", 1.0))


static func _format_effective_value(row: Dictionary) -> String:
	match str(row.get("kind", "mult")):
		"add":
			if row.get("as_percent", false):
				return "%+.0f%%" % (float(row.get("effective", 0.0)) * 100.0)
			return "%.2f" % float(row.get("effective", 0.0))
		"score":
			return "%.0f" % float(row.get("effective", 0.0))
		_:
			return "×%.2f" % float(row.get("effective", 1.0))


static func _format_national_value(value: float) -> String:
	if absf(value) < 0.0001:
		return "—"
	if absf(value) < 1.0:
		return "%+.0f%%" % (value * 100.0)
	return "%+.2f" % value


static func _depot_bbcode_line(province_id: int) -> String:
	var sm := _supply_manager()
	if sm == null:
		return "%sDepot: network not built[/color]" % COLOR_MUTED
	var depot: ProvinceDepotState = sm.get_depot_state(province_id)
	if depot == null:
		return "%sDepot: not a supply hub[/color]" % COLOR_MUTED
	var fill := depot.fill_ratio()
	var pct := int(round(fill * 100.0))
	var color := COLOR_EFFECTIVE
	var status := "adequate"
	var icon := "✓"
	if fill < 0.35:
		color = COLOR_WARN
		status = "critical"
		icon = "⚠"
	elif fill < 0.65:
		color = "[color=#e8c04a]"
		status = "strained"
		icon = "◐"
	return (
		"%s%s Depot [/color]%s%d%% (%s)[/color]%s · %.0f t/day · cap %.0f"
		% [
			COLOR_MUTED,
			icon,
			color,
			pct,
			status,
			COLOR_MUTED,
			depot.throughput_capacity,
			depot.storage_capacity,
		]
	)


static func _province_short_name(province_id: int) -> String:
	var p := _province_by_id(province_id)
	if p != null and not p.name.is_empty():
		return p.name
	return "P%d" % province_id


static func _bbcode_stat_line(row: Dictionary) -> String:
	var label := str(row.get("label", ""))
	var nat := str(row.get("nat_delta", ""))
	var improved: bool = row.get("improved", false)
	var eff_color := COLOR_EFFECTIVE if improved else COLOR_BASE
	match str(row.get("kind", "mult")):
		"add":
			var as_pct: bool = row.get("as_percent", false)
			var b := float(row.get("base", 0.0))
			var e := float(row.get("effective", 0.0))
			if as_pct:
				return "%s%s: %s%+.0f%%[/color] → %s%+.0f%%[/color]%s" % [
					COLOR_BASE, label, COLOR_BASE, b * 100.0, eff_color, e * 100.0,
					_nat_suffix(nat),
				]
			return "%s%s: %s%.2f[/color] → %s%.2f[/color]%s" % [
				COLOR_BASE, label, COLOR_BASE, b, eff_color, e, _nat_suffix(nat),
			]
		"score":
			return "%s%s: %s%.0f[/color] → %s%.0f[/color]%s" % [
				COLOR_BASE, label, COLOR_BASE, row.get("base", 0.0), eff_color, row.get("effective", 0.0),
				_nat_suffix(nat),
			]
		_:
			return "%s%s: %s×%.2f[/color] → %s×%.2f[/color]%s" % [
				COLOR_BASE, label, COLOR_BASE, row.get("base", 1.0), eff_color, row.get("effective", 1.0),
				_nat_suffix(nat),
			]


static func _plain_stat_line(row: Dictionary) -> String:
	var nat := str(row.get("nat_delta", ""))
	match str(row.get("kind", "mult")):
		"add":
			if row.get("as_percent", false):
				return "%s: +%.0f%% → +%.0f%%%s" % [
					row.get("label", ""), float(row.get("base", 0.0)) * 100.0,
					float(row.get("effective", 0.0)) * 100.0, _nat_suffix_plain(nat),
				]
			return "%s: %.2f → %.2f%s" % [
				row.get("label", ""), row.get("base", 0.0), row.get("effective", 0.0), _nat_suffix_plain(nat),
			]
		"score":
			return "%s: %.0f → %.0f%s" % [
				row.get("label", ""), row.get("base", 0.0), row.get("effective", 0.0), _nat_suffix_plain(nat),
			]
		_:
			return "%s: ×%.2f → ×%.2f%s" % [
				row.get("label", ""), row.get("base", 1.0), row.get("effective", 1.0), _nat_suffix_plain(nat),
			]


static func _nat_suffix(nat: String) -> String:
	if nat.is_empty():
		return ""
	return " %s(%s)[/color]" % [COLOR_NATIONAL, nat]


static func _nat_suffix_plain(nat: String) -> String:
	if nat.is_empty():
		return ""
	return " (%s)" % nat


static func _owner_controller_bbcode(province: Province) -> String:
	var owner := province.owner_tag if not province.owner_tag.is_empty() else "—"
	var ctrl := province.controller_tag if not province.controller_tag.is_empty() else owner
	if ctrl == owner:
		return "%sOwner: %s[/color]" % [COLOR_MUTED, owner]
	return "%sOwner: %s  ·  %s⚑ Held by: %s[/color]" % [COLOR_MUTED, owner, COLOR_WARN, ctrl]


static func _battle_block_for(
	province: Province,
	selected_province_id: int,
	other_province: Province,
) -> String:
	if other_province != null and other_province.id != province.id:
		return _battle_preview_block(province, other_province, selected_province_id)
	return _local_battle_block(province)


# --- National sources ---

static func _national_spirit_lines(country_tag: String) -> PackedStringArray:
	var lines := PackedStringArray()
	if typeof(NationalSpiritManager) == TYPE_NIL:
		return lines
	var data := NationalSpiritManager.get_spirits_screen_data(country_tag)
	for spirit in data.permanent_spirits:
		if typeof(spirit) != TYPE_DICTIONARY:
			continue
		var mods := _extract_relevant_modifiers(spirit.get("modifier_details", []))
		if mods.is_empty():
			continue
		lines.append(
			"%s  ◆ Spirit · %s: %s[/color]" % [COLOR_NATIONAL, spirit.get("name", ""), ", ".join(mods)]
		)
	return lines


static func _temporary_effect_lines(country_tag: String) -> PackedStringArray:
	var lines := PackedStringArray()
	if typeof(NationalSpiritManager) == TYPE_NIL:
		return lines
	for row in NationalSpiritManager.get_temporary_effect_rows(country_tag):
		if typeof(row) != TYPE_DICTIONARY:
			continue
		var mods := _extract_relevant_modifiers(row.get("modifier_details", []))
		if mods.is_empty():
			continue
		var months := int(row.get("remaining_months", 0))
		lines.append(
			"%s  ⏱ Timed · %s (%dm): %s[/color]"
			% [COLOR_WARN, row.get("source_label", "Effect"), months, ", ".join(mods)]
		)
	return lines


static func _extract_relevant_modifiers(details: Array) -> PackedStringArray:
	var parts := PackedStringArray()
	for raw in details:
		if typeof(raw) != TYPE_DICTIONARY:
			continue
		var d := raw as Dictionary
		var key := str(d.get("key", "")).to_lower()
		if not _modifier_key_affects_provinces(key):
			continue
		parts.append("%s %s" % [d.get("label", key), d.get("value_text", "")])
	return parts


static func _modifier_key_affects_provinces(key: String) -> bool:
	var k := key.to_lower()
	for rel in PROVINCE_MODIFIER_KEYS:
		if rel in k or k in rel:
			return true
	return false


static func _agent_network_line(province_id: int, country_tag: String) -> String:
	if typeof(AgentManager) == TYPE_NIL:
		return ""
	var net: AgentNetwork = AgentManager.get_network(province_id)
	if net == null or not net.is_active():
		return ""
	if net.controlling_country.strip_edges().to_upper() != country_tag:
		return ""
	return (
		"%s  ◎ Agent network: %s (str %.0f, %d locals)[/color]"
		% [COLOR_NATIONAL, net.focus, net.strength, net.local_operatives]
	)


# --- Battle preview (unchanged logic, bbcode headers) ---

static func get_battle_preview(attacker: Province, defender: Province) -> Dictionary:
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
	var pe_att := get_province_effects_for(attacker)
	var pe_def := get_province_effects_for(defender)
	var att_width := pe_att.get_effective_combat_width_multiplier() if pe_att else 1.0
	var def_width := pe_def.get_effective_combat_width_multiplier() if pe_def else 1.0
	var def_org := pe_def.get_effective_organization_recovery() if pe_def else 1.0
	return {
		"terrain": terrain,
		"terrain_width_modifier": terrain_mod,
		"rules_engagement_width": rules_width,
		"province_width_multiplier": prov_mult,
		"estimated_effective_width": rules_width,
		"attacker_width_mult": att_width,
		"defender_width_mult": def_width,
		"defender_org_recovery": def_org,
		"attacker_infra": attacker.infrastructure,
		"defender_infra": defender.infrastructure,
		"attacker_dev": attacker.development_level,
		"defender_dev": defender.development_level,
	}


static func _local_battle_block(province: Province) -> String:
	var preview := get_battle_preview(province, province)
	var block := _format_preview_header("Local engagement", preview)
	var pe := get_province_effects_for(province)
	if pe != null:
		block += (
			"\n  %sNational/org on defender: width ×%.2f · org ×%.2f[/color]"
			% [
				COLOR_MUTED,
				pe.get_effective_combat_width_multiplier(),
				pe.get_effective_organization_recovery(),
			]
		)
	block += "\n  %sSelect adjacent province for cross-border preview.[/color]" % COLOR_MUTED
	return block


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
	var block := _format_preview_header("⚔ " + title, preview)
	var situation := build_compare_situation_note(attacker, defender)
	if not situation.is_empty():
		block += "\n" + situation
	return block


static func _format_preview_header(title: String, preview: Dictionary) -> String:
	if preview.is_empty():
		return "%s%s: unavailable[/color]" % [COLOR_HEADER, title]
	var lines: PackedStringArray = []
	lines.append("%s%s[/color]" % [COLOR_HEADER, title])
	lines.append(
		"  %sEngagement width: %.1f[/color]"
		% [COLOR_EFFECTIVE, float(preview.get("estimated_effective_width", preview.get("rules_engagement_width", 0.0)))]
	)
	lines.append(
		"  %s%s ×%.2f · Infra %d vs %d · Dev %d vs %d[/color]"
		% [
			COLOR_MUTED,
			str(preview.get("terrain", "plains")).capitalize(),
			float(preview.get("terrain_width_modifier", 1.0)),
			int(preview.get("attacker_infra", 0)),
			int(preview.get("defender_infra", 0)),
			int(preview.get("attacker_dev", 0)),
			int(preview.get("defender_dev", 0)),
		]
	)
	lines.append(
		"  %sAttacker width ×%.2f · Defender width ×%.2f · Defender org ×%.2f[/color]"
		% [
			COLOR_NATIONAL,
			float(preview.get("attacker_width_mult", 1.0)),
			float(preview.get("defender_width_mult", 1.0)),
			float(preview.get("defender_org_recovery", 1.0)),
		]
	)
	return "\n".join(lines)


static func _terrain_width_line(terrain: String) -> String:
	var calc := CombatWidthCalculator.new()
	var mod := calc.get_terrain_width_modifier(terrain)
	calc.free()
	return "Terrain (%s) width mod: ×%.2f" % [terrain.capitalize(), mod]


static func _depot_summary_line(province_id: int) -> String:
	var sm := _supply_manager()
	if sm == null:
		return "Depot: network not built"
	var depot: ProvinceDepotState = sm.get_depot_state(province_id)
	if depot == null:
		return "Depot: not a supply hub"
	var fill := int(round(depot.fill_ratio() * 100.0))
	var status := "adequate"
	if fill < 35:
		status = "critical"
	elif fill < 65:
		status = "strained"
	return "Depot: %d%% full (%s) · %.0f t/day · cap %.0f" % [fill, status, depot.throughput_capacity, depot.storage_capacity]


static func _resolve_battle_counterpart(province: Province, selected_province_id: int) -> Province:
	if selected_province_id < 0 or selected_province_id == province.id:
		return null
	# Prefer MapManager (central authority)
	if typeof(MapManager) != TYPE_NIL and MapManager.has_method("get_adjacency_system"):
		var adj := MapManager.get_adjacency_system()
		if adj != null and not adj.are_adjacent(province.id, selected_province_id):
			return null
		var p := MapManager.get_province(selected_province_id)
		if p != null:
			return p
	# Fallback
	var loader := _scenario_loader()
	if loader == null or not loader.provinces.has(selected_province_id):
		return null
	if loader.adjacency != null and not loader.adjacency.are_adjacent(province.id, selected_province_id):
		return null
	return loader.provinces[selected_province_id] as Province


static func _province_by_id(province_id: int) -> Province:
	var p := MapManager.get_province(province_id) if typeof(MapManager) != TYPE_NIL and MapManager.has_method("get_province") else null
	if p != null:
		return p
	var loader := _scenario_loader()
	if loader != null and loader.provinces.has(province_id):
		return loader.provinces[province_id] as Province
	return null


static func _supply_manager() -> Node:
	var tree := Engine.get_main_loop()
	if tree == null:
		return null
	return tree.root.get_node_or_null("SupplyManager")


static func _scenario_loader() -> ScenarioLoader:
	# DEPRECATED — Direct ScenarioLoader access is legacy technical debt.
	# All map code (overlays, tooltips, picking, effects, culling) must use MapManager exclusively.
	# This helper remains only for a couple of internal fallback paths during the transition and will be removed.
	var tree := Engine.get_main_loop()
	if tree == null:
		return null
	var node: Node = tree.root.find_child("ScenarioLoader", true, false)
	return node as ScenarioLoader
