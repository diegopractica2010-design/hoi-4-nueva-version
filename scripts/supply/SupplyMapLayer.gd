class_name SupplyMapLayer
extends Node2D

## Draws land / sea / air supply routes on the map.

@export var line_width: float = 3.0
var _centroids: Dictionary = {}
var _rules: SupplyRules = null


func setup(centroids: Dictionary, rules: SupplyRules) -> void:
	_centroids = centroids
	_rules = rules
	z_index = 60
	queue_redraw()


func set_routes(plans: Array) -> void:
	_routes_to_draw = plans
	queue_redraw()


var _routes_to_draw: Array = []


func _draw() -> void:
	if _routes_to_draw.is_empty():
		return
	var colors_cfg := {}
	if _rules != null:
		colors_cfg = _rules.get_block("overlay_colors")

	for plan_var in _routes_to_draw:
		if not (plan_var is SupplyRoutePlan):
			continue
		var plan := plan_var as SupplyRoutePlan
		if plan.province_path.size() < 2:
			continue
		var color := _color_for_plan(plan, colors_cfg)
		var points: PackedVector2Array = PackedVector2Array()
		for pid in plan.province_path:
			if _centroids.has(pid):
				points.append(_centroids[pid])
		if points.size() >= 2:
			draw_polyline(points, color, line_width, true)
			_draw_route_nodes(points, color)


func _color_for_plan(plan: SupplyRoutePlan, colors_cfg: Dictionary) -> Color:
	var key := plan.primary_mode()
	var raw: Variant = colors_cfg.get(key, colors_cfg.get("land", [0.4, 0.9, 0.5, 0.9]))
	if typeof(raw) == TYPE_ARRAY and raw.size() >= 3:
		var a := 0.9
		if raw.size() >= 4:
			a = float(raw[3])
		return Color(float(raw[0]), float(raw[1]), float(raw[2]), a)
	return Color(0.4, 0.9, 0.5, 0.9)


func _draw_route_nodes(points: PackedVector2Array, color: Color) -> void:
	for pt in points:
		draw_circle(pt, 4.0, color)
		draw_arc(pt, 6.0, 0.0, TAU, 12, color.darkened(0.2), 1.5)
