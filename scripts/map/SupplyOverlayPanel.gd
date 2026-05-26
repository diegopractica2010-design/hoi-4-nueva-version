class_name SupplyOverlayPanel
extends Panel

## Preview panel for supply reroutes: ETA and interdiction.

@export var title_label: Label
@export var body_label: RichTextLabel
@export var btn_commit: Button
@export var btn_clear: Button
@export var btn_close: Button

var _on_commit: Callable = Callable()
var _on_clear: Callable = Callable()
var _on_close: Callable = Callable()


func _ready() -> void:
	visible = false
	if btn_commit and not btn_commit.pressed.is_connected(_emit_commit):
		btn_commit.pressed.connect(_emit_commit)
	if btn_clear and not btn_clear.pressed.is_connected(_emit_clear):
		btn_clear.pressed.connect(_emit_clear)
	if btn_close and not btn_close.pressed.is_connected(_emit_close):
		btn_close.pressed.connect(_emit_close)


func show_plan(
	plan: SupplyRoutePlan,
	reroute_mode: bool,
	province: Province = null,
	player_tag: String = "",
	top_depots_text: String = "",
) -> void:
	visible = true
	if title_label and plan != null:
		var hops := plan.path_length()
		var stats := "reinf ×%.2f · %.0f%% interdict" % [
			plan.reinforcement_modifier, plan.interdiction_chance * 100.0,
		]
		if reroute_mode:
			title_label.text = "⟳ Reroute preview"
		else:
			title_label.text = "⛟ Supply route"
		if hops > 0:
			title_label.text += " · %d hops" % hops
		title_label.text += " · " + stats
	if body_label:
		body_label.bbcode_enabled = true
		body_label.scroll_active = true
		body_label.fit_content = false
		var top := top_depots_text
		if not top.is_empty():
			top = "Top depots\n" + top
		body_label.text = ProvinceInsight.build_supply_overlay_bbcode(
			plan, province, player_tag, top,
		)


func hide_panel() -> void:
	visible = false


func set_callbacks(on_commit: Callable, on_clear: Callable, on_close: Callable) -> void:
	_on_commit = on_commit
	_on_clear = on_clear
	_on_close = on_close


func _emit_commit() -> void:
	if _on_commit.is_valid():
		_on_commit.call()


func _emit_clear() -> void:
	if _on_clear.is_valid():
		_on_clear.call()


func _emit_close() -> void:
	if _on_close.is_valid():
		_on_close.call()
