# scripts/map/CameraController.gd
class_name CameraController
extends Node2D

@export var target: Node2D

var _target_zoom := 1.0
var _is_panning := false

func _ready():
	if target == null:
		target = self
	_target_zoom = target.scale.x

	# Force input processing
	set_process(true)
	set_process_unhandled_input(true)
	set_process_input(true)


func _unhandled_input(event: InputEvent):
	if target == null:
		return

	# === Zoom ===
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_zoom_toward_mouse(1.0 + 0.1)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_zoom_toward_mouse(1.0 - 0.1)

		if event.button_index == MOUSE_BUTTON_MIDDLE:
			_is_panning = event.pressed

	# === Pan with middle mouse drag ===
	if _is_panning and event is InputEventMouseMotion:
		target.position += event.relative


func _process(delta):
	if target == null:
		return

	# Smooth zoom toward target
	if abs(target.scale.x - _target_zoom) > 0.001:
		var mouse_pos = get_local_mouse_position()
		var old_scale = target.scale.x
		target.scale = lerp(target.scale, Vector2(_target_zoom, _target_zoom), 12.0 * delta)
		target.position = mouse_pos - (mouse_pos - target.position) * (_target_zoom / old_scale)


func _zoom_toward_mouse(factor: float):
	_target_zoom = clamp(_target_zoom * factor, 0.2, 5.0)
