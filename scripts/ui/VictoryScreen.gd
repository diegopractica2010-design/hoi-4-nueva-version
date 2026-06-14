class_name VictoryScreen
extends Control

## Pantalla completa que se muestra al alcanzar una condición de victoria.
## Muestra ganador, fecha, resumen histórico y botón para volver al menú principal.


func _ready() -> void:
	visible = false
	if typeof(VictoryConditions) != TYPE_NIL:
		if not VictoryConditions.victory_achieved.is_connected(_on_victory_achieved):
			VictoryConditions.victory_achieved.connect(_on_victory_achieved)


func _on_victory_achieved(winner_tag: String, condition_name: String, description: String) -> void:
	visible = true

	# Pausar el juego
	if typeof(TimeManager) != TYPE_NIL:
		TimeManager.set_paused(true)

	# Nombre legible de la nación
	var nation_names := {"CHL": "Chile", "PER": "Perú", "BOL": "Bolivia"}
	var winner_name: String = str(nation_names.get(winner_tag, winner_tag))
	$CenterContainer/Panel/VBoxContainer/WinnerTitle.text = "¡" + winner_name + " ha ganado!"

	# Resumen histórico según el ganador
	var summaries := {
		"CHL": "Chile emerge victorioso de la Guerra del Pacífico. \
Las ricas provincias salitreras de Antofagasta y Tarapacá \
quedan bajo soberanía chilena. Bolivia pierde su salida al mar. \
La era del salitre comienza.",
		"PER": "Perú ha resistido la agresión chilena. \
La alianza entre Perú y Bolivia ha demostrado su fortaleza. \
Las provincias salitreras permanecen en manos aliadas.",
		"BOL": "Bolivia ha defendido su litoral. \
La salida al mar boliviana permanece intacta. \
La historia del Pacífico toma un rumbo diferente."
	}
	$CenterContainer/Panel/VBoxContainer/SummaryLabel.text = summaries.get(winner_tag, description)

	# Fecha final
	var date_str := "1879-02-14"
	if typeof(TimeManager) != TYPE_NIL:
		date_str = "%d-%02d-%02d" % [
			TimeManager.current_year,
			TimeManager.current_month,
			TimeManager.current_day
		]
	$CenterContainer/Panel/VBoxContainer/DateLabel.text = "Fecha final: " + date_str
	$CenterContainer/Panel/VBoxContainer/ConditionLabel.text = condition_name


func _on_main_menu_pressed() -> void:
	if typeof(TimeManager) != TYPE_NIL:
		TimeManager.set_paused(false)
	# Reiniciar: volver a la pantalla de selección de nación (nueva partida).
	NationSelectScreen.selected_tag = ""
	get_tree().change_scene_to_file("res://scenes/ui/NationSelectScreen.tscn")