extends Control

@onready var nation_list: ItemList = %NationList
@onready var relation_label: Label = %RelationLabel
@onready var status_label: Label = %StatusLabel
@onready var declare_war_btn: Button = %DeclareWarBtn
@onready var form_alliance_btn: Button = %FormAllianceBtn
@onready var give_guarantee_btn: Button = %GiveGuaranteeBtn
@onready var sign_peace_btn: Button = %SignPeaceBtn
@onready var close_btn: Button = %CloseBtn

var current_nation: String
var selected_target: String

signal diplomacy_closed()

func _ready() -> void:
	close_btn.pressed.connect(_on_close_pressed)
	nation_list.item_selected.connect(_on_nation_selected)
	declare_war_btn.pressed.connect(_on_declare_war_pressed)
	form_alliance_btn.pressed.connect(_on_form_alliance_pressed)
	give_guarantee_btn.pressed.connect(_on_give_guarantee_pressed)
	sign_peace_btn.pressed.connect(_on_sign_peace_pressed)
	_update_localization()

func open(nation: String) -> void:
	current_nation = nation
	show()
	_refresh_list()
	_update_info()

func close() -> void:
	hide()
	diplomacy_closed.emit()

func _refresh_list() -> void:
	nation_list.clear()
	if typeof(GameData) == TYPE_NIL or GameData.world == null:
		return
	for tag in GameData.world.tags:
		if tag != current_nation:
			nation_list.add_item(tag + " - " + GameData.world.get_country_name(tag))

func _on_nation_selected(index: int) -> void:
	var text: String = nation_list.get_item_text(index)
	selected_target = text.split(" - ")[0]
	_update_info()

func _update_info() -> void:
	if selected_target.is_empty():
		relation_label.text = ""
		status_label.text = ""
		declare_war_btn.disabled = true
		form_alliance_btn.disabled = true
		give_guarantee_btn.disabled = true
		sign_peace_btn.disabled = true
		return
	var rel = DiplomacyManager.get_relation(current_nation, selected_target)
	relation_label.text = "Relación: " + str(rel)
	var status = DiplomacyManager.get_status_between(current_nation, selected_target)
	status_label.text = "Estado: " + status
	declare_war_btn.disabled = (status == "war")
	form_alliance_btn.disabled = (status == "allied" or status == "war")
	give_guarantee_btn.disabled = DiplomacyManager.has_guarantee(current_nation, selected_target)
	sign_peace_btn.disabled = (status != "war")

func _on_declare_war_pressed() -> void:
	if selected_target.is_empty():
		return
	DiplomacyManager.declare_war(current_nation, selected_target)
	_update_info()

func _on_form_alliance_pressed() -> void:
	if selected_target.is_empty():
		return
	DiplomacyManager.form_alliance(current_nation, selected_target)
	_update_info()

func _on_give_guarantee_pressed() -> void:
	if selected_target.is_empty():
		return
	DiplomacyManager.give_guarantee(current_nation, selected_target)
	_update_info()

func _on_sign_peace_pressed() -> void:
	if selected_target.is_empty():
		return
	var at_war = DiplomacyManager.get_wars_for(current_nation)
	for w in at_war:
		if w.attacker == selected_target or w.defender == selected_target:
			DiplomacyManager.sign_peace(w.attacker, w.defender, current_nation)
			break
	_update_info()

func _on_close_pressed() -> void:
	close()

func _update_localization() -> void:
	declare_war_btn.text = "Declarar Guerra"
	form_alliance_btn.text = "Formar Alianza"
	give_guarantee_btn.text = "Garantizar"
	sign_peace_btn.text = "Firmar Paz"
	close_btn.text = "Cerrar"
