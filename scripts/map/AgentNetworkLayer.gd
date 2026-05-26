# scripts/map/AgentNetworkLayer.gd
## Agent network rings at province centroids (strength = network effectiveness).

class_name AgentNetworkLayer
extends Node2D

@export var ring_color: Color = Color(0.62, 0.45, 0.98, 0.88)
@export var ring_color_highlight: Color = Color(0.78, 0.58, 1.0, 0.98)
@export var ring_color_high_pressure: Color = Color(1.0, 0.42, 0.48, 0.9)
@export var ring_color_supply_disrupt: Color = Color(0.98, 0.58, 0.28, 0.92)
@export var ring_color_infra_sabotage: Color = Color(1.0, 0.38, 0.45, 0.92)
@export var ring_width: float = 2.8
@export var ring_width_highlight: float = 3.6
@export var max_ring_radius: float = 22.0
@export var min_ring_radius: float = 7.0
@export var pressure_reduction: float = 0.55
@export var show_focus_color_tint: bool = true
@export var double_ring_for_strong_low_pressure: bool = true
@export var target_country: String = ""

var _highlight_province_id: int = -1
var _pulse_phase: float = 0.0
var _pulse_active_until_msec: int = 0


func _ready() -> void:
	z_index = 6
	if typeof(MapManager) != TYPE_NIL and MapManager.has_signal("province_data_changed"):
		if not MapManager.province_data_changed.is_connected(_on_province_data_changed):
			MapManager.province_data_changed.connect(_on_province_data_changed)

	if typeof(TimeManager) != TYPE_NIL:
		if not TimeManager.game_day_advanced.is_connected(_on_daily_tick):
			TimeManager.game_day_advanced.connect(_on_daily_tick)


func setup() -> void:
	queue_redraw()


func set_highlight_province(province_id: int) -> void:
	if _highlight_province_id == province_id:
		return
	_highlight_province_id = province_id
	queue_redraw()


func trigger_daily_pulse(duration_msec: int = 2800) -> void:
	_pulse_phase = 0.0
	_pulse_active_until_msec = Time.get_ticks_msec() + duration_msec
	set_process(true)
	queue_redraw()


func is_daily_pulse_active() -> bool:
	return Time.get_ticks_msec() <= _pulse_active_until_msec


func _process(delta: float) -> void:
	if Time.get_ticks_msec() > _pulse_active_until_msec:
		set_process(false)
		return
	_pulse_phase += delta * 4.5
	queue_redraw()


func _on_province_data_changed(_pid: int, what: String) -> void:
	if what in ["owner", "controller", "all", "effects", "infrastructure"]:
		queue_redraw()


func _on_daily_tick(_year: int, _month: int, _day: int) -> void:
	trigger_daily_pulse()


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

	var global_pulse := is_daily_pulse_active()
	var pulse_wave := 0.5 + 0.5 * sin(_pulse_phase) if global_pulse else 0.0

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
		var activity_note := net.last_daily_note.strip_edges()
		var pressure_focus := net.focus in ["supply_disruption", "infrastructure_sabotage"]
		var activity_pulse := global_pulse and (
			pulse_wave > 0.55
			or not activity_note.is_empty()
			or pressure_focus
		)
		_draw_network_ring(
			c, effective, emphasized, net.focus, pressure, activity_pulse, activity_note, pressure_focus,
		)


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


func _draw_pressure_glyph(
	center: Vector2,
	radius: float,
	focus: String,
	activity_pulse: bool,
) -> void:
	var offset := Vector2(0.0, -radius - 7.0)
	var pos := center + offset
	var alpha := 0.88
	if activity_pulse:
		alpha = 0.65 + 0.35 * (0.5 + 0.5 * sin(_pulse_phase))
	if focus == "supply_disruption":
		var c := Color(ring_color_supply_disrupt.r, ring_color_supply_disrupt.g, ring_color_supply_disrupt.b, alpha)
		var half := 4.5
		var diamond := PackedVector2Array([
			pos + Vector2(0.0, -half),
			pos + Vector2(half, 0.0),
			pos + Vector2(0.0, half),
			pos + Vector2(-half, 0.0),
		])
		draw_colored_polygon(diamond, c)
	elif focus == "infrastructure_sabotage":
		var c := Color(ring_color_infra_sabotage.r, ring_color_infra_sabotage.g, ring_color_infra_sabotage.b, alpha)
		draw_rect(Rect2(pos - Vector2(4.0, 4.0), Vector2(8.0, 8.0)), c, true)


func _draw_network_ring(
	center: Vector2,
	strength: float,
	emphasized: bool,
	focus: String,
	pressure: float = 0.0,
	activity_pulse: bool = false,
	activity_note: String = "",
	pressure_focus: bool = false,
) -> void:
	var radius := lerpf(min_ring_radius, max_ring_radius, strength)
	var alpha := lerpf(0.35, 0.95, strength)
	var base_col := ring_color_highlight if emphasized else ring_color

	var pressure_t := clampf(pressure * 0.8, 0.0, 1.0)
	var col := base_col.lerp(ring_color_high_pressure, pressure_t)

	if show_focus_color_tint:
		if focus == "supply_disruption":
			col = col.lerp(ring_color_supply_disrupt, 0.48 if pressure_focus else 0.3)
		elif focus == "infrastructure_sabotage":
			col = col.lerp(ring_color_infra_sabotage, 0.44 if pressure_focus else 0.25)

	col.a *= alpha

	var width := ring_width_highlight if emphasized else ring_width
	if pressure_focus:
		width += 0.35
	if activity_pulse:
		var boost := 0.22 + 0.18 * sin(_pulse_phase)
		if activity_note in ["intel", "disrupt", "recruit", "sabotage", "infra_pressure"]:
			boost += 0.14
		if pressure_focus:
			boost += 0.1
		radius *= 1.0 + boost * 0.35
		width += boost * 1.4
		col.a = minf(1.0, col.a * (1.0 + boost * 0.25))

	draw_arc(center, radius, 0.0, TAU, 56, col, width, true)

	if pressure_focus:
		var outer := Color(col.r, col.g, col.b, col.a * 0.42)
		draw_arc(center, radius * 1.32, 0.0, TAU, 40, outer, maxf(1.0, width * 0.55), true)

	if activity_pulse:
		var pulse_col := Color(col, col.a * (0.25 + 0.2 * sin(_pulse_phase)))
		draw_arc(center, radius * 1.22, 0.0, TAU, 48, pulse_col, maxf(1.0, width * 0.45), true)

	if emphasized or strength > 0.65:
		var core_radius := 3.8 if emphasized else 2.8
		if activity_note == "recruit":
			core_radius += 1.2
		if pressure_focus:
			core_radius += 0.6
		draw_circle(center, core_radius, Color(col, col.a * 0.7), true)

	if pressure_focus:
		_draw_pressure_glyph(center, radius, focus, activity_pulse)

	if double_ring_for_strong_low_pressure and strength > 0.82 and pressure < 0.35:
		draw_arc(center, radius * 0.6, 0.0, TAU, 40, Color(col, col.a * 0.5), width * 0.65, true)
