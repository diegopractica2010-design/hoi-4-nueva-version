# scripts/ui/DesignPickerPopup.gd
class_name DesignPickerPopup
extends Window

const MAX_WINDOW_SIZE := Vector2i(580, 660)
const ROW_DOMESTIC := Color("#d8f4ff")
const MIN_LIST_HEIGHT := 200
const MAX_LIST_HEIGHT := 380

const TIER_COLOR_ACTIVE := Color("#33e6ff")
const TIER_COLOR_ARCHIVE := Color("#ffb85a")
const TIER_COLOR_LOCKED := Color("#8a9ab8")
const HEADER_DOMESTIC := Color("#33e6ff")
const HEADER_FOREIGN := Color("#88b8ff")
const HEADER_PREVIOUS := Color("#e8b060")
const HEADER_OBSOLETE := Color("#8a92a8")
const HEADER_LOCKED := Color("#7a8aa4")
const ROW_UNIVERSAL := Color("#b8c8e0")
const LOCKED_ROW_BASE := Color("#9aa8c0")
const DIVIDER_COLOR := Color("#3a4460")

const DOMAIN_FILTER_TOOLTIPS: PackedStringArray = [
	"All equipment domains",
	"Land — armor, infantry, artillery",
	"Naval — ships and submarines",
	"Air — aircraft and air wings",
	"Space — orbital and strategic assets",
	"Support — logistics and auxiliary",
]

@export var factory_id: int = 0
@export var country_tag: String = "GER"

@onready var title_label: Label = $MarginContainer/VBoxContainer/TitleLabel
@onready var domain_filter: OptionButton = $MarginContainer/VBoxContainer/FilterRow/DomainFilter
@onready var show_obsolete_check: CheckBox = (
	$MarginContainer/VBoxContainer/FilterRow/ShowObsoleteCheck
)
@onready var search_edit: LineEdit = $MarginContainer/VBoxContainer/SearchEdit
@onready var legend_label: Label = $MarginContainer/VBoxContainer/LegendLabel
@onready var list_scroll: ScrollContainer = $MarginContainer/VBoxContainer/ListScroll
@onready var design_list: ItemList = $MarginContainer/VBoxContainer/ListScroll/DesignList
@onready var confirm_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/ConfirmButton
@onready var cancel_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/CancelButton
@onready var lock_hint_label: Label = $MarginContainer/VBoxContainer/LockHintLabel

var _list_entries: Array[Dictionary] = []
var _visible_design_count: int = 0
var selected_design: String = ""


func _ready() -> void:
	title = "Select Production Design"
	close_requested.connect(_on_cancel_pressed)
	_clamp_window_to_viewport()

	RetrowaveTheme.style_popup_root(self)
	RetrowaveTheme.style_title(title_label, RetrowaveTheme.CYAN)
	RetrowaveTheme.style_search(search_edit)
	RetrowaveTheme.style_item_list(design_list)
	RetrowaveTheme.style_primary_button(confirm_button)
	RetrowaveTheme.style_secondary_button(cancel_button)
	RetrowaveTheme.style_body_label(lock_hint_label)
	RetrowaveTheme.style_body_label(legend_label)
	lock_hint_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	lock_hint_label.add_theme_color_override("font_color", RetrowaveTheme.TEXT_DIM)
	legend_label.add_theme_color_override("font_color", RetrowaveTheme.TEXT_DIM)

	var tag := country_tag.strip_edges().to_upper()
	title_label.text = "Production design — %s" % tag if not tag.is_empty() else "Production design"
	search_edit.placeholder_text = "Search (name, nation, captured, year…) — multiple words OK"
	search_edit.tooltip_text = "Filters the list; all words must match. Hides the legend while active."
	legend_label.text = _legend_key_text()
	show_obsolete_check.button_pressed = false

	_setup_domain_filter()
	_update_filter_labels()
	_update_default_lock_hint()

	confirm_button.disabled = true
	confirm_button.pressed.connect(_on_confirm_pressed)
	cancel_button.pressed.connect(_on_cancel_pressed)
	design_list.item_selected.connect(_on_design_selected)
	search_edit.text_changed.connect(_on_search_changed)
	domain_filter.item_selected.connect(_on_filters_changed)
	show_obsolete_check.toggled.connect(_on_filters_changed)

	if _is_scene_validation_mode():
		lock_hint_label.text = "Scene validation mode"
		return

	_rebuild_list()
	_update_legend_visibility()
	popup_centered()


func _is_scene_validation_mode() -> bool:
	for argument in OS.get_cmdline_user_args():
		if argument == "--scene-validation":
			return true
		if argument.begins_with("--manifest=") or argument.begins_with("--scene="):
			return true
	return false


func _legend_key_text() -> String:
	return (
		"🏠 Domestic  ·  🌐 Foreign (⚔ Captured · 💰 Purchased · 📜 Licensed + nation tag)  ·  "
		+ "◇ Universal  ·  ↺ / ⏳ archive  ·  ★ sole role  ·  🔒 research"
	)


func _update_legend_visibility() -> void:
	var searching := not search_edit.text.strip_edges().is_empty()
	legend_label.visible = not searching
	if searching:
		legend_label.tooltip_text = _legend_key_text()
	else:
		legend_label.tooltip_text = ""


func _clamp_window_to_viewport() -> void:
	var vp_size := get_viewport().get_visible_rect().size
	var max_w := mini(MAX_WINDOW_SIZE.x, int(vp_size.x * 0.9))
	var max_h := mini(MAX_WINDOW_SIZE.y, int(vp_size.y * 0.85))
	max_size = Vector2i(max_w, max_h)
	min_size = Vector2i(mini(420, max_w), mini(460, max_h))
	if size.x > max_w or size.y > max_h:
		size = Vector2i(mini(size.x, max_w), mini(size.y, max_h))
	list_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	design_list.tooltip_text = "Hover a design for origin and lock details"


func _setup_domain_filter() -> void:
	domain_filter.clear()
	var labels := DesignManager.DOMAIN_FILTER_DISPLAY
	if labels.is_empty():
		labels = DesignManager.DOMAIN_FILTER_LABELS
	for i in labels.size():
		domain_filter.add_item(labels[i])
		if i < DOMAIN_FILTER_TOOLTIPS.size():
			domain_filter.set_item_tooltip(i, DOMAIN_FILTER_TOOLTIPS[i])
	domain_filter.tooltip_text = "Filter designs by equipment domain"
	RetrowaveTheme.style_filter_option(domain_filter)
	domain_filter.custom_minimum_size.x = 168.0


func _get_factory() -> Factory:
	if FactoryManager == null:
		return null
	return FactoryManager.get_factory(factory_id)


func _rebuild_list() -> void:
	design_list.clear()
	_list_entries.clear()
	selected_design = ""
	_visible_design_count = 0

	var catalog := _fetch_catalog()
	var needle := search_edit.text.strip_edges().to_lower()
	_update_legend_visibility()

	var domestic: Dictionary = catalog.get("domestic", {}) as Dictionary
	var foreign: Dictionary = catalog.get("foreign", {}) as Dictionary
	var locked_domestic: Array = catalog.get("locked_domestic", []) as Array
	var locked_foreign: Array = catalog.get("locked_foreign", []) as Array

	_append_tier_header("ACTIVE", TIER_COLOR_ACTIVE)
	_append_active_tier_hint()
	var had_domestic_active := _append_design_section(
		"🏠 DOMESTIC",
		domestic.get("active", []) as Array,
		DesignManager.DesignStatus.ACTIVE,
		needle,
		false,
		false,
		false,
		HEADER_DOMESTIC,
	)
	if had_domestic_active:
		_append_section_divider()
	_append_design_section(
		"🌐 FOREIGN ACQUIRED",
		foreign.get("active", []) as Array,
		DesignManager.DesignStatus.ACTIVE,
		needle,
		true,
		false,
		true,
		HEADER_FOREIGN,
	)

	if show_obsolete_check.button_pressed:
		_append_tier_header("ARCHIVE", TIER_COLOR_ARCHIVE)
		_append_archive_tier_hint()
		var had_archive := false
		var section_added := _append_design_section(
			"↺ PREVIOUSLY USED · 🏠 DOMESTIC",
			domestic.get("previously_used", []) as Array,
			DesignManager.DesignStatus.PREVIOUSLY_USED,
			needle,
			false,
			false,
			false,
			HEADER_PREVIOUS,
		)
		if section_added:
			_append_section_divider()
		had_archive = section_added
		section_added = _append_design_section(
			"↺ PREVIOUSLY USED · 🌐 FOREIGN",
			foreign.get("previously_used", []) as Array,
			DesignManager.DesignStatus.PREVIOUSLY_USED,
			needle,
			true,
			false,
			false,
			HEADER_PREVIOUS,
		)
		if section_added:
			_append_section_divider()
		had_archive = had_archive or section_added
		section_added = _append_design_section(
			"⏳ OBSOLETE · 🏠 DOMESTIC",
			domestic.get("obsolete", []) as Array,
			DesignManager.DesignStatus.OBSOLETE,
			needle,
			false,
			false,
			false,
			HEADER_OBSOLETE,
		)
		if section_added:
			_append_section_divider()
		had_archive = had_archive or section_added
		section_added = _append_design_section(
			"⏳ OBSOLETE · 🌐 FOREIGN",
			foreign.get("obsolete", []) as Array,
			DesignManager.DesignStatus.OBSOLETE,
			needle,
			true,
			false,
			false,
			HEADER_OBSOLETE,
		)
		had_archive = had_archive or section_added
		if not had_archive:
			var note_idx := design_list.add_item("    No archive entries match this filter")
			design_list.set_item_disabled(note_idx, true)
			design_list.set_item_custom_fg_color(note_idx, RetrowaveTheme.TEXT_DIM)
			_list_entries.append(_header_entry())
	var has_locked := not locked_domestic.is_empty() or not locked_foreign.is_empty()
	if has_locked:
		_append_tier_header("LOCKED — RESEARCH REQUIRED", TIER_COLOR_LOCKED)
		_append_locked_tier_hint()
		var had_locked_domestic := _append_design_section(
			"🔒 LOCKED · 🏠 DOMESTIC",
			locked_domestic,
			DesignManager.DesignStatus.ACTIVE,
			needle,
			false,
			true,
			false,
			HEADER_LOCKED,
		)
		if had_locked_domestic:
			_append_section_divider()
		_append_design_section(
			"🔒 LOCKED · 🌐 FOREIGN",
			locked_foreign,
			DesignManager.DesignStatus.ACTIVE,
			needle,
			true,
			true,
			false,
			HEADER_LOCKED,
		)

	if not _list_has_design_rows():
		var idx := design_list.add_item("No designs match — try another domain or search")
		design_list.set_item_disabled(idx, true)
		_list_entries.append(_header_entry())

	_clamp_window_to_viewport()
	_sync_list_scroll_size()
	_scroll_list_to_top()
	confirm_button.disabled = true
	_update_summary_hint(catalog)
	_update_lock_hint()


func _header_entry() -> Dictionary:
	return {"design_id": "", "is_header": true, "status": -1, "foreign": false, "locked": false}


func _list_has_design_rows() -> bool:
	for entry in _list_entries:
		if bool(entry.get("is_header", true)):
			continue
		if not str(entry.get("design_id", "")).is_empty():
			return true
	return false


func _update_summary_hint(catalog: Dictionary) -> void:
	var domestic: Dictionary = catalog.get("domestic", {}) as Dictionary
	var foreign: Dictionary = catalog.get("foreign", {}) as Dictionary
	var active_n := (domestic.get("active", []) as Array).size() + (foreign.get("active", []) as Array).size()
	var foreign_n := (foreign.get("active", []) as Array).size()
	var locked_n := (catalog.get("locked_domestic", []) as Array).size() + (
		catalog.get("locked_foreign", []) as Array
	).size()
	var parts: PackedStringArray = ["%d buildable" % active_n]
	if foreign_n > 0:
		parts.append("%d foreign" % foreign_n)
	if locked_n > 0:
		parts.append("%d locked" % locked_n)
	if show_obsolete_check.button_pressed:
		var arch := (domestic.get("previously_used", []) as Array).size()
		arch += (foreign.get("previously_used", []) as Array).size()
		arch += (domestic.get("obsolete", []) as Array).size()
		arch += (foreign.get("obsolete", []) as Array).size()
		if arch > 0:
			parts.append("%d archive" % arch)
	var domain_label := _domain_filter_label()
	var summary := "%s · %s" % [" · ".join(parts), domain_label]
	var needle := search_edit.text.strip_edges()
	if not needle.is_empty():
		var match_phrase := "%d match%s" % [_visible_design_count, "es" if _visible_design_count != 1 else ""]
		if _visible_design_count == 0:
			match_phrase = "no matches"
		summary += " · %s" % match_phrase
	lock_hint_label.text = summary
	if not needle.is_empty() and _visible_design_count == 0:
		lock_hint_label.add_theme_color_override("font_color", RetrowaveTheme.MAGENTA)
	else:
		lock_hint_label.add_theme_color_override("font_color", RetrowaveTheme.TEXT_DIM)


func _domain_filter_label() -> String:
	var labels := DesignManager.DOMAIN_FILTER_DISPLAY
	if labels.is_empty():
		labels = DesignManager.DOMAIN_FILTER_LABELS
	var idx := domain_filter.selected
	if idx >= 0 and idx < labels.size():
		return labels[idx]
	return "All domains"


func _append_tier_header(title: String, accent: Color) -> bool:
	var idx := design_list.add_item("━━  %s" % title)
	design_list.set_item_disabled(idx, true)
	design_list.set_item_custom_fg_color(idx, accent)
	_list_entries.append(_header_entry())
	return true


func _append_active_tier_hint() -> void:
	var idx := design_list.add_item("      Buildable domestic and foreign-acquired lines")
	design_list.set_item_disabled(idx, true)
	design_list.set_item_custom_fg_color(idx, RetrowaveTheme.TEXT_DIM)
	_list_entries.append(_header_entry())


func _append_archive_tier_hint() -> void:
	var idx := design_list.add_item("      Previously used and obsolete lines (domestic & foreign)")
	design_list.set_item_disabled(idx, true)
	design_list.set_item_custom_fg_color(idx, RetrowaveTheme.TEXT_DIM)
	_list_entries.append(_header_entry())


func _append_locked_tier_hint() -> void:
	var idx := design_list.add_item("      Unlock via Technology — rows are preview-only")
	design_list.set_item_disabled(idx, true)
	design_list.set_item_custom_fg_color(idx, RetrowaveTheme.TEXT_DIM)
	_list_entries.append(_header_entry())


func _append_foreign_empty_block(section_title: String, header_color: Color) -> void:
	var header_idx := design_list.add_item("  %s  (0)" % section_title)
	design_list.set_item_disabled(header_idx, true)
	design_list.set_item_custom_fg_color(header_idx, header_color)
	_list_entries.append(_header_entry())
	for hint in [
		"      No captured, purchased, or licensed designs for this filter.",
		"      ⚔ Capture in war  ·  💰 Purchase on the market  ·  📜 License from allies.",
		"      Completed acquisitions appear here automatically.",
	]:
		var hint_idx := design_list.add_item(hint)
		design_list.set_item_disabled(hint_idx, true)
		design_list.set_item_custom_fg_color(hint_idx, RetrowaveTheme.TEXT_DIM)
		_list_entries.append(_header_entry())


func _append_section_divider() -> void:
	var idx := design_list.add_item("  ─── domestic / foreign ───")
	design_list.set_item_disabled(idx, true)
	design_list.set_item_custom_fg_color(idx, DIVIDER_COLOR)
	_list_entries.append(_header_entry())


func _append_design_section(
	title: String,
	design_ids: Array,
	status: DesignManager.DesignStatus,
	needle: String,
	is_foreign: bool,
	locked_section: bool,
	show_empty_note: bool,
	header_color: Color,
) -> bool:
	var sorted: Array[String] = []
	if typeof(DesignManager) != TYPE_NIL:
		sorted = DesignManager.sort_design_ids_for_display(design_ids)
	var visible: Array[String] = []
	for design_id in sorted:
		if _matches_search(design_id, needle):
			visible.append(design_id)

	if visible.is_empty():
		if not show_empty_note:
			return false
		if is_foreign:
			_append_foreign_empty_block(title, header_color)
		else:
			var empty_idx := design_list.add_item("  %s  (0)" % title)
			design_list.set_item_disabled(empty_idx, true)
			design_list.set_item_custom_fg_color(empty_idx, RetrowaveTheme.TEXT_DIM)
			_list_entries.append(_header_entry())
			var hint_idx := design_list.add_item("      No designs in this section for the current filter.")
			design_list.set_item_disabled(hint_idx, true)
			design_list.set_item_custom_fg_color(hint_idx, RetrowaveTheme.TEXT_DIM)
			_list_entries.append(_header_entry())
		return false

	var header_idx := design_list.add_item("  %s  (%d)" % [title, visible.size()])
	design_list.set_item_disabled(header_idx, true)
	design_list.set_item_custom_fg_color(header_idx, header_color)
	_list_entries.append(_header_entry())

	var sub := _section_subtitle(status, is_foreign, locked_section)
	if not sub.is_empty():
		var sub_idx := design_list.add_item("      %s" % sub)
		design_list.set_item_disabled(sub_idx, true)
		design_list.set_item_custom_fg_color(sub_idx, RetrowaveTheme.TEXT_DIM)
		_list_entries.append(_header_entry())

	for design_id in visible:
		var row_idx := design_list.add_item(_design_list_label(design_id, status, is_foreign, locked_section))
		design_list.set_item_tooltip(row_idx, _design_row_tooltip(design_id, status, locked_section))
		_list_entries.append({
			"design_id": design_id,
			"is_header": false,
			"status": status,
			"foreign": is_foreign,
			"locked": locked_section,
		})
		_apply_row_color(row_idx, design_id, status, is_foreign, locked_section)
		design_list.set_item_disabled(row_idx, locked_section or not _is_design_selectable(design_id))
		_visible_design_count += 1
	return true


func _design_row_tooltip(
	design_id: String,
	status: DesignManager.DesignStatus,
	locked_section: bool,
) -> String:
	var lines: PackedStringArray = []
	if typeof(DesignManager) != TYPE_NIL:
		lines.append(DesignManager.format_origin_tooltip(country_tag, design_id))
	match status:
		DesignManager.DesignStatus.PREVIOUSLY_USED:
			lines.append("Previously used in this role — still authorized for production.")
		DesignManager.DesignStatus.OBSOLETE:
			lines.append("Obsolete line — suitable for export stock or emergency runs.")
	if locked_section:
		lines.append(_lock_suffix(design_id).replace("🔒 ", "Requires research: "))
	elif typeof(TechnologyManager) != TYPE_NIL:
		var availability: Dictionary = TechnologyManager.get_design_availability(country_tag, design_id)
		if not bool(availability.get("available", true)):
			lines.append(str(availability.get("reason", "Locked by technology")))
	if (
		typeof(DesignManager) != TYPE_NIL
		and not DesignManager.is_design_factory_compatible(design_id, _get_factory())
	):
		lines.append("Needs a shipyard factory at a port.")
	if (
		typeof(DesignManager) != TYPE_NIL
		and DesignManager.is_only_design_in_role(country_tag, design_id)
	):
		lines.append("Only design remaining in this equipment role.")
	return "\n".join(lines)


func _matches_search(design_id: String, needle: String) -> bool:
	if needle.is_empty():
		return true
	var blob := ""
	if typeof(DesignManager) != TYPE_NIL:
		blob = DesignManager.design_row_search_blob(country_tag, design_id)
	else:
		blob = _design_list_label(design_id, DesignManager.DesignStatus.ACTIVE, false, false).to_lower()
	for token in needle.split(" ", false):
		var t := token.strip_edges()
		if t.is_empty():
			continue
		if not blob.contains(t):
			return false
	return true


func _fetch_catalog() -> Dictionary:
	if typeof(DesignManager) == TYPE_NIL:
		return {
			"domestic": {"active": [], "previously_used": [], "obsolete": []},
			"foreign": {"active": [], "previously_used": [], "obsolete": []},
			"locked_domestic": [],
			"locked_foreign": [],
		}
	return DesignManager.get_designs_for_picker(
		country_tag,
		DesignManager.domain_from_filter_index(domain_filter.selected),
		show_obsolete_check.button_pressed,
		_get_factory(),
		true,
	)


func _section_subtitle(
	status: DesignManager.DesignStatus,
	is_foreign: bool,
	locked_section: bool,
) -> String:
	if locked_section:
		if is_foreign:
			return "Complete research to produce this acquired design"
		return "Complete research to unlock domestic production"
	if is_foreign:
		match status:
			DesignManager.DesignStatus.PREVIOUSLY_USED:
				return "Superseded in role — still buildable for reserves"
			DesignManager.DesignStatus.OBSOLETE:
				return "Legacy foreign stock — emergency or export runs"
			_:
				return "Captured, purchased, or licensed equipment"
	match status:
		DesignManager.DesignStatus.ACTIVE:
			return "Current lines for your nation and filter"
		DesignManager.DesignStatus.PREVIOUSLY_USED:
			return "Older domestic lines — rebuilds and reserves"
		DesignManager.DesignStatus.OBSOLETE:
			return "Aged out — export or emergency production"
		_:
			return ""


const DESIGN_LIST_LABEL_MAX_LEN := 72


func _truncate_list_label(text: String, max_len: int = DESIGN_LIST_LABEL_MAX_LEN) -> String:
	if text.length() <= max_len:
		return text
	return text.left(maxi(1, max_len - 1)) + "…"


func _design_list_label(
	design_id: String,
	status: DesignManager.DesignStatus,
	is_foreign: bool,
	locked_section: bool,
) -> String:
	var display := design_id
	if GameData.design_data != null:
		var template: UnitTemplate = GameData.design_data.get_template(design_id)
		if template != null and not template.display_name.is_empty():
			display = template.display_name

	var origin := "◇ Universal"
	if typeof(DesignManager) != TYPE_NIL:
		origin = DesignManager.format_origin_badge(country_tag, design_id)

	var status_mark := ""
	match status:
		DesignManager.DesignStatus.PREVIOUSLY_USED:
			status_mark = "↺ "
		DesignManager.DesignStatus.OBSOLETE:
			status_mark = "⏳ "

	var role_mark := ""
	if (
		not locked_section
		and typeof(DesignManager) != TYPE_NIL
		and DesignManager.is_only_design_in_role(country_tag, design_id)
	):
		role_mark = "★ "

	var year := ""
	if typeof(DesignManager) != TYPE_NIL:
		year = "  ·  %s" % DesignManager.get_unlock_year(design_id)

	var badge := "[%s]" % origin
	var meta := year
	if typeof(DesignManager) != TYPE_NIL and not DesignManager.is_design_factory_compatible(
		design_id,
		_get_factory(),
	):
		meta += "  ·  ⚓ Shipyard"

	# Name-first: title │ [origin badge] │ year
	var line := "%s%s%s  │  %s  │%s" % [role_mark, status_mark, display, badge, meta]

	if locked_section:
		line = "%s  │  %s  │  %s  │%s" % [
			_lock_prefix(design_id),
			display,
			badge,
			meta,
		]
	elif typeof(TechnologyManager) != TYPE_NIL:
		var availability: Dictionary = TechnologyManager.get_design_availability(country_tag, design_id)
		if not bool(availability.get("available", true)):
			line += "  ·  🔒 " + str(availability.get("reason", "Locked"))

	return _truncate_list_label(line)


func _lock_prefix(design_id: String) -> String:
	return _lock_suffix(design_id).replace("🔒 ", "🔒 RESEARCH: ")


func _lock_suffix(design_id: String) -> String:
	if typeof(TechnologyManager) == TYPE_NIL:
		return "🔒 Research required"
	var availability: Dictionary = TechnologyManager.get_design_availability(country_tag, design_id)
	var tech_name := str(availability.get("tech_name", "")).strip_edges()
	if not tech_name.is_empty():
		return "🔒 Needs %s" % tech_name
	return "🔒 %s" % str(availability.get("reason", "Research required"))


func _apply_row_color(
	row_idx: int,
	design_id: String,
	status: DesignManager.DesignStatus,
	is_foreign: bool,
	locked_section: bool,
) -> void:
	if locked_section:
		var locked_base := LOCKED_ROW_BASE
		if is_foreign and typeof(DesignManager) != TYPE_NIL:
			locked_base = locked_base.lerp(
				DesignManager.acquisition_row_color(country_tag, design_id),
				0.35,
			)
		design_list.set_item_custom_fg_color(row_idx, locked_base.lerp(RetrowaveTheme.TEXT_PRIMARY, 0.12))
		return
	if (
		not is_foreign
		and typeof(DesignManager) != TYPE_NIL
		and DesignManager.is_only_design_in_role(country_tag, design_id)
	):
		design_list.set_item_custom_fg_color(row_idx, RetrowaveTheme.SUCCESS)
		return
	if is_foreign and typeof(DesignManager) != TYPE_NIL:
		design_list.set_item_custom_fg_color(
			row_idx,
			DesignManager.acquisition_row_color(country_tag, design_id),
		)
		return
	if typeof(DesignManager) != TYPE_NIL:
		var nation := DesignManager.get_design_nation_tag(design_id)
		if nation.is_empty():
			design_list.set_item_custom_fg_color(row_idx, ROW_UNIVERSAL)
			return
		if status == DesignManager.DesignStatus.ACTIVE:
			design_list.set_item_custom_fg_color(row_idx, ROW_DOMESTIC)
			return
	match status:
		DesignManager.DesignStatus.PREVIOUSLY_USED:
			design_list.set_item_custom_fg_color(row_idx, HEADER_PREVIOUS)
		DesignManager.DesignStatus.OBSOLETE:
			design_list.set_item_custom_fg_color(row_idx, HEADER_OBSOLETE)
		_:
			if (
				typeof(DesignManager) != TYPE_NIL
				and DesignManager.get_design_domain(design_id) == DesignManager.DOMAIN_SPACE
			):
				design_list.set_item_custom_fg_color(row_idx, RetrowaveTheme.MAGENTA)
			else:
				design_list.set_item_custom_fg_color(row_idx, RetrowaveTheme.TEXT_PRIMARY)


func _sync_list_scroll_size() -> void:
	var row_h := float(design_list.get_theme_constant("v_separation", "ItemList")) + 22.0
	var content_h := float(maxi(design_list.get_item_count(), 1)) * row_h
	var vp_size := get_viewport().get_visible_rect().size
	var viewport_budget := clampf(float(vp_size.y) * 0.85 - 320.0, float(MIN_LIST_HEIGHT), float(MAX_LIST_HEIGHT))
	design_list.custom_minimum_size.y = content_h
	list_scroll.custom_minimum_size.y = clampf(content_h, float(MIN_LIST_HEIGHT), viewport_budget)


func _scroll_list_to_top() -> void:
	list_scroll.set_deferred("scroll_vertical", 0)


func _is_design_selectable(design_id: String) -> bool:
	if typeof(DesignManager) != TYPE_NIL:
		if not DesignManager.is_design_factory_compatible(design_id, _get_factory()):
			return false
	if typeof(TechnologyManager) == TYPE_NIL:
		return true
	return bool(
		TechnologyManager.factory_can_build_design(country_tag, _get_factory(), design_id).get(
			"allowed",
			true,
		)
	)


func _on_search_changed(_new_text: String) -> void:
	_update_legend_visibility()
	_rebuild_list()


func _on_filters_changed(_value: Variant = null) -> void:
	_update_filter_labels()
	_rebuild_list()


func _update_filter_labels() -> void:
	show_obsolete_check.text = (
		"Showing older designs" if show_obsolete_check.button_pressed else "Show older designs"
	)
	show_obsolete_check.tooltip_text = (
		"Show Previously Used and Obsolete sections (domestic and foreign)"
		if not show_obsolete_check.button_pressed
		else "Hide Previously Used and Obsolete sections"
	)


func _update_default_lock_hint() -> void:
	if not selected_design.is_empty():
		return
	_update_summary_hint(_fetch_catalog())


func _update_lock_hint() -> void:
	if selected_design.is_empty():
		_update_default_lock_hint()
		return

	var parts: PackedStringArray = []
	if typeof(DesignManager) != TYPE_NIL:
		parts.append(DesignManager.format_origin_badge(country_tag, selected_design))
		match DesignManager.get_design_status(country_tag, selected_design):
			DesignManager.DesignStatus.PREVIOUSLY_USED:
				parts.append("Previously used — still buildable")
			DesignManager.DesignStatus.OBSOLETE:
				parts.append("Obsolete — export or emergency OK")

	if (
		typeof(DesignManager) != TYPE_NIL
		and not DesignManager.is_design_factory_compatible(selected_design, _get_factory())
	):
		lock_hint_label.text = " · ".join(parts) + " · Requires shipyard factory at a port."
		return

	var availability: Dictionary = (
		TechnologyManager.get_design_availability(country_tag, selected_design)
		if typeof(TechnologyManager) != TYPE_NIL
		else {"available": true}
	)
	if bool(availability.get("available", true)):
		if (
			typeof(DesignManager) != TYPE_NIL
			and DesignManager.is_only_design_in_role(country_tag, selected_design)
		):
			parts.append("★ Only design in this role")
		parts.append("Ready to assign")
		lock_hint_label.text = " · ".join(parts)
	else:
		parts.append(_lock_suffix(selected_design))
		lock_hint_label.text = " · ".join(parts)


func _on_design_selected(index: int) -> void:
	if index < 0 or index >= _list_entries.size():
		selected_design = ""
		confirm_button.disabled = true
		_update_lock_hint()
		return

	var entry: Dictionary = _list_entries[index]
	if bool(entry.get("is_header", false)) or bool(entry.get("locked", false)):
		selected_design = ""
		confirm_button.disabled = true
		design_list.deselect(index)
		_update_lock_hint()
		return

	selected_design = str(entry.get("design_id", ""))
	confirm_button.disabled = not _is_design_selectable(selected_design)
	_update_lock_hint()


func _on_confirm_pressed() -> void:
	if selected_design.is_empty() or not _is_design_selectable(selected_design):
		return
	var warning_scene: PackedScene = load("res://scenes/ui/RetoolingWarningPopup.tscn")
	if warning_scene == null:
		return
	var warning: RetoolingWarningPopup = warning_scene.instantiate() as RetoolingWarningPopup
	if warning == null:
		return
	warning.factory_id = factory_id
	warning.new_design = selected_design
	get_tree().root.add_child(warning)
	warning.popup_centered()
	queue_free()


func _on_cancel_pressed() -> void:
	queue_free()
