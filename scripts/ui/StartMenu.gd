class_name StartMenu
extends Control

## Menu principal del juego. La Fase 0 reemplaza el fondo negro/neon por una
## portada liviana con tono historico de la Guerra del Pacifico.

const GAME_SCENE := "res://scenes/TestScenario.tscn"
const NATION_SELECT_SCENE := "res://scenes/ui/NationSelectScreen.tscn"

const INK := Color(0.08, 0.07, 0.055)
const PAPER := Color(0.78, 0.68, 0.48)
const SAND := Color(0.47, 0.35, 0.20)
const SEA := Color(0.08, 0.20, 0.27)
const COPPER := Color(0.72, 0.35, 0.18)


func _ready() -> void:
	_build_ui()


func _build_ui() -> void:
	var bg := ColorRect.new()
	bg.color = Color(0.12, 0.105, 0.075)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)

	_add_historical_backdrop()

	var safe := MarginContainer.new()
	safe.set_anchors_preset(Control.PRESET_FULL_RECT)
	safe.add_theme_constant_override("margin_left", 80)
	safe.add_theme_constant_override("margin_top", 72)
	safe.add_theme_constant_override("margin_right", 80)
	safe.add_theme_constant_override("margin_bottom", 58)
	add_child(safe)

	var layout := VBoxContainer.new()
	layout.add_theme_constant_override("separation", 18)
	safe.add_child(layout)

	var header := VBoxContainer.new()
	header.add_theme_constant_override("separation", 8)
	layout.add_child(header)

	var title := Label.new()
	title.text = "GUERRA DEL PACIFICO"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 44)
	title.add_theme_color_override("font_color", Color(0.98, 0.91, 0.72))
	header.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "1879 - Chile, Peru y Bolivia"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 18)
	subtitle.add_theme_color_override("font_color", Color(0.86, 0.75, 0.53))
	header.add_child(subtitle)

	var context := Label.new()
	context.text = "Salitre, puertos, desierto y decision politica"
	context.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	context.add_theme_font_size_override("font_size", 13)
	context.add_theme_color_override("font_color", Color(0.70, 0.62, 0.47))
	header.add_child(context)

	var spacer_top := Control.new()
	spacer_top.size_flags_vertical = Control.SIZE_EXPAND_FILL
	layout.add_child(spacer_top)

	var menu_wrap := CenterContainer.new()
	layout.add_child(menu_wrap)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(460, 272)
	panel.add_theme_stylebox_override("panel", _panel_style(Color(0.11, 0.095, 0.07, 0.82), Color(0.74, 0.58, 0.34, 0.9)))
	menu_wrap.add_child(panel)

	var menu_margin := MarginContainer.new()
	menu_margin.add_theme_constant_override("margin_left", 22)
	menu_margin.add_theme_constant_override("margin_top", 22)
	menu_margin.add_theme_constant_override("margin_right", 22)
	menu_margin.add_theme_constant_override("margin_bottom", 22)
	panel.add_child(menu_margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 12)
	menu_margin.add_child(vbox)

	vbox.add_child(_make_button("Nueva partida", _on_new_game, true))
	var has_saves := typeof(SaveLoadManager) != TYPE_NIL and not SaveLoadManager.list_saves().is_empty()
	var load_btn := _make_button("Cargar partida", _on_load_game)
	load_btn.disabled = not has_saves
	vbox.add_child(load_btn)
	vbox.add_child(_make_button("Ajustes", _on_settings))
	vbox.add_child(_make_button("Salir", _on_quit))

	var spacer_bottom := Control.new()
	spacer_bottom.size_flags_vertical = Control.SIZE_EXPAND_FILL
	layout.add_child(spacer_bottom)

	var footer := Label.new()
	footer.text = "MVP 1879 - teatro del Pacifico sur"
	footer.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	footer.add_theme_font_size_override("font_size", 12)
	footer.add_theme_color_override("font_color", Color(0.62, 0.55, 0.43))
	layout.add_child(footer)


func _add_historical_backdrop() -> void:
	var sea := ColorRect.new()
	sea.color = SEA
	sea.anchor_left = 0.0
	sea.anchor_top = 0.0
	sea.anchor_right = 0.33
	sea.anchor_bottom = 1.0
	sea.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(sea)

	var desert := ColorRect.new()
	desert.color = Color(0.37, 0.25, 0.13, 0.84)
	desert.anchor_left = 0.33
	desert.anchor_top = 0.0
	desert.anchor_right = 1.0
	desert.anchor_bottom = 1.0
	desert.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(desert)

	var coast := ColorRect.new()
	coast.color = Color(0.87, 0.66, 0.34, 0.75)
	coast.anchor_left = 0.315
	coast.anchor_top = 0.0
	coast.anchor_right = 0.335
	coast.anchor_bottom = 1.0
	coast.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(coast)

	var vignette := ColorRect.new()
	vignette.color = Color(0.02, 0.018, 0.014, 0.38)
	vignette.set_anchors_preset(Control.PRESET_FULL_RECT)
	vignette.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(vignette)

	var routes := Node2D.new()
	routes.name = "HistoricalRouteLines"
	routes.z_index = 2
	routes.process_mode = Node.PROCESS_MODE_DISABLED
	add_child(routes)
	_add_route_line(routes, PackedVector2Array([Vector2(360, 120), Vector2(410, 250), Vector2(390, 430), Vector2(450, 620)]), Color(0.94, 0.80, 0.52, 0.34))
	_add_route_line(routes, PackedVector2Array([Vector2(510, 160), Vector2(610, 250), Vector2(670, 390), Vector2(820, 510)]), Color(0.20, 0.12, 0.06, 0.22))
	_add_route_line(routes, PackedVector2Array([Vector2(250, 690), Vector2(365, 620), Vector2(455, 520)]), Color(0.75, 0.88, 0.92, 0.26))


func _add_route_line(parent: Node, points: PackedVector2Array, color: Color) -> void:
	var line := Line2D.new()
	line.points = points
	line.width = 3.0
	line.default_color = color
	line.antialiased = true
	parent.add_child(line)


func _make_button(text: String, handler: Callable, primary := false) -> Button:
	var b := Button.new()
	b.text = text
	b.custom_minimum_size = Vector2(0, 46)
	b.focus_mode = Control.FOCUS_NONE
	b.pressed.connect(handler)
	var normal_col := COPPER if primary else Color(0.19, 0.16, 0.12)
	var hover_col := Color(0.86, 0.46, 0.22) if primary else Color(0.30, 0.24, 0.17)
	b.add_theme_stylebox_override("normal", _button_style(normal_col))
	b.add_theme_stylebox_override("hover", _button_style(hover_col))
	b.add_theme_stylebox_override("pressed", _button_style(normal_col.darkened(0.22)))
	b.add_theme_color_override("font_color", Color(0.98, 0.92, 0.78))
	b.add_theme_color_override("font_hover_color", Color.WHITE)
	b.add_theme_font_size_override("font_size", 15)
	return b


func _button_style(bg: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg
	style.border_color = Color(0.78, 0.62, 0.38, 0.95)
	style.set_border_width_all(1)
	style.set_corner_radius_all(4)
	style.set_content_margin_all(10)
	return style


func _panel_style(bg: Color, border: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg
	style.border_color = border
	style.set_border_width_all(1)
	style.set_corner_radius_all(6)
	style.shadow_color = Color(0, 0, 0, 0.35)
	style.shadow_size = 12
	style.set_content_margin_all(16)
	return style


func _on_new_game() -> void:
	NationSelectScreen.selected_tag = ""
	get_tree().change_scene_to_file(NATION_SELECT_SCENE)


func _on_load_game() -> void:
	if typeof(SaveLoadManager) == TYPE_NIL:
		return
	var saves := SaveLoadManager.list_saves()
	if saves.is_empty():
		return
	var slot := str(saves[0].get("slot", ""))
	var meta: Dictionary = saves[0].get("metadata", {})
	var tag := str(meta.get("player_tag", "CHL")).strip_edges().to_upper()
	if tag.is_empty():
		tag = "CHL"
	NationSelectScreen.selected_tag = tag
	SaveLoadManager.pending_load_slot = slot
	get_tree().change_scene_to_file(GAME_SCENE)


func _on_settings() -> void:
	var settings := preload("res://scenes/ui/SettingsPopup.tscn").instantiate()
	add_child(settings)


func _on_quit() -> void:
	get_tree().quit()
