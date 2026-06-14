class_name TutorialPopup
extends Control

## Onboarding mínimo: explica lo básico la primera vez que se entra al juego.
## Tras cerrarlo, escribe un marcador en user:// para no volver a mostrarlo.

const SEEN_MARKER := "user://tutorial_seen.flag"


func _ready() -> void:
	# Solo la primera vez (a menos que se borre el marcador).
	if FileAccess.file_exists(SEEN_MARKER):
		queue_free()
		return
	_build_ui()


func _build_ui() -> void:
	var dim := ColorRect.new()
	dim.color = Color(0, 0, 0, 0.6)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(dim)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(560, 0)
	center.add_child(panel)
	if typeof(RetrowaveTheme) != TYPE_NIL:
		var st := StyleBoxFlat.new()
		st.bg_color = Color(0.09, 0.09, 0.14)
		st.border_color = RetrowaveTheme.CYAN
		st.set_border_width_all(2)
		st.set_corner_radius_all(8)
		st.set_content_margin_all(22)
		panel.add_theme_stylebox_override("panel", st)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 12)
	panel.add_child(vbox)

	var title := Label.new()
	title.text = "Cómo jugar — Guerra del Pacífico (1879)"
	title.add_theme_font_size_override("font_size", 22)
	if typeof(RetrowaveTheme) != TYPE_NIL:
		RetrowaveTheme.style_title(title, RetrowaveTheme.CYAN)
	vbox.add_child(title)

	var body := Label.new()
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body.text = (
		"OBJETIVO: controlar el litoral del salitre — Antofagasta, Tarapacá e Iquique.\n\n"
		+ "MOVER EJÉRCITOS: haz clic en una provincia tuya (verás tus unidades) y luego en una "
		+ "provincia ADYACENTE para moverte. Si entras en territorio enemigo, hay batalla.\n\n"
		+ "GANAR BATALLAS: concentra varias unidades en la misma provincia — vence quien reúne "
		+ "más fuerza (y un buen general ayuda).\n\n"
		+ "EL TIEMPO: arriba a la izquierda controlas pausa y velocidad. Los eventos históricos "
		+ "(Iquique, Angamos, Tratado de Ancón) aparecen solos en su fecha.\n\n"
		+ "GUARDAR: desde el menú (botón de la barra superior). ¡Suerte, comandante!"
	)
	vbox.add_child(body)

	var ok := Button.new()
	ok.text = "Entendido"
	ok.custom_minimum_size = Vector2(0, 42)
	ok.pressed.connect(_dismiss)
	if typeof(RetrowaveTheme) != TYPE_NIL:
		RetrowaveTheme.style_primary_button(ok)
	vbox.add_child(ok)


func _dismiss() -> void:
	var f := FileAccess.open(SEEN_MARKER, FileAccess.WRITE)
	if f != null:
		f.store_string("1")
		f.close()
	queue_free()
