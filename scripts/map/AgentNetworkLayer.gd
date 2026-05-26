# scripts/map/AgentNetworkLayer.gd
## Agent network rings at province centroids (strength = network effectiveness).

class_name AgentNetworkLayer
extends Node2D

@export var ring_color: Color = Color(0.62, 0.45, 0.98, 0.88)
@export var ring_color_highlight: Color = Color(0.78, 0.58, 1.0, 0.98)
@export var ring_width: float = 2.8
@export var ring_width_highlight: float = 3.6
@export var max_ring_radius: float = 22.0
@export var min_ring_radius: float = 7.0
@export var pressure_reduction: float = 0.55
@export var target_country: String = ""

var _highlight_province_id: int = -1


func _ready() -> void:
	z_index = 6
	if typeof(MapManager) != TYPE_NIL and MapManager.has_signal("province_data_changed"):
		if not MapManager.province_data_changed.is_connected(_on_province_data_changed):
			MapManager.province_data_changed.connect(_on_province_data_changed)


func setup() -> void:
	queue_redraw()


func set_highlight_province(province_id: int) -> void:
	if _highlight_province_id == province_id:
		return
	_highlight_province_id = province_id
	queue_redraw()


func _on_province_data_changed(_pid: int, what: String) -> void:
	if what in ["owner", "controller", "all"]:
		queue_redraw()


static func count_active_networks(provinces: Dictionary = {}, country_tag: String = "") -> int:
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


func _draw() -> void:
	if typeof(MapManager) == TYPE_NIL or typeof(AgentManager) == TYPE_NIL:
		return

	var visible_rect := _get_camera_world_rect()
	var visible_pids: Array = []
	if visible_rect.has_area():
		visible_pids = MapManager.get_provinces_in_rect(visible_rect.grow(80.0)) as Array

	var tag_filter := target_country.strip_edges().to_upper()
	var networks: Array[AgentNetwork] = []
	if not tag_filter.is_empty():
		networks = AgentManager.get_networks_for_country(tag_filter)
	else:
		for pid in MapManager.get_all_provinces().keys():
			var net: AgentNetwork = AgentManager.get_network(int(pid))
			if net != null:
				networks.append(net)

	for net in networks:
		if net == null or not net.is_active():
			continue
		var pid := net.province_id
		if visible_rect.has_area() and pid not in visible_pids:
			continue
		var data := MapManager.get_overlay_data_for_province(pid, net.controlling_country) as Dictionary
		if data.is_empty():
			continue
		var c: Vector2 = data.get("centroid", Vector2.ZERO)
		var owner := str(data.get("owner", ""))
		var controller := str(data.get("controller", ""))
		var pressure := _enemy_pressure(pid, owner, controller)
		var base := net.get_effectiveness()
		var effective := clampf(base * (1.0 - pressure * pressure_reduction), 0.08, 1.0)
		var emphasized := pid == _highlight_province_id
		_draw_network_ring(c, effective, emphasized, net.focus, pressure)


func _enemy_pressure(province_id: int, owner: String, controller: String) -> float:
	var pressure := 0.0
	if owner != controller and not controller.is_empty():
		pressure += 0.45
	for nid in MapManager.get_adjacent_provinces(province_id, true) as Array:
		var ndata := MapManager.get_overlay_data_for_province(int(nid)) as Dictionary
		if ndata.is_empty():
			continue
		if str(ndata.get("owner", "")) != str(ndata.get("controller", "")):
			pressure += 0.12
	return clampf(pressure, 0.0, 1.0)


func _draw_network_ring(center: Vector2, strength: float, emphasized: bool, focus: String, pressure: float = 0.0) -> void:
	var radius := lerpf(min_ring_radius, max_ring_radius, strength)
	var alpha := lerpf(0.35, 0.95, strength)
	var base_col := ring_color_highlight if emphasized else ring_color

	# Pressure shifts the color toward danger (high pressure = redder)
	var pressure_t := clampf(pressure * 0.8, 0.0, 1.0)
	var col := base_col.lerp(ring_color_high_pressure, pressure_t)

	# Focus tint
	if show_focus_color_tint:
		if focus == "supply_disruption":
			col = col.lerp(Color(0.95, 0.6, 0.3), 0.3)
		elif focus == "infrastructure_sabotage":
			col = col.lerp(Color(1.0, 0.35, 0.45), 0.25)

	col.a *= alpha

	var width := ring_width_highlight if emphasized else ring_width
	draw_arc(center, radius, 0.0, TAU, 56, col, width, true)

	# Inner core for strong networks
	if emphasized or strength > 0.65:
		var core_radius := 3.8 if emphasized else 2.8
		draw_circle(center, core_radius, Color(col, col.a * 0.7), true)

	# Extra concentric ring for very strong + low pressure (stable powerful network)
	if double_ring_for_strong_low_pressure and strength > 0.82 and pressure < 0.35:
		draw_arc(center, radius * 0.6, 0.0, TAU, 40, Color(col, col.a * 0.5), width * 0.65, true)


func _get_camera_world_rect() -> Rect2:
	var cam := get_viewport().get_camera_2d()
	if cam == null:
		return Rect2()
	var vp_size := get_viewport().get_visible_rect().size
	var top_left := cam.get_canvas_transform().affine_inverse() * Vector2.ZERO
	return Rect2(top_left, vp_size / cam.zoom)
