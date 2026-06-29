class_name NationSelectScreen
extends Control

signal nation_selected(tag: String)

const GAME_SCENE_PATH := "res://scenes/TestScenario.tscn"

const NATIONS: Array[Dictionary] = [
	{
		"tag": "CHL",
		"name": "Chile",
		"difficulty": "Más viable",
		"color": Color(0.0, 0.2, 0.627),
		"color2": Color(1.0, 1.0, 1.0),
		"color3": Color(0.7, 0.0, 0.0),
		"stars": 3,
		"army": 0.75,
		"navy": 0.65,
		"economy": 0.70,
		"title": "Ofensiva naval y salitrera",
		"objective": "Tomar Antofagasta, dominar el mar y forzar una paz favorable.",
		"details": "Ejército profesional, mejor organización inicial y marina moderna con blindados.",
		"flag_colors": [Color(0.0, 0.2, 0.627), Color(1.0, 1.0, 1.0), Color(0.7, 0.0, 0.0)],
	},
	{
		"tag": "PER",
		"name": "Perú",
		"difficulty": "Intermedia",
		"color": Color(0.851, 0.063, 0.137),
		"color2": Color(1.0, 1.0, 1.0),
		"color3": Color(0.851, 0.063, 0.137),
		"stars": 2,
		"army": 0.50,
		"navy": 0.80,
		"economy": 0.45,
		"title": "Defensa aliada del litoral",
		"objective": "Resistir en Tarapacá, proteger Lima y usar la alianza con Bolivia.",
		"details": "Marina con el Huáscar, tratado defensivo con Bolivia y defensas costeras.",
		"flag_colors": [Color(0.851, 0.063, 0.137), Color(1.0, 1.0, 1.0), Color(0.851, 0.063, 0.137)],
	},
	{
		"tag": "BOL",
		"name": "Bolivia",
		"difficulty": "Difícil",
		"color": Color(0.0, 0.478, 0.2),
		"color2": Color(1.0, 1.0, 0.0),
		"color3": Color(0.7, 0.0, 0.0),
		"stars": 1,
		"army": 0.45,
		"navy": 0.05,
		"economy": 0.35,
		"title": "Recuperar el litoral",
		"objective": "Evitar el aislamiento, sostener Antofagasta y explotar la defensa andina.",
		"details": "Sin marina, terreno montañoso favorable, menos recursos pero margen para sorprender.",
		"flag_colors": [Color(0.0, 0.478, 0.2), Color(1.0, 1.0, 0.0), Color(0.7, 0.0, 0.0)],
	},
]


func _ready() -> void:
	_build_ui()


func _build_ui() -> void:
	var bg := ColorRect.new()
	bg.color = Color(0.07, 0.06, 0.04)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)

	_add_backdrop()

	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 38)
	margin.add_theme_constant_override("margin_top", 38)
	margin.add_theme_constant_override("margin_right", 38)
	margin.add_theme_constant_override("margin_bottom", 32)
	add_child(margin)

	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 14)
	margin.add_child(root)

	var title := Label.new()
	title.text = "ELIGE TU PAÍS"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 32)
	title.add_theme_color_override("font_color", Color(0.98, 0.90, 0.70))
	root.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "Cada nación empieza con su situación histórica y una ruta distinta hacia la victoria."
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	subtitle.add_theme_font_size_override("font_size", 13)
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
	var back_btn := _make_small_button("Volver al menú", _on_back_pressed)
	bottom.add_child(back_btn)


func _add_backdrop() -> void:
	var sea := ColorRect.new()
	sea.color = Color(0.04, 0.14, 0.20)
	sea.anchor_left = 0.0
	sea.anchor_top = 0.0
	sea.anchor_right = 0.28
	sea.anchor_bottom = 1.0
	sea.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(sea)

	var coast := ColorRect.new()
	coast.color = Color(0.72, 0.52, 0.24, 0.70)
	coast.anchor_left = 0.275
	coast.anchor_top = 0.0
	coast.anchor_right = 0.295
	coast.anchor_bottom = 1.0
	coast.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(coast)

	var desert := ColorRect.new()
	desert.color = Color(0.34, 0.22, 0.10, 0.40)
	desert.anchor_left = 0.295
	desert.anchor_top = 0.0
	desert.anchor_right = 1.0
	desert.anchor_bottom = 1.0
	desert.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(desert)

	var shade := ColorRect.new()
	shade.color = Color(0.01, 0.01, 0.01, 0.30)
	shade.set_anchors_preset(Control.PRESET_FULL_RECT)
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(shade)


func _make_nation_card(nation: Dictionary) -> Button:
	var tag := str(nation["tag"])
	var color: Color = nation["color"]
	var btn := Button.new()
	btn.custom_minimum_size = Vector2(300, 440)
	btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	btn.focus_mode = Control.FOCUS_NONE
	btn.add_theme_font_size_override("font_size", 14)
	btn.add_theme_color_override("font_color", Color(0.96, 0.90, 0.78))
	btn.add_theme_color_override("font_hover_color", Color.WHITE)
	btn.add_theme_color_override("font_pressed_color", Color.WHITE)
	btn.add_theme_stylebox_override("normal", _card_style(Color(0.11, 0.09, 0.065, 0.94), color.darkened(0.15)))
	btn.add_theme_stylebox_override("hover", _card_style(Color(0.18, 0.14, 0.10, 0.98), color))
	btn.add_theme_stylebox_override("pressed", _card_style(Color(0.08, 0.06, 0.05, 0.98), color.darkened(0.30)))
	btn.pressed.connect(_on_nation_pressed.bind(tag))

	var card_vbox := VBoxContainer.new()
	card_vbox.add_theme_constant_override("separation", 4)
	card_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card_vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	btn.add_child(card_vbox)

	_add_flag_banner(card_vbox, nation)
	_add_country_header(card_vbox, nation)
	_add_difficulty_stars(card_vbox, nation)
	_add_stat_bars(card_vbox, nation)
	_add_description(card_vbox, nation)
	_add_play_button(card_vbox, nation)

	return btn


func _add_flag_banner(parent: VBoxContainer, nation: Dictionary) -> void:
	var flag_colors: Array = nation["flag_colors"]
	var banner := MarginContainer.new()
	banner.add_theme_constant_override("margin_bottom", 4)
	parent.add_child(banner)

	var hbox := HBoxContainer.new()
	hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	banner.add_child(hbox)

	for c in flag_colors:
		var strip := ColorRect.new()
		strip.color = c
		strip.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		strip.custom_minimum_size = Vector2(0, 28)
		hbox.add_child(strip)


func _add_country_header(parent: VBoxContainer, nation: Dictionary) -> void:
	var hbox := HBoxContainer.new()
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	parent.add_child(hbox)

	var name_label := Label.new()
	name_label.text = str(nation["name"]).to_upper()
	name_label.add_theme_font_size_override("font_size", 22)
	name_label.add_theme_color_override("font_color", nation["color"])
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	parent.add_child(name_label)


func _add_difficulty_stars(parent: VBoxContainer, nation: Dictionary) -> void:
	var star_count := int(nation.get("stars", 1))
	var hbox_difficulty := HBoxContainer.new()
	hbox_difficulty.alignment = BoxContainer.ALIGNMENT_CENTER
	parent.add_child(hbox_difficulty)

	var stars := ""
	var difficulty := str(nation.get("difficulty", ""))
	for i in 3:
		if i < star_count:
			stars += "★"
		else:
			stars += "☆"

	var star_label := Label.new()
	star_label.text = "%s  %s" % [stars, difficulty]
	star_label.add_theme_font_size_override("font_size", 13)
	star_label.add_theme_color_override("font_color", Color(0.90, 0.78, 0.45))
	star_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	parent.add_child(star_label)


func _add_stat_bars(parent: VBoxContainer, nation: Dictionary) -> void:
	var stats := [
		["EJÉRCITO", float(nation.get("army", 0.5)), Color(0.75, 0.35, 0.15)],
		["MARINA", float(nation.get("navy", 0.5)), Color(0.15, 0.45, 0.75)],
		["ECONOMÍA", float(nation.get("economy", 0.5)), Color(0.65, 0.65, 0.15)],
	]

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 8)
	margin.add_theme_constant_override("margin_right", 8)
	margin.add_theme_constant_override("margin_top", 4)
	margin.add_theme_constant_override("margin_bottom", 4)
	parent.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 3)
	margin.add_child(vbox)

	for stat in stats:
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 6)
		vbox.add_child(row)

		var label := Label.new()
		label.text = stat[0]
		label.custom_minimum_size = Vector2(64, 0)
		label.add_theme_font_size_override("font_size", 10)
		label.add_theme_color_override("font_color", Color(0.80, 0.75, 0.60))
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		row.add_child(label)

		var bar_bg := ColorRect.new()
		bar_bg.color = Color(0.20, 0.18, 0.14)
		bar_bg.custom_minimum_size = Vector2(0, 8)
		bar_bg.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(bar_bg)

		var fill := ColorRect.new()
		var val := clampf(stat[1], 0.0, 1.0)
		fill.color = stat[2]
		fill.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		fill.custom_minimum_size = Vector2(0, 8)
		fill.size_flags_stretch_ratio = val
		bar_bg.add_child(fill)

		var filler := ColorRect.new()
		filler.color = Color(0.20, 0.18, 0.14)
		filler.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		filler.size_flags_stretch_ratio = 1.0 - val
		bar_bg.add_child(filler)


func _add_description(parent: VBoxContainer, nation: Dictionary) -> void:
	var title := str(nation.get("title", ""))
	var objective := str(nation.get("objective", ""))
	var details := str(nation.get("details", ""))

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 8)
	margin.add_theme_constant_override("margin_right", 8)
	parent.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 2)
	margin.add_child(vbox)

	if not title.is_empty():
		var t_label := Label.new()
		t_label.text = title
		t_label.add_theme_font_size_override("font_size", 11)
		t_label.add_theme_color_override("font_color", nation["color"])
		t_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		t_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		vbox.add_child(t_label)

	var desc := ""
	if not objective.is_empty():
		desc += objective
		desc += "\n\n" if not details.is_empty() else ""
	if not details.is_empty():
		desc += details

	var d_label := Label.new()
	d_label.text = desc
	d_label.add_theme_font_size_override("font_size", 10)
	d_label.add_theme_color_override("font_color", Color(0.80, 0.72, 0.58))
	d_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	d_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	d_label.max_lines_visible = 4
	vbox.add_child(d_label)


func _add_play_button(parent: VBoxContainer, nation: Dictionary) -> void:
	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	parent.add_child(spacer)

	var hbox := HBoxContainer.new()
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	parent.add_child(hbox)

	var play_btn := Button.new()
	play_btn.text = "▶  JUGAR"
	play_btn.custom_minimum_size = Vector2(160, 34)
	play_btn.focus_mode = Control.FOCUS_NONE
	play_btn.add_theme_font_size_override("font_size", 14)
	play_btn.add_theme_color_override("font_color", Color(0.98, 0.92, 0.78))
	play_btn.add_theme_color_override("font_hover_color", Color.WHITE)

	var bg: Color = nation["color"]
	var style_normal := StyleBoxFlat.new()
	style_normal.bg_color = bg.darkened(0.2)
	style_normal.border_color = bg
	style_normal.set_border_width_all(1)
	style_normal.set_corner_radius_all(4)
	style_normal.set_content_margin_all(6)
	play_btn.add_theme_stylebox_override("normal", style_normal)

	var style_hover := StyleBoxFlat.new()
	style_hover.bg_color = bg
	style_hover.border_color = bg.lightened(0.3)
	style_hover.set_border_width_all(1)
	style_hover.set_corner_radius_all(4)
	style_hover.set_content_margin_all(6)
	play_btn.add_theme_stylebox_override("hover", style_hover)

	var tag := str(nation["tag"])
	play_btn.pressed.connect(_on_nation_pressed.bind(tag))
	hbox.add_child(play_btn)


func _make_small_button(text: String, handler: Callable) -> Button:
	var btn := Button.new()
	btn.text = text
	btn.custom_minimum_size = Vector2(220, 38)
	btn.focus_mode = Control.FOCUS_NONE
	btn.add_theme_stylebox_override("normal", _small_style(Color(0.14, 0.11, 0.08)))
	btn.add_theme_stylebox_override("hover", _small_style(Color(0.24, 0.18, 0.12)))
	btn.add_theme_stylebox_override("pressed", _small_style(Color(0.09, 0.07, 0.05)))
	btn.add_theme_color_override("font_color", Color(0.93, 0.86, 0.70))
	btn.pressed.connect(handler)
	return btn


func _card_style(bg: Color, accent: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg
	style.border_color = accent
	style.border_width_left = 0
	style.border_width_top = 0
	style.border_width_right = 0
	style.border_width_bottom = 0
	style.set_corner_radius_all(8)
	style.content_margin_left = 0
	style.content_margin_right = 0
	style.content_margin_top = 0
	style.content_margin_bottom = 0
	style.shadow_color = Color(0, 0, 0, 0.40)
	style.shadow_size = 10
	return style


func _small_style(bg: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg
	style.border_color = Color(0.70, 0.55, 0.35, 0.85)
	style.set_border_width_all(1)
	style.set_corner_radius_all(4)
	style.set_content_margin_all(8)
	return style


func _on_nation_pressed(tag: String) -> void:
	GameData.selected_nation_tag = tag
	nation_selected.emit(tag)
	get_tree().change_scene_to_file(GAME_SCENE_PATH)


func _on_back_pressed() -> void:
	GameData.selected_nation_tag = ""
	get_tree().change_scene_to_file("res://scenes/ui/StartMenu.tscn")
