# scripts/map/MapRenderer.gd
class_name MapRenderer
extends Node2D

const Log = preload("res://scripts/core/Logger.gd")

#region Exports
@export var container: Node2D
@export var info_panel: Panel
@export var info_name: Label
@export var info_owner: Label
@export var info_population: Label
@export var info_terrain: Label
@export var info_factories: Label
@export var info_dev: Label
@export var info_resources: Label
@export var info_core: Label
@export var info_special: Label
@export var info_logistics: Label
@export var info_combat: Label
@export var info_modifiers: RichTextLabel
@export var info_national: Label
@export var btn_national_spirits: Button
@export var btn_close: Button

#region Province names (visible at lower zoom when enabled)
@export var show_province_names: bool = false
@export var province_name_font_size: int = 11
@export var province_name_color: Color = Color(1, 1, 1, 0.85)
#endregion

#region Hover name
@export var show_hover_province_name: bool = true
@export var hover_name_follow_mouse: bool = false
#endregion

#region Feature markers
@export var feature_icon_ring_radius: float = 28.0
@export var province_detail_min_zoom: float = 0.8
#endregion

#region Debug
@export var debug_draw_province_centroids: bool = false
#endregion
#endregion

#region Camera Controls
@export var pan_speed: float = 900.0
@export var edge_scroll_speed: float = 1100.0
@export var edge_margin: float = 50.0
@export var zoom_speed: float = 0.1
@export var min_zoom: float = 0.15
@export var max_zoom: float = 8.0
@export var middle_mouse_pan_speed: float = 1.0
#endregion

#region Picking (MapPickGrid integration)
## Recommended production configuration for 250+ provinces (pure spatial, zero Area2D overhead):
##   use_spatial_picking = true
##   create_area_nodes_for_fallback = false
##
## In this mode:
## - No Area2D nodes are created at render time.
## - Hover is handled exclusively by _update_spatial_hover() polling MapPickGrid.
## - Clicks are handled by the unhandled_input spatial path.
## - All visuals (outlines, fills, etc.) continue to work on the province node via ProvinceMapVisuals.
## This is the intended long-term default for performance and simplicity.
@export var use_spatial_picking: bool = true
@export var create_area_nodes_for_fallback: bool = true
#endregion

var _is_middle_dragging := false
var _middle_drag_start := Vector2.ZERO
var _last_mouse_pos := Vector2.ZERO
# Selección por "tap": en táctil el dedo emula el ratón, así que separamos un toque
# (seleccionar/mover) de un arrastre (mover el mapa) actuando al SOLTAR, no al pulsar,
# y solo si el puntero apenas se movió. En ratón el comportamiento es idéntico.
var _left_press_pos := Vector2.ZERO
var _left_press_active := false
const _TAP_MAX_MOVE := 14.0

var provinces: Dictionary[int, Province] = {}
var geometry: Dictionary = {}
var countries: Dictionary[String, Variant] = {}
var adjacency: AdjacencySystem

var province_nodes: Dictionary[int, Node2D] = {}
var province_centroids: Dictionary[int, Vector2] = {}
var _province_name_labels: Dictionary[int, Label] = {}
var current_hover: Node2D = null
var _hover_province: Province = null
var hover_tooltip: ProvinceHoverTooltip = null

var selected_province_id: int = -1
var _hover_outline_province_id: int = -1
var _compare_preview_province_id: int = -1
var _outline_pulse_phase: float = 0.0
var _hover_fill_province_id: int = -1

const _HOVER_FILL_TINT := Color(0.5, 0.82, 1.0, 1.0)
const _COMPARE_FILL_TINT := Color(1.0, 0.72, 0.32, 1.0)
const _CANDIDATE_FILL_TINT := ProvinceMapVisuals.FILL_COMPARE_CANDIDATE
const _CONFLICT_FILL_TINT := ProvinceMapVisuals.FILL_CONFLICT
const _AGENT_FILL_TINT := ProvinceMapVisuals.FILL_AGENT

var _supply_role_by_province: Dictionary[int, String] = {}
var _compare_candidate_ids: Array[int] = []
var _supply_legend_panel: PanelContainer = null
var _compare_hint_label: Label = null
var _legend_tracked_year: int = -1
var _legend_tracked_month: int = -1
var _legend_tracked_day: int = -1
var _map_time_pulse_bbcode: String = ""
var _map_time_pulse_kind: String = ""
var _map_time_pulse_until_msec: int = 0

#region Supply overlay
@export var supply_overlay_panel: SupplyMenuPanel
var supply_map_layer: SupplyMapLayer = null
var supply_mode: bool = false
var _supply_reroute_active: bool = false
var _supply_overlay_legend: RichTextLabel = null
#endregion

#region Conflict overlay
@export var show_conflict_overlay: bool = true
var _conflict_layer: ConflictOverlayLayer = null
#endregion

#region Agent network overlay
@export var show_agent_overlay: bool = true
var _agent_layer: AgentNetworkLayer = null
#endregion


func _ready():
	var world_background := get_node_or_null("WorldBackground") as Sprite2D
	if world_background != null:
		world_background.visible = false
	var province_map := get_node_or_null("ProvinceMap") as Sprite2D
	if province_map != null:
		province_map.visible = false

	if btn_close == null:
		btn_close = get_node_or_null("UI/InfoPanel/BtnClose") as Button

	if btn_close:
		if not btn_close.pressed.is_connected(_on_close_pressed):
			btn_close.pressed.connect(_on_close_pressed)
	else:
		Log.warn("MapRenderer: Could not find BtnClose!")

	if container == null:
		container = get_node_or_null("ProvinceContainers") as Node2D

	var cam := get_node_or_null("MapCamera") as Camera2D
	if cam:
		cam.make_current()
		Log.info("✅ Camera2D activated", "MapRenderer")
	else:
		Log.warn("MapRenderer: MapCamera node missing!")

	_setup_hover_tooltip()
	_setup_inspector_extras()
	_connect_time_manager_signals()
	_connect_map_manager_signals()
	_connect_unit_movement_signals()
	_connect_battle_manager_signals()
	_init_legend_calendar_tracking()
	set_process(true)
	Log.info("MapRenderer _ready() completed", "MapRenderer")


func _init_legend_calendar_tracking() -> void:
	if typeof(TimeManager) == TYPE_NIL:
		return
	_legend_tracked_year = TimeManager.get_current_year()
	_legend_tracked_month = TimeManager.get_current_month()
	_legend_tracked_day = TimeManager.get_current_day()


func _connect_map_manager_signals() -> void:
	if typeof(MapManager) == TYPE_NIL:
		return
	if not MapManager.province_data_changed.is_connected(_on_map_province_data_changed):
		MapManager.province_data_changed.connect(_on_map_province_data_changed)


func _on_map_province_data_changed(province_id: int, what: String) -> void:
	if what not in ["effects", "infrastructure", "owner", "controller", "all"]:
		return
	if provinces.has(province_id):
		_refresh_single_province_fill(province_id)
	if _hover_fill_province_id == province_id:
		_apply_hover_fill(province_id, true)


func _connect_battle_manager_signals() -> void:
	if typeof(BattleManager) == TYPE_NIL:
		return
	if not BattleManager.province_captured.is_connected(_on_province_captured):
		BattleManager.province_captured.connect(_on_province_captured)
	if not BattleManager.battle_resolved.is_connected(_on_battle_resolved):
		BattleManager.battle_resolved.connect(_on_battle_resolved)


func _on_province_captured(province_id: int, _new_owner: String, _old_owner: String) -> void:
	refresh_province_color(province_id)


func _on_battle_resolved(
	province_id: int,
	winner_tag: String,
	_loser_tag: String,
	result: Dictionary
) -> void:
	Log.info(
		"[Battle] %s vs %s in province %d - Winner: %s"
		% [result.attacker_tag, result.defender_tag, province_id, winner_tag], "MapRenderer"
	)


func _connect_time_manager_signals() -> void:
	if typeof(TimeManager) == TYPE_NIL:
		return
	if not TimeManager.game_day_advanced.is_connected(_on_game_day_advanced_legend):
		TimeManager.game_day_advanced.connect(_on_game_day_advanced_legend)
	if not TimeManager.game_month_advanced.is_connected(_on_time_advanced_refresh_legend):
		TimeManager.game_month_advanced.connect(_on_time_advanced_refresh_legend)
	if not TimeManager.game_year_advanced.is_connected(_on_time_advanced_refresh_legend):
		TimeManager.game_year_advanced.connect(_on_time_advanced_refresh_legend)


func _on_game_day_advanced_legend(year: int, month: int, day: int) -> void:
	if _legend_tracked_day < 0:
		_legend_tracked_day = day
		_legend_tracked_month = month
		_legend_tracked_year = year
		return
	if day != _legend_tracked_day or month != _legend_tracked_month or year != _legend_tracked_year:
		_try_set_map_time_pulse(
			GameDateDisplay.build_map_time_pulse_bbcode("day", year, month, day),
			"day",
			2200,
		)
	_legend_tracked_day = day
	_legend_tracked_month = month
	_legend_tracked_year = year
	_refresh_province_fill_colors()
	_refresh_map_time_ui()


func _on_time_advanced_refresh_legend(_a: Variant = null, _b: Variant = null) -> void:
	_note_time_boundary_for_legend(_b != null)
	_refresh_map_time_ui()


func _note_time_boundary_for_legend(is_month_signal: bool) -> void:
	if typeof(TimeManager) == TYPE_NIL:
		return
	var cur_y := TimeManager.get_current_year()
	var cur_m := TimeManager.get_current_month()
	var cur_d := TimeManager.get_current_day()
	if _legend_tracked_year < 0:
		_legend_tracked_year = cur_y
		_legend_tracked_month = cur_m
		_legend_tracked_day = cur_d
		return
	if cur_y > _legend_tracked_year:
		_try_set_map_time_pulse(
			GameDateDisplay.build_map_time_pulse_bbcode("year", cur_y, cur_m, cur_d),
			"year",
			5000,
		)
	elif is_month_signal and cur_m != _legend_tracked_month:
		_try_set_map_time_pulse(
			GameDateDisplay.build_map_time_pulse_bbcode("month", cur_y, cur_m, cur_d),
			"month",
			5000,
		)
	_legend_tracked_year = cur_y
	_legend_tracked_month = cur_m
	_legend_tracked_day = cur_d


func _try_set_map_time_pulse(bbcode: String, kind: String, duration_msec: int) -> void:
	if bbcode.is_empty():
		return
	var new_prio := GameDateDisplay.time_pulse_priority(kind)
	if not _map_time_pulse_bbcode.is_empty() and Time.get_ticks_msec() <= _map_time_pulse_until_msec:
		var cur_prio := GameDateDisplay.time_pulse_priority(_map_time_pulse_kind)
		if cur_prio >= new_prio:
			return
	_map_time_pulse_bbcode = bbcode
	_map_time_pulse_kind = kind
	_map_time_pulse_until_msec = Time.get_ticks_msec() + duration_msec


func _refresh_map_time_ui() -> void:
	if supply_mode:
		_update_supply_legend_text()
	if _hover_province != null and hover_tooltip != null and hover_tooltip.visible:
		_refresh_hover_tooltip(_hover_province)


func _get_active_map_time_pulse_bbcode() -> String:
	if _map_time_pulse_bbcode.is_empty():
		return ""
	if Time.get_ticks_msec() > _map_time_pulse_until_msec:
		return ""
	return _map_time_pulse_bbcode


func _expire_map_time_pulse_if_needed() -> void:
	if _map_time_pulse_bbcode.is_empty():
		return
	if Time.get_ticks_msec() <= _map_time_pulse_until_msec:
		return
	_map_time_pulse_bbcode = ""
	_map_time_pulse_kind = ""
	if supply_mode:
		_update_supply_legend_text()


func _setup_inspector_extras() -> void:
	if btn_national_spirits and not btn_national_spirits.pressed.is_connected(_on_open_national_spirits_pressed):
		btn_national_spirits.pressed.connect(_on_open_national_spirits_pressed)
	if info_modifiers == null:
		info_modifiers = get_node_or_null("UI/InfoPanel/InfoContent/RichTextModifiers") as RichTextLabel
	if info_national == null:
		info_national = get_node_or_null("UI/InfoPanel/InfoContent/LabelNationalHeader") as Label
	if info_modifiers:
		info_modifiers.bbcode_enabled = true
		info_modifiers.fit_content = false
		info_modifiers.scroll_active = true
		info_modifiers.custom_minimum_size = Vector2(360, 140)
	if btn_national_spirits == null:
		btn_national_spirits = get_node_or_null("UI/InfoPanel/BtnNationalSpirits") as Button
		if btn_national_spirits and not btn_national_spirits.pressed.is_connected(_on_open_national_spirits_pressed):
			btn_national_spirits.pressed.connect(_on_open_national_spirits_pressed)


func _setup_hover_tooltip() -> void:
	var ui := get_node_or_null("UI")
	if ui == null:
		return
	hover_tooltip = ProvinceHoverTooltip.new()
	hover_tooltip.name = "ProvinceHoverTooltip"
	ui.add_child(hover_tooltip)


func _input(event: InputEvent) -> void:
	if MapViewInput.gui_blocks_map_input(get_viewport()):
		return
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_zoom_toward_mouse(1.0 + zoom_speed)
			get_viewport().set_input_as_handled()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_zoom_toward_mouse(1.0 - zoom_speed)
			get_viewport().set_input_as_handled()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_L:
			_toggle_supply_overlay()
			get_viewport().set_input_as_handled()
			return

	# Spatial picking click handling — this path makes the system fully functional
	# even when create_area_nodes_for_fallback=false (pure MapPickGrid mode, zero Area2D nodes).
	# Se actúa al SOLTAR un toque/clic corto (tap): así un arrastre con el dedo mueve el
	# mapa sin emitir órdenes de movimiento por error.
	if use_spatial_picking and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var lmb := event as InputEventMouseButton
		if lmb.pressed:
			_left_press_pos = get_viewport().get_mouse_position()
			_left_press_active = true
			return
		# Soltar: solo cuenta como tap si apenas se movió desde que se pulsó.
		if not _left_press_active:
			return
		_left_press_active = false
		if get_viewport().get_mouse_position().distance_to(_left_press_pos) > _TAP_MAX_MOVE:
			return
		var world_pos := _screen_to_world(get_viewport().get_mouse_position())
		var pid := -1
		if typeof(MapManager) != TYPE_NIL and MapManager.has_method("get_province_at_world_pos"):
			pid = MapManager.get_province_at_world_pos(world_pos, true)
		if pid >= 0 and provinces.has(pid):
			var resolved_province: Province = provinces[pid] as Province
			var resolved_node: Node2D = _province_node(pid)
			# Movimiento de unidades: enrutar el clic al sistema de movimiento.
			_on_province_clicked(pid)
			if supply_mode and _handle_supply_province_click(resolved_province):
				_select_province(resolved_province, resolved_node)
				get_viewport().set_input_as_handled()
				return
			show_info_panel(resolved_province)
			_select_province(resolved_province, resolved_node)
			get_viewport().set_input_as_handled()
			return

	# Middle mouse drag start
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			if MapViewInput.gui_blocks_map_input(get_viewport()):
				_is_middle_dragging = false
				return
			if event.pressed:
				_is_middle_dragging = true
				_middle_drag_start = get_viewport().get_mouse_position()
				_last_mouse_pos = _middle_drag_start
			else:
				_is_middle_dragging = false


func _process(delta: float) -> void:
	_expire_map_time_pulse_if_needed()

	_refresh_province_detail_visibility()

	if hover_tooltip and hover_tooltip.visible and _hover_province != null and hover_name_follow_mouse:
		_refresh_hover_tooltip(_hover_province)

	_handle_camera_input(delta)
	_outline_pulse_phase += delta * 4.5
	_update_outline_pulse()

	# Spatial picking integration (MapPickGrid via MapManager)
	if use_spatial_picking:
		_update_spatial_hover()


func _handle_camera_input(delta: float) -> void:
	var cam := get_viewport().get_camera_2d()
	if not cam:
		return

	var nav_delta := MapViewInput.motion_delta(delta)
	var move_dir := Vector2.ZERO
	var gui_blocks_map := MapViewInput.gui_blocks_map_input(get_viewport())

	# WASD / Arrow keys (simulation pause must not freeze map navigation)
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):    move_dir.y -= 1
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):  move_dir.y += 1
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):  move_dir.x -= 1
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT): move_dir.x += 1

	# Edge scrolling must stop over top bar and popups.
	if not gui_blocks_map:
		var mouse_pos := get_viewport().get_mouse_position()
		var viewport_size := get_viewport().get_visible_rect().size

		if mouse_pos.x < edge_margin:              move_dir.x -= 1
		elif mouse_pos.x > viewport_size.x - edge_margin: move_dir.x += 1
		if mouse_pos.y < edge_margin:              move_dir.y -= 1
		elif mouse_pos.y > viewport_size.y - edge_margin: move_dir.y += 1

	# Middle mouse drag (pixel-based — works while paused)
	if _is_middle_dragging and not gui_blocks_map:
		var current_mouse := get_viewport().get_mouse_position()
		var drag_delta := current_mouse - _last_mouse_pos
		cam.global_position -= drag_delta * middle_mouse_pan_speed / cam.zoom.x
		_last_mouse_pos = current_mouse
	elif gui_blocks_map:
		_is_middle_dragging = false

	if move_dir != Vector2.ZERO:
		move_dir = move_dir.normalized()
		cam.global_position += move_dir * pan_speed * nav_delta / cam.zoom.x


func _zoom_toward_mouse(zoom_change: float) -> void:
	if MapViewInput.gui_blocks_map_input(get_viewport()):
		return
	var cam := get_viewport().get_camera_2d()
	if not cam:
		return

	var mouse_screen := get_viewport().get_mouse_position()
	var old_zoom := cam.zoom

	var new_zoom := old_zoom * zoom_change
	new_zoom.x = clamp(new_zoom.x, min_zoom, max_zoom)
	new_zoom.y = clamp(new_zoom.y, min_zoom, max_zoom)

	if new_zoom == old_zoom:
		return

	var world_before := cam.get_canvas_transform().affine_inverse() * mouse_screen
	cam.zoom = new_zoom
	var world_after := cam.get_canvas_transform().affine_inverse() * mouse_screen
	cam.global_position += world_before - world_after

## Converts screen (pixel) mouse position to world/map space using the active Camera2D.
## This is the key bridge for using MapPickGrid / MapManager picking.
func _screen_to_world(screen_pos: Vector2) -> Vector2:
	var cam := get_viewport().get_camera_2d()
	if not cam:
		return screen_pos
	return cam.get_canvas_transform().affine_inverse() * screen_pos


func _on_close_pressed() -> void:
	hide_info_panel()


func _refresh_province_detail_visibility() -> void:
	if container == null:
		return

	var current_zoom := absf(container.scale.x)
	var show_details := current_zoom > province_detail_min_zoom

	for id in _province_name_labels:
		var lbl: Variant = _province_name_labels[id]
		if lbl is Label and is_instance_valid(lbl):
			(lbl as Label).visible = show_province_names and show_details

	for pid in province_nodes:
		var node: Variant = province_nodes[pid]
		if node is Node2D and is_instance_valid(node):
			for child in (node as Node2D).get_children():
				if child is Label:
					(child as Label).visible = show_details


func initialize(p_provinces: Dictionary, p_geometry: Dictionary, p_adjacency: AdjacencySystem, p_countries: Dictionary = {}):
	provinces = MapScenarioData.coerce_provinces(p_provinces)
	geometry = p_geometry
	adjacency = p_adjacency
	countries = MapScenarioData.coerce_countries(p_countries)
	render_provinces()


func render_provinces():
	if container == null:
		Log.error("MapRenderer: container not assigned")
		return

	_clear_selection()
	for child in container.get_children():
		child.queue_free()
	province_nodes.clear()
	province_centroids.clear()
	_province_name_labels.clear()

	Log.info("Rendering map with %d provinces using Polygon2D..." % provinces.size(), "MapRenderer")

	for id in provinces.keys():
		var province: Province = provinces[id]
		if not geometry.has(id):
			continue

		var geo = geometry[id]
		var node := _create_province_node(province, geo)
		container.add_child(node)
		province_nodes[id] = node

	_refresh_province_detail_visibility()
	_setup_supply_layer()
	_setup_conflict_layer()
	_setup_agent_layer()
	_refresh_supply_highlights()
	_update_compare_hint_label()
	draw_unit_icons()  # CHANGE 4: iconos de unidad tras renderizar el mapa
	_focus_camera_on_theater()  # Recorte de mapa al teatro: encuadrar la zona de guerra
	Log.info("✅ Map rendered with real polygons", "MapRenderer")

	# Sync MapPickGrid (via MapManager) after rendering for best picking accuracy
	if use_spatial_picking and typeof(MapManager) != TYPE_NIL and MapManager.has_method("rebuild_pick_grid"):
		MapManager.rebuild_pick_grid()


## Recorte de mapa al teatro: encuadra la cámara sobre la zona de la Guerra del Pacífico
## (Antofagasta, Tarapacá, Iquique, Arica, Tacna, La Paz, Sucre + Lima y Santiago) al cargar,
## en vez de mostrar el mundo entero (del que el 87% no tiene geometría).
func _focus_camera_on_theater() -> void:
	var cam := get_node_or_null("MapCamera") as Camera2D
	if cam == null:
		return
	var theater := [841, 842, 843, 844, 845, 846, 847, 71, 90]
	var min_v := Vector2(INF, INF)
	var max_v := Vector2(-INF, -INF)
	var found := false
	for pid in theater:
		if province_centroids.has(pid):
			var c: Vector2 = province_centroids[pid]
			min_v.x = minf(min_v.x, c.x)
			min_v.y = minf(min_v.y, c.y)
			max_v.x = maxf(max_v.x, c.x)
			max_v.y = maxf(max_v.y, c.y)
			found = true
	if not found:
		return
	cam.position = (min_v + max_v) * 0.5
	var span := max_v - min_v
	# Usamos el tamaño de ventana configurado del proyecto (fiable; el viewport en runtime
	# puede no estar listo o dar 0 en headless).
	var vw := float(ProjectSettings.get_setting("display/window/size/viewport_width", 1680))
	var vh := float(ProjectSettings.get_setting("display/window/size/viewport_height", 960))
	var margin := 2.2  # deja aire alrededor del teatro
	var zx := vw / maxf(span.x * margin, 1.0)
	var zy := vh / maxf(span.y * margin, 1.0)
	var z := clampf(minf(zx, zy), min_zoom, max_zoom)
	cam.zoom = Vector2(z, z)


func _create_province_node(province: Province, geo: Dictionary) -> Node2D:
	var node := Node2D.new()
	node.name = "Prov_%d" % province.id

	var points: PackedVector2Array = geo.get("points", PackedVector2Array())
	if points.size() < 3:
		return node

	var poly := Polygon2D.new()
	poly.polygon = points
	poly.color = _get_province_color(province)
	poly.antialiased = true

	# Area2D is now completely optional.
	# In the recommended production pure-spatial configuration (use_spatial_picking=true AND
	# create_area_nodes_for_fallback=false), no Area2D nodes are ever created.
	if create_area_nodes_for_fallback or not use_spatial_picking:
		var area := Area2D.new()
		var collision := CollisionPolygon2D.new()
		collision.polygon = points
		area.add_child(collision)
		area.input_event.connect(_on_province_input.bind(province, node))
		area.mouse_entered.connect(_on_mouse_entered.bind(node, province))
		area.mouse_exited.connect(_on_mouse_exited.bind(node))

		node.add_child(area)

	node.add_child(poly)

	var center := _calculate_centroid(points)
	province_centroids[province.id] = center

	if debug_draw_province_centroids:
		var marker := _make_centroid_debug_marker(4.0)
		marker.position = center
		node.add_child(marker)

	if province.has_feature("capital"):
		var star := Label.new()
		star.text = "⭐"
		star.mouse_filter = Control.MOUSE_FILTER_IGNORE
		star.add_theme_font_size_override("font_size", 22)
		star.position = center - Vector2(11, 11)
		node.add_child(star)

	var icon_dirs := _feature_icon_offsets_radial(_count_special_icons(province), feature_icon_ring_radius)
	var icon_i := 0
	for feature in province.special_features.keys():
		var fk := str(feature)
		if fk == "capital" or icon_i >= icon_dirs.size():
			continue
		var icon := Label.new()
		icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		icon.text = _get_feature_icon(fk)
		icon.add_theme_font_size_override("font_size", 15)
		var offs: Vector2 = icon_dirs[icon_i]
		icon.position = center + offs - Vector2(7, 7)
		node.add_child(icon)
		icon_i += 1

	_create_or_update_province_name_label(province, center)

	return node


func _create_or_update_province_name_label(province: Province, center: Vector2) -> void:
	if not show_province_names or container == null:
		return

	var label: Label
	if _province_name_labels.has(province.id):
		label = _province_name_labels[province.id]
		if not is_instance_valid(label):
			_province_name_labels.erase(province.id)
			label = null

	if label == null:
		label = Label.new()
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		label.z_index = 48
		container.add_child(label)
		_province_name_labels[province.id] = label

	label.add_theme_font_size_override("font_size", province_name_font_size)
	label.add_theme_color_override("font_color", province_name_color)
	label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.7))

	label.text = province.name
	label.reset_size()
	var ms := label.get_minimum_size()
	label.position = center - Vector2(ms.x * 0.5, 8)
	label.visible = true


func _count_special_icons(province: Province) -> int:
	var n := 0
	for feature in province.special_features.keys():
		if str(feature) != "capital":
			n += 1
	return mini(n, 4)


func _feature_icon_offsets_radial(count: int, radius: float) -> Array[Vector2]:
	var pts: Array[Vector2] = []
	if count <= 0:
		return pts
	var mid_angle := PI * 0.5
	var span := clampf(PI * (0.42 + 0.11 * float(count - 1)), PI * 0.38, PI * 1.12)
	for i in count:
		var u := 0.5 if count == 1 else float(i) / float(count - 1)
		var ang := mid_angle - span * 0.5 + u * span
		pts.append(Vector2(cos(ang), sin(ang)) * radius)
	return pts


func _make_centroid_debug_marker(radius: float) -> Polygon2D:
	var poly := Polygon2D.new()
	var ring := PackedVector2Array()
	var segments := 12
	for i in segments:
		var a := TAU * float(i) / float(segments)
		ring.append(Vector2(cos(a), sin(a)) * radius)
	poly.polygon = ring
	poly.color = Color(1.0, 0.08, 0.06, 0.95)
	poly.z_index = 500
	return poly


func _calculate_centroid(points: PackedVector2Array) -> Vector2:
	if points.size() < 3:
		return points[0] if points.size() > 0 else Vector2.ZERO

	var area := 0.0
	var cx := 0.0
	var cy := 0.0

	for i in range(points.size()):
		var p1 := points[i]
		var p2 := points[(i + 1) % points.size()]

		var cross := p1.x * p2.y - p2.x * p1.y
		area += cross
		cx += (p1.x + p2.x) * cross
		cy += (p1.y + p2.y) * cross

	area *= 0.5

	if absf(area) < 0.0001:
		var sum := Vector2.ZERO
		for p in points:
			sum += p
		return sum / float(points.size())

	cx /= (6.0 * area)
	cy /= (6.0 * area)
	return Vector2(cx, cy)


func _get_province_color(province: Province) -> Color:
	var fallback := Color(0.06, 0.12, 0.20, 0.90)
	if province.is_sea:
		return Color(0.04, 0.10, 0.18, 0.88)
	if province.owner_tag.is_empty() or not countries.has(province.owner_tag):
		return fallback
	var nation: Variant = countries[province.owner_tag]
	if nation is Country:
		var c := nation as Country
		var col := _saturate_color(c.color, 1.15)
		col.a = 0.88
		return col
	if typeof(nation) == TYPE_DICTIONARY:
		var d: Dictionary = nation
		if d.has("color"):
			var co: Variant = d["color"]
			if typeof(co) == TYPE_COLOR:
				var cc: Color = co as Color
				cc = _saturate_color(cc, 1.15)
				cc.a = 0.88
				return cc
			return Color(String(co))
	return fallback


## Aumenta la saturación de un color sin usar métodos no disponibles en Godot 4.6.
func _saturate_color(c: Color, factor: float) -> Color:
	var h: float
	var s: float
	var v: float
	h = c.h
	s = c.s
	v = c.v
	s = clampf(s * factor, 0.0, 1.0)
	return Color.from_hsv(h, s, v, c.a)


# ============== UNIT MOVEMENT INTEGRATION (UnitMovementSystem) ==============
## Clic de provincia → selección/orden de movimiento, resaltado de la provincia
## seleccionada y de los destinos válidos, e iconos de unidad por provincia.

const MOVE_SELECT_OUTLINE := "MoveSelectOutline"
const MOVE_TARGET_OUTLINE := "MoveTargetOutline"
const MOVE_SELECT_COLOR := Color(1.0, 0.95, 0.35, 1.0)   # amarillo (provincia seleccionada)
const MOVE_SELECT_GLOW := Color(1.0, 0.82, 0.15, 0.35)
const MOVE_TARGET_COLOR := Color(0.4, 0.95, 0.45, 0.9)   # verde (destinos válidos)
const MOVE_TARGET_GLOW := Color(0.18, 0.7, 0.3, 0.28)

var _move_selected_pid: int = -1
var _move_target_pids: Array[int] = []
var _unit_icons_layer: Node2D = null


## CHANGE 1: enruta un clic de provincia al sistema de movimiento de unidades.
func _on_province_clicked(province_id: int) -> void:
	if typeof(UnitMovementSystem) != TYPE_NIL:
		UnitMovementSystem.on_province_clicked(province_id)


## CHANGE 3: conecta las señales de UnitMovementSystem a la retroalimentación visual.
func _connect_unit_movement_signals() -> void:
	if typeof(UnitMovementSystem) == TYPE_NIL:
		return
	if not UnitMovementSystem.formation_selected.is_connected(_on_formation_selected):
		UnitMovementSystem.formation_selected.connect(_on_formation_selected)
	if not UnitMovementSystem.move_completed.is_connected(_on_move_completed):
		UnitMovementSystem.move_completed.connect(_on_move_completed)
	if not UnitMovementSystem.movement_invalid.is_connected(_on_movement_invalid):
		UnitMovementSystem.movement_invalid.connect(_on_movement_invalid)


func _on_formation_selected(_formation_id: String, province_id: int) -> void:
	# Resaltar la provincia seleccionada y mostrar los destinos válidos (adyacentes).
	highlight_selected_province(province_id)
	if typeof(UnitMovementSystem) != TYPE_NIL:
		highlight_valid_move_targets(UnitMovementSystem.get_adjacent_provinces(province_id))


func _on_move_completed(_formation_id: String, _province_id: int) -> void:
	# Limpiar resaltados y refrescar los iconos de unidad en su nueva posición.
	clear_province_highlight()
	clear_move_highlights()
	draw_unit_icons()


func _on_movement_invalid(reason: String) -> void:
	Log.info("[Movement] Invalid: " + str(reason), "MapRenderer")


## CHANGE 2: resalta la provincia seleccionada con un contorno amarillo.
func highlight_selected_province(province_id: int) -> void:
	clear_province_highlight()
	var node := _province_node(province_id)
	var pts := _province_points(province_id)
	if node == null or pts.size() < 3:
		return
	ProvinceMapVisuals.ensure_polished_outline(
		node, pts, MOVE_SELECT_OUTLINE, MOVE_SELECT_COLOR, 3.2, MOVE_SELECT_GLOW, 3.0,
		ProvinceMapVisuals.Z_SELECT + 1,
	)
	_move_selected_pid = province_id


func clear_province_highlight() -> void:
	if _move_selected_pid >= 0:
		var node := _province_node(_move_selected_pid)
		if node != null:
			ProvinceMapVisuals.hide_polished_outline(node, MOVE_SELECT_OUTLINE)
	_move_selected_pid = -1


## CHANGE 2: resalta los destinos de movimiento válidos con un contorno verde.
func highlight_valid_move_targets(province_ids: Array) -> void:
	clear_move_highlights()
	for pid_var in province_ids:
		var pid := int(pid_var)
		var node := _province_node(pid)
		var pts := _province_points(pid)
		if node == null or pts.size() < 3:
			continue
		ProvinceMapVisuals.ensure_polished_outline(
			node, pts, MOVE_TARGET_OUTLINE, MOVE_TARGET_COLOR, 2.4, MOVE_TARGET_GLOW, 2.6,
			ProvinceMapVisuals.Z_SELECT,
		)
		_move_target_pids.append(pid)


func clear_move_highlights() -> void:
	for pid in _move_target_pids:
		var node := _province_node(pid)
		if node != null:
			ProvinceMapVisuals.hide_polished_outline(node, MOVE_TARGET_OUTLINE)
	_move_target_pids.clear()


func _province_points(province_id: int) -> PackedVector2Array:
	var geo: Dictionary = geometry.get(province_id, {})
	var pts: Variant = geo.get("points", PackedVector2Array())
	return pts if pts is PackedVector2Array else PackedVector2Array()


## CHANGE 4: dibuja un icono (cuadrado con el color de la nación) en cada provincia
## que contiene una formación. Se reconstruye por completo en cada llamada.
func draw_unit_icons() -> void:
	if container == null:
		return
	if _unit_icons_layer == null or not is_instance_valid(_unit_icons_layer):
		_unit_icons_layer = Node2D.new()
		_unit_icons_layer.name = "UnitIcons"
		_unit_icons_layer.z_index = ProvinceMapVisuals.Z_SELECT + 2
		container.add_child(_unit_icons_layer)
	for child in _unit_icons_layer.get_children():
		child.queue_free()

	if typeof(LeaderManager) == TYPE_NIL:
		return
	for fid in LeaderManager.formations.keys():
		var f: Formation = LeaderManager.formations[fid] as Formation
		if f == null or f.province_id < 0:
			continue
		if not province_centroids.has(f.province_id):
			continue
		var center: Vector2 = province_centroids[f.province_id]
		var marker := Polygon2D.new()
		marker.polygon = PackedVector2Array([
			Vector2(-6, -6), Vector2(6, -6), Vector2(6, 6), Vector2(-6, 6),
		])
		marker.position = center
		marker.color = _nation_color(f.country_tag)
		_unit_icons_layer.add_child(marker)


## Color de la nación, tomado de los datos de país (los mismos que pintan las provincias).
func _nation_color(tag: String) -> Color:
	var nation: Variant = countries.get(tag)
	if nation is Country:
		return (nation as Country).color
	if typeof(nation) == TYPE_DICTIONARY:
		var d: Dictionary = nation
		if d.has("color"):
			var co: Variant = d["color"]
			if typeof(co) == TYPE_COLOR:
				return co as Color
			return Color(String(co))
	# Respaldo: colores reales de los países (consistentes con el mapa).
	match tag.strip_edges().to_upper():
		"CHL": return Color(0.0, 0.2, 0.627)
		"PER": return Color(0.851, 0.063, 0.137)
		"BOL": return Color(0.0, 0.478, 0.2)
	return Color(0.7, 0.7, 0.7)

# ============== UNIT MOVEMENT INTEGRATION END ==============


# ====================== INTERACTION ======================

func _on_province_input(_viewport: Node, event: InputEvent, _shape_idx: int, province: Province, node: Node2D):
	# When pure spatial picking is active (no Area2D or ignoring it), this handler should not fire for hover/selection.
	# The unhandled_input path above handles clicks.
	if use_spatial_picking:
		return

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var resolved_province := province
		var resolved_node := node

		if supply_mode and _handle_supply_province_click(resolved_province):
			_select_province(resolved_province, resolved_node)
			return
		show_info_panel(resolved_province)
		_select_province(resolved_province, resolved_node)


func _clear_selection() -> void:
	if selected_province_id >= 0:
		_set_selection_outline(selected_province_id, false)
	selected_province_id = -1
	_clear_compare_preview_outline()
	_refresh_compare_candidate_outlines()
	_update_supply_legend_text()
	_update_compare_hint_label()


func _select_province(province: Province, node: Node2D) -> void:
	if selected_province_id >= 0 and selected_province_id != province.id:
		_set_selection_outline(selected_province_id, false)

	selected_province_id = province.id
	_set_selection_outline(province.id, true)
	var sm := _supply_manager()
	if sm != null:
		sm.set_selected_province(province.id)
	if info_panel != null and info_panel.visible:
		show_info_panel(province)
	if _hover_province != null:
		_refresh_hover_tooltip(_hover_province)
	else:
		_clear_compare_preview_outline()
	_refresh_supply_highlights()
	_refresh_compare_candidate_outlines()
	_update_supply_legend_text()
	_update_compare_hint_label()


func _clear_hover_state() -> void:
	if _hover_fill_province_id >= 0:
		_apply_hover_fill(_hover_fill_province_id, false)
		_hover_fill_province_id = -1
	if _hover_outline_province_id >= 0:
		_set_hover_outline(_hover_outline_province_id, false)
		_hover_outline_province_id = -1
	current_hover = null
	_hover_province = null
	_set_conflict_highlight(-1)
	_set_agent_highlight(-1)
	_hide_hover_tooltip()


func _on_mouse_entered(node: Node2D, province: Province):
	# When spatial picking is the primary mode, completely ignore Area2D hover events.
	# This reduces overhead from hundreds of Area2D nodes at scale.
	if use_spatial_picking:
		return
	current_hover = node
	_hover_province = province
	_apply_hover_visuals(province.id, true)
	if show_hover_province_name:
		_refresh_hover_tooltip(province)


func _on_mouse_exited(node: Node2D) -> void:
	if use_spatial_picking:
		return   # Pure spatial mode - Area2D events are ignored
	if node != null and current_hover != node:
		return
	_clear_hover_state()


func _refresh_hover_tooltip(province: Province) -> void:
	if hover_tooltip == null or province == null:
		return
	var counterpart := _battle_counterpart_for_hover(province)
	_update_compare_preview_outline(province, counterpart)
	_refresh_compare_candidate_outlines()
	var hover_role := str(_supply_role_by_province.get(province.id, ""))
	var is_candidate := _is_compare_candidate(province.id) and counterpart == null
	var contested := ProvinceInsight.is_province_contested(province)
	var has_agent := ProvinceInsight.has_active_agent_network(province)
	var p_tag := _player_tag()
	if p_tag.is_empty():
		p_tag = ProvinceInsight.country_tag_for_province(province)
	var has_tech := (
		typeof(TechnologyManager) != TYPE_NIL
		and not p_tag.is_empty()
		and TechnologyManager.get_active_research_count(p_tag) > 0
	)
	var has_radio := (
		not p_tag.is_empty()
		and ProvinceInsight.province_benefits_country(province, p_tag)
		and MapTechnologyContext.has_support_radio_bonuses(p_tag)
	)
	var text := ProvinceInsight.build_hover_tooltip(
		province, selected_province_id, counterpart, supply_mode, hover_role,
		is_candidate, contested, has_agent,
	)
	var mouse := get_viewport().get_mouse_position()
	var compare_active := counterpart != null
	var selected_accent := selected_province_id == province.id
	var dual := contested and has_agent
	var agent_activity := has_agent and ProvinceInsight.agent_has_daily_activity(province)
	var agent_pressure := ProvinceInsight.agent_pressure_focus_kind(province) if has_agent else ""
	if hover_role == "infra_sabotage":
		agent_pressure = "sabotage"
		if typeof(MapManager) != TYPE_NIL:
			var hover_bd: Dictionary = MapManager.get_infrastructure_repair_breakdown(province.id)
			if ProvinceInsight.daily_infra_duel_winner(province, hover_bd) == "repair":
				agent_pressure = "repair"
			elif ProvinceInsight.daily_infra_duel_winner(province, hover_bd) == "even":
				agent_pressure = "stalemate"
	elif hover_role in ["infra_repair", "infra_duel_even"]:
		agent_pressure = "repair" if hover_role == "infra_repair" else "stalemate"
	elif hover_role == "depot_sabotage":
		agent_pressure = "depot"
	elif hover_role == "supply_pressure":
		agent_pressure = "disrupt"
	hover_tooltip.show_text(
		text,
		mouse,
		get_viewport().get_visible_rect().size,
		true,
		supply_mode,
		compare_active,
		selected_accent,
		is_candidate,
		contested and not compare_active,
		has_agent and not compare_active,
		has_tech and not compare_active,
		has_radio and not compare_active,
		dual and not compare_active,
		agent_activity,
		agent_pressure,
	)
	_set_conflict_highlight(province.id if ProvinceInsight.is_province_contested(province) else -1)
	_set_agent_highlight(province.id if ProvinceInsight.has_active_agent_network(province) else -1)
	_update_compare_hint_label()


func _set_conflict_highlight(province_id: int) -> void:
	if _conflict_layer == null or not is_instance_valid(_conflict_layer):
		return
	_conflict_layer.set_highlight_province(province_id)


func _set_agent_highlight(province_id: int) -> void:
	if _agent_layer == null or not is_instance_valid(_agent_layer):
		return
	_agent_layer.set_highlight_province(province_id)


func _is_compare_candidate(province_id: int) -> bool:
	if selected_province_id < 0 or province_id == selected_province_id:
		return false
	return province_id in _compare_candidate_ids


func _battle_counterpart_for_hover(province: Province) -> Province:
	if selected_province_id < 0 or selected_province_id == province.id:
		return null
	if adjacency == null or not adjacency.are_adjacent(province.id, selected_province_id):
		return null
	if not provinces.has(selected_province_id):
		return null
	return provinces[selected_province_id] as Province


func _hide_hover_tooltip() -> void:
	_clear_compare_preview_outline()
	if hover_tooltip:
		hover_tooltip.hide_tooltip()

## Uses MapManager + MapPickGrid (when available) for fast hover detection.
## This is the primary hover mechanism when use_spatial_picking is true (hybrid with Area2D).
func _update_spatial_hover() -> void:
	if not use_spatial_picking:
		return

	var cam := get_viewport().get_camera_2d()
	if cam == null:
		return

	var mouse_screen := get_viewport().get_mouse_position()
	var world_pos := _screen_to_world(mouse_screen)

	var pid := -1
	if typeof(MapManager) != TYPE_NIL and MapManager.has_method("get_province_at_world_pos"):
		pid = MapManager.get_province_at_world_pos(world_pos, true)

	var new_hover_province: Province = null
	if pid >= 0 and provinces.has(pid):
		new_hover_province = provinces[pid]

	# Only update state if the hovered province actually changed
	if new_hover_province != _hover_province:
		if _hover_province != null:
			_clear_hover_state()
		if new_hover_province != null:
			_hover_province = new_hover_province
			current_hover = province_nodes.get(pid) as Node2D
			_apply_hover_visuals(pid, true)
			if show_hover_province_name:
				_refresh_hover_tooltip(new_hover_province)


# ====================== INFO PANEL ======================

func show_info_panel(province: Province):
	if info_panel == null:
		return

	var name_text := province.name
	if selected_province_id >= 0 and selected_province_id != province.id:
		var other := _battle_counterpart_for_hover(province)
		if other != null:
			name_text += "  ⚔ vs " + other.name
	info_name.text = name_text
	var ctrl_note := ""
	if ProvinceInsight.is_province_contested(province):
		ctrl_note = "  ⚑ held by %s" % province.controller_tag
	elif province.controller_tag != province.owner_tag and not province.controller_tag.is_empty():
		ctrl_note = " (controlled by %s)" % province.controller_tag
	info_owner.text = (
		"Owner: %s%s" % [province.owner_tag if province.owner_tag != "" else "None", ctrl_note]
	)
	info_population.text = "Population: %s" % str(province.population)
	info_terrain.text = "Terrain: " + province.terrain.capitalize()
	info_factories.text = "Factories: %d" % province.factories
	info_dev.text = "Development: %d  ·  Infrastructure: %d" % [
		province.development_level, province.infrastructure,
	]
	if info_logistics != null:
		info_logistics.text = ProvinceInsight.build_at_a_glance_logistics(province)
	if info_combat != null:
		info_combat.text = ProvinceInsight.build_combat_summary_for_inspector(
			province, selected_province_id,
		)
	if info_modifiers != null:
		info_modifiers.text = ProvinceInsight.build_inspector_text(province, selected_province_id)
	if info_national != null:
		var conflict_note := ""
		if ProvinceInsight.is_province_contested(province):
			conflict_note = " Contested provinces show ⚑ in tooltip and diagonal stripes on the map."
		info_national.text = (
			"Inspector: Province | National | Effective columns. "
			+ "National section lists spirits, timed effects, agents, then combined rollup."
			+ conflict_note
		)

	var res_text := "Resources: "
	if province.resources.size() > 0:
		for key in province.resources:
			res_text += "%s:%s " % [key, str(province.resources[key])]
	else:
		res_text += "None"
	info_resources.text = res_text.strip_edges()

	info_core.text = "Core For: " + (", ".join(province.core_for) if province.core_for.size() > 0 else "None")

	var special_list := []
	for feature in province.special_features.keys():
		var fk := str(feature)
		var level = province.special_features[feature]
		special_list.append("%s %s (Lv.%d)" % [_get_feature_icon(fk), fk.capitalize(), level])
	info_special.text = "Special: " + (", ".join(special_list) if special_list.size() > 0 else "None")

	info_panel.visible = true


func hide_info_panel():
	if info_panel:
		info_panel.visible = false


#region Overlay layer infrastructure (preparing for M3 gameplay overlays)
## Clean API for adding future layers (AgentNetworkLayer, ConflictOverlayLayer, TechBuildLayer, etc.)
## All overlay layers live under ProvinceContainers so they move/zoom with the map.
## Data for overlays is best accessed via MapManager (centroids, bounds, adjacency, effects, etc.).
func add_overlay_layer(layer_name: String, layer_node: Node2D, z_index: int = 0) -> void:
	if container == null or layer_node == null:
		return
	layer_node.name = layer_name
	layer_node.z_index = z_index   # Allows basic ordering (e.g. supply routes behind conflict lines)
	var existing := container.get_node_or_null(layer_name)
	if existing:
		existing.queue_free()
	container.add_child(layer_node)

func remove_overlay_layer(layer_name: String) -> void:
	if container == null:
		return
	var existing := container.get_node_or_null(layer_name)
	if existing:
		existing.queue_free()

func get_active_overlay_layers() -> Array[String]:
	## Returns names of active custom overlay layers added via add_overlay_layer.
	## Excludes core map elements. Useful for UI/debug.
	var names: Array[String] = []
	if container == null:
		return names
	var excluded: Array[String] = ["SupplyMapLayer", "ProvinceContainers"]
	for child in container.get_children():
		if child is Node2D:
			var n := child.name
			if n not in excluded and not n.begins_with("Prov_") and not n.ends_with("Outline") and not n.ends_with("Glow"):
				names.append(n)
	return names

func get_overlay_layer(name: String) -> Node2D:
	if container == null:
		return null
	return container.get_node_or_null(name) as Node2D

func _setup_conflict_layer() -> void:
	if not show_conflict_overlay or container == null:
		remove_overlay_layer("ConflictOverlay")
		_conflict_layer = null
		return
	if _conflict_layer == null or not is_instance_valid(_conflict_layer):
		_conflict_layer = ConflictOverlayLayer.new()
	var centroids := province_centroids
	var provs := provinces
	if typeof(MapManager) != TYPE_NIL:
		if MapManager.has_method("get_all_centroids"):
			centroids = MapManager.get_all_centroids()
		if MapManager.has_method("get_all_provinces"):
			provs = MapManager.get_all_provinces()
	_conflict_layer.setup_with_map(container, centroids, provs, geometry)
	add_overlay_layer("ConflictOverlay", _conflict_layer, -1)


## Convenience alias for scenes/scripts that call this after map init.
func setup_demo_conflict_overlay() -> void:
	_setup_conflict_layer()


func _setup_agent_layer() -> void:
	if not show_agent_overlay or container == null:
		remove_overlay_layer("AgentNetworkLayer")
		_agent_layer = null
		return
	if _agent_layer == null or not is_instance_valid(_agent_layer):
		_agent_layer = AgentNetworkLayer.new()
	var sm := _supply_manager()
	if sm != null and sm.get("player_tag"):
		_agent_layer.target_country = str(sm.player_tag).strip_edges().to_upper()
	else:
		_agent_layer.target_country = ""
	_agent_layer.setup()
	add_overlay_layer("AgentNetworkLayer", _agent_layer, 6)


func setup_demo_agent_overlay() -> void:
	_setup_agent_layer()

# Recommended data access for any overlay layer:
#   MapManager.get_all_centroids()
#   MapManager.get_world_bounds()
#   MapManager.get_adjacency_system()
#   MapManager.get_province_effects(pid, tag)
#   MapManager.get_provinces_in_rect(...) for culling
#endregion


#region Supply map layer
func _setup_supply_layer() -> void:
	if container == null:
		return
	if supply_map_layer == null or not is_instance_valid(supply_map_layer):
		supply_map_layer = SupplyMapLayer.new()
		supply_map_layer.name = "SupplyMapLayer"
		container.add_child(supply_map_layer)
	var sm := _supply_manager()
	if sm != null and sm.rules != null:
		supply_map_layer.setup(province_centroids, sm.rules)
	_ensure_supply_overlay_panel()
	_refresh_supply_routes()


func _ensure_supply_overlay_panel() -> void:
	if supply_overlay_panel != null:
		supply_overlay_panel.set_callbacks(
			_on_supply_commit, _on_supply_clear_waypoints, _on_supply_close_overlay,
		)
		return
	var ui := get_node_or_null("UI")
	if ui == null:
		return
	supply_overlay_panel = SupplyMenuPanel.new()
	supply_overlay_panel.name = "SupplyMenuPanel"
	supply_overlay_panel.custom_minimum_size = Vector2(420, 300)
	supply_overlay_panel.position = Vector2(16, 120)
	ui.add_child(supply_overlay_panel)
	var vbox := VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	vbox.offset_left = 12
	vbox.offset_top = 12
	vbox.offset_right = -12
	vbox.offset_bottom = -12
	supply_overlay_panel.add_child(vbox)
	supply_overlay_panel.title_label = Label.new()
	supply_overlay_panel.title_label.text = "Supply command"
	vbox.add_child(supply_overlay_panel.title_label)
	supply_overlay_panel.mode_option = OptionButton.new()
	vbox.add_child(supply_overlay_panel.mode_option)
	supply_overlay_panel.setup_mode_selector()
	supply_overlay_panel.depot_label = Label.new()
	supply_overlay_panel.depot_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(supply_overlay_panel.depot_label)
	supply_overlay_panel.attrition_label = Label.new()
	supply_overlay_panel.attrition_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(supply_overlay_panel.attrition_label)
	supply_overlay_panel.body_label = RichTextLabel.new()
	supply_overlay_panel.body_label.fit_content = true
	supply_overlay_panel.body_label.custom_minimum_size = Vector2(380, 90)
	vbox.add_child(supply_overlay_panel.body_label)
	var row := HBoxContainer.new()
	supply_overlay_panel.btn_commit = Button.new()
	supply_overlay_panel.btn_commit.text = "Commit route"
	row.add_child(supply_overlay_panel.btn_commit)
	supply_overlay_panel.btn_clear = Button.new()
	supply_overlay_panel.btn_clear.text = "Clear waypoints"
	row.add_child(supply_overlay_panel.btn_clear)
	supply_overlay_panel.btn_close = Button.new()
	supply_overlay_panel.btn_close.text = "Close"
	row.add_child(supply_overlay_panel.btn_close)
	vbox.add_child(row)
	supply_overlay_panel.set_callbacks(
		_on_supply_commit, _on_supply_clear_waypoints, _on_supply_close_overlay,
	)
	supply_overlay_panel.set_mode_callback(_on_supply_mode_changed)


func _player_tag() -> String:
	var sm := _supply_manager()
	if sm != null and sm.get("player_tag"):
		return str(sm.player_tag).strip_edges().to_upper()
	return ""


func _supply_manager() -> Node:
	return get_tree().root.get_node_or_null("SupplyManager")


func build_supply_network(city_layer: Dictionary, player_tag: String = "USA") -> void:
	var sm := _supply_manager()
	if sm == null:
		return
	sm.build_network(provinces, countries, city_layer, adjacency, player_tag)
	if sm.has_method("seed_demo_enemy_forces"):
		sm.seed_demo_enemy_forces()
	if sm.has_method("seed_demo_engineer_presence"):
		sm.seed_demo_engineer_presence(player_tag)
	_setup_supply_layer()


func _toggle_supply_overlay() -> void:
	var sm := _supply_manager()
	if sm == null:
		return
	sm.toggle_overlay()
	supply_mode = sm.overlay_visible
	if supply_map_layer:
		supply_map_layer.visible = supply_mode
	if supply_mode:
		_refresh_supply_routes()
	else:
		_end_supply_reroute()
	_refresh_province_fill_colors()
	_refresh_supply_highlights()
	_update_supply_overlay_legend()
	_refresh_compare_candidate_outlines()
	if _hover_province != null:
		_refresh_hover_tooltip(_hover_province)
	if supply_overlay_panel:
		if not supply_mode:
			supply_overlay_panel.hide_panel()


func _refresh_supply_routes() -> void:
	var sm := _supply_manager()
	if supply_map_layer == null or sm == null:
		return
	supply_map_layer.set_routes(sm.get_all_routes())
	supply_map_layer.visible = supply_mode
	_refresh_supply_highlights()


func _handle_supply_province_click(province: Province) -> bool:
	var sm := _supply_manager()
	if sm == null:
		return false
	sm.set_selected_province(province.id)
	if not _supply_reroute_active:
		var source: int = sm.get_capital_hub_id()
		if source < 0:
			source = province.id
		sm.begin_player_reroute(source, province.id)
		_supply_reroute_active = true
		_show_supply_preview()
		return true
	sm.add_reroute_waypoint(province.id)
	_show_supply_preview()
	_refresh_supply_highlights()
	return true


func _show_supply_preview() -> void:
	var sm := _supply_manager()
	if sm == null:
		return
	var plan: SupplyRoutePlan = sm.preview_player_route()
	_update_supply_menu(plan, true)
	_refresh_supply_routes()


func _update_supply_menu(plan: SupplyRoutePlan, reroute_mode: bool) -> void:
	var sm := _supply_manager()
	if sm == null or supply_overlay_panel == null:
		return
	var depot: ProvinceDepotState = sm.get_depot_state(sm.get_selected_province_id())
	if depot == null:
		depot = sm.get_depot_state(plan.target_province_id)
	var attrition: Dictionary = sm.get_attrition_cargo_summary()
	var extra := ""
	for line in sm.get_depot_menu_lines(5):
		extra += line + "\n"
	var pid: int = SupplyManager.get_selected_province_id()
	var province: Province = provinces.get(pid) as Province if provinces.has(pid) else null
	supply_overlay_panel.show_supply_state(
		plan, depot, attrition, reroute_mode, province, sm.player_tag, extra.strip_edges(),
	)


func _on_supply_mode_changed(mode: String) -> void:
	var sm := _supply_manager()
	if sm:
		sm.set_routing_mode(mode)
	_show_supply_preview()


func _on_supply_commit() -> void:
	var sm := _supply_manager()
	if sm == null:
		return
	var plan: SupplyRoutePlan = sm.commit_player_route()
	_update_supply_menu(plan, false)
	_refresh_supply_routes()


func _on_supply_clear_waypoints() -> void:
	var sm := _supply_manager()
	if sm:
		sm.clear_reroute_waypoints()
	_show_supply_preview()


func _on_supply_close_overlay() -> void:
	_toggle_supply_overlay()


func _end_supply_reroute() -> void:
	_supply_reroute_active = false
	var sm := _supply_manager()
	if sm:
		sm.clear_reroute_waypoints()


func _refresh_province_fill_colors() -> void:
	for pid in province_nodes.keys():
		var node: Variant = province_nodes[pid]
		if not (node is Node2D) or not is_instance_valid(node):
			continue
		if not provinces.has(pid):
			continue
		var province: Province = provinces[pid] as Province
		var poly: Polygon2D = _get_province_polygon(node as Node2D)
		if poly == null:
			continue
		var col := _get_province_color(province)
		if supply_mode:
			var fill := ProvinceInsight.depot_fill_ratio(int(pid))
			if fill >= 0.0:
				col = col.lerp(_supply_depot_tint_color(fill), 0.38)
		col = _apply_agent_pressure_base_tint(col, province)
		poly.color = col
	_refresh_supply_highlights()


func _province_polygon(node: Node2D) -> PackedVector2Array:
	var poly := _get_province_polygon(node)
	if poly == null:
		return PackedVector2Array()
	return poly.polygon


func _province_node(province_id: int) -> Node2D:
	var node: Variant = province_nodes.get(province_id)
	return node as Node2D if node is Node2D else null

## Robust helper to find the Polygon2D child regardless of whether an Area2D was also added.
## Essential for pure spatial mode (no Area2D) and hybrid mode.
func _get_province_polygon(node: Node2D) -> Polygon2D:
	if node == null:
		return null
	for child in node.get_children():
		if child is Polygon2D:
			return child as Polygon2D
	return null


func _apply_hover_visuals(province_id: int, active: bool) -> void:
	if active:
		if _hover_outline_province_id >= 0 and _hover_outline_province_id != province_id:
			_apply_hover_visuals(_hover_outline_province_id, false)
		_hover_outline_province_id = province_id
		_hover_fill_province_id = province_id
	_set_hover_outline(province_id, active)
	if active:
		_apply_hover_fill(province_id, true)
		if selected_province_id >= 0:
			_refresh_compare_candidate_outlines()
		if supply_mode:
			_update_supply_legend_text()
	elif _hover_fill_province_id == province_id:
		_apply_hover_fill(province_id, false)
		_hover_fill_province_id = -1
	if not active and supply_mode:
		_update_supply_legend_text()
	if not active and selected_province_id >= 0:
		_refresh_compare_candidate_outlines()


func _hover_outline_colors(province_id: int) -> Dictionary:
	var colors := {
		"color": ProvinceMapVisuals.OUTLINE_HOVER,
		"glow": ProvinceMapVisuals.OUTLINE_HOVER_GLOW,
	}
	if not provinces.has(province_id):
		return colors
	var hp: Province = provinces[province_id] as Province
	var contested := ProvinceInsight.is_province_contested(hp)
	var agent := ProvinceInsight.has_active_agent_network(hp)
	if contested and agent:
		var dual_lerp := 0.22 if supply_mode else 0.28
		var dual_base := ProvinceMapVisuals.OUTLINE_DUAL
		match ProvinceInsight.agent_pressure_focus_kind(hp):
			"disrupt":
				dual_base = ProvinceMapVisuals.OUTLINE_DUAL_DISRUPT
				dual_lerp = 0.16 if ProvinceInsight.agent_applies_daily_pressure(hp) else dual_lerp
			"sabotage":
				dual_base = ProvinceMapVisuals.OUTLINE_DUAL_SABOTAGE
				dual_lerp = 0.16 if ProvinceInsight.agent_applies_daily_pressure(hp) else dual_lerp
		if ProvinceInsight.agent_has_today_pressure_tick(hp):
			dual_lerp = maxf(0.12, dual_lerp - 0.06)
		colors["color"] = dual_base.lerp(ProvinceMapVisuals.OUTLINE_HOVER, dual_lerp)
		colors["glow"] = ProvinceMapVisuals.OUTLINE_DUAL_GLOW
	elif agent:
		var agent_lerp := 0.28 if ProvinceInsight.agent_has_daily_activity(hp) else 0.38
		var pressure_kind := ProvinceInsight.agent_pressure_focus_kind(hp)
		var agent_outline := ProvinceMapVisuals.OUTLINE_AGENT
		if pressure_kind == "disrupt":
			agent_outline = ProvinceMapVisuals.OUTLINE_AGENT_DISRUPT
			agent_lerp = 0.24 if ProvinceInsight.agent_applies_daily_pressure(hp) else agent_lerp
		elif pressure_kind == "sabotage":
			agent_outline = ProvinceMapVisuals.OUTLINE_AGENT_SABOTAGE
			agent_lerp = 0.24 if ProvinceInsight.agent_applies_daily_pressure(hp) else agent_lerp
		if ProvinceInsight.agent_has_today_pressure_tick(hp):
			agent_lerp = maxf(0.18, agent_lerp - 0.08)
		colors["color"] = agent_outline.lerp(ProvinceMapVisuals.OUTLINE_HOVER, agent_lerp)
		colors["glow"] = ProvinceMapVisuals.OUTLINE_AGENT_GLOW
	elif contested:
		colors["color"] = ProvinceMapVisuals.OUTLINE_CONFLICT.lerp(ProvinceMapVisuals.OUTLINE_HOVER, 0.42)
		colors["glow"] = ProvinceMapVisuals.OUTLINE_CONFLICT_GLOW
	if provinces.has(province_id):
		var hp2: Province = provinces[province_id] as Province
		if _province_has_support_radio_benefit(hp2):
			colors["color"] = colors["color"].lerp(ProvinceMapVisuals.OUTLINE_SUPPORT_RADIO, 0.18)
			colors["glow"] = colors["glow"].lerp(ProvinceMapVisuals.OUTLINE_SUPPORT_RADIO_GLOW, 0.24)
		if ProvinceInsight.agent_applies_daily_pressure(hp2):
			var role := str(_supply_role_by_province.get(province_id, ""))
			if role == "infra_sabotage":
				colors["color"] = colors["color"].lerp(ProvinceMapVisuals.OUTLINE_INFRA_SABOTAGE, 0.2)
				colors["glow"] = colors["glow"].lerp(ProvinceMapVisuals.OUTLINE_INFRA_SABOTAGE_GLOW, 0.22)
			elif role == "supply_pressure":
				colors["color"] = colors["color"].lerp(ProvinceMapVisuals.OUTLINE_SUPPLY_PRESSURE, 0.16)
			elif role == "infra_repair":
				colors["color"] = colors["color"].lerp(ProvinceMapVisuals.OUTLINE_INFRA_REPAIR, 0.14)
				colors["glow"] = colors["glow"].lerp(ProvinceMapVisuals.OUTLINE_INFRA_REPAIR_GLOW, 0.12)
			elif role == "depot_sabotage":
				colors["color"] = colors["color"].lerp(ProvinceMapVisuals.OUTLINE_DEPOT_SABOTAGE, 0.14)
	return colors


func _set_hover_outline(province_id: int, visible: bool) -> void:
	var node := _province_node(province_id)
	if node == null:
		return
	if visible:
		var width := 2.8 if province_id == selected_province_id else 2.5
		if provinces.has(province_id):
			var hp: Province = provinces[province_id] as Province
			if ProvinceInsight.agent_has_today_pressure_tick(hp):
				width += 0.3
			if (
				ProvinceInsight.is_province_contested(hp)
				and ProvinceInsight.has_active_agent_network(hp)
			):
				width += 0.35
				if province_id == selected_province_id:
					width += 0.2
				if ProvinceInsight.agent_applies_daily_pressure(hp):
					width += 0.15
		var oc: Dictionary = _hover_outline_colors(province_id)
		ProvinceMapVisuals.ensure_polished_outline(
			node,
			_province_polygon(node),
			ProvinceMapVisuals.NODE_HOVER,
			oc["color"],
			width,
			oc["glow"],
			3.5,
			ProvinceMapVisuals.Z_HOVER,
		)
	else:
		ProvinceMapVisuals.hide_polished_outline(node, ProvinceMapVisuals.NODE_HOVER)
		if _hover_outline_province_id == province_id:
			_hover_outline_province_id = -1


func _set_selection_outline(province_id: int, visible: bool) -> void:
	var node := _province_node(province_id)
	if node == null:
		return
	if visible:
		var sel_col := ProvinceMapVisuals.OUTLINE_SELECT
		var sel_glow := ProvinceMapVisuals.OUTLINE_SELECT_GLOW
		if provinces.has(province_id):
			var sp: Province = provinces[province_id] as Province
			var contested := ProvinceInsight.is_province_contested(sp)
			var agent := ProvinceInsight.has_active_agent_network(sp)
			if contested and agent:
				var dual_sel := ProvinceMapVisuals.OUTLINE_DUAL
				match ProvinceInsight.agent_pressure_focus_kind(sp):
					"disrupt":
						dual_sel = ProvinceMapVisuals.OUTLINE_DUAL_DISRUPT
					"sabotage":
						dual_sel = ProvinceMapVisuals.OUTLINE_DUAL_SABOTAGE
				sel_col = dual_sel.lerp(ProvinceMapVisuals.OUTLINE_SELECT, 0.35)
				sel_glow = ProvinceMapVisuals.OUTLINE_DUAL_GLOW
			elif contested:
				sel_col = ProvinceMapVisuals.OUTLINE_SELECT_CONTESTED
				sel_glow = ProvinceMapVisuals.OUTLINE_SELECT_CONTESTED_GLOW
			elif agent:
				var agent_sel := ProvinceMapVisuals.OUTLINE_AGENT
				match ProvinceInsight.agent_pressure_focus_kind(sp):
					"disrupt":
						agent_sel = ProvinceMapVisuals.OUTLINE_AGENT_DISRUPT
					"sabotage":
						agent_sel = ProvinceMapVisuals.OUTLINE_AGENT_SABOTAGE
				sel_col = agent_sel.lerp(ProvinceMapVisuals.OUTLINE_SELECT, 0.5)
				sel_glow = ProvinceMapVisuals.OUTLINE_AGENT_GLOW
			if _province_has_support_radio_benefit(sp):
				sel_col = sel_col.lerp(ProvinceMapVisuals.OUTLINE_SUPPORT_RADIO, 0.12)
				sel_glow = sel_glow.lerp(ProvinceMapVisuals.OUTLINE_SUPPORT_RADIO_GLOW, 0.18)
		ProvinceMapVisuals.ensure_polished_outline(
			node,
			_province_polygon(node),
			ProvinceMapVisuals.NODE_SELECT,
			sel_col,
			3.5,
			sel_glow,
			4.0,
			ProvinceMapVisuals.Z_SELECT,
		)
	else:
		ProvinceMapVisuals.hide_polished_outline(node, ProvinceMapVisuals.NODE_SELECT)


func _clear_compare_preview_outline() -> void:
	if _compare_preview_province_id >= 0:
		_set_compare_preview_outline(_compare_preview_province_id, false)
	_compare_preview_province_id = -1


func _update_compare_preview_outline(hover_province: Province, counterpart: Province) -> void:
	_clear_compare_preview_outline()
	if hover_province == null or counterpart == null:
		return
	if counterpart.id == hover_province.id:
		return
	_compare_preview_province_id = counterpart.id
	_set_compare_preview_outline(counterpart.id, true)


func refresh_province_color(province_id: int) -> void:
	_refresh_single_province_fill(province_id)
	if _hover_fill_province_id == province_id:
		_apply_hover_fill(province_id, true)


func _refresh_single_province_fill(province_id: int) -> void:
	if not provinces.has(province_id):
		return
	var node := _province_node(province_id)
	if node == null:
		return
	var poly := _get_province_polygon(node)
	if poly == null:
		return
	var province: Province = provinces[province_id] as Province
	var col := _get_province_color(province)
	if supply_mode:
		var fill := ProvinceInsight.depot_fill_ratio(province_id)
		if fill >= 0.0:
			col = col.lerp(_supply_depot_tint_color(fill), 0.38)
	col = _apply_agent_pressure_base_tint(col, province)
	col = _apply_recovering_fill_tint(col, province_id)
	col = _apply_support_radio_fill_tint(col, province)
	poly.color = col


func _province_has_support_radio_benefit(province: Province) -> bool:
	if province == null:
		return false
	var tag := _player_tag()
	if tag.is_empty():
		tag = ProvinceInsight.country_tag_for_province(province)
	return (
		not tag.is_empty()
		and MapTechnologyContext.has_support_radio_bonuses(tag)
		and ProvinceInsight.province_benefits_country(province, tag)
	)


func _apply_support_radio_fill_tint(col: Color, province: Province) -> Color:
	if not _province_has_support_radio_benefit(province):
		return col
	var strength := 0.06 if supply_mode else 0.09
	if province != null and ProvinceInsight.agent_applies_daily_pressure(province):
		strength = minf(strength, 0.05)
	return col.lerp(ProvinceMapVisuals.FILL_SUPPORT_RADIO, strength)


func _apply_recovering_fill_tint(col: Color, province_id: int) -> Color:
	if not supply_mode:
		return col
	var role := str(_supply_role_by_province.get(province_id, ""))
	if role == "infra_repair":
		return col.lerp(ProvinceMapVisuals.FILL_INFRA_RECOVERING, 0.44)
	if role == "infra_sabotage":
		return col.lerp(ProvinceMapVisuals.FILL_INFRA_SABOTAGE_ACTIVE, 0.34)
	if role == "infra_duel_even":
		var duel_mix := ProvinceMapVisuals.FILL_AGENT_DISRUPT_BASE.lerp(
			ProvinceMapVisuals.FILL_INFRA_RECOVERING,
			0.5,
		)
		return col.lerp(duel_mix, 0.18)
	if str(_supply_role_by_province.get(province_id, "")) == "supply_pressure":
		return col.lerp(ProvinceMapVisuals.FILL_AGENT_DISRUPT_BASE, 0.14)
	if str(_supply_role_by_province.get(province_id, "")) == "depot_sabotage":
		return col.lerp(ProvinceMapVisuals.FILL_AGENT_DISRUPT_BASE, 0.12)
	return col


func _apply_agent_pressure_base_tint(col: Color, province: Province) -> Color:
	var strength := ProvinceInsight.get_agent_pressure_fill_strength(province, supply_mode)
	if strength <= 0.0:
		return col
	var tint := ProvinceInsight.get_agent_pressure_fill_tint(province)
	if tint.a <= 0.0:
		return col
	col = col.lerp(tint, strength)
	if (
		ProvinceInsight.agent_pressure_focus_kind(province) == "sabotage"
		and province.infrastructure <= 12
	):
		col = col.lerp(ProvinceMapVisuals.FILL_AGENT_SABOTAGE, 0.04)
	return col


func _apply_hover_fill(province_id: int, active: bool) -> void:
	if not active:
		_refresh_single_province_fill(province_id)
		return
	var node := _province_node(province_id)
	if node == null or not provinces.has(province_id):
		return
	var poly := _get_province_polygon(node)
	if poly == null:
		return
	var province: Province = provinces[province_id] as Province
	var col := _get_province_color(province)
	if supply_mode:
		var fill := ProvinceInsight.depot_fill_ratio(province_id)
		if fill >= 0.0:
			col = col.lerp(_supply_depot_tint_color(fill), 0.38)
	col = _apply_agent_pressure_base_tint(col, province)
	col = _apply_recovering_fill_tint(col, province_id)
	col = _apply_support_radio_fill_tint(col, province)
	var boost := 0.2
	if _compare_preview_province_id >= 0 and province_id == _hover_outline_province_id:
		col = col.lerp(_COMPARE_FILL_TINT, 0.14)
		boost = 0.16
	elif _is_compare_candidate(province_id):
		col = col.lerp(_CANDIDATE_FILL_TINT, 0.12)
		boost = 0.18
	var contested := ProvinceInsight.is_province_contested(province)
	var agent := ProvinceInsight.has_active_agent_network(province)
	if contested and agent:
		var dual_strength := 0.14
		if supply_mode:
			dual_strength = 0.2
		if province_id == selected_province_id:
			dual_strength += 0.04
		col = col.lerp(ProvinceMapVisuals.FILL_DUAL, dual_strength)
		if ProvinceInsight.agent_applies_daily_pressure(province):
			match ProvinceInsight.agent_pressure_focus_kind(province):
				"disrupt":
					col = col.lerp(ProvinceMapVisuals.FILL_AGENT_DISRUPT, 0.07)
				"sabotage":
					col = col.lerp(ProvinceMapVisuals.FILL_AGENT_SABOTAGE, 0.07)
	elif agent:
		var agent_tint := _AGENT_FILL_TINT
		match ProvinceInsight.agent_pressure_focus_kind(province):
			"disrupt":
				agent_tint = ProvinceMapVisuals.FILL_AGENT_DISRUPT
			"sabotage":
				agent_tint = ProvinceMapVisuals.FILL_AGENT_SABOTAGE
		var fill_strength := 0.08
		if ProvinceInsight.agent_applies_daily_pressure(province):
			fill_strength = 0.2 if supply_mode else 0.15
		if ProvinceInsight.agent_has_today_pressure_tick(province):
			fill_strength += 0.06
		elif ProvinceInsight.agent_has_daily_activity(province):
			fill_strength += 0.03
		col = col.lerp(agent_tint, fill_strength)
	elif contested:
		col = col.lerp(_CONFLICT_FILL_TINT, 0.09)
	poly.color = col.lerp(_HOVER_FILL_TINT, boost)


func _update_outline_pulse() -> void:
	var hover_on_selection := (
		_hover_outline_province_id >= 0
		and _hover_outline_province_id == selected_province_id
	)
	if _hover_outline_province_id >= 0:
		var node := _province_node(_hover_outline_province_id)
		if node != null:
			var hover_w := 3.0 if hover_on_selection else 2.5
			var pulse_amp := 0.4 if hover_on_selection else 0.35
			var pulse_speed := 5.5 if hover_on_selection else 4.5
			if provinces.has(_hover_outline_province_id):
				var hp: Province = provinces[_hover_outline_province_id] as Province
				var dual_hover := (
					ProvinceInsight.is_province_contested(hp)
					and ProvinceInsight.has_active_agent_network(hp)
				)
				if ProvinceInsight.agent_has_today_pressure_tick(hp):
					hover_w += 0.35
					pulse_amp += 0.12
					pulse_speed += 0.6
				elif ProvinceInsight.agent_applies_daily_pressure(hp):
					hover_w += 0.2
					pulse_amp += 0.06
				if dual_hover:
					hover_w += 0.25
					pulse_amp += 0.08
					if supply_mode:
						pulse_amp += 0.05
			var hoc: Dictionary = _hover_outline_colors(_hover_outline_province_id)
			ProvinceMapVisuals.apply_pulse_to_polished(
				node,
				ProvinceMapVisuals.NODE_HOVER,
				hoc["color"],
				hover_w,
				hoc["glow"],
				6.0,
				_outline_pulse_phase,
				pulse_amp,
				pulse_speed,
			)
	if selected_province_id >= 0 and not hover_on_selection:
		var sel_node := _province_node(selected_province_id)
		if sel_node != null:
			var sel_col := ProvinceMapVisuals.OUTLINE_SELECT
			var sel_glow := ProvinceMapVisuals.OUTLINE_SELECT_GLOW
			if provinces.has(selected_province_id):
				var sp: Province = provinces[selected_province_id] as Province
				var contested := ProvinceInsight.is_province_contested(sp)
				var agent := ProvinceInsight.has_active_agent_network(sp)
				if contested and agent:
					var dual_sel := ProvinceMapVisuals.OUTLINE_DUAL
					match ProvinceInsight.agent_pressure_focus_kind(sp):
						"disrupt":
							dual_sel = ProvinceMapVisuals.OUTLINE_DUAL_DISRUPT
						"sabotage":
							dual_sel = ProvinceMapVisuals.OUTLINE_DUAL_SABOTAGE
					sel_col = dual_sel.lerp(ProvinceMapVisuals.OUTLINE_SELECT, 0.35)
					sel_glow = ProvinceMapVisuals.OUTLINE_DUAL_GLOW
				elif contested:
					sel_col = ProvinceMapVisuals.OUTLINE_SELECT_CONTESTED
					sel_glow = ProvinceMapVisuals.OUTLINE_SELECT_CONTESTED_GLOW
				elif agent:
					var agent_sel := ProvinceMapVisuals.OUTLINE_AGENT
					match ProvinceInsight.agent_pressure_focus_kind(sp):
						"disrupt":
							agent_sel = ProvinceMapVisuals.OUTLINE_AGENT_DISRUPT
						"sabotage":
							agent_sel = ProvinceMapVisuals.OUTLINE_AGENT_SABOTAGE
					sel_col = agent_sel.lerp(ProvinceMapVisuals.OUTLINE_SELECT, 0.5)
					sel_glow = ProvinceMapVisuals.OUTLINE_AGENT_GLOW
			ProvinceMapVisuals.apply_pulse_to_polished(
				sel_node,
				ProvinceMapVisuals.NODE_SELECT,
				sel_col,
				3.5,
				sel_glow,
				7.5,
				_outline_pulse_phase + 0.8,
				0.3,
				3.2,
			)
	if _compare_preview_province_id >= 0:
		var cmp_node := _province_node(_compare_preview_province_id)
		if cmp_node != null:
			ProvinceMapVisuals.apply_pulse_to_polished(
				cmp_node,
				ProvinceMapVisuals.NODE_COMPARE,
				ProvinceMapVisuals.OUTLINE_COMPARE,
				3.0,
				ProvinceMapVisuals.OUTLINE_COMPARE_GLOW,
				5.8,
				_outline_pulse_phase + 1.6,
				0.45,
				5.0,
			)
	for pid in _compare_candidate_ids:
		if pid == _compare_preview_province_id:
			continue
		var cand_node := _province_node(pid)
		if cand_node == null:
			continue
		var emph := pid == _hover_outline_province_id
		var c_col := (
			ProvinceMapVisuals.OUTLINE_COMPARE_CANDIDATE_EMPH
			if emph
			else ProvinceMapVisuals.OUTLINE_COMPARE_CANDIDATE
		)
		ProvinceMapVisuals.apply_pulse_to_polished(
			cand_node,
			ProvinceMapVisuals.NODE_COMPARE_CANDIDATE,
			c_col,
			2.6 if emph else 1.6,
			ProvinceMapVisuals.OUTLINE_COMPARE_CANDIDATE_GLOW if not emph else ProvinceMapVisuals.OUTLINE_COMPARE_GLOW,
			4.1,
			_outline_pulse_phase + float(pid % 5) * 0.4,
			0.22 if emph else 0.12,
			3.0 if emph else 2.0,
		)
	if supply_mode:
		_pulse_supply_outlines()


func _refresh_compare_candidate_outlines() -> void:
	for pid in _compare_candidate_ids:
		_set_compare_candidate_outline(pid, false, false)
	_compare_candidate_ids.clear()
	if selected_province_id < 0 or adjacency == null:
		return
	for nid in adjacency.get_neighbors(selected_province_id):
		var id := int(nid)
		if id == selected_province_id:
			continue
		if id == _compare_preview_province_id:
			continue
		_compare_candidate_ids.append(id)
		var emphasized := id == _hover_outline_province_id
		_set_compare_candidate_outline(id, true, emphasized)


func _set_compare_candidate_outline(province_id: int, visible: bool, emphasized: bool = false) -> void:
	var node := _province_node(province_id)
	if node == null:
		return
	if visible:
		var color := ProvinceMapVisuals.OUTLINE_COMPARE_CANDIDATE
		var glow := ProvinceMapVisuals.OUTLINE_COMPARE_CANDIDATE_GLOW
		var width := 1.6
		if emphasized:
			color = ProvinceMapVisuals.OUTLINE_COMPARE_CANDIDATE_EMPH
			glow = ProvinceMapVisuals.OUTLINE_COMPARE_GLOW
			width = 2.6
		ProvinceMapVisuals.ensure_polished_outline(
			node,
			_province_polygon(node),
			ProvinceMapVisuals.NODE_COMPARE_CANDIDATE,
			color,
			width,
			glow,
			2.5,
			ProvinceMapVisuals.Z_COMPARE_CANDIDATE,
		)
	else:
		ProvinceMapVisuals.hide_polished_outline(node, ProvinceMapVisuals.NODE_COMPARE_CANDIDATE)


func _set_compare_preview_outline(province_id: int, visible: bool) -> void:
	var node := _province_node(province_id)
	if node == null:
		return
	if visible:
		ProvinceMapVisuals.ensure_polished_outline(
			node,
			_province_polygon(node),
			ProvinceMapVisuals.NODE_COMPARE,
			ProvinceMapVisuals.OUTLINE_COMPARE,
			2.8,
			ProvinceMapVisuals.OUTLINE_COMPARE_GLOW,
			3.0,
			ProvinceMapVisuals.Z_COMPARE,
		)
	else:
		ProvinceMapVisuals.hide_polished_outline(node, ProvinceMapVisuals.NODE_COMPARE)


func _supply_highlight_roles() -> Dictionary[int, String]:
	var roles: Dictionary[int, String] = {}
	if not supply_mode:
		return roles
	var sm := _supply_manager()
	for pid in province_nodes.keys():
		if ProvinceInsight.depot_fill_ratio(int(pid)) >= 0.0:
			roles[int(pid)] = "hub"  # overwritten below if on route / preview / selected
	if sm == null:
		return roles
	var selected: int = SupplyManager.get_selected_province_id()
	if selected < 0:
		selected = selected_province_id
	if selected >= 0:
		roles[selected] = "active"
	var preview_pids: Dictionary[int, bool] = {}
	if _supply_reroute_active:
		var preview: SupplyRoutePlan = sm.preview_player_route()
		if preview != null and preview.path_length() > 0:
			for pid_var in preview.province_path:
				preview_pids[int(pid_var)] = true
	for plan_var in sm.get_all_routes():
		if not (plan_var is SupplyRoutePlan):
			continue
		var plan := plan_var as SupplyRoutePlan
		for pid_var in plan.province_path:
			var pid := int(pid_var)
			if str(roles.get(pid, "")) == "active":
				continue
			if preview_pids.has(pid):
				roles[pid] = "preview"
			else:
				roles[pid] = "route"
	for pid in preview_pids.keys():
		if str(roles.get(pid, "")) != "active":
			roles[pid] = "preview"
	_apply_infra_pressure_overlay_roles(roles)
	return roles


func _apply_infra_pressure_overlay_roles(roles: Dictionary[int, String]) -> void:
	if not supply_mode or typeof(MapManager) == TYPE_NIL:
		return
	for pid_var in province_nodes.keys():
		var pid := int(pid_var)
		var existing: String = str(roles.get(pid, ""))
		if existing in ["active", "preview", "route"]:
			continue
		if not provinces.has(pid):
			continue
		var p: Province = provinces[pid] as Province
		if p == null:
			continue
		var bd: Dictionary = MapManager.get_infrastructure_repair_breakdown(pid)
		if bool(bd.get("under_infra_sabotage", false)):
			match ProvinceInsight.daily_infra_duel_winner(p, bd):
				"repair":
					roles[pid] = "infra_repair"
				"even":
					roles[pid] = "infra_duel_even"
				_:
					roles[pid] = "infra_sabotage"
			continue
		if ProvinceInsight.agent_pressure_focus_kind(p) == "disrupt":
			roles[pid] = "supply_pressure"
			continue
		var depot_sab := float(bd.get("depot_sabotage_level", 0.0))
		if depot_sab > 0.12:
			roles[pid] = "depot_sabotage"
			continue
		var infra := int(bd.get("infrastructure", p.infrastructure))
		if infra < 45 and float(bd.get("total", 0.0)) > 0.0:
			roles[pid] = "infra_repair"


func _pulse_supply_outlines() -> void:
	for pid in _supply_role_by_province.keys():
		var role: String = str(_supply_role_by_province[pid])
		if role not in [
			"active", "preview", "infra_sabotage", "infra_repair", "infra_duel_even",
			"depot_sabotage", "supply_pressure",
		]:
			continue
		var node := _province_node(int(pid))
		if node == null:
			continue
		var style: Dictionary = ProvinceMapVisuals.get_supply_outline_style(role)
		var phase_off := float(int(pid) % 7) * 0.35
		ProvinceMapVisuals.apply_pulse_to_polished(
			node,
			ProvinceMapVisuals.NODE_SUPPLY,
			style["color"],
			style["width"],
			style["glow"],
			float(style["width"]) + float(style["glow_extra"]),
			_outline_pulse_phase + phase_off,
			_pulse_amount_for_supply_role(role),
			float(style.get("pulse_speed", 1.0)),
		)


func _pulse_amount_for_supply_role(role: String) -> float:
	match role:
		"infra_sabotage":
			return 0.78
		"infra_duel_even":
			return 0.48
		"supply_pressure":
			return 0.5
		"depot_sabotage":
			return 0.38
		"infra_repair":
			return 0.16
		"hub":
			return 0.22
		_:
			return 0.32


func _refresh_supply_highlights() -> void:
	var roles := _supply_highlight_roles()
	_supply_role_by_province = roles
	for pid in province_nodes.keys():
		var node := _province_node(int(pid))
		if node == null:
			continue
		var role: String = str(roles.get(int(pid), ""))
		if role.is_empty():
			ProvinceMapVisuals.hide_polished_outline(node, ProvinceMapVisuals.NODE_SUPPLY)
			continue
		var style: Dictionary = ProvinceMapVisuals.get_supply_outline_style(role)
		ProvinceMapVisuals.ensure_polished_outline(
			node,
			_province_polygon(node),
			ProvinceMapVisuals.NODE_SUPPLY,
			style["color"],
			style["width"],
			style["glow"],
			style["glow_extra"],
			style["z_index"],
		)


func _update_supply_overlay_legend() -> void:
	var ui := get_node_or_null("UI")
	if ui == null:
		return
	if _supply_overlay_legend == null or not is_instance_valid(_supply_overlay_legend):
		var panel := PanelContainer.new()
		_supply_legend_panel = panel
		panel.name = "SupplyOverlayLegend"
		panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		panel.set_anchors_preset(Control.PRESET_TOP_LEFT)
		panel.offset_left = 10.0
		panel.offset_top = 10.0
		panel.custom_minimum_size = Vector2(520, 0)
		var style := StyleBoxFlat.new()
		style.bg_color = Color(0.06, 0.08, 0.14, 0.88)
		style.border_color = Color(0.35, 0.55, 0.85, 0.75)
		style.set_border_width_all(1)
		style.set_corner_radius_all(5)
		style.content_margin_left = 8
		style.content_margin_right = 8
		style.content_margin_top = 6
		style.content_margin_bottom = 6
		panel.add_theme_stylebox_override("panel", style)
		var margin := MarginContainer.new()
		panel.add_child(margin)
		_supply_overlay_legend = RichTextLabel.new()
		_supply_overlay_legend.bbcode_enabled = true
		_supply_overlay_legend.fit_content = true
		_supply_overlay_legend.scroll_active = false
		_supply_overlay_legend.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_supply_overlay_legend.add_theme_font_size_override("normal_font_size", 11)
		margin.add_child(_supply_overlay_legend)
		ui.add_child(panel)
	_update_supply_legend_text()


func _update_supply_legend_text() -> void:
	_set_supply_legend_visible(supply_mode)
	if _supply_overlay_legend != null and supply_mode:
		var hover_role := ""
		if _hover_province != null:
			hover_role = str(_supply_role_by_province.get(_hover_province.id, ""))
		var hid := _hover_province.id if _hover_province != null else -1
		var contested_n := ProvinceInsight.count_contested_provinces(provinces)
		var agent_n := ProvinceInsight.count_agent_networks(provinces, _player_tag())
		var dual_n := ProvinceInsight.count_dual_situation_provinces(provinces)
		var pulse := _get_active_map_time_pulse_bbcode()
		_supply_overlay_legend.text = ProvinceInsight.build_supply_legend_bbcode(
			selected_province_id,
			_compare_candidate_ids.size(),
			hid,
			hover_role,
			contested_n,
			agent_n,
			_player_tag(),
			dual_n,
			pulse,
			_map_time_pulse_kind,
		)
		_apply_supply_legend_time_pulse_style(not pulse.is_empty(), _map_time_pulse_kind)
	_update_compare_hint_label()


func _apply_supply_legend_time_pulse_style(pulse_active: bool, pulse_kind: String = "") -> void:
	if _supply_legend_panel == null:
		return
	var style := _supply_legend_panel.get_theme_stylebox("panel") as StyleBoxFlat
	if style == null:
		return
	if not pulse_active:
		style.border_color = Color(0.35, 0.55, 0.85, 0.75)
	elif pulse_kind == "year":
		style.border_color = Color(0.45, 0.82, 1.0, 0.95)
	elif pulse_kind == "month":
		style.border_color = Color(0.55, 0.72, 0.92, 0.9)
	elif pulse_kind == "day":
		style.border_color = Color(0.42, 0.52, 0.68, 0.82)
	else:
		style.border_color = Color(0.55, 0.72, 0.92, 0.9)


func _update_compare_hint_label() -> void:
	var ui := get_node_or_null("UI")
	if ui == null:
		return
	if _compare_hint_label == null or not is_instance_valid(_compare_hint_label):
		_compare_hint_label = Label.new()
		_compare_hint_label.name = "CompareHintLabel"
		_compare_hint_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_compare_hint_label.add_theme_font_size_override("font_size", 11)
		_compare_hint_label.add_theme_color_override("font_color", Color(1.0, 0.75, 0.45))
		_compare_hint_label.set_anchors_preset(Control.PRESET_TOP_LEFT)
		_compare_hint_label.offset_left = 12.0
		_compare_hint_label.offset_top = 52.0
		_compare_hint_label.custom_minimum_size = Vector2(480, 0)
		ui.add_child(_compare_hint_label)
	var contested_n := ProvinceInsight.count_contested_provinces(provinces)
	var agent_n := ProvinceInsight.count_agent_networks(provinces, _player_tag())
	var dual_n := ProvinceInsight.count_dual_situation_provinces(provinces)
	var show_compare := selected_province_id >= 0 and not supply_mode
	var show_conflict := contested_n > 0 and not supply_mode and not show_compare
	var show_agent := agent_n > 0 and not supply_mode and not show_compare and not show_conflict
	var show_supply_compare := selected_province_id >= 0 and supply_mode
	var p_tag := _player_tag()
	var has_radio := MapTechnologyContext.has_support_radio_bonuses(p_tag)
	var show_supply_overlays := (
		supply_mode
		and not show_supply_compare
		and (contested_n > 0 or agent_n > 0 or has_radio)
	)
	_compare_hint_label.visible = (
		show_compare or show_conflict or show_agent or show_supply_compare or show_supply_overlays
	)
	if show_supply_compare:
		var hid := _hover_province.id if _hover_province != null else -1
		var hover_cand := _is_compare_candidate(hid)
		var base := ProvinceInsight.build_map_compare_hint_plain(
			selected_province_id, _compare_candidate_ids.size(), hid, hover_cand,
		)
		var overlay := ProvinceInsight.build_map_supply_mode_hint_plain(
			contested_n, agent_n, dual_n, selected_province_id, p_tag,
		)
		_compare_hint_label.text = base + "  |  " + overlay if not overlay.is_empty() else base
		_compare_hint_label.add_theme_color_override("font_color", Color(1.0, 0.75, 0.45))
	elif show_supply_overlays:
		_compare_hint_label.text = ProvinceInsight.build_map_supply_mode_hint_plain(
			contested_n, agent_n, dual_n, -1, p_tag,
		)
		_compare_hint_label.add_theme_color_override("font_color", Color(0.55, 0.92, 0.78))
	elif show_compare:
		var hid := _hover_province.id if _hover_province != null else -1
		var hover_cand := _is_compare_candidate(hid)
		_compare_hint_label.text = ProvinceInsight.build_map_compare_hint_plain(
			selected_province_id, _compare_candidate_ids.size(), hid, hover_cand,
		)
	elif show_conflict:
		_compare_hint_label.text = ProvinceInsight.build_conflict_map_hint_plain(contested_n)
		_compare_hint_label.add_theme_color_override("font_color", Color(1.0, 0.55, 0.55))
	elif show_agent:
		_compare_hint_label.text = (
			"◎ %d agent network%s — rings pulse daily · hover for strength & today's activity"
			% [agent_n, "s" if agent_n != 1 else ""]
		)
		_compare_hint_label.add_theme_color_override("font_color", Color(0.72, 0.55, 1.0))
	else:
		_compare_hint_label.add_theme_color_override("font_color", Color(1.0, 0.75, 0.45))


func _set_supply_legend_visible(visible: bool) -> void:
	if _supply_overlay_legend == null:
		return
	var panel: CanvasItem = _supply_legend_panel
	if panel == null:
		var margin := _supply_overlay_legend.get_parent()
		panel = margin.get_parent() if margin else null
	if panel is CanvasItem:
		panel.visible = visible


func _supply_depot_tint_color(fill_ratio: float) -> Color:
	if fill_ratio < 0.35:
		return Color(0.85, 0.2, 0.25, 0.9)
	if fill_ratio < 0.65:
		return Color(0.9, 0.65, 0.15, 0.85)
	return Color(0.25, 0.75, 0.45, 0.85)


func _on_open_national_spirits_pressed() -> void:
	if selected_province_id < 0 or not provinces.has(selected_province_id):
		return
	var province: Province = provinces[selected_province_id] as Province
	var tag := ProvinceInsight.country_tag_for_province(province)
	var existing := get_tree().root.get_node_or_null("NationalSpiritsScreen")
	if existing != null:
		existing.queue_free()
	var packed: PackedScene = load("res://scenes/ui/NationalSpiritsScreen.tscn") as PackedScene
	if packed == null:
		return
	var screen: NationalSpiritsScreen = packed.instantiate() as NationalSpiritsScreen
	if screen == null:
		return
	screen.country_tag = tag
	screen.name = "NationalSpiritsScreen"
	get_tree().root.add_child(screen)
	screen.refresh_screen()


#endregion


func _get_feature_icon(feature: String) -> String:
	match feature.to_lower():
		"port", "major_port": return "⚓"
		"naval_shipyard": return "⚙️"
		"airfield": return "✈️"
		"fort": return "🛡️"
		"research_center": return "🔬"
		"oil_rig", "oil": return "⛽"
		"nuclear_plant": return "☢️"
		"spaceport": return "🚀"
		"mega_factory", "major_factory": return "🏭"
		_: return "◆"
