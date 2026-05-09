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

	var new_scale := lerpf(current, _target_zoom, clampf(_ZOOM_LERP_SPEED * delta, 0.0, 1.0))
	if absf(new_scale - _target_zoom) < 0.002:
		new_scale = _target_zoom
	_adjust_origin_for_uniform_zoom(current, new_scale)
	target.scale = Vector2(new_scale, new_scale)


func _apply_wasd(delta: float) -> void:
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
		target.position += move.normalized() * wasd_speed * delta


func _apply_edge_pan(delta: float) -> void:
	var vp := get_viewport()
	if vp.gui_get_hovered_control() != null:
		return
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
	target.position += dir.normalized() * edge_pan_speed * delta


func _input(event: InputEvent) -> void:
	if target == null or not enable_pan:
		return

	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_MIDDLE:
			_is_panning = mb.pressed

	if _is_panning and event is InputEventMouseMotion:
		target.position += (event as InputEventMouseMotion).relative


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
