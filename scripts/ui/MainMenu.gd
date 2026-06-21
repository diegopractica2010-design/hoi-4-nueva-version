# scripts/ui/MainMenu.gd
## Reusable Main Menu scene (extends Window for proper popup behavior).
## 
## Architecture (signal-based handoff):
## - TopInfoBar emits `menu_option_selected(option: String)` when the player requests the menu
##   (via top-bar buttons or ESC).
## - This MainMenu scene listens to the signal (or is instanced by TopInfoBar on demand)
##   and presents the full menu.
## - The menu handles its own open/close lifecycle, including auto-pause/resume.
## - Future dedicated MainMenu.tscn can be instanced by TopInfoBar or listen globally.
##
## Auto-Pause Behavior (priority 1):
## - On open (_ready or show): pauses the game via TimeManager + Engine.time_scale.
## - On close (close_requested or explicit): resumes previous pause/speed state.
## - Non-intrusive: stores/restores prior state so autosave and other systems are unaffected.
##
## Save/Load Integration (priority 2):
## - Core options (Save Game, Load Game, Save As) open or trigger the integrated Save Manager.
## - The Save Manager view uses SaveLoadManager.list_saves() (rich metadata: timestamp, scenario_id,
##   last_played, game_version) + delete_save/rename_save/load_game.
## - Clear toasts/feedback on actions (consistent with LeaderEventUI patterns).
##
## Extensibility (priority 4):
## - Add new buttons in _build_menu_options() that emit the signal (e.g. "settings", "help").
## - Future pages can be swapped into the main content area (VBox or TabContainer).
## - The signal allows a full scene replacement without changing TopInfoBar.
##
## Usage:
##   # From TopInfoBar or global:
##   var menu = preload("res://scenes/ui/MainMenu.tscn").instantiate()
##   get_tree().root.add_child(menu)
##   # Or listen to TopInfoBar.menu_option_selected and instance this.
##
## Styling: Uses RetrowaveTheme (consistent with DesignPickerPopup and other popups).
## Keep this file as the single source of truth for main menu behavior.

class_name MainMenu
extends Window

const Log = preload("res://scripts/core/Logger.gd")

const MENU_WIDTH := 640
const MENU_HEIGHT := 480

signal menu_closed

var _previous_pause_state := false
var _previous_speed := 1

@onready var main_vbox: VBoxContainer = $MarginContainer/VBoxContainer
@onready var title_label: Label = $MarginContainer/VBoxContainer/TitleLabel
@onready var content_hbox: HBoxContainer = $MarginContainer/VBoxContainer/ContentHBox
@onready var options_vbox: VBoxContainer = $MarginContainer/VBoxContainer/ContentHBox/OptionsVBox
@onready var save_manager_container: VBoxContainer = $MarginContainer/VBoxContainer/ContentHBox/SaveManagerContainer
@onready var close_button: Button = $MarginContainer/VBoxContainer/CloseButton

func _ready() -> void:
	title = "Main Menu"
	close_requested.connect(_on_close_requested)
	_clamp_to_viewport()

	# Apply consistent styling
	if has_node("/root/RetrowaveTheme"):
		RetrowaveTheme.style_popup_root(self)
		RetrowaveTheme.style_title(title_label, RetrowaveTheme.CYAN)

	_build_menu_options()
	_build_save_manager_view()

	# Style dynamic content for professional Retrowave look (polish for scene-based menu)
	_style_dynamic_controls()

	# Auto-pause on open (priority 1)
	_pause_game(true)

	Log.info("MainMenu opened (auto-paused)", "MainMenu")

func _clamp_to_viewport() -> void:
	var vp := get_viewport().get_visible_rect().size
	size = Vector2i(mini(MENU_WIDTH, int(vp.x * 0.9)), mini(MENU_HEIGHT, int(vp.y * 0.85)))
	position = (Vector2i(vp) - size) / 2

func _build_menu_options() -> void:
	options_vbox.add_child(_make_menu_button(Localization.get_text("menu.main.new_game"), "new_game"))
	options_vbox.add_child(_make_menu_button(Localization.get_text("menu.main.save_game"), "save"))
	options_vbox.add_child(_make_menu_button(Localization.get_text("menu.main.load_game"), "load"))
	options_vbox.add_child(_make_menu_button(Localization.get_text("menu.main.save_game"), "save_as"))
	options_vbox.add_child(_make_menu_button(Localization.get_text("menu.main.quit"), "return_to_main"))
	options_vbox.add_child(_make_menu_button(Localization.get_text("menu.main.quit"), "exit"))
	options_vbox.add_child(_make_menu_button("Ayuda / Acerca de", "help"))

	var spacer := Control.new()
	spacer.custom_minimum_size.y = 20
	options_vbox.add_child(spacer)

	close_button.pressed.connect(_on_close_requested)

func _make_menu_button(text: String, option: String) -> Button:
	var btn := Button.new()
	btn.text = text
	btn.custom_minimum_size = Vector2(0, 36)
	btn.pressed.connect(func():
		# Emit for external listeners (future full scene takeover)
		if get_tree().root.has_node("TopInfoBar"):
			var top_bar := get_tree().root.get_node("TopInfoBar")
			if top_bar.has_signal("menu_option_selected"):
				top_bar.menu_option_selected.emit(option)
		_handle_menu_option(option)
	)
	# Retrowave styling for immediate professional appearance
	if has_node("/root/RetrowaveTheme"):
		if option == "exit":
			RetrowaveTheme.style_danger_button(btn)
		else:
			RetrowaveTheme.style_secondary_button(btn)
	return btn

func _build_save_manager_view() -> void:
	# Title for the Save Manager section (rich metadata view)
	var title := Label.new()
	title.text = "Gestor de partidas"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	save_manager_container.add_child(title)
	if has_node("/root/RetrowaveTheme"):
		RetrowaveTheme.style_title(title, RetrowaveTheme.CYAN)
		RetrowaveTheme.style_body_label(title)  # will be overridden by style_title size but keeps color path

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	save_manager_container.add_child(scroll)

	var list_vbox := VBoxContainer.new()
	scroll.add_child(list_vbox)

	_populate_save_list(list_vbox)

func _populate_save_list(parent: VBoxContainer) -> void:
	parent.add_child(Control.new()) # spacer

	var saves := SaveLoadManager.list_saves()
	if saves.is_empty():
		var l := Label.new()
		l.text = "Aún no hay partidas guardadas."
		parent.add_child(l)
		return

	for save_info in saves:
		var h := HBoxContainer.new()

		var meta: Dictionary = save_info.get("metadata", {})
		var slot := str(save_info.get("slot", ""))
		var ts := str(meta.get("timestamp", meta.get("last_played", "")))
		var scenario := str(meta.get("scenario_id", "unknown"))

		var label := Label.new()
		label.text = "%s | %s | %s" % [slot, ts.substr(0, 16), scenario]
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		h.add_child(label)

		var load_btn := Button.new()
		load_btn.text = "Cargar"
		load_btn.pressed.connect(func():
			SaveLoadManager.load_game(slot)
			if typeof(LeaderEventUI) != TYPE_NIL and LeaderEventUI.has_method("show_toast"):
				LeaderEventUI.show_toast("Game loaded: " + slot, 2.5)
			_on_close_requested()
		)
		if has_node("/root/RetrowaveTheme"):
			RetrowaveTheme.style_primary_button(load_btn)
		h.add_child(load_btn)

		var del_btn := Button.new()
		del_btn.text = "Eliminar"
		del_btn.pressed.connect(func():
			SaveLoadManager.delete_save(slot)
			if typeof(LeaderEventUI) != TYPE_NIL and LeaderEventUI.has_method("show_toast"):
				LeaderEventUI.show_toast("Save deleted: " + slot, 2.0, true)
			# Refresh the list in place (robust clear + rebuild)
			_refresh_save_list(parent)
		)
		if has_node("/root/RetrowaveTheme"):
			RetrowaveTheme.style_danger_button(del_btn)
		h.add_child(del_btn)

		var rename_btn := Button.new()
		rename_btn.text = "Renombrar"
		rename_btn.pressed.connect(func():
			# Lightweight foundation - real UI would use a LineEdit dialog
			Log.info("Rename requested for " + slot + " (use SaveLoadManager.rename_save via console/API for now)", "MainMenu")
			if typeof(LeaderEventUI) != TYPE_NIL and LeaderEventUI.has_method("show_toast"):
				LeaderEventUI.show_toast("Rename ready via API (see SaveLoadManager)", 2.0)
		)
		if has_node("/root/RetrowaveTheme"):
			RetrowaveTheme.style_secondary_button(rename_btn)
		h.add_child(rename_btn)

		parent.add_child(h)

func _handle_menu_option(option: String) -> void:
	match option:
		"new_game":
			# Reinicia el flujo de nueva partida: limpia la selección previa y va a
			# la pantalla de selección de nación.
			if typeof(GameData) != TYPE_NIL:
				GameData.selected_nation_tag = ""
			_on_close_requested()  # cierra el popup y reanuda el estado de pausa
			get_tree().change_scene_to_file("res://scenes/ui/NationSelectScreen.tscn")
		"save":
			SaveLoadManager.quicksave()
			if typeof(LeaderEventUI) != TYPE_NIL and LeaderEventUI.has_method("show_toast"):
				LeaderEventUI.show_toast("Game saved (quicksave)", 2.0)
			# Optionally refresh Save Manager list or close
		"load":
			# For simplicity, load the most recent or show the manager (already visible)
			pass
		"save_as":
			# Future: open a name dialog then call save_game with custom slot
			Log.info("Save As requested (API ready via SaveLoadManager)", "MainMenu")
		"return_to_main":
			# Reiniciar partida: cerrar el menú y volver a la selección de nación.
			_on_close_requested()
			if typeof(GameData) != TYPE_NIL:
				GameData.selected_nation_tag = ""
			get_tree().change_scene_to_file("res://scenes/ui/NationSelectScreen.tscn")
		"exit":
			get_tree().quit()
		"help":
			Log.info("Help/About requested", "MainMenu")
		_:
			Log.info("MainMenu option: " + str(option), "MainMenu")

func _on_close_requested() -> void:
	_pause_game(false)
	queue_free()
	menu_closed.emit()

## Auto-pause/resume (priority 1) - self-contained so the menu works even if instanced independently.
func _pause_game(pause: bool) -> void:
	var resume_speed := _get_resume_speed()
	if typeof(TimeManager) == TYPE_NIL:
		Engine.time_scale = 0.0 if pause else float(resume_speed)
		return

	if pause:
		if not has_meta("was_paused_before_menu"):
			set_meta("was_paused_before_menu", TimeManager.is_paused())
			set_meta("speed_before_menu", resume_speed)
		TimeManager.set_paused(true)
		TimeManager.set_time_scale(0.0)
		Engine.time_scale = 0.0
	else:
		var was_paused: bool = get_meta("was_paused_before_menu", false)
		var prev_speed: int = int(get_meta("speed_before_menu", resume_speed))
		TimeManager.set_paused(was_paused)
		var scale := 0.0 if was_paused else float(prev_speed)
		TimeManager.set_time_scale(scale)
		Engine.time_scale = scale
		_sync_top_bar_after_menu_close(was_paused, prev_speed)
		remove_meta("was_paused_before_menu")
		remove_meta("speed_before_menu")


func _get_resume_speed() -> int:
	var top_bar := get_tree().root.get_node_or_null("TopInfoBar")
	if top_bar != null and "current_speed" in top_bar:
		return maxi(1, int(top_bar.current_speed))
	return maxi(1, _previous_speed)


func _sync_top_bar_after_menu_close(was_paused: bool, speed: int) -> void:
	var top_bar := get_tree().root.get_node_or_null("TopInfoBar")
	if top_bar == null:
		return
	if "is_paused" in top_bar:
		top_bar.is_paused = was_paused
	if "current_speed" in top_bar:
		top_bar.current_speed = speed
	if top_bar.has_method("_sync_time_manager_controls"):
		top_bar._sync_time_manager_controls()
	if top_bar.has_method("_update_speed_buttons"):
		top_bar._update_speed_buttons()

# Optional: connect to TopInfoBar signal if you want global listening
# func _ready():
#     if get_tree().root.has_node("TopInfoBar"):
#         get_tree().root.get_node("TopInfoBar").menu_option_selected.connect(_handle_menu_option)


## Apply RetrowaveTheme to dynamically created controls (called from _ready after builds).
## Keeps the scene-driven menu visually consistent with DesignPickerPopup and other UI.
func _style_dynamic_controls() -> void:
	if typeof(RetrowaveTheme) == TYPE_NIL:
		return
	# Close button (footer)
	if close_button:
		RetrowaveTheme.style_secondary_button(close_button)

	# Any late-added labels or containers can be styled here if needed.
	# Per-row buttons in the Save Manager list are styled at creation time in _populate_save_list
	# for Load (primary), Delete (danger), Rename (secondary).

## Robust refresh for the Save Manager list after Delete/Rename (avoids fragile ancestor queue_free).
func _refresh_save_list(list_vbox: VBoxContainer) -> void:
	if list_vbox == null or not is_instance_valid(list_vbox):
		# Fallback: full rebuild of the save view
		for c in save_manager_container.get_children():
			c.queue_free()
		_build_save_manager_view()
		return
	# Clear only the list rows (keep any header if present above)
	for c in list_vbox.get_children():
		c.queue_free()
	_populate_save_list(list_vbox)
