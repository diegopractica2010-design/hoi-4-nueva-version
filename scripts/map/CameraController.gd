# scripts/map/CameraController.gd
## Attach to WorldMap/CameraInput. Drives target (ProvinceContainers) scale + position.
class_name CameraController
extends Node2D

@export var target: Node2D
@export var zoom_speed: float = 0.12
@export var min_zoom: float = 0.15
@export var max_zoom: float = 6.0
@export var enable_zoom: bool = true
@export var enable_pan: bool = true
@export var enable_wasd: bool = true
@export var wasd_speed: float = 600.0
@export var enable_edge_pan: bool = true
@export var edge_pan_margin: float = 36.0
@export var edge_pan_speed: float = 720.0

var _target_zoom := 1.0
var _is_panning := false

# --- Táctil (tablet) ---
# Un dedo arrastra el mapa; dos dedos hacen zoom con pellizco. La selección de
# provincias la resuelve MapRenderer al soltar un toque corto, así que aquí solo
# movemos/escalamos la vista sin tocar la lógica de selección.
var _touch_points: Dictionary = {}   # index -> Vector2 (posición en pantalla)
var _pinch_prev_dist: float = 0.0

const _ZOOM_LERP_SPEED: float = 12.0


func _ready() -> void:
	if target == null:
		target = self
	_target_zoom = clampf(target.scale.x, min_zoom, max_zoom)
	target.scale = Vector2.ONE * _target_zoom
	set_process(true)
	set_process_input(true)
	set_process_unhandled_input(true)


func _process(delta: float) -> void:
	if target == null:
		return

	if enable_wasd:
		_apply_wasd(delta)

	if enable_edge_pan:
		_apply_edge_pan(delta)

	if not enable_zoom:
		return

	var current := target.scale.x
	if absf(current - _target_zoom) <= 0.001:
		return

	var nav_delta := MapViewInput.motion_delta(delta)
	var new_scale := lerpf(current, _target_zoom, clampf(_ZOOM_LERP_SPEED * nav_delta, 0.0, 1.0))
	if absf(new_scale - _target_zoom) < 0.002:
		new_scale = _target_zoom
	_adjust_origin_for_uniform_zoom(current, new_scale)
	target.scale = Vector2(new_scale, new_scale)


func _apply_wasd(delta: float) -> void:
	var nav_delta := MapViewInput.motion_delta(delta)
	var move := Vector2.ZERO
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("move_left"):
		move.x -= 1.0
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("move_right"):
		move.x += 1.0
	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("move_up"):
		move.y -= 1.0
	if Input.is_action_pressed("ui_down") or Input.is_action_pressed("move_down"):
		move.y += 1.0
	if move.length_squared() > 0.0001:
		target.position += move.normalized() * wasd_speed * nav_delta


func _apply_edge_pan(delta: float) -> void:
	var vp := get_viewport()
	if MapViewInput.edge_pan_blocked_by_gui(vp):
		return
	var nav_delta := MapViewInput.motion_delta(delta)
	var m := vp.get_mouse_position()
	var sz := vp.get_visible_rect().size
	var dir := Vector2.ZERO
	if m.x <= edge_pan_margin:
		dir.x -= 1.0
	elif m.x >= sz.x - edge_pan_margin:
		dir.x += 1.0
	if m.y <= edge_pan_margin:
		dir.y -= 1.0
	elif m.y >= sz.y - edge_pan_margin:
		dir.y += 1.0
	if dir.length_squared() < 0.0001:
		return
	target.position += dir.normalized() * edge_pan_speed * nav_delta


func _input(event: InputEvent) -> void:
	if target == null:
		return

	# --- Gestos táctiles (tablet) ---
	if event is InputEventScreenTouch:
		_handle_screen_touch(event as InputEventScreenTouch)
		return
	if event is InputEventScreenDrag:
		_handle_screen_drag(event as InputEventScreenDrag)
		return

	# --- Ratón (escritorio): arrastre con botón central ---
	if not enable_pan:
		return
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_MIDDLE:
			_is_panning = mb.pressed

	if _is_panning and event is InputEventMouseMotion:
		target.position += (event as InputEventMouseMotion).relative


func _handle_screen_touch(t: InputEventScreenTouch) -> void:
	if t.pressed:
		_touch_points[t.index] = t.position
	else:
		_touch_points.erase(t.index)
	# La referencia de pellizco solo es válida con exactamente dos dedos.
	if _touch_points.size() == 2:
		_pinch_prev_dist = _two_finger_distance()
	else:
		_pinch_prev_dist = 0.0


func _handle_screen_drag(d: InputEventScreenDrag) -> void:
	_touch_points[d.index] = d.position
	var count := _touch_points.size()
	if count >= 2:
		if enable_zoom:
			_apply_pinch()
		return
	if count == 1 and enable_pan:
		target.position += d.relative


func _two_finger_distance() -> float:
	var pts: Array = _touch_points.values()
	if pts.size() < 2:
		return 0.0
	return (pts[0] as Vector2).distance_to(pts[1] as Vector2)


func _two_finger_centroid() -> Vector2:
	var pts: Array = _touch_points.values()
	if pts.size() < 2:
		return Vector2.ZERO
	return ((pts[0] as Vector2) + (pts[1] as Vector2)) * 0.5


func _apply_pinch() -> void:
	var cur_dist := _two_finger_distance()
	if cur_dist <= 0.0:
		return
	if _pinch_prev_dist <= 0.0:
		_pinch_prev_dist = cur_dist
		return
	var factor := cur_dist / _pinch_prev_dist
	_pinch_prev_dist = cur_dist
	var cur: float = target.scale.x
	var next: float = clampf(cur * factor, min_zoom, max_zoom)
	if is_equal_approx(next, cur):
		return
	# Mantener bajo los dedos el punto del mapa que había en el centro del pellizco.
	var screen_centroid := _two_finger_centroid()
	var world_centroid: Vector2 = get_viewport().get_canvas_transform().affine_inverse() * screen_centroid
	var local: Vector2 = target.get_global_transform().affine_inverse() * world_centroid
	target.position += local * (cur - next)
	target.scale = Vector2(next, next)
	_target_zoom = next


func _unhandled_input(event: InputEvent) -> void:
	if target == null or not enable_zoom:
		return

	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if not mb.pressed:
			return
		if mb.button_index == MOUSE_BUTTON_WHEEL_UP:
			_zoom_toward_mouse(1.0 + zoom_speed)
			get_viewport().set_input_as_handled()
		elif mb.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_zoom_toward_mouse(1.0 - zoom_speed)
			get_viewport().set_input_as_handled()


func _zoom_toward_mouse(factor: float) -> void:
	var cur := clampf(_target_zoom, min_zoom, max_zoom)
	var next := clampf(cur * factor, min_zoom, max_zoom)
	if is_equal_approx(next, cur):
		return
	_target_zoom = next


func _adjust_origin_for_uniform_zoom(old_s: float, new_s: float) -> void:
	var mp := target.get_global_mouse_position()
	var local_mouse := target.get_global_transform().affine_inverse() * mp
	target.position += Vector2(local_mouse.x * (old_s - new_s), local_mouse.y * (old_s - new_s))
