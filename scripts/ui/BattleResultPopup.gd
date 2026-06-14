class_name BattleResultPopup
extends Control

## Popup que muestra el resultado de una batalla.
## Se ubica en la esquina superior derecha, se auto-descarta tras 4 segundos
## o al hacer clic en "Continuar".

var _dismiss_timer: float = 0.0
var AUTO_DISMISS_SECONDS: float = 4.0
var _showing: bool = false

@onready var _panel: PanelContainer = $Panel
@onready var _province_label: Label = $Panel/VBoxContainer/ProvinceLabel
@onready var _attacker_label: Label = $Panel/VBoxContainer/AttackerLabel
@onready var _defender_label: Label = $Panel/VBoxContainer/DefenderLabel
@onready var _winner_label: Label = $Panel/VBoxContainer/WinnerLabel
@onready var _casualties_label: Label = $Panel/VBoxContainer/CasualtiesLabel
@onready var _timer_label: Label = $Panel/VBoxContainer/HBoxContainer/TimerLabel
@onready var _continue_button: Button = $Panel/VBoxContainer/HBoxContainer/ContinueButton


func _ready() -> void:
	visible = false
	if typeof(BattleManager) != TYPE_NIL:
		if not BattleManager.battle_resolved.is_connected(_on_battle_resolved):
			BattleManager.battle_resolved.connect(_on_battle_resolved)


func _on_battle_resolved(province_id: int, winner_tag: String, loser_tag: String, result: Dictionary) -> void:
	_showing = true
	_dismiss_timer = AUTO_DISMISS_SECONDS

	# Obtener nombre de provincia desde provinces_base si es posible
	var province_name = result.get("province_name", "")
	if province_name.is_empty():
		province_name = "Provincia %d" % province_id

	_province_label.text = "⚔ Batalla: " + province_name
	_attacker_label.text = "Atacante: %s (Poder: %.1f)" % [result.get("attacker_tag", "?"), result.get("attacker_power", 0.0)]
	_defender_label.text = "Defensor: %s (Poder: %.1f)" % [result.get("defender_tag", "?"), result.get("defender_power", 0.0)]

	var att_cas: int = int(result.get("attacker_casualties", 0))
	var def_cas: int = int(result.get("defender_casualties", 0))
	_winner_label.text = "VICTORIA: " + winner_tag
	_casualties_label.text = "Bajas: Atacante %d | Defensor %d" % [att_cas, def_cas]

	# Colorear el label del ganador según si el jugador ganó o perdió
	var win_color := Color.GREEN if winner_tag == result.get("attacker_tag") else Color.RED
	_winner_label.add_theme_color_override("font_color", win_color)

	visible = true


func _process(delta: float) -> void:
	if not _showing:
		return
	_dismiss_timer -= delta
	_timer_label.text = "%.1f" % max(0.0, _dismiss_timer)
	if _dismiss_timer <= 0.0:
		_dismiss()


func _dismiss() -> void:
	_showing = false
	visible = false


func _on_continue_pressed() -> void:
	_dismiss()