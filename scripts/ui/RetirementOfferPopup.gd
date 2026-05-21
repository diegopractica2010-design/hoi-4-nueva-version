# scripts/ui/RetirementOfferPopup.gd
class_name RetirementOfferPopup
extends Window

signal retirement_resolved(leader_id: String, let_retire: bool, asked_to_stay: bool)

@export var leader_id: String = ""

@onready var title_label: Label = $MarginContainer/VBoxContainer/TitleLabel
@onready var leader_name_label: Label = $MarginContainer/VBoxContainer/LeaderNameLabel
@onready var body_label: Label = $MarginContainer/VBoxContainer/BodyLabel
@onready var honors_label: Label = $MarginContainer/VBoxContainer/HonorsLabel
@onready var stay_button: Button = $MarginContainer/VBoxContainer/ButtonRow/StayButton
@onready var retire_button: Button = $MarginContainer/VBoxContainer/ButtonRow/RetireButton


func _ready() -> void:
	visible = false
	unresizable = true
	close_requested.connect(_on_close_blocked)
	RetrowaveTheme.style_popup_root(self)
	RetrowaveTheme.style_title(title_label, RetrowaveTheme.MAGENTA)
	RetrowaveTheme.style_column_header(leader_name_label)
	RetrowaveTheme.style_body_label(body_label)
	RetrowaveTheme.style_body_label(honors_label)
	RetrowaveTheme.style_primary_button(stay_button)
	RetrowaveTheme.style_secondary_button(retire_button)

	stay_button.pressed.connect(_on_stay_pressed)
	retire_button.pressed.connect(_on_retire_pressed)
	_populate_from_leader()
	call_deferred("_present_popup")


func _on_close_blocked() -> void:
	# Require an explicit choice — retirement is pending until resolved.
	pass


func _present_popup() -> void:
	if not is_inside_tree():
		return
	popup_centered()
	visible = true


func _populate_from_leader() -> void:
	var summary := LeaderManager.get_leader_summary(leader_id)
	if summary.is_empty():
		leader_name_label.text = "Unknown Commander"
		body_label.text = "This leader is considering retirement."
		return

	var leader_name: String = str(summary.get("name", "Unknown"))
	var age := int(summary.get("age", 0))
	var xp := int(summary.get("experience", 0))
	var battles := int(summary.get("battles_fought", 0))
	leader_name_label.text = leader_name
	title = "%s — Retirement" % leader_name
	title_label.text = "Considering Retirement"

	var trait_lines: PackedStringArray = []
	for entry in summary.get("trait_display", []) as Array:
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		var row := entry as Dictionary
		trait_lines.append(
			"%s %s" % [row.get("name", ""), row.get("roman", "")]
		)

	body_label.text = (
		"%s has served with distinction and is considering stepping down.\n\n"
		% leader_name
		+ "Age: %d | Experience: %d | Battles: %d\n" % [age, xp, battles]
		+ ("Traits: %s" % ", ".join(trait_lines) if not trait_lines.is_empty() else "")
	)

	honors_label.text = (
		"Retire with honors: +%.0f prestige, +%.0f national unity."
		% [
			LeaderManager.RETIREMENT_HONORS_PRESTIGE,
			LeaderManager.RETIREMENT_HONORS_UNITY,
		]
	)


func _on_retire_pressed() -> void:
	_finish(true, false)


func _on_stay_pressed() -> void:
	_finish(false, true)


func _finish(let_retire: bool, asked_to_stay: bool) -> void:
	retirement_resolved.emit(leader_id, let_retire, asked_to_stay)
	queue_free()


static func open_for_leader(target_leader_id: String) -> RetirementOfferPopup:
	var scene: PackedScene = load("res://scenes/ui/RetirementOfferPopup.tscn")
	if scene == null:
		push_warning("RetirementOfferPopup.tscn not found")
		return null

	var popup: RetirementOfferPopup = scene.instantiate() as RetirementOfferPopup
	if popup == null:
		return null

	popup.leader_id = target_leader_id
	var tree := Engine.get_main_loop() as SceneTree
	if tree == null or tree.root == null:
		popup.queue_free()
		return null
	tree.root.add_child(popup)
	return popup
