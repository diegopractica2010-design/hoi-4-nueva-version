# scripts/map/MapRenderer.gd
# class_name MapRenderer
extends Node2D

#region Exports
@export var container: Node2D
@export var info_panel: Panel
@export var info_name: Label
@export var info_owner: Label
@export var info_population: Label
@export var info_terrain: Label
@export var info_factories: Label
@export var info_dev: Label
@export var info_resources: Label
@export var info_core: Label
@export var info_special: Label
@export var btn_close: Button

#region Province names (visible at lower zoom when enabled)
@export var show_province_names: bool = false
@export var province_name_font_size: int = 11
@export var province_name_color: Color = Color(1, 1, 1, 0.85)
#endregion

#region Hover name
@export var show_hover_province_name: bool = true
## When false, the hover name stays anchored near the cached centroid.
@export var hover_name_follow_mouse: bool = false
#endregion

#region Feature markers
@export var feature_icon_ring_radius: float = 28.0
## Labels/icons on provinces stay hidden until container scale exceeds this (axis assumed uniform).
@export var province_detail_min_zoom: float = 0.8
#endregion

#region Debug
@export var debug_draw_province_centroids: bool = false
#endregion
#endregion

var provinces: Dictionary = {}
var geometry: Dictionary = {}
var countries: Dictionary = {}           # tag -> Country (must have .color)
var adjacency: AdjacencySystem

var province_nodes: Dictionary = {}
## Province id -> centroid in province-node local space (matches polygon coordinates).
var province_centroids: Dictionary = {}
var _province_name_labels: Dictionary = {}
var current_hover: Node2D = null
var hover_label: Label = null

var selected_province_id: int = -1
var _selection_highlight: Polygon2D = null


func _ready():
	if btn_close == null:
		btn_close = get_node_or_null("UI/InfoPanel/BtnClose") as Button

	if btn_close:
		if not btn_close.pressed.is_connected(_on_close_pressed):
			btn_close.pressed.connect(_on_close_pressed)
	else:
		push_warning("MapRenderer: Could not find BtnClose!")

	if container == null:
		container = get_node_or_null("ProvinceContainers") as Node2D

	set_process(true)


func _on_close_pressed() -> void:
	hide_info_panel()


func _process(_delta: float) -> void:
	_refresh_province_detail_visibility()

	if hover_label == null or not hover_label.visible or current_hover == null:
		return
	if not hover_name_follow_mouse:
		return
	hover_label.position = get_local_mouse_position() + Vector2(14, -18)


func _refresh_province_detail_visibility() -> void:
	if container == null:
		return

	var current_zoom := absf(container.scale.x)
	var show_details := current_zoom > province_detail_min_zoom

	for id in _province_name_labels:
		var lbl: Variant = _province_name_labels[id]
		if lbl is Label and is_instance_valid(lbl):
			(lbl as Label).visible = show_province_names and show_details

	for pid in province_nodes:
		var node: Variant = province_nodes[pid]
		if node is Node2D and is_instance_valid(node):
			for child in (node as Node2D).get_children():
				if child is Label:
					(child as Label).visible = show_details


func initialize(p_provinces: Dictionary, p_geometry: Dictionary, p_adjacency: AdjacencySystem, p_countries: Dictionary = {}):
	provinces = p_provinces
	geometry = p_geometry
	adjacency = p_adjacency
	countries = p_countries
	render_provinces()


func render_provinces():
	if container == null:
		push_error("MapRenderer: container not assigned")
		return

	_clear_selection()
	for child in container.get_children():
		child.queue_free()
	province_nodes.clear()
	province_centroids.clear()
	_province_name_labels.clear()

	print("Rendering map with %d provinces using Polygon2D..." % provinces.size())

	for id in provinces.keys():
		var province: Province = provinces[id]
		if not geometry.has(id):
			continue

		var geo = geometry[id]
		var node := _create_province_node(province, geo)
		container.add_child(node)
		province_nodes[id] = node

	_refresh_province_detail_visibility()
	print("✅ Map rendered with real polygons")


func _create_province_node(province: Province, geo: Dictionary) -> Node2D:
	var node := Node2D.new()
	node.name = "Prov_%d" % province.id

	var points: PackedVector2Array = geo.get("points", PackedVector2Array())
	if points.size() < 3:
		return node

	var poly := Polygon2D.new()
	poly.polygon = points
	poly.color = _get_province_color(province)
	poly.antialiased = true

	var area := Area2D.new()
	var collision := CollisionPolygon2D.new()
	collision.polygon = points
	area.add_child(collision)
	area.input_event.connect(_on_province_input.bind(province, node))
	area.mouse_entered.connect(_on_mouse_entered.bind(node, province))
	area.mouse_exited.connect(_on_mouse_exited.bind(node))

	node.add_child(poly)
	node.add_child(area)

	var center := _calculate_centroid(points)
	province_centroids[province.id] = center

	if debug_draw_province_centroids:
		var marker := _make_centroid_debug_marker(4.0)
		marker.position = center
		node.add_child(marker)

	if province.has_feature("capital"):
		var star := Label.new()
		star.text = "⭐"
		star.mouse_filter = Control.MOUSE_FILTER_IGNORE
		star.add_theme_font_size_override("font_size", 22)
		star.position = center - Vector2(11, 11)
		node.add_child(star)

	var icon_dirs := _feature_icon_offsets_radial(_count_special_icons(province), feature_icon_ring_radius)
	var icon_i := 0
	for feature in province.special_features.keys():
		var fk := str(feature)
		if fk == "capital" or icon_i >= icon_dirs.size():
			continue
		var icon := Label.new()
		icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		icon.text = _get_feature_icon(fk)
		icon.add_theme_font_size_override("font_size", 15)
		var offs: Vector2 = icon_dirs[icon_i]
		icon.position = center + offs - Vector2(7, 7)
		node.add_child(icon)
		icon_i += 1

	_create_or_update_province_name_label(province, center)

	return node


func _create_or_update_province_name_label(province: Province, center: Vector2) -> void:
	if not show_province_names or container == null:
		return

	var label: Label
	if _province_name_labels.has(province.id):
		label = _province_name_labels[province.id]
		if not is_instance_valid(label):
			_province_name_labels.erase(province.id)
			label = null

	if label == null:
		label = Label.new()
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		label.z_index = 48
		container.add_child(label)
		_province_name_labels[province.id] = label

	label.add_theme_font_size_override("font_size", province_name_font_size)
	label.add_theme_color_override("font_color", province_name_color)
	label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.7))

	label.text = province.name
	label.reset_size()
	var ms := label.get_minimum_size()
	label.position = center - Vector2(ms.x * 0.5, 8)
	label.visible = true


func _count_special_icons(province: Province) -> int:
	var n := 0
	for feature in province.special_features.keys():
		if str(feature) != "capital":
			n += 1
	return mini(n, 4)


func _feature_icon_offsets_radial(count: int, radius: float) -> Array[Vector2]:
	var pts: Array[Vector2] = []
	if count <= 0:
		return pts
	## Spread icons along a downward-facing arc so they ring the centroid below the capital star.
	var mid_angle := PI * 0.5
	var span := clampf(PI * (0.42 + 0.11 * float(count - 1)), PI * 0.38, PI * 1.12)
	for i in count:
		var u := 0.5 if count == 1 else float(i) / float(count - 1)
		var ang := mid_angle - span * 0.5 + u * span
		pts.append(Vector2(cos(ang), sin(ang)) * radius)
	return pts


func _make_centroid_debug_marker(radius: float) -> Polygon2D:
	var poly := Polygon2D.new()
	var ring := PackedVector2Array()
	var segments := 12
	for i in segments:
		var a := TAU * float(i) / float(segments)
		ring.append(Vector2(cos(a), sin(a)) * radius)
	poly.polygon = ring
	poly.color = Color(1.0, 0.08, 0.06, 0.95)
	poly.z_index = 500
	return poly


func _calculate_centroid(points: PackedVector2Array) -> Vector2:
	if points.size() < 3:
		return points[0] if points.size() > 0 else Vector2.ZERO

	var area := 0.0
	var cx := 0.0
	var cy := 0.0

	for i in range(points.size()):
		var p1 := points[i]
		var p2 := points[(i + 1) % points.size()]

		var cross := p1.x * p2.y - p2.x * p1.y
		area += cross
		cx += (p1.x + p2.x) * cross
		cy += (p1.y + p2.y) * cross

	area *= 0.5

	if absf(area) < 0.0001:
		var sum := Vector2.ZERO
		for p in points:
			sum += p
		return sum / float(points.size())

	cx /= (6.0 * area)
	cy /= (6.0 * area)
	return Vector2(cx, cy)


func _get_province_color(province: Province) -> Color:
	var fallback := Color(0.35, 0.35, 0.4, 0.85)
	if province.owner_tag.is_empty() or not countries.has(province.owner_tag):
		return fallback
	var nation: Variant = countries[province.owner_tag]
	if nation is Country:
		var c := nation as Country
		var col := c.color
		col.a = 0.85
		return col
	if typeof(nation) == TYPE_DICTIONARY:
		var d: Dictionary = nation
		if d.has("color"):
			var co: Variant = d["color"]
			if typeof(co) == TYPE_COLOR:
				var cc := co as Color
				cc.a = 0.85
				return cc
			return Color(String(co))
	return fallback


# ====================== INTERACTION ======================

func _on_province_input(_viewport: Node, event: InputEvent, _shape_idx: int, province: Province, node: Node2D):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		show_info_panel(province)
		_select_province(province, node)


func _clear_selection() -> void:
	if _selection_highlight != null and is_instance_valid(_selection_highlight):
		_selection_highlight.queue_free()
	_selection_highlight = null
	selected_province_id = -1


func _select_province(province: Province, node: Node2D) -> void:
	_clear_selection()

	selected_province_id = province.id

	var poly: Polygon2D = node.get_child(0) as Polygon2D
	if poly:
		_selection_highlight = Polygon2D.new()
		_selection_highlight.polygon = poly.polygon
		_selection_highlight.color = Color(1, 1, 1, 0.15)
		_selection_highlight.z_index = 10
		node.add_child(_selection_highlight)


func _on_mouse_entered(node: Node2D, province: Province):
	current_hover = node
	node.scale = Vector2(1.05, 1.05)
	if show_hover_province_name:
		_show_hover_label(node, province)


func _on_mouse_exited(node: Node2D):
	if current_hover == node:
		node.scale = Vector2.ONE
		current_hover = null
		_hide_hover_label()


func _show_hover_label(node: Node2D, province: Province):
	if hover_label == null:
		hover_label = Label.new()
		hover_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		hover_label.add_theme_font_size_override("font_size", 14)
		hover_label.add_theme_color_override("font_color", Color.WHITE)
		hover_label.add_theme_color_override("font_shadow_color", Color.BLACK)
		add_child(hover_label)

	hover_label.text = province.name

	if hover_name_follow_mouse:
		hover_label.position = get_local_mouse_position() + Vector2(14, -18)
	elif province_centroids.has(province.id):
		var center: Vector2 = province_centroids[province.id] as Vector2
		hover_label.position = to_local(node.to_global(center)) + Vector2(0, -22)
	else:
		hover_label.position = get_local_mouse_position() + Vector2(12, -20)
	hover_label.visible = true


func _hide_hover_label():
	if hover_label:
		hover_label.visible = false


# ====================== INFO PANEL ======================

func show_info_panel(province: Province):
	if info_panel == null:
		return

	info_name.text = province.name
	info_owner.text = "Owner: " + province.owner_tag if province.owner_tag != "" else "Owner: None"
	info_population.text = "Population: %s" % str(province.population)
	info_terrain.text = "Terrain: " + province.terrain.capitalize()
	info_factories.text = "Factories: %d" % province.factories
	info_dev.text = "Development: %d" % province.development_level

	var res_text := "Resources: "
	if province.resources.size() > 0:
		for key in province.resources:
			res_text += "%s:%s " % [key, str(province.resources[key])]
	else:
		res_text += "None"
	info_resources.text = res_text.strip_edges()

	info_core.text = "Core For: " + (", ".join(province.core_for) if province.core_for.size() > 0 else "None")

	var special_list := []
	for feature in province.special_features.keys():
		var fk := str(feature)
		var level = province.special_features[feature]
		special_list.append("%s %s (Lv.%d)" % [_get_feature_icon(fk), fk.capitalize(), level])
	info_special.text = "Special: " + (", ".join(special_list) if special_list.size() > 0 else "None")

	info_panel.visible = true


func hide_info_panel():
	if info_panel:
		info_panel.visible = false


func _get_feature_icon(feature: String) -> String:
	match feature.to_lower():
		"port", "major_port": return "⚓"
		"naval_shipyard": return "⚙️"
		"airfield": return "✈️"
		"fort": return "🛡️"
		"research_center": return "🔬"
		"oil_rig", "oil": return "⛽"
		"nuclear_plant": return "☢️"
		"spaceport": return "🚀"
		"mega_factory", "major_factory": return "🏭"
		_: return "◆"
