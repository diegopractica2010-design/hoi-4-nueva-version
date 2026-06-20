class_name NationSelectScreen
extends Control

signal nation_selected(tag: String)

static var selected_tag: String = ""

const GAME_SCENE_PATH := "res://scenes/TestScenario.tscn"

const NATIONS: Array[Dictionary] = [
	{
		"tag": "CHL",
		"name": "Chile",
		"difficulty": "Mas viable",
		"color": Color(0.0, 0.2, 0.627),
		"title": "Ofensiva naval y salitrera",
		"objective": "Tomar Antofagasta, dominar el mar y forzar una paz favorable.",
		"details": "Ejercito profesional, mejor organizacion inicial y marina capaz de cortar el suministro enemigo.",
	},
	{
		"tag": "PER",
		"name": "Peru",
		"difficulty": "Intermedia",
		"color": Color(0.851, 0.063, 0.137),
		"title": "Defensa aliada del litoral",
		"objective": "Resistir en Tarapaca, proteger Lima y usar la alianza con Bolivia.",
		"details": "Marina con el Huascar, territorio clave y presion politica si la guerra se alarga.",
	},
	{
		"tag": "BOL",
		"name": "Bolivia",
		"difficulty": "Dificil",
		"color": Color(0.0, 0.478, 0.2),
		"title": "Recuperar el litoral",
		"objective": "Evitar el aislamiento, sostener Antofagasta y explotar la defensa andina.",
		"details": "Menos recursos y peor armamento, pero con rutas dificiles y margen para una victoria alternativa.",
	},
]


func _ready() -> void:
	_build_ui()


func _build_ui() -> void:
	var bg := ColorRect.new()
	bg.color = Color(0.10, 0.085, 0.06)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)

	_add_backdrop()

	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 58)
	margin.add_theme_constant_override("margin_top", 52)
	margin.add_theme_constant_override("margin_right", 58)
	margin.add_theme_constant_override("margin_bottom", 42)
	add_child(margin)

	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 18)
	margin.add_child(root)

	var title := Label.new()
	title.text = "Elige tu pais"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 34)
	title.add_theme_color_override("font_color", Color(0.98, 0.90, 0.70))
	root.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "Cada pais empieza con su situacion historica y una ruta distinta hacia la victoria."
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	subtitle.add_theme_font_size_override("font_size", 14)
	subtitle.add_theme_color_override("font_color", Color(0.76, 0.68, 0.52))
	root.add_child(subtitle)

	var cards := HBoxContainer.new()
	cards.alignment = BoxContainer.ALIGNMENT_CENTER
	cards.size_flags_vertical = Control.SIZE_EXPAND_FILL
	cards.add_theme_constant_override("separation", 18)
	root.add_child(cards)

	for nation in NATIONS:
		cards.add_child(_make_nation_card(nation))

	var bottom := HBoxContainer.new()
	bottom.alignment = BoxContainer.ALIGNMENT_CENTER
	root.add_child(bottom)
	var back_btn := _make_small_button("Volver al menu", _on_back_pressed)
	bottom.add_child(back_btn)


func _add_backdrop() -> void:
	var sea := ColorRect.new()
	sea.color = Color(0.055, 0.17, 0.23)
	sea.anchor_left = 0.0
	sea.anchor_top = 0.0
	sea.anchor_right = 0.28
	sea.anchor_bottom = 1.0
	sea.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(sea)

	var coast := ColorRect.new()
	coast.color = Color(0.78, 0.57, 0.28, 0.74)
	coast.anchor_left = 0.275
	coast.anchor_top = 0.0
	coast.anchor_right = 0.295
	coast.anchor_bottom = 1.0
	coast.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(coast)

	var shade := ColorRect.new()
	shade.color = Color(0.02, 0.016, 0.011, 0.38)
	shade.set_anchors_preset(Control.PRESET_FULL_RECT)
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(shade)


func _make_nation_card(nation: Dictionary) -> Button:
	var tag := str(nation["tag"])
	var color: Color = nation["color"]
	var btn := Button.new()
	btn.custom_minimum_size = Vector2(330, 420)
	btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	btn.focus_mode = Control.FOCUS_NONE
	btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	btn.text = "%s\n%s\n\n%s\n\nObjetivo\n%s\n\n%s" % [
		str(nation["name"]).to_upper(),
		str(nation["difficulty"]),
		str(nation["title"]),
		str(nation["objective"]),
		str(nation["details"]),
	]
	btn.tooltip_text = "Jugar como %s" % str(nation["name"])
	btn.add_theme_font_size_override("font_size", 16)
	btn.add_theme_color_override("font_color", Color(0.96, 0.90, 0.78))
	btn.add_theme_color_override("font_hover_color", Color.WHITE)
	btn.add_theme_color_override("font_pressed_color", Color.WHITE)
	btn.add_theme_stylebox_override("normal", _card_style(Color(0.13, 0.105, 0.075, 0.94), color.darkened(0.1)))
	btn.add_theme_stylebox_override("hover", _card_style(Color(0.20, 0.16, 0.105, 0.98), color))
	btn.add_theme_stylebox_override("pressed", _card_style(Color(0.09, 0.075, 0.055, 0.98), color.darkened(0.25)))
	btn.pressed.connect(_on_nation_pressed.bind(tag))
	return btn


func _make_small_button(text: String, handler: Callable) -> Button:
	var btn := Button.new()
	btn.text = text
	btn.custom_minimum_size = Vector2(240, 42)
	btn.focus_mode = Control.FOCUS_NONE
	btn.add_theme_stylebox_override("normal", _small_style(Color(0.16, 0.13, 0.095)))
	btn.add_theme_stylebox_override("hover", _small_style(Color(0.26, 0.20, 0.13)))
	btn.add_theme_stylebox_override("pressed", _small_style(Color(0.10, 0.08, 0.06)))
	btn.add_theme_color_override("font_color", Color(0.93, 0.86, 0.70))
	btn.pressed.connect(handler)
	return btn


func _card_style(bg: Color, accent: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg
	style.border_color = accent
	style.border_width_left = 6
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 1
	style.set_corner_radius_all(6)
	style.content_margin_left = 18
	style.content_margin_right = 16
	style.content_margin_top = 22
	style.content_margin_bottom = 18
	style.shadow_color = Color(0, 0, 0, 0.32)
	style.shadow_size = 8
	return style


func _small_style(bg: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg
	style.border_color = Color(0.75, 0.60, 0.38, 0.9)
	style.set_border_width_all(1)
	style.set_corner_radius_all(4)
	style.set_content_margin_all(8)
	return style


func _on_nation_pressed(tag: String) -> void:
	selected_tag = tag
	nation_selected.emit(tag)
	get_tree().change_scene_to_file(GAME_SCENE_PATH)


func _on_back_pressed() -> void:
	selected_tag = ""
	get_tree().change_scene_to_file("res://scenes/ui/StartMenu.tscn")
