class_name NationSelectScreen
extends Control

## Pantalla de selección de nación para el escenario de 1879 (Guerra del Pacífico).
##
## Flujo: se muestra antes de cargar la partida. El jugador elige Chile, Perú o Bolivia;
## la elección se guarda en `selected_tag` (estática, sobrevive al cambio de escena) y se
## carga la escena de juego (TestScenario), donde TestRunner lee el tag y lo propaga a
## SaveLoadManager.
##
## Los colores de cada botón provienen de data/countries/*.json (fuente única de verdad),
## por lo que coinciden con los colores del mapa.

signal nation_selected(tag: String)

## Nación elegida por el jugador. Estática para sobrevivir a `change_scene_to_file`.
## Vacía hasta que el jugador elige; TestRunner la usa como bandera de "ya hay nación".
static var selected_tag: String = ""

const GAME_SCENE_PATH := "res://scenes/TestScenario.tscn"

# Definición de las 3 naciones jugables (color real del país + contexto histórico).
const NATIONS: Array[Dictionary] = [
	{
		"tag": "CHL",
		"name": "Chile",
		"color": Color(0.0, 0.2, 0.627),  # #0033A0 (azul, igual que data/countries/chile.json)
		"description": "Ejército profesional y marina moderna de suministro británico.\nFusil Comblain y artillería Krupp; busca el salitre del litoral.",
	},
	{
		"tag": "PER",
		"name": "Perú",
		"color": Color(0.851, 0.063, 0.137),  # #D91023 (rojo, igual que data/countries/peru.json)
		"description": "Marina acorazada liderada por el monitor Huáscar.\nLigada a Bolivia por tratado secreto; defiende Tarapacá y Arica.",
	},
	{
		"tag": "BOL",
		"name": "Bolivia",
		"color": Color(0.0, 0.478, 0.2),  # #007A33 (verde, igual que data/countries/bolivia.json)
		"description": "Ejército débil y armamento obsoleto, especialista en montaña.\nDefiende su único litoral en Antofagasta.",
	},
]


func _ready() -> void:
	_build_ui()


func _build_ui() -> void:
	# Fondo oscuro a pantalla completa.
	var background := ColorRect.new()
	background.color = Color(0.06, 0.06, 0.1)
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	# Contenedor centrado.
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(560, 520)
	center.add_child(panel)
	if typeof(RetrowaveTheme) != TYPE_NIL:
		var panel_style := StyleBoxFlat.new()
		panel_style.bg_color = Color(0.09, 0.09, 0.14)
		panel_style.border_color = RetrowaveTheme.CYAN
		panel_style.set_border_width_all(2)
		panel_style.set_corner_radius_all(8)
		panel_style.set_content_margin_all(24)
		panel.add_theme_stylebox_override("panel", panel_style)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 16)
	panel.add_child(vbox)

	# Título.
	var title := Label.new()
	title.text = "Selecciona tu Nación"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 26)
	if typeof(RetrowaveTheme) != TYPE_NIL:
		RetrowaveTheme.style_title(title, RetrowaveTheme.CYAN)
	vbox.add_child(title)

	# Botón por nación.
	for nation in NATIONS:
		vbox.add_child(_make_nation_button(nation))

	# Separador antes del botón Volver.
	var spacer := Control.new()
	spacer.custom_minimum_size.y = 12
	vbox.add_child(spacer)

	# Botón Volver.
	var back_btn := Button.new()
	back_btn.text = "Volver"
	back_btn.custom_minimum_size = Vector2(0, 40)
	back_btn.pressed.connect(_on_back_pressed)
	if typeof(RetrowaveTheme) != TYPE_NIL:
		RetrowaveTheme.style_secondary_button(back_btn)
	vbox.add_child(back_btn)


## Construye un botón grande con el nombre de la nación, su color y su descripción histórica.
func _make_nation_button(nation: Dictionary) -> Button:
	var tag := str(nation["tag"])
	var nation_name := str(nation["name"])
	var color: Color = nation["color"]
	var description := str(nation["description"])

	var btn := Button.new()
	btn.custom_minimum_size = Vector2(0, 110)
	btn.text = "%s\n%s" % [nation_name, description]
	btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	btn.add_theme_color_override("font_color", Color.WHITE)
	btn.add_theme_color_override("font_hover_color", Color.WHITE)
	btn.add_theme_color_override("font_pressed_color", Color.WHITE)

	# Estilo con el color de la nación (más oscuro en reposo, más vivo al pasar el ratón).
	btn.add_theme_stylebox_override("normal", _nation_style(color.darkened(0.25)))
	btn.add_theme_stylebox_override("hover", _nation_style(color))
	btn.add_theme_stylebox_override("pressed", _nation_style(color.darkened(0.4)))

	btn.pressed.connect(_on_nation_pressed.bind(tag))
	return btn


func _nation_style(bg: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg
	style.set_corner_radius_all(6)
	style.set_content_margin_all(12)
	return style


## Guarda la nación elegida, avisa por señal y pasa a la escena de juego.
func _on_nation_pressed(tag: String) -> void:
	selected_tag = tag
	nation_selected.emit(tag)
	get_tree().change_scene_to_file(GAME_SCENE_PATH)


## "Volver": no existe una pantalla de menú principal de inicio en este proyecto
## (MainMenu es un popup de pausa in-game), así que Volver sale del juego.
func _on_back_pressed() -> void:
	get_tree().quit()
