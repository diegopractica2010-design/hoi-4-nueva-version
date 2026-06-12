class_name EventPopup
extends Control

var _event_queue: Array = []
var _showing: bool = false

@onready var _title_label: Label = $Card/VBoxContainer/TitleLabel
@onready var _description_label: Label = $Card/VBoxContainer/ScrollContainer/DescriptionLabel
@onready var _effects_label: Label = $Card/VBoxContainer/EffectsLabel


func _ready() -> void:
	visible = false
	if typeof(EventManager) != TYPE_NIL:
		if not EventManager.event_triggered.is_connected(_on_event_triggered):
			EventManager.event_triggered.connect(_on_event_triggered)


func _on_event_triggered(event_data: Dictionary) -> void:
	_event_queue.append(event_data)
	if not _showing:
		_show_next_event()


func _show_next_event() -> void:
	if _event_queue.is_empty():
		_showing = false
		visible = false
		if typeof(TimeManager) != TYPE_NIL:
			TimeManager.set_paused(false)
		return

	_showing = true
	var event: Dictionary = _event_queue.pop_front() as Dictionary

	if typeof(TimeManager) != TYPE_NIL:
		TimeManager.set_paused(true)

	_title_label.text = str(event.get("name", "Evento Historico"))
	_description_label.text = str(event.get("description", ""))
	_effects_label.text = _build_effects_text(event.get("effects", []) as Array)

	visible = true


func _build_effects_text(effects: Array) -> String:
	var effects_text := ""
	for effect_variant in effects:
		if typeof(effect_variant) != TYPE_DICTIONARY:
			continue

		var effect: Dictionary = effect_variant as Dictionary
		match str(effect.get("type", "")):
			"declare_war":
				effects_text += "Guerra declarada: %s vs %s\n" % [
					effect.get("attacker", ""),
					effect.get("defender", "")
				]
			"province_transfer":
				effects_text += "Provincia %d cambia de dueno\n" % int(effect.get("province_id", 0))
			"add_national_spirit":
				effects_text += "Espiritu nacional: %s\n" % str(effect.get("spirit_id", ""))
			"news_event":
				effects_text += "%s\n" % str(effect.get("text", ""))

	if effects_text.is_empty():
		effects_text = "Sin efectos inmediatos."
	return effects_text


func _on_continue_pressed() -> void:
	_show_next_event()
