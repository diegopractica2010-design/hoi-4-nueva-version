class_name ProvinceMapVisuals
extends RefCounted

## Retrowave-style province outline helpers for MapRenderer.

const OUTLINE_HOVER := Color(0.45, 0.88, 1.0, 0.95)
const OUTLINE_HOVER_GLOW := Color(0.25, 0.55, 0.95, 0.35)
const OUTLINE_SELECT := Color(0.98, 0.42, 0.88, 1.0)
const OUTLINE_SELECT_GLOW := Color(0.75, 0.2, 0.65, 0.3)
const OUTLINE_COMPARE := Color(1.0, 0.72, 0.32, 0.92)
const OUTLINE_COMPARE_GLOW := Color(0.95, 0.55, 0.15, 0.28)
const OUTLINE_COMPARE_CANDIDATE := Color(1.0, 0.65, 0.28, 0.5)
const OUTLINE_COMPARE_CANDIDATE_GLOW := Color(0.85, 0.45, 0.12, 0.2)
const OUTLINE_COMPARE_CANDIDATE_EMPH := Color(1.0, 0.78, 0.42, 0.88)
const FILL_COMPARE_CANDIDATE := Color(1.0, 0.68, 0.28, 1.0)
const FILL_CONFLICT := Color(1.0, 0.42, 0.42, 1.0)
const FILL_AGENT := Color(0.62, 0.45, 0.98, 1.0)
const FILL_AGENT_DISRUPT := Color(0.95, 0.55, 0.28, 1.0)
const FILL_AGENT_SABOTAGE := Color(1.0, 0.38, 0.45, 1.0)
const FILL_AGENT_DISRUPT_BASE := Color(0.92, 0.48, 0.22, 1.0)
const FILL_AGENT_SABOTAGE_BASE := Color(0.95, 0.32, 0.38, 1.0)
const OUTLINE_AGENT_DISRUPT := Color(1.0, 0.62, 0.32, 0.95)
const OUTLINE_AGENT_SABOTAGE := Color(1.0, 0.42, 0.48, 0.95)
const OUTLINE_CONFLICT := Color(1.0, 0.45, 0.45, 0.75)
const OUTLINE_CONFLICT_GLOW := Color(0.75, 0.2, 0.2, 0.22)
const OUTLINE_SELECT_CONTESTED := Color(0.98, 0.5, 0.72, 1.0)
const OUTLINE_SELECT_CONTESTED_GLOW := Color(0.85, 0.25, 0.35, 0.32)
const OUTLINE_AGENT := Color(0.72, 0.52, 1.0, 0.9)
const OUTLINE_AGENT_GLOW := Color(0.45, 0.28, 0.75, 0.28)
const OUTLINE_DUAL := Color(0.95, 0.52, 0.82, 0.92)
const OUTLINE_DUAL_GLOW := Color(0.7, 0.28, 0.55, 0.32)
const FILL_DUAL := Color(0.92, 0.48, 0.72, 1.0)

const NODE_COMPARE_CANDIDATE := "CompareCandidateOutline"
const OUTLINE_SUPPLY_HUB := Color(0.35, 0.95, 0.72, 0.9)
const OUTLINE_SUPPLY_ROUTE := Color(0.95, 0.78, 0.28, 0.88)
const OUTLINE_SUPPLY_PREVIEW := Color(0.55, 0.9, 0.98, 0.9)
const OUTLINE_SUPPLY_ACTIVE := Color(0.62, 0.48, 1.0, 0.98)
const OUTLINE_SUPPLY_HUB_GLOW := Color(0.2, 0.55, 0.4, 0.25)
const OUTLINE_SUPPLY_ROUTE_GLOW := Color(0.6, 0.45, 0.1, 0.28)
const OUTLINE_SUPPLY_PREVIEW_GLOW := Color(0.3, 0.65, 0.75, 0.32)
const OUTLINE_SUPPLY_ACTIVE_GLOW := Color(0.4, 0.25, 0.75, 0.35)

const Z_SUPPLY := 10
const Z_COMPARE_CANDIDATE := 11
const Z_COMPARE := 13
const Z_HOVER := 14
const Z_SELECT := 16

const NODE_HOVER := "HoverOutline"
const NODE_HOVER_GLOW := "HoverOutlineGlow"
const NODE_SELECT := "SelectionOutline"
const NODE_SELECT_GLOW := "SelectionOutlineGlow"
const NODE_COMPARE := "ComparePreviewOutline"
const NODE_COMPARE_GLOW := "ComparePreviewGlow"
const NODE_SUPPLY := "SupplyOutline"
const NODE_SUPPLY_GLOW := "SupplyOutlineGlow"

const SUFFIX_GLOW := "Glow"


static func make_closed_outline(points: PackedVector2Array, color: Color, width: float = 2.0) -> Line2D:
	var line := Line2D.new()
	line.points = points
	line.closed = true
	line.width = width
	line.default_color = color
	line.antialiased = true
	line.joint_mode = Line2D.LINE_JOINT_ROUND
	line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	line.end_cap_mode = Line2D.LINE_CAP_ROUND
	line.z_index = 12
	return line


static func ensure_outline(
	parent: Node2D,
	polygon: PackedVector2Array,
	node_name: String,
	color: Color,
	width: float,
	z_index: int = 12,
) -> Line2D:
	var existing := parent.get_node_or_null(node_name) as Line2D
	if existing != null:
		existing.points = polygon
		existing.default_color = color
		existing.width = width
		existing.z_index = z_index
		existing.visible = true
		return existing
	var line := make_closed_outline(polygon, color, width)
	line.name = node_name
	line.z_index = z_index
	parent.add_child(line)
	return line


static func ensure_polished_outline(
	parent: Node2D,
	polygon: PackedVector2Array,
	base_name: String,
	color: Color,
	width: float,
	glow_color: Color,
	glow_extra_width: float = 3.0,
	z_index: int = 12,
) -> void:
	ensure_outline(
		parent,
		polygon,
		base_name + SUFFIX_GLOW,
		glow_color,
		width + glow_extra_width,
		z_index - 1,
	)
	ensure_outline(parent, polygon, base_name, color, width, z_index)


static func hide_outline(parent: Node2D, node_name: String) -> void:
	var existing := parent.get_node_or_null(node_name) as Line2D
	if existing != null:
		existing.visible = false


static func hide_polished_outline(parent: Node2D, base_name: String) -> void:
	hide_outline(parent, base_name)
	hide_outline(parent, base_name + SUFFIX_GLOW)


static func get_outline_line(parent: Node2D, node_name: String) -> Line2D:
	return parent.get_node_or_null(node_name) as Line2D


## pulse_phase: radians; animates width/alpha for responsive feedback.
static func apply_pulse_to_line(
	line: Line2D,
	base_color: Color,
	base_width: float,
	pulse_phase: float,
	width_amount: float = 0.35,
	alpha_min_scale: float = 0.72,
) -> void:
	if line == null or not line.visible:
		return
	var raw := 0.5 + 0.5 * sin(pulse_phase)
	var t := raw * raw * (3.0 - 2.0 * raw)
	var c := base_color
	c.a = lerpf(base_color.a * alpha_min_scale, base_color.a, t)
	line.default_color = c
	line.width = base_width + width_amount * t


static func apply_pulse_to_polished(
	parent: Node2D,
	base_name: String,
	main_color: Color,
	main_width: float,
	glow_color: Color,
	glow_width: float,
	pulse_phase: float,
	width_amount: float = 0.35,
	pulse_speed: float = 1.0,
) -> void:
	var phase := pulse_phase * pulse_speed
	apply_pulse_to_line(
		get_outline_line(parent, base_name), main_color, main_width, phase, width_amount, 0.75,
	)
	apply_pulse_to_line(
		get_outline_line(parent, base_name + SUFFIX_GLOW),
		glow_color,
		glow_width,
		phase,
		width_amount + 0.15,
		0.55,
	)


## Returns {color, glow, width, glow_extra, z_index, pulse_speed}.
static func get_supply_outline_style(role: String) -> Dictionary:
	match role:
		"active":
			return {
				"color": OUTLINE_SUPPLY_ACTIVE,
				"glow": OUTLINE_SUPPLY_ACTIVE_GLOW,
				"width": 3.2,
				"glow_extra": 3.0,
				"z_index": Z_SUPPLY,
				"pulse_speed": 1.15,
			}
		"preview":
			return {
				"color": OUTLINE_SUPPLY_PREVIEW,
				"glow": OUTLINE_SUPPLY_PREVIEW_GLOW,
				"width": 2.4,
				"glow_extra": 2.8,
				"z_index": Z_SUPPLY,
				"pulse_speed": 2.4,
			}
		"route":
			return {
				"color": OUTLINE_SUPPLY_ROUTE,
				"glow": OUTLINE_SUPPLY_ROUTE_GLOW,
				"width": 2.0,
				"glow_extra": 2.2,
				"z_index": Z_SUPPLY,
				"pulse_speed": 0.85,
			}
		_:
			return {
				"color": OUTLINE_SUPPLY_HUB,
				"glow": OUTLINE_SUPPLY_HUB_GLOW,
				"width": 1.8,
				"glow_extra": 2.0,
				"z_index": Z_SUPPLY,
				"pulse_speed": 0.65,
			}
