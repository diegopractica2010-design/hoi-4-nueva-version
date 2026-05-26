class_name ProvinceHoverTooltip
extends PanelContainer

## Floating multiline province tooltip for map hover.

@export var max_width: float = 340.0
@export var font_size: int = 12

var _label: Label


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	visible = false
	z_index = 200
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 10)
	margin.add_theme_constant_override("margin_right", 10)
	margin.add_theme_constant_override("margin_top", 8)
	margin.add_theme_constant_override("margin_bottom", 8)
	add_child(margin)

	_label = Label.new()
	_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_label.add_theme_font_size_override("font_size", font_size)
	_label.add_theme_color_override("font_color", Color(0.95, 0.97, 1.0))
	margin.add_child(_label)

	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.08, 0.1, 0.16, 0.94)
	style.border_color = Color(0.35, 0.55, 0.85, 0.9)
	style.set_border_width_all(2)
	style.set_corner_radius_all(6)
	style.shadow_size = 6
	style.shadow_color = Color(0, 0, 0, 0.45)
	add_theme_stylebox_override("panel", style)


func show_text(text: String, screen_pos: Vector2, viewport_size: Vector2) -> void:
	_label.text = text
	_label.custom_minimum_size = Vector2(max_width - 20.0, 0)
	_label.reset_size()

	visible = not text.is_empty()
	if not visible:
		return

	reset_size()
	var size := get_minimum_size()
	var pos := screen_pos + Vector2(16, 12)
	if pos.x + size.x > viewport_size.x - 8.0:
		pos.x = viewport_size.x - size.x - 8.0
	if pos.y + size.y > viewport_size.y - 8.0:
		pos.y = screen_pos.y - size.y - 12.0
	position = pos


func hide_tooltip() -> void:
	visible = false
