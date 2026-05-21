# scripts/ui/DraggablePanel.gd
class_name DraggablePanel
extends Control

## Drag a panel by its root or by an optional handle (e.g. title bar).

@export var drag_handle: Control = null

var _dragging := false
var _drag_offset := Vector2.ZERO


func _ready() -> void:
	var handle := drag_handle if drag_handle != null else self
	handle.mouse_filter = Control.MOUSE_FILTER_STOP
	if handle != self:
		handle.gui_input.connect(_on_drag_input)
	else:
		gui_input.connect(_on_drag_input)


func _on_drag_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_LEFT:
			if mb.pressed:
				_dragging = true
				_drag_offset = get_global_mouse_position() - global_position
			else:
				_dragging = false
	elif event is InputEventMouseMotion and _dragging:
		global_position = get_global_mouse_position() - _drag_offset
