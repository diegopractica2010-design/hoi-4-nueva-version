extends Control

@onready var offers_list: ItemList = %OffersList
@onready var offer_detail_label: RichTextLabel = %OfferDetailLabel
@onready var accept_btn: Button = %AcceptBtn
@onready var reject_btn: Button = %RejectBtn
@onready var create_offer_btn: Button = %CreateOfferBtn
@onready var close_btn: Button = %CloseBtn
@onready var target_nation_option: OptionButton = %TargetNationOption
@onready var resource_type_option: OptionButton = %ResourceTypeOption
@onready var resource_quantity_spin: SpinBox = %ResourceQuantitySpin
@onready var create_form_btn: Button = %CreateFormBtn
@onready var create_panel: Panel = %CreatePanel
@onready var refresh_btn: Button = %RefreshBtn

var current_nation: String
var selected_offer_id: String
var cached_offers: Array = []

signal trade_screen_closed()

func _ready() -> void:
	close_btn.pressed.connect(_on_close_pressed)
	offers_list.item_selected.connect(_on_offer_selected)
	accept_btn.pressed.connect(_on_accept_pressed)
	reject_btn.pressed.connect(_on_reject_pressed)
	create_offer_btn.pressed.connect(_on_toggle_create_panel)
	create_form_btn.pressed.connect(_on_create_offer_pressed)
	refresh_btn.pressed.connect(_on_refresh_pressed)
	resource_type_option.add_item("Acero (Steel)", 0)
	resource_type_option.add_item("Caucho (Rubber)", 1)
	resource_type_option.add_item("Petróleo (Oil)", 2)
	resource_type_option.add_item("Aluminio (Aluminum)", 3)
	resource_type_option.add_item("Combustible (Fuel)", 4)
	_update_localization()

func open(nation: String) -> void:
	current_nation = nation
	show()
	_populate_target_nations()
	refresh_offers()

func close() -> void:
	hide()
	create_panel.hide()
	trade_screen_closed.emit()

func refresh_offers() -> void:
	cached_offers = []
	offers_list.clear()
	selected_offer_id = ""
	offer_detail_label.text = ""
	accept_btn.disabled = true
	reject_btn.disabled = true
	if typeof(TradeManager) == TYPE_NIL:
		return
	var raw_offers = TradeManager.get_offers_for_country(current_nation)
	for o in raw_offers:
		if o.get("status") != TradeStatus.PROPOSED:
			continue
		cached_offers.append(o)
		var label := _format_offer_summary(o)
		offers_list.add_item(label)
	if cached_offers.is_empty():
		offer_detail_label.text = "No hay ofertas activas"

func _format_offer_summary(offer: Dictionary) -> String:
	var from := str(offer.get("from_tag", "?"))
	var to := str(offer.get("to_tag", "?"))
	var offered_count := (offer.get("offered", []) as Array).size()
	var requested_count := (offer.get("requested", []) as Array).size()
	var vis := offer.get("visibility", "PUBLIC")
	return from + " → " + to + " | Da: " + str(offered_count) + " · Pide: " + str(requested_count) + " [" + str(vis) + "]"

func _on_offer_selected(index: int) -> void:
	if index < 0 or index >= cached_offers.size():
		return
	var offer = cached_offers[index]
	selected_offer_id = str(offer.get("id", ""))
	var detail := "Oferta: " + str(offer.get("id", "")) + "\n"
	detail += "De: " + str(offer.get("from_tag", "")) + " → Para: " + str(offer.get("to_tag", "")) + "\n"
	detail += "Estado: " + str(offer.get("status", "")) + "\n"
	detail += "Visibilidad: " + str(offer.get("visibility", "")) + "\n\n"
	detail += "--- Ofrece ---\n"
	for item in offer.get("offered", []):
		detail += "  " + _format_item(item) + "\n"
	detail += "\n--- Solicita ---\n"
	for item in offer.get("requested", []):
		detail += "  " + _format_item(item) + "\n"
	var fairness := TradeManager.evaluate_fairness(selected_offer_id, current_nation)
	detail += "\nJusticia: " + str(fairness.get("score", 0.0))
	detail += "\n" + str(fairness.get("reason", ""))
	offer_detail_label.text = detail
	accept_btn.disabled = false
	reject_btn.disabled = false

func _format_item(item: Dictionary) -> String:
	var type := item.get("type", "?")
	var id := item.get("id", "?")
	var qty := item.get("quantity", 1)
	return str(type) + " " + str(id) + " x" + str(qty)

func _on_accept_pressed() -> void:
	if selected_offer_id.is_empty() or typeof(TradeManager) == TYPE_NIL:
		return
	if TradeManager.accept_offer(selected_offer_id):
		offer_detail_label.text = "✅ Oferta aceptada"
	else:
		push_error("TradeScreen: Failed to accept offer")
	refresh_offers()

func _on_reject_pressed() -> void:
	if selected_offer_id.is_empty() or typeof(TradeManager) == TYPE_NIL:
		return
	if TradeManager.reject_offer(selected_offer_id):
		offer_detail_label.text = "Oferta rechazada"
	refresh_offers()

func _on_toggle_create_panel() -> void:
	create_panel.visible = not create_panel.visible

func _on_create_offer_pressed() -> void:
	if typeof(TradeManager) == TYPE_NIL:
		return
	var target_idx := target_nation_option.selected
	if target_idx < 0:
		return
	var target_tag := target_nation_option.get_item_text(target_idx).split(" - ")[0]
	var resource_names := ["steel", "rubber", "oil", "aluminum", "fuel"]
	var resource_idx := resource_type_option.selected
	if resource_idx < 0:
		return
	var resource_id := resource_names[resource_idx]
	var quantity := resource_quantity_spin.value
	var offered := [{"type": TradeItemType.RESOURCE, "id": resource_id, "quantity": quantity}]
	var requested := [{"type": TradeItemType.RESOURCE, "id": "steel", "quantity": quantity * 0.8}]
	TradeManager.create_offer(current_nation, target_tag, offered, requested, TradeVisibility.PUBLIC)
	create_panel.hide()
	refresh_offers()

func _on_refresh_pressed() -> void:
	refresh_offers()

func _populate_target_nations() -> void:
	target_nation_option.clear()
	if typeof(GameData) == TYPE_NIL or GameData.world == null:
		return
	var idx := 0
	for tag in GameData.world.tags:
		if tag != current_nation:
			target_nation_option.add_item(tag + " - " + GameData.world.get_country_name(tag), idx)
			idx += 1

func _on_close_pressed() -> void:
	close()

func _update_localization() -> void:
	create_offer_btn.text = "Crear Oferta"
	refresh_btn.text = "Refrescar"
	accept_btn.text = "Aceptar"
	reject_btn.text = "Rechazar"
	close_btn.text = "Cerrar"
	create_form_btn.text = "Enviar Oferta"
