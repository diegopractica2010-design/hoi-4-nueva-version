class_name SettingsPopup
extends Control

## Ajustes mínimos: idioma (usa el sistema de localización) + cierre.
## Pensado para crecer (audio/gráficos) cuando existan esos sistemas.


func _ready() -> void:
	_build_ui()


func _build_ui() -> void:
	var dim := ColorRect.new()
	dim.color = Color(0, 0, 0, 0.55)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(dim)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(420, 320)
	center.add_child(panel)
	if typeof(RetrowaveTheme) != TYPE_NIL:
		var st := StyleBoxFlat.new()
		st.bg_color = Color(0.09, 0.09, 0.14)
		st.border_color = RetrowaveTheme.CYAN
		st.set_border_width_all(2)
		st.set_corner_radius_all(8)
		st.set_content_margin_all(20)
		panel.add_theme_stylebox_override("panel", st)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 12)
	panel.add_child(vbox)

	var title := Label.new()
	title.text = "Ajustes"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 24)
	if typeof(RetrowaveTheme) != TYPE_NIL:
		RetrowaveTheme.style_title(title, RetrowaveTheme.CYAN)
	vbox.add_child(title)

	var lang_label := Label.new()
	lang_label.text = "Idioma"
	vbox.add_child(lang_label)

	# Botones de idioma (desde el sistema de localización si está disponible).
	if typeof(LanguageManager) != TYPE_NIL:
		var current := LanguageManager.get_current_language()
		for code in LanguageManager.get_available_languages():
			var b := Button.new()
			var name := LanguageManager.get_language_display_name(code)
			b.text = ("● " if code == current else "○ ") + name
			b.pressed.connect(func() -> void:
				LanguageManager.set_language(code)
				_refresh_language_buttons())
			b.set_meta("lang_code", code)
			b.name = "Lang_" + code
			if typeof(RetrowaveTheme) != TYPE_NIL:
				RetrowaveTheme.style_secondary_button(b)
			vbox.add_child(b)
	else:
		var na := Label.new()
		na.text = "(Sistema de idioma no disponible)"
		vbox.add_child(na)

	var diff_label := Label.new()
	diff_label.text = "Dificultad de la IA"
	vbox.add_child(diff_label)

	if typeof(AIManager) != TYPE_NIL:
		for level in [AIManager.DIFF_FACIL, AIManager.DIFF_NORMAL, AIManager.DIFF_DIFICIL]:
			var db := Button.new()
			db.set_meta("diff_level", level)
			db.name = "Diff_" + str(level)
			db.pressed.connect(func() -> void:
				AIManager.set_difficulty(level)
				_refresh_difficulty_buttons())
			if typeof(RetrowaveTheme) != TYPE_NIL:
				RetrowaveTheme.style_secondary_button(db)
			vbox.add_child(db)
		_refresh_difficulty_buttons()
	else:
		var na_ai := Label.new()
		na_ai.text = "(Sistema de IA no disponible)"
		vbox.add_child(na_ai)

	var note := Label.new()
	note.text = "Audio y gráficos: pendientes (no hay assets aún)."
	note.add_theme_font_size_override("font_size", 12)
	vbox.add_child(note)

	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(spacer)

	var close := Button.new()
	close.text = "Cerrar"
	close.custom_minimum_size = Vector2(0, 40)
	close.pressed.connect(queue_free)
	if typeof(RetrowaveTheme) != TYPE_NIL:
		RetrowaveTheme.style_secondary_button(close)
	vbox.add_child(close)


func _refresh_language_buttons() -> void:
	if typeof(LanguageManager) == TYPE_NIL:
		return
	var current := LanguageManager.get_current_language()
	for child in find_children("Lang_*", "Button", true, false):
		var code := str(child.get_meta("lang_code", ""))
		child.text = ("● " if code == current else "○ ") + LanguageManager.get_language_display_name(code)


func _refresh_difficulty_buttons() -> void:
	if typeof(AIManager) == TYPE_NIL:
		return
	var current := AIManager.get_difficulty()
	for child in find_children("Diff_*", "Button", true, false):
		var level := int(child.get_meta("diff_level", AIManager.DIFF_NORMAL))
		child.text = ("● " if level == current else "○ ") + _diff_name(level)


func _diff_name(level: int) -> String:
	if typeof(AIManager) != TYPE_NIL:
		if level == AIManager.DIFF_FACIL:
			return "Fácil"
		if level == AIManager.DIFF_DIFICIL:
			return "Difícil"
	return "Normal"
