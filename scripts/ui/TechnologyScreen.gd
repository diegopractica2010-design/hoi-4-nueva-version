# scripts/ui/TechnologyScreen.gd
class_name TechnologyScreen
extends DraggablePanel

@export var country_tag: String = "USA"

@onready var title_label: Label = $TitleBar/TitleLabel
@onready var close_button: Button = $TitleBar/CloseButton
@onready var slots_label: Label = $MarginContainer/VBoxContainer/SummaryBar/SlotsLabel
@onready var rp_label: Label = $MarginContainer/VBoxContainer/SummaryBar/RpLabel
@onready var year_label: Label = $MarginContainer/VBoxContainer/SummaryBar/YearLabel
@onready var available_label: Label = $MarginContainer/VBoxContainer/SummaryBar/AvailableLabel
@onready var completed_label: Label = $MarginContainer/VBoxContainer/SummaryBar/CompletedLabel
@onready var compromised_label: Label = $MarginContainer/VBoxContainer/SummaryBar/CompromisedLabel
@onready var agent_summary_label: Label = $MarginContainer/VBoxContainer/AgentBar/AgentSummaryLabel
@onready var open_agents_button: Button = $MarginContainer/VBoxContainer/AgentBar/OpenAgentsButton
@onready var active_research_label: Label = (
	$MarginContainer/VBoxContainer/ActiveBar/ActiveResearchLabel
)
@onready var domain_filter: OptionButton = $MarginContainer/VBoxContainer/ToolRow/DomainFilter
@onready var view_mode_filter: OptionButton = $MarginContainer/VBoxContainer/ToolRow/ViewModeFilter
@onready var era_slider: HSlider = $MarginContainer/VBoxContainer/ToolRow/EraSlider
@onready var era_value_label: Label = $MarginContainer/VBoxContainer/ToolRow/EraValueLabel
@onready var reset_view_button: Button = $MarginContainer/VBoxContainer/ToolRow/ResetViewButton
@onready var list_scroll: ScrollContainer = $MarginContainer/VBoxContainer/BodyRow/MainColumn/ListScroll
@onready var research_list: VBoxContainer = (
	$MarginContainer/VBoxContainer/BodyRow/MainColumn/ListScroll/ResearchList
)
@onready var graph_view: TechnologyGraphView = (
	$MarginContainer/VBoxContainer/BodyRow/MainColumn/TechnologyGraphView
)
@onready var doctrine_panel: PanelContainer = (
	$MarginContainer/VBoxContainer/BodyRow/MainColumn/DoctrinePanel
)
@onready var doctrine_header: Label = (
	$MarginContainer/VBoxContainer/BodyRow/MainColumn/DoctrinePanel/DoctrineMargin/DoctrineVBox/DoctrineHeader
)
@onready var doctrine_xp_label: Label = (
	$MarginContainer/VBoxContainer/BodyRow/MainColumn/DoctrinePanel/DoctrineMargin/DoctrineVBox/DoctrineXpLabel
)
@onready var open_training_button: Button = (
	$MarginContainer/VBoxContainer/BodyRow/MainColumn/DoctrinePanel/DoctrineMargin/DoctrineVBox/OpenTrainingButton
)
@onready var doctrine_list: VBoxContainer = (
	$MarginContainer/VBoxContainer/BodyRow/MainColumn/DoctrinePanel/DoctrineMargin/DoctrineVBox/DoctrineScroll/DoctrineList
)
@onready var inspector_panel: PanelContainer = $MarginContainer/VBoxContainer/BodyRow/InspectorPanel
@onready var inspector_title: Label = (
	$MarginContainer/VBoxContainer/BodyRow/InspectorPanel/InspectorMargin/InspectorVBox/InspectorTitle
)
@onready var inspector_body: Label = (
	$MarginContainer/VBoxContainer/BodyRow/InspectorPanel/InspectorMargin/InspectorVBox/InspectorBody
)
@onready var research_button: Button = (
	$MarginContainer/VBoxContainer/BodyRow/InspectorPanel/InspectorMargin/InspectorVBox/InspectorActions/ResearchButton
)
@onready var cancel_button: Button = (
	$MarginContainer/VBoxContainer/BodyRow/InspectorPanel/InspectorMargin/InspectorVBox/InspectorActions/CancelButton
)

var current_data: TechnologyScreenData
var _selected_tech_id: String = ""
var _domain_filter_id: String = "all"
var _view_mode: String = "list"
var _era_filter_key: String = "all"
var _domain_filter_ready: bool = false
var _view_mode_ready: bool = false


func _ready() -> void:
	add_to_group("technology_screen")
	drag_handle = $TitleBar
	super._ready()
	close_button.pressed.connect(_on_close_pressed)
	research_button.pressed.connect(_on_research_pressed)
	cancel_button.pressed.connect(_on_cancel_pressed)
	domain_filter.item_selected.connect(_on_domain_changed)
	view_mode_filter.item_selected.connect(_on_view_mode_changed)
	era_slider.value_changed.connect(_on_era_slider_changed)
	reset_view_button.pressed.connect(_on_reset_view_pressed)
	open_training_button.pressed.connect(_on_open_training_pressed)
	open_agents_button.pressed.connect(_on_open_agents_pressed)
	if graph_view:
		graph_view.node_selected.connect(_on_graph_node_selected)
	_apply_screen_theme()
	_connect_manager_signals()
	_setup_era_slider()
	_setup_view_mode_filter()
	_setup_domain_filter()
	refresh_screen()


func _exit_tree() -> void:
	if typeof(TechnologyManager) == TYPE_NIL:
		return
	if TechnologyManager.research_state_changed.is_connected(_on_research_state_changed):
		TechnologyManager.research_state_changed.disconnect(_on_research_state_changed)
	if TechnologyManager.agent_tech_state_changed.is_connected(_on_research_state_changed):
		TechnologyManager.agent_tech_state_changed.disconnect(_on_research_state_changed)


func _connect_manager_signals() -> void:
	if typeof(TechnologyManager) == TYPE_NIL:
		return
	if not TechnologyManager.research_state_changed.is_connected(_on_research_state_changed):
		TechnologyManager.research_state_changed.connect(_on_research_state_changed)
	if not TechnologyManager.agent_tech_state_changed.is_connected(_on_research_state_changed):
		TechnologyManager.agent_tech_state_changed.connect(_on_research_state_changed)


func _on_research_state_changed(tag: String) -> void:
	if tag == country_tag.strip_edges().to_upper() and is_inside_tree():
		refresh_screen()


func _setup_view_mode_filter() -> void:
	if _view_mode_ready:
		return
	view_mode_filter.clear()
	view_mode_filter.add_item("List")
	view_mode_filter.add_item("Graph")
	view_mode_filter.set_item_metadata(0, "list")
	view_mode_filter.set_item_metadata(1, "graph")
	view_mode_filter.select(0)
	_view_mode = "list"
	_view_mode_ready = true


func _setup_era_slider() -> void:
	var keys := TechnologyManager.get_era_swimlane_keys()
	era_slider.min_value = 0
	era_slider.max_value = maxf(float(keys.size() - 1), 0.0)
	era_slider.step = 1.0
	era_slider.value = 0.0
	_on_era_slider_changed(0.0)


func _setup_domain_filter() -> void:
	_rebuild_domain_filter(["all", "support"])


func _rebuild_domain_filter(domains_present: Array[String]) -> void:
	var ids := TechnologyManager.get_domain_tab_ids()
	var labels := TechnologyManager.get_domain_tab_labels()
	var previous := _domain_filter_id
	domain_filter.clear()
	for i in range(mini(ids.size(), labels.size())):
		var domain_id := str(ids[i])
		if domain_id not in domains_present:
			continue
		var idx := domain_filter.item_count
		domain_filter.add_item(labels[i])
		domain_filter.set_item_metadata(idx, domain_id)
	var pick := 0
	for i in range(domain_filter.item_count):
		if str(domain_filter.get_item_metadata(i)) == previous:
			pick = i
			break
	if domain_filter.item_count > 0:
		domain_filter.select(pick)
		_domain_filter_id = str(domain_filter.get_item_metadata(pick))
	else:
		_domain_filter_id = "all"
	_domain_filter_ready = true


func _apply_screen_theme() -> void:
	RetrowaveTheme.style_production_screen(self)
	RetrowaveTheme.style_title(title_label, RetrowaveTheme.CYAN)
	RetrowaveTheme.style_secondary_button(close_button)
	RetrowaveTheme.style_summary_metric(slots_label, RetrowaveTheme.CYAN)
	RetrowaveTheme.style_summary_metric(rp_label, RetrowaveTheme.MAGENTA)
	RetrowaveTheme.style_summary_metric(year_label)
	RetrowaveTheme.style_summary_metric(available_label, RetrowaveTheme.SUCCESS)
	RetrowaveTheme.style_summary_metric(completed_label)
	RetrowaveTheme.style_summary_metric(compromised_label, RetrowaveTheme.WARNING)
	RetrowaveTheme.style_body_label(agent_summary_label)
	RetrowaveTheme.style_secondary_button(open_agents_button)
	RetrowaveTheme.style_filter_option(domain_filter)
	RetrowaveTheme.style_filter_option(view_mode_filter)
	RetrowaveTheme.style_detail_panel(inspector_panel)
	RetrowaveTheme.style_detail_panel(doctrine_panel)
	RetrowaveTheme.style_detail_label(inspector_title)
	RetrowaveTheme.style_body_label(inspector_body)
	RetrowaveTheme.style_body_label(doctrine_header)
	RetrowaveTheme.style_body_label(doctrine_xp_label)
	RetrowaveTheme.style_primary_button(research_button)
	RetrowaveTheme.style_primary_button(open_training_button)
	RetrowaveTheme.style_secondary_button(cancel_button)
	RetrowaveTheme.style_secondary_button(reset_view_button)
	RetrowaveTheme.style_body_label($MarginContainer/VBoxContainer/ActiveBar/ActiveTitle)
	RetrowaveTheme.style_body_label(active_research_label)
	RetrowaveTheme.style_body_label(era_value_label)
	RetrowaveTheme.style_body_label($MarginContainer/VBoxContainer/FooterLabel)


func _on_close_pressed() -> void:
	queue_free()


func _on_domain_changed(_index: int) -> void:
	var meta = domain_filter.get_item_metadata(domain_filter.selected)
	_domain_filter_id = str(meta) if meta != null else "all"
	refresh_screen()


func _on_view_mode_changed(_index: int) -> void:
	var meta = view_mode_filter.get_item_metadata(view_mode_filter.selected)
	_view_mode = str(meta) if meta != null else "list"
	_apply_view_visibility()
	refresh_screen()


func _on_era_slider_changed(value: float) -> void:
	var keys := TechnologyManager.get_era_swimlane_keys()
	var labels := TechnologyManager.get_era_swimlane_labels()
	var idx := clampi(int(round(value)), 0, maxi(keys.size() - 1, 0))
	_era_filter_key = str(keys[idx])
	if idx < labels.size():
		era_value_label.text = str(labels[idx])
	refresh_screen()


func _on_reset_view_pressed() -> void:
	if graph_view:
		graph_view.reset_view()


func _on_graph_node_selected(tech_id: String) -> void:
	_selected_tech_id = tech_id
	refresh_screen()


func _on_open_agents_pressed() -> void:
	var tree := get_tree()
	if tree == null:
		return
	for node in tree.get_nodes_in_group("agent_screen"):
		node.queue_free()
	var scene: PackedScene = load("res://scenes/ui/AgentAssignmentScreen.tscn")
	if scene == null:
		return
	var screen: AgentAssignmentScreen = scene.instantiate() as AgentAssignmentScreen
	if screen == null:
		return
	screen.country_tag = country_tag
	screen.z_index = z_index
	tree.root.add_child(screen)
	screen.refresh_screen()


func _populate_agent_bar() -> void:
	var summary: Dictionary = current_data.agent_tech_summary
	if summary.is_empty():
		agent_summary_label.text = "Espionage: no active technology operations"
		return
	var parts: PackedStringArray = []
	var bonus := float(summary.get("tech_intel_rp_bonus", 0.0))
	if bonus > 0.0:
		parts.append("+%.1f RP/day intel" % bonus)
	if bool(summary.get("theft_protection_active", false)):
		parts.append("theft shield to %d" % int(summary.get("theft_protection_until", 0)))
	var compromised := int(summary.get("compromised_tech_count", 0))
	if compromised > 0:
		parts.append("%d compromised projects" % compromised)
	var missions: Array = summary.get("active_tech_missions", []) as Array
	if not missions.is_empty():
		parts.append("%d active tech missions" % missions.size())
	if parts.is_empty():
		agent_summary_label.text = "Espionage: standing by"
	else:
		agent_summary_label.text = "Espionage: " + ", ".join(parts)
	open_agents_button.tooltip_text = "Open the Agents screen to assign steal-research and counter-intel missions."


func _on_open_training_pressed() -> void:
	if current_data == null or current_data.primary_leader_id.is_empty():
		return
	TrainingPathScreen.open(self, current_data.primary_leader_id)


func _on_research_pressed() -> void:
	if _selected_tech_id.is_empty() or typeof(TechnologyManager) == TYPE_NIL:
		return
	if TechnologyManager.start_research(country_tag, _selected_tech_id):
		refresh_screen()


func _on_cancel_pressed() -> void:
	if _selected_tech_id.is_empty() or typeof(TechnologyManager) == TYPE_NIL:
		return
	if TechnologyManager.cancel_research(country_tag, _selected_tech_id):
		refresh_screen()


func refresh_screen() -> void:
	if typeof(TechnologyManager) == TYPE_NIL:
		return
	var preview := TechnologyManager.get_technology_screen_data(
		country_tag,
		_domain_filter_id,
		_selected_tech_id,
		_era_filter_key,
	)
	if not _selected_tech_id.is_empty():
		var still_visible := false
		for entry in preview.research_entries:
			if str(entry.get("tech_id", "")) == _selected_tech_id:
				still_visible = true
				break
		if not still_visible and not preview.research_entries.is_empty():
			_selected_tech_id = str(preview.research_entries[0].get("tech_id", ""))
	elif not preview.research_entries.is_empty():
		_selected_tech_id = str(preview.research_entries[0].get("tech_id", ""))

	_rebuild_domain_filter(preview.domains_present)
	current_data = TechnologyManager.get_technology_screen_data(
		country_tag,
		_domain_filter_id,
		_selected_tech_id,
		_era_filter_key,
	)

	title_label.text = "Technology — %s" % country_tag
	slots_label.text = "Slots: %d/%d" % [
		current_data.research_slots_used,
		current_data.research_slots_max,
	]
	rp_label.text = "RP/day: %.1f" % current_data.daily_rp
	rp_label.tooltip_text = current_data.daily_rp_tooltip
	year_label.text = "Year: %d" % current_data.current_year
	available_label.text = "Available: %d" % current_data.available_count
	completed_label.text = "Done: %d" % current_data.completed_count
	compromised_label.text = "Compromised: %d" % current_data.compromised_count
	if current_data.compromised_count > 0:
		compromised_label.modulate = RetrowaveTheme.WARNING
	else:
		compromised_label.modulate = Color.WHITE
	_populate_agent_bar()
	_populate_active_bar()
	_apply_view_visibility()
	_populate_research_list()
	_populate_graph()
	_populate_doctrine_panel()
	_update_inspector()


func _apply_view_visibility() -> void:
	var is_doctrine := _domain_filter_id == "doctrine"
	doctrine_panel.visible = is_doctrine
	list_scroll.visible = _view_mode == "list"
	if graph_view:
		graph_view.visible = _view_mode == "graph"
	if is_doctrine:
		if list_scroll.visible:
			list_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
			list_scroll.custom_minimum_size = Vector2(0, 120)
		if graph_view and graph_view.visible:
			graph_view.size_flags_vertical = Control.SIZE_EXPAND_FILL
			graph_view.custom_minimum_size = Vector2(0, 140)
		doctrine_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	else:
		list_scroll.custom_minimum_size = Vector2.ZERO
		if graph_view:
			graph_view.custom_minimum_size = Vector2.ZERO
	reset_view_button.visible = _view_mode == "graph"


func _populate_active_bar() -> void:
	if current_data.active_research.is_empty():
		active_research_label.text = "—"
		active_research_label.modulate = RetrowaveTheme.TEXT_DIM
		return
	var parts: PackedStringArray = []
	for slot in current_data.active_research:
		if typeof(slot) != TYPE_DICTIONARY:
			continue
		var pct := int(round(float(slot.get("progress_pct", 0.0)) * 100.0))
		parts.append("%s (%d%%)" % [slot.get("name", ""), pct])
	active_research_label.text = ", ".join(parts)
	active_research_label.modulate = Color.WHITE


func _populate_research_list() -> void:
	for child in research_list.get_children():
		child.queue_free()
	if not list_scroll.visible:
		return

	if current_data.research_entries.is_empty():
		var empty := Label.new()
		empty.text = "No technologies match filters."
		RetrowaveTheme.style_body_label(empty)
		research_list.add_child(empty)
		return

	for entry in current_data.research_entries:
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		research_list.add_child(_create_research_row(entry as Dictionary))


func _populate_graph() -> void:
	if graph_view == null or not graph_view.visible:
		return
	graph_view.set_graph_data(
		current_data.graph_nodes,
		current_data.graph_edges,
		_selected_tech_id,
	)


func _populate_doctrine_panel() -> void:
	for child in doctrine_list.get_children():
		child.queue_free()
	if not doctrine_panel.visible:
		return

	doctrine_xp_label.text = "National Doctrine XP: %d — %s" % [
		current_data.doctrine_xp,
		current_data.doctrine_xp_hint,
	]
	if current_data.primary_leader_name.is_empty():
		open_training_button.text = "Open Leader Training Paths"
		open_training_button.disabled = true
		open_training_button.tooltip_text = "No active leader found for this country."
	else:
		open_training_button.text = "Training Paths — %s" % current_data.primary_leader_name
		open_training_button.disabled = false
		open_training_button.tooltip_text = "Invest leader XP in doctrine schools (requires unlocked doctrine keys)."

	if current_data.doctrine_training_entries.is_empty():
		var empty := Label.new()
		empty.text = "No training path definitions loaded."
		RetrowaveTheme.style_body_label(empty)
		doctrine_list.add_child(empty)
		return

	for entry in current_data.doctrine_training_entries:
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		doctrine_list.add_child(_create_doctrine_row(entry as Dictionary))


func _create_doctrine_row(entry: Dictionary) -> PanelContainer:
	var panel := PanelContainer.new()
	RetrowaveTheme.style_detail_panel(panel)
	var unlocked := bool(entry.get("doctrine_unlocked", false))
	if unlocked:
		panel.modulate = Color(0.85, 1.0, 0.92)
	else:
		panel.modulate = Color(0.6, 0.6, 0.68)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 3)
	panel.add_child(box)

	var title := Label.new()
	title.text = str(entry.get("name", ""))
	RetrowaveTheme.style_body_label(title)
	box.add_child(title)

	var req := str(entry.get("doctrine_requirement", ""))
	var status := Label.new()
	if unlocked:
		status.text = "Doctrine unlocked — leaders may invest XP (max level %d)" % int(
			entry.get("max_level", 3),
		)
		status.add_theme_color_override("font_color", RetrowaveTheme.SUCCESS)
	else:
		var tech_name := str(entry.get("unlock_tech_name", ""))
		if tech_name.is_empty():
			status.text = "Requires research: %s" % req
		else:
			status.text = "Requires: %s" % tech_name
		status.add_theme_color_override("font_color", RetrowaveTheme.WARNING)
	RetrowaveTheme.style_body_label(status)
	box.add_child(status)

	var desc := Label.new()
	desc.text = str(entry.get("description", ""))
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	RetrowaveTheme.style_body_label(desc)
	desc.add_theme_color_override("font_color", RetrowaveTheme.TEXT_DIM)
	box.add_child(desc)

	return panel


func _create_research_row(entry: Dictionary) -> PanelContainer:
	var tech_id := str(entry.get("tech_id", ""))
	var panel := PanelContainer.new()
	RetrowaveTheme.style_detail_panel(panel)
	panel.gui_input.connect(_on_row_gui_input.bind(tech_id, panel))

	var status := str(entry.get("status", "locked"))
	var selected := tech_id == _selected_tech_id
	if selected:
		panel.modulate = Color(1.0, 0.95, 0.75)
	elif status == "available":
		panel.modulate = Color(0.85, 1.0, 0.9)
	elif status == "in_progress":
		panel.modulate = Color(0.75, 0.9, 1.0)
	elif status == "completed":
		panel.modulate = Color(0.7, 0.85, 0.7)
	elif status == "compromised":
		panel.modulate = Color(1.0, 0.6, 0.6)
	else:
		panel.modulate = Color(0.65, 0.65, 0.7)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 2)
	panel.add_child(box)

	var title := Label.new()
	title.text = "%s · %s" % [entry.get("name", ""), status.replace("_", " ").capitalize()]
	RetrowaveTheme.style_body_label(title)
	box.add_child(title)

	if status == "in_progress":
		var bar := ProgressBar.new()
		bar.min_value = 0.0
		bar.max_value = 1.0
		bar.value = float(entry.get("progress_pct", 0.0))
		bar.show_percentage = true
		bar.custom_minimum_size = Vector2(0, 14)
		box.add_child(bar)

	var meta := Label.new()
	meta.text = "%s · %d days · tier %d" % [
		entry.get("epoch", ""),
		int(entry.get("cost_days", 0)),
		int(entry.get("tier", 0)),
	]
	RetrowaveTheme.style_body_label(meta)
	meta.add_theme_color_override("font_color", RetrowaveTheme.TEXT_DIM)
	box.add_child(meta)

	var effect := Label.new()
	effect.text = str(entry.get("short_effect", ""))
	effect.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	RetrowaveTheme.style_body_label(effect)
	effect.add_theme_color_override("font_color", RetrowaveTheme.TEXT_DIM)
	box.add_child(effect)

	return panel


func _on_row_gui_input(event: InputEvent, tech_id: String, panel: PanelContainer) -> void:
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.pressed and mb.button_index == MOUSE_BUTTON_LEFT:
			_selected_tech_id = tech_id
			refresh_screen()
			panel.accept_event()


func _update_inspector() -> void:
	var info: Dictionary = current_data.inspector
	if info.is_empty():
		inspector_title.text = "Select a technology"
		inspector_body.text = ""
		research_button.disabled = true
		cancel_button.disabled = true
		return

	inspector_title.text = "%s [%s]" % [info.get("name", ""), str(info.get("status", "")).capitalize()]

	var lines: PackedStringArray = []
	lines.append("Domain: %s · %s" % [info.get("domain", ""), info.get("epoch", "")])
	lines.append("Era: %s · Cost: %d days" % [info.get("era_range", ""), int(info.get("cost_days", 0))])
	if str(info.get("node_kind", "")) == "doctrine":
		lines.append("Doctrine node — unlocks leader training eligibility.")
	if str(info.get("short_effect", "")) != "":
		lines.append(str(info.get("short_effect", "")))
	if str(info.get("flavor", "")) != "":
		lines.append(str(info.get("flavor", "")))

	var prereqs: Array = info.get("prerequisite_lines", []) as Array
	if not prereqs.is_empty():
		lines.append("Prerequisites: " + ", ".join(prereqs))

	var unlocks: Array = info.get("unlock_lines", []) as Array
	if not unlocks.is_empty():
		lines.append("Unlocks:")
		for line in unlocks:
			lines.append("  • " + str(line))

	var agent_lines: Array = info.get("agent_lines", []) as Array
	if not agent_lines.is_empty():
		lines.append("Agents / espionage:")
		for line in agent_lines:
			lines.append("  • " + str(line))

	if _domain_filter_id == "doctrine":
		lines.append("")
		lines.append("After research: open Leader Training Paths to spend XP on schools.")

	inspector_body.text = "\n".join(lines)

	var status := str(info.get("status", ""))
	research_button.disabled = status == "compromised" or not bool(info.get("can_start", false))
	cancel_button.disabled = not bool(info.get("can_cancel", false))
	if status == "compromised":
		research_button.tooltip_text = "Research halted — security breach. Wait for counter-intel or year expiry."
	else:
		research_button.tooltip_text = "Assign a free research slot to this technology."
