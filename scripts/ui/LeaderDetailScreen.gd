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
@onready var level_up_section: PanelContainer = $MarginContainer/VBoxContainer/LevelUpSection
@onready var level_up_list: VBoxContainer = (
	$MarginContainer/VBoxContainer/LevelUpSection/LevelUpInner/LevelUpScroll/LevelUpList
)
@onready var potential_traits_list: VBoxContainer = (
	$MarginContainer/VBoxContainer/PotentialTraitsSection/PotentialScroll/PotentialTraitsList
)
@onready var close_button: Button = $MarginContainer/VBoxContainer/Footer/CloseButton

@onready var _section_headers: Array[Label] = [
	$MarginContainer/VBoxContainer/CurrentTraitsSection/SectionHeader,
	$MarginContainer/VBoxContainer/LevelUpSection/LevelUpInner/SectionHeader,
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
	_style_level_up_section()


func _style_section_header(label: Label) -> void:
	label.add_theme_font_size_override("font_size", 14)
	label.add_theme_color_override("font_color", RetrowaveTheme.CYAN)


func _style_level_up_section() -> void:
	if level_up_section == null:
		return
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.12, 0.16, 0.22)
	style.border_color = Color(0.3, 0.7, 0.9, 0.3)
	style.set_border_width_all(1)
	style.set_corner_radius_all(6)
	style.set_content_margin_all(10)
	level_up_section.add_theme_stylebox_override("panel", style)


func _update_header() -> void:
	name_label.text = current_leader.name
	name_label.add_theme_font_size_override("font_size", 22)

	var age := 0
	if typeof(LeaderManager) != TYPE_NIL:
		age = LeaderManager.get_leader_age(current_leader)
	elif current_leader.birth_year > 0:
		age = maxi(1936 - current_leader.birth_year, 0)

	var assignment_text := "Unassigned"
	if not current_leader.assigned_army_id.is_empty():
		assignment_text = current_leader.assigned_army_id

	age_assignment_label.text = "Age: %d   |   Assignment: %s" % [age, assignment_text]

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

	for trait_entry in traits_data:
		var vbox := VBoxContainer.new()
		vbox.add_theme_constant_override("separation", 4)
		vbox.custom_minimum_size = Vector2(0, 52)

		var header := Label.new()
		header.text = "%s %s  —  Level %d" % [
			trait_entry.get("name", trait_entry.get("trait_id", "")),
			_get_rarity_tag(str(trait_entry.get("rarity", "common"))),
			int(trait_entry.get("level", 1)),
		]
		header.add_theme_font_size_override("font_size", 15)
		RetrowaveTheme.style_column_header(header)
		vbox.add_child(header)

		var effects: Dictionary = trait_entry.get("effects", {}) as Dictionary
		if not effects.is_empty():
			var effects_label := Label.new()
			effects_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			effects_label.text = _format_trait_effects_clean(effects)
			effects_label.add_theme_font_size_override("font_size", 12)
			effects_label.modulate = Color(0.8, 0.8, 0.8)
			vbox.add_child(effects_label)

		current_traits_list.add_child(vbox)


func _populate_level_up_options() -> void:
	_clear_children(level_up_list)

	var xp_header := Label.new()
	xp_header.text = "You have %d XP available to spend" % current_leader.experience
	xp_header.add_theme_font_size_override("font_size", 14)
	xp_header.modulate = Color(0.4, 0.95, 0.6)
	xp_header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	level_up_list.add_child(xp_header)

	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(0, 8)
	level_up_list.add_child(spacer)

	var traits_data := LeaderManager.get_leader_trait_display_data(leader_id)
	var has_options := false
	for trait_entry in traits_data:
		if bool(trait_entry.get("can_level_up", false)):
			has_options = true
			level_up_list.add_child(_create_level_up_row(trait_entry))

	if not has_options:
		var no_options := Label.new()
		no_options.text = "No traits can be leveled up right now."
		no_options.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		no_options.modulate = Color(0.6, 0.6, 0.6)
		RetrowaveTheme.style_body_label(no_options)
		level_up_list.add_child(no_options)


func _create_level_up_row(trait_entry: Dictionary) -> HBoxContainer:
	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 12)
	hbox.custom_minimum_size = Vector2(0, 52)

	var trait_id: String = str(trait_entry.get("trait_id", ""))
	var level := int(trait_entry.get("level", 1))
	var next_effects := _get_next_level_effects(trait_id, level)

	var info_vbox := VBoxContainer.new()
	info_vbox.add_theme_constant_override("separation", 2)
	info_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var name_label := Label.new()
	name_label.text = "%s (Level %d → %d)" % [
		trait_entry.get("name", trait_id),
		level,
		level + 1,
	]
	name_label.add_theme_font_size_override("font_size", 14)
	RetrowaveTheme.style_column_header(name_label)
	info_vbox.add_child(name_label)

	var current_effects: Dictionary = trait_entry.get("effects", {}) as Dictionary
	if not current_effects.is_empty():
		var current_label := Label.new()
		current_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		current_label.text = "Current: " + _format_trait_effects_clean(current_effects)
		current_label.add_theme_font_size_override("font_size", 11)
		current_label.modulate = Color(0.7, 0.7, 0.7)
		info_vbox.add_child(current_label)

	if not next_effects.is_empty():
		var next_label := Label.new()
		next_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		next_label.text = "Next Level: " + _format_trait_effects_clean(next_effects)
		next_label.add_theme_font_size_override("font_size", 11)
		next_label.modulate = XP_HIGHLIGHT_COLOR
		info_vbox.add_child(next_label)

	hbox.add_child(info_vbox)

	var action_vbox := VBoxContainer.new()
	action_vbox.alignment = BoxContainer.ALIGNMENT_CENTER

	var cost_label := Label.new()
	cost_label.text = "%d XP" % int(trait_entry.get("level_up_cost", 0))
	cost_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	cost_label.modulate = XP_HIGHLIGHT_COLOR
	action_vbox.add_child(cost_label)

	var level_btn := Button.new()
	level_btn.text = "Level Up"
	level_btn.custom_minimum_size = Vector2(90, 28)
	level_btn.tooltip_text = _build_level_up_tooltip(trait_entry, next_effects)
	RetrowaveTheme.style_primary_button(level_btn)
	level_btn.disabled = current_leader.experience < int(trait_entry.get("level_up_cost", 0))
	level_btn.pressed.connect(_on_level_up_pressed.bind(trait_id))
	action_vbox.add_child(level_btn)

	hbox.add_child(action_vbox)
	return hbox


func _populate_potential_traits() -> void:
	_clear_children(potential_traits_list)

	var potential := LeaderManager.get_potential_traits_for_leader(leader_id)
	if potential.is_empty():
		_add_note_label(potential_traits_list, "No additional traits previewed for this leader.")
		return

	for trait_entry in potential:
		var hbox := HBoxContainer.new()
		hbox.add_theme_constant_override("separation", 8)

		var label := Label.new()
		label.text = "%s %s" % [
			trait_entry.get("name", trait_entry.get("trait_id", "")),
			_get_rarity_tag(str(trait_entry.get("rarity", "common"))),
		]
		label.modulate = Color(0.55, 0.55, 0.55)
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		RetrowaveTheme.style_row_label(label)
		hbox.add_child(label)

		var info_btn := Button.new()
		info_btn.text = "?"
		info_btn.tooltip_text = str(trait_entry.get("unlock_reason", ""))
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


func _build_level_up_tooltip(trait_entry: Dictionary, next_effects: Dictionary) -> String:
	var trait_name := str(trait_entry.get("name", trait_entry.get("trait_id", "")))
	var level := int(trait_entry.get("level", 1))
	var cost := int(trait_entry.get("level_up_cost", 0))
	if next_effects.is_empty():
		return "%s: Level %d → %d\nCost: %d XP" % [trait_name, level, level + 1, cost]
	var bonus := _format_trait_effects_clean(next_effects).replace("→  ", "").strip_edges()
	return "Next Level Bonus:\n%s\n\nCost: %d XP" % [bonus, cost]


## Effects the trait would have at current_level + 1 (preview before spending XP).
func _get_next_level_effects(trait_id: String, current_level: int) -> Dictionary:
	if trait_id.is_empty() or typeof(LeaderManager) == TYPE_NIL:
		return {}
	return LeaderManager.get_trait_effects_at_level(trait_id, current_level + 1)


func _format_trait_effects_clean(effects: Dictionary) -> String:
	if effects.is_empty():
		return ""

	var parts: Array[String] = []
	for key in effects.keys():
		var text := _format_single_effect(str(key), effects[key])
		if not text.is_empty():
			parts.append(text)

	return "→  " + "   •   ".join(parts)


func _format_single_effect(key: String, value: Variant) -> String:
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
			var percent := int(num * 100.0)
			if percent < 0:
				return "%d%% Supply Use" % percent
			return "+%d%% Supply Use" % percent
		"breakthrough":
			return "%+.0f%% Breakthrough" % (num * 100.0)
		"armor_attack":
			return "%+.0f%% Armor Attack" % (num * 100.0)
		"combined_arms_sync":
			return "%+.0f%% Combined Arms Sync" % (num * 100.0)
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


func _format_trait_effects(effects: Dictionary) -> String:
	return _format_trait_effects_clean(effects)
