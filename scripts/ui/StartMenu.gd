class_name StartMenu
extends Control

## Menú principal de inicio del juego (escena de arranque).
## Opciones: Nueva Partida, Cargar partida, Ajustes, Salir.

const GAME_SCENE := "res://scenes/TestScenario.tscn"
const NATION_SELECT_SCENE := "res://scenes/ui/NationSelectScreen.tscn"


func _ready() -> void:
	_build_ui()


func _build_ui() -> void:
	var bg := ColorRect.new()
	bg.color = Color(0.05, 0.05, 0.09)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 14)
	vbox.custom_minimum_size = Vector2(420, 0)
	center.add_child(vbox)

	var title := Label.new()
	title.text = "EPOCHS OF ASCENDANCY"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 34)
	vbox.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "Guerra del Pacífico — 1879"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 16)
	vbox.add_child(subtitle)

	if typeof(RetrowaveTheme) != TYPE_NIL:
		RetrowaveTheme.style_title(title, RetrowaveTheme.CYAN)
		RetrowaveTheme.style_title(subtitle, RetrowaveTheme.MAGENTA)

	var spacer := Control.new()
	spacer.custom_minimum_size.y = 18
	vbox.add_child(spacer)

	vbox.add_child(_make_button("Nueva Partida", _on_new_game))
	var has_saves := typeof(SaveLoadManager) != TYPE_NIL and not SaveLoadManager.list_saves().is_empty()
	var load_btn := _make_button("Cargar partida", _on_load_game)
	load_btn.disabled = not has_saves
	vbox.add_child(load_btn)
	vbox.add_child(_make_button("Ajustes", _on_settings))
	vbox.add_child(_make_button("Salir", _on_quit))


func _make_button(text: String, handler: Callable) -> Button:
	var b := Button.new()
	b.text = text
	b.custom_minimum_size = Vector2(0, 46)
	b.pressed.connect(handler)
	if typeof(RetrowaveTheme) != TYPE_NIL:
		RetrowaveTheme.style_secondary_button(b)
	return b


func _on_new_game() -> void:
	NationSelectScreen.selected_tag = ""
	get_tree().change_scene_to_file(NATION_SELECT_SCENE)


func _on_load_game() -> void:
	if typeof(SaveLoadManager) == TYPE_NIL:
		return
	var saves := SaveLoadManager.list_saves()
	if saves.is_empty():
		return
	# Cargar la partida más reciente (list_saves ya viene ordenada por fecha desc).
	var slot := str(saves[0].get("slot", ""))
	var meta: Dictionary = saves[0].get("metadata", {})
	var tag := str(meta.get("player_tag", "CHL")).strip_edges().to_upper()
	if tag.is_empty():
		tag = "CHL"
	# Fijar nación (para saltar la selección) y dejar la carga pendiente para TestRunner.
	NationSelectScreen.selected_tag = tag
	SaveLoadManager.pending_load_slot = slot
	get_tree().change_scene_to_file(GAME_SCENE)


func _on_settings() -> void:
	var settings := preload("res://scenes/ui/SettingsPopup.tscn").instantiate()
	add_child(settings)


func _on_quit() -> void:
	get_tree().quit()
