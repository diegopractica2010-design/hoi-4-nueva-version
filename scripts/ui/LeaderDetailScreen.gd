# scripts/ui/LeaderDetailScreen.gd
class_name LeaderDetailScreen
extends DraggablePanel

const XP_HIGHLIGHT_COLOR := Color(0.4, 0.9, 0.6)

@export var leader_id: String = ""

@onready var name_label: Label = $MarginContainer/VBoxContainer/Header/InfoVBox/NameLabel
@onready var age_assignment_label: Label = (
	$MarginContainer/VBoxContainer/Header/InfoVBox/AgeAssignmentLabel
)
@onready var skills_label: Label = $MarginContainer/VBoxContainer/Header/InfoVBox/SkillsLabel
@onready var xp_label: Label = $MarginContainer/VBoxContainer/Header/InfoVBox/XPLabel

@onready var current_traits_list: VBoxContainer = (
	$MarginContainer/VBoxContainer/CurrentTraitsSection/TraitsScroll/TraitsList
)
@onready var level_up_list: VBoxContainer = (
	$MarginContainer/VBoxContainer/LevelUpSection/LevelUpScroll/LevelUpList
)
@onready var potential_traits_list: VBoxContainer = (
	$MarginContainer/VBoxContainer/PotentialTraitsSection/PotentialScroll/PotentialTraitsList
)
@onready var close_button: Button = $MarginContainer/VBoxContainer/Footer/CloseButton

@onready var _section_headers: Array[Label] = [
	$MarginContainer/VBoxContainer/CurrentTraitsSection/SectionHeader,
	$MarginContainer/VBoxContainer/LevelUpSection/SectionHeader,
	$MarginContainer/VBoxContainer/PotentialTraitsSection/SectionHeader,
]

var current_leader: Leader


static func open(parent: Node, id: String) -> LeaderDetailScreen:
	var scene: PackedScene = load("res://scenes/ui/LeaderDetailScreen.tscn") as PackedScene
	if scene == null:
		push_warning("LeaderDetailScreen.tscn not found")
		return null
	var screen: LeaderDetailScreen = scene.instantiate() as LeaderDetailScreen
	if screen == null:
		return null
	screen.leader_id = id
	screen.z_index = 100
	parent.add_child(screen)
	return screen


func _ready() -> void:
	drag_handle = $MarginContainer/VBoxContainer/Header
	super._ready()

	if leader_id.is_empty():
		push_error("LeaderDetailScreen opened without a leader_id")
		queue_free()
		return

	current_leader = LeaderManager.get_leader(leader_id)
	if current_leader == null:
		push_error("Leader not found: %s" % leader_id)
		queue_free()
		return

	_apply_theme()
	close_button.pressed.connect(_on_close_pressed)
	if not LeaderManager.trait_leveled.is_connected(_on_trait_leveled):
		LeaderManager.trait_leveled.connect(_on_trait_leveled)
	refresh_screen()


func _exit_tree() -> void:
	if typeof(LeaderManager) != TYPE_NIL and LeaderManager.trait_leveled.is_connected(_on_trait_leveled):
		LeaderManager.trait_leveled.disconnect(_on_trait_leveled)


func _on_close_pressed() -> void:
	queue_free()


func _on_trait_leveled(leveled_leader_id: String, _trait_id: String, _new_level: int) -> void:
	if leveled_leader_id == leader_id:
		refresh_screen()


func refresh_screen() -> void:
	if current_leader == null:
		current_leader = LeaderManager.get_leader(leader_id)
	if current_leader == null:
		return
	_update_header()
	_populate_current_traits()
	_populate_level_up_options()
	_populate_potential_traits()


func _apply_theme() -> void:
	RetrowaveTheme.style_production_screen(self)
	RetrowaveTheme.style_title(name_label, RetrowaveTheme.CYAN)
	RetrowaveTheme.style_body_label(age_assignment_label)
	RetrowaveTheme.style_body_label(skills_label)
	RetrowaveTheme.style_secondary_button(close_button)
	for header in _section_headers:
		_style_section_header(header)


func _style_section_header(label: Label) -> void:
	label.add_theme_font_size_override("font_size", 14)
	label.add_theme_color_override("font_color", RetrowaveTheme.CYAN)


func _update_header() -> void:
	name_label.text = current_leader.name
	name_label.add_theme_font_size_override("font_size", 22)

	var assignment_text := "Unassigned"
	if not current_leader.assigned_army_id.is_empty():
		assignment_text = current_leader.assigned_army_id

	age_assignment_label.text = "Age: %d   |   Assignment: %s" % [
		LeaderManager.get_leader_age(current_leader),
		assignment_text,
	]

	skills_label.text = "Atk %d  Def %d  Log %d  Plan %d  Init %d" % [
		current_leader.attack_skill,
		current_leader.defense_skill,
		current_leader.logistics_skill,
		current_leader.planning_skill,
		current_leader.initiative_skill,
	]
	skills_label.modulate = Color(0.8, 0.8, 0.85)

	xp_label.text = "XP: %d" % current_leader.experience
	xp_label.add_theme_font_size_override("font_size", 16)
	xp_label.add_theme_color_override("font_color", XP_HIGHLIGHT_COLOR)


func _populate_current_traits() -> void:
	_clear_children(current_traits_list)

	var traits_data := LeaderManager.get_leader_trait_display_data(leader_id)
	if traits_data.is_empty():
		_add_note_label(current_traits_list, "No traits yet.")
		return

	for trait in traits_data:
		var vbox := VBoxContainer.new()
		vbox.add_theme_constant_override("separation", 2)

		var header := Label.new()
		header.text = "%s %s  —  Level %d" % [
			trait.get("name", trait.get("trait_id", "")),
			_get_rarity_tag(str(trait.get("rarity", "common"))),
			int(trait.get("level", 1)),
		]
		header.add_theme_font_size_override("font_size", 15)
		RetrowaveTheme.style_column_header(header)
		vbox.add_child(header)

		var effects: Dictionary = trait.get("effects", {}) as Dictionary
		if not effects.is_empty():
			var effects_label := Label.new()
			effects_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			effects_label.text = _format_trait_effects(effects)
			effects_label.add_theme_font_size_override("font_size", 12)
			effects_label.modulate = Color(0.75, 0.75, 0.75)
			vbox.add_child(effects_label)

		current_traits_list.add_child(vbox)


func _populate_level_up_options() -> void:
	_clear_children(level_up_list)

	var traits_data := LeaderManager.get_leader_trait_display_data(leader_id)
	var any_option := false
	for trait in traits_data:
		if bool(trait.get("can_level_up", false)):
			any_option = true
			level_up_list.add_child(_create_level_up_row(trait))

	if not any_option:
		_add_note_label(level_up_list, "No traits available to level up.")


func _create_level_up_row(trait: Dictionary) -> HBoxContainer:
	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 12)

	var name_lbl := Label.new()
	name_lbl.text = "%s (Level %d → %d)" % [
		trait.get("name", trait.get("trait_id", "")),
		int(trait.get("level", 1)),
		int(trait.get("level", 1)) + 1,
	]
	name_lbl.custom_minimum_size = Vector2(260, 0)
	RetrowaveTheme.style_row_label(name_lbl)
	hbox.add_child(name_lbl)

	var cost_lbl := Label.new()
	cost_lbl.text = "%d XP" % int(trait.get("level_up_cost", 0))
	cost_lbl.modulate = XP_HIGHLIGHT_COLOR
	hbox.add_child(cost_lbl)

	var level_btn := Button.new()
	level_btn.text = "Level Up"
	RetrowaveTheme.style_primary_button(level_btn)
	level_btn.disabled = current_leader.experience < int(trait.get("level_up_cost", 0))
	level_btn.pressed.connect(_on_level_up_pressed.bind(str(trait.get("trait_id", ""))))
	hbox.add_child(level_btn)

	return hbox


func _populate_potential_traits() -> void:
	_clear_children(potential_traits_list)

	var potential := LeaderManager.get_potential_traits_for_leader(leader_id)
	if potential.is_empty():
		_add_note_label(potential_traits_list, "No additional traits previewed for this leader.")
		return

	for trait in potential:
		var hbox := HBoxContainer.new()
		hbox.add_theme_constant_override("separation", 8)

		var label := Label.new()
		label.text = "%s %s" % [
			trait.get("name", trait.get("trait_id", "")),
			_get_rarity_tag(str(trait.get("rarity", "common"))),
		]
		label.modulate = Color(0.55, 0.55, 0.55)
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		RetrowaveTheme.style_row_label(label)
		hbox.add_child(label)

		var info_btn := Button.new()
		info_btn.text = "?"
		info_btn.tooltip_text = str(trait.get("unlock_reason", ""))
		info_btn.custom_minimum_size = Vector2(28, 28)
		RetrowaveTheme.style_secondary_button(info_btn)
		hbox.add_child(info_btn)

		potential_traits_list.add_child(hbox)


func _on_level_up_pressed(trait_id: String) -> void:
	if LeaderManager.level_trait(leader_id, trait_id):
		refresh_screen()
	else:
		push_warning("Could not level trait %s for %s" % [trait_id, leader_id])


func _get_rarity_tag(rarity: String) -> String:
	match rarity:
		"legendary": return "[Legendary]"
		"rare": return "[Rare]"
		"notable": return "[Notable]"
		_: return ""


func _clear_children(container: Node) -> void:
	for child in container.get_children():
		child.queue_free()


func _add_note_label(container: VBoxContainer, text: String) -> void:
	var note := Label.new()
	note.text = text
	note.modulate = Color(0.7, 0.7, 0.75)
	RetrowaveTheme.style_body_label(note)
	container.add_child(note)


func _format_trait_effects(effects: Dictionary) -> String:
	if effects.is_empty():
		return ""

	var parts: Array[String] = []
	for key in effects.keys():
		var formatted := _format_effect_key(str(key), effects[key])
		if not formatted.is_empty():
			parts.append(formatted)

	return "→  " + "   |   ".join(parts)


func _format_effect_key(key: String, value: Variant) -> String:
	var num := float(value)
	match key:
		"attack":
			return "%+d Attack" % int(num) if num != 0.0 else ""
		"defense":
			return "%+d Defense" % int(num) if num != 0.0 else ""
		"logistics":
			return "%+d Logistics" % int(num) if num != 0.0 else ""
		"planning":
			return "%+d Planning" % int(num) if num != 0.0 else ""
		"initiative":
			return "%+d Initiative" % int(num) if num != 0.0 else ""
		"organization":
			return "%+d Organization" % int(num) if num != 0.0 else ""
		"supply_consumption":
			if num < 0.0:
				return "%d%% Supply Use" % int(num * 100.0)
			return "+%d%% Supply Use" % int(num * 100.0)
		"breakthrough":
			return "%+.0f%% Breakthrough" % (num * 100.0)
		"armor_attack":
			return "%+.0f%% Armor Attack" % (num * 100.0)
		"desert_attack":
			return "%+.0f%% Desert Attack" % (num * 100.0)
		"desert_defense":
			return "%+.0f%% Desert Defense" % (num * 100.0)
		"organization_recovery":
			return "%+.0f%% Org Recovery" % (num * 100.0)
		"casualties":
			return "%+.0f%% Casualties" % (num * 100.0)
		_:
			return "%s: %s" % [key.replace("_", " ").capitalize(), str(value)]
