class_name MapRenderer
extends Node2D

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

var province_nodes: Dictionary = {}
var current_hover: Node2D = null

# ==================== CAMERA CONTROLS ====================
var camera: Camera2D

@export var pan_speed: float = 800.0
@export var edge_scroll_speed: float = 900.0
@export var edge_margin: float = 50.0
@export var zoom_speed: float = 0.12
@export var min_zoom: float = 0.2
@export var max_zoom: float = 5.0

func _ready():
	# Make sure info panel starts closed
	if info_panel:
		info_panel.visible = false
	
	if btn_close:
		btn_close.pressed.connect(hide_info_panel)
	
	_setup_camera()
	print("MapRenderer _ready() completed - Camera should be working now")

func _unhandled_input(event: InputEvent) -> void:
	# Also allow closing info panel with Escape
	if event.is_action_pressed("ui_cancel"):   # Escape key
		if info_panel and info_panel.visible:
			hide_info_panel()
			return
	
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_zoom_toward_mouse(1.0 + zoom_speed)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_zoom_toward_mouse(1.0 - zoom_speed)

func _setup_camera():
	camera = get_node_or_null("Camera2D")
	if not camera:
		camera = Camera2D.new()
		camera.name = "Camera2D"
		add_child(camera)
	
	camera.enabled = true
	camera.make_current()
	camera.zoom = Vector2(0.85, 0.85)
	print("✅ Camera2D created and activated")

func _process(delta: float) -> void:
	if not camera: return
	_handle_keyboard_pan(delta)
	_handle_edge_scroll(delta)

func _zoom_toward_mouse(zoom_change: float) -> void:
	if not camera: return
	
	var mouse_screen = get_viewport().get_mouse_position()
	var old_zoom = camera.zoom
	
	var new_zoom = old_zoom * zoom_change
	new_zoom.x = clamp(new_zoom.x, min_zoom, max_zoom)
	new_zoom.y = clamp(new_zoom.y, min_zoom, max_zoom)
	
	if new_zoom == old_zoom: return
	
	var world_before = camera.get_canvas_transform().affine_inverse() * mouse_screen
	camera.zoom = new_zoom
	var world_after = camera.get_canvas_transform().affine_inverse() * mouse_screen
	camera.global_position += world_before - world_after

func _handle_keyboard_pan(delta: float) -> void:
	var dir = Vector2.ZERO
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP): dir.y -= 1
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN): dir.y += 1
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT): dir.x -= 1
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT): dir.x += 1
	
	if dir != Vector2.ZERO:
		dir = dir.normalized()
		camera.global_position += dir * pan_speed * delta

func _handle_edge_scroll(delta: float) -> void:
	var mouse = get_viewport().get_mouse_position()
	var size = get_viewport().get_visible_rect().size
	var dir = Vector2.ZERO
	
	if mouse.x < edge_margin: dir.x -= 1
	elif mouse.x > size.x - edge_margin: dir.x += 1
	if mouse.y < edge_margin: dir.y -= 1
	elif mouse.y > size.y - edge_margin: dir.y += 1
	
	if dir != Vector2.ZERO:
		dir = dir.normalized()
		camera.global_position += dir * edge_scroll_speed * delta

# ==================== MAP RENDERING & INFO PANEL (rest unchanged) ====================

func render_provinces(loader: ScenarioLoader):
	for child in container.get_children():
		child.queue_free()
	province_nodes.clear()

	var provinces = loader.provinces.values()
	print("Rendering map with ", provinces.size(), " provinces")

	for province in provinces:
		var prov_node = Node2D.new()
		prov_node.name = "Prov_" + str(province.id)
		var column = (province.id - 1) % 13
		var row = (province.id - 1) / 13
		prov_node.position = Vector2(column * 118, row * 82)

		var bg = ColorRect.new()
		bg.size = Vector2(112, 72)
		bg.color = Color(0.18, 0.18, 0.22, 0.85)
		if province.owner_tag != "":
			var country = loader.get_country(province.owner_tag)
			if country:
				bg.color = country.color
				bg.color.a = 0.92
		
		bg.mouse_filter = Control.MOUSE_FILTER_STOP
		bg.gui_input.connect(_on_province_clicked.bind(province))
		bg.mouse_entered.connect(_on_mouse_entered.bind(prov_node))
		bg.mouse_exited.connect(_on_mouse_exited.bind(prov_node))
		prov_node.add_child(bg)

		if "capital" in province.special_features:
			var star = Label.new()
			star.text = "⭐"
			star.add_theme_font_size_override("font_size", 28)
			star.position = Vector2(6, 2)
			prov_node.add_child(star)

		var icon_x = 8
		var count = 0
		for feature in province.special_features:
			if feature == "capital": continue
			if count >= 5: break
			var icon = Label.new()
			icon.text = get_feature_icon(feature)
			icon.add_theme_font_size_override("font_size", 24)
			icon.position = Vector2(icon_x, 40)
			prov_node.add_child(icon)
			icon_x += 26
			count += 1

		container.add_child(prov_node)
		province_nodes[province.id] = prov_node

	print("✅ Map rendered")

func _on_mouse_entered(prov_node: Node2D):
	current_hover = prov_node
	prov_node.scale = Vector2(1.08, 1.08)

func _on_mouse_exited(prov_node: Node2D):
	if current_hover == prov_node:
		prov_node.scale = Vector2(1.0, 1.0)
		current_hover = null

func _on_province_clicked(event: InputEvent, province):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		show_info_panel(province)

func show_info_panel(province):
	if not info_panel: return
	info_name.text = province.name
	info_owner.text = "Owner: " + province.owner_tag if province.owner_tag != "" else "Owner: None"
	info_population.text = "Population: " + str(province.population)
	info_terrain.text = "Terrain: " + province.terrain.capitalize()
	info_factories.text = "Factories: " + str(province.factories)
	info_dev.text = "Development: " + str(province.development_level)
	
	var res_text = "Resources: "
	if province.resources.size() > 0:
		for key in province.resources:
			res_text += key.capitalize() + ": " + str(province.resources[key]) + " "
	else:
		res_text += "None"
	info_resources.text = res_text.strip_edges()
	
	var core_text = "Core For: "
	if province.core_for_tags.size() > 0:
		core_text += ", ".join(province.core_for_tags)
	else:
		core_text += "None"
	info_core.text = core_text
	
	var special_list = []
	for feature in province.special_features:
		var icon = get_feature_icon(feature)
		var nice_name = feature.capitalize().replace("_", " ")
		var level = province.special_levels.get(feature, 1)
		if level > 1:
			special_list.append(icon + " " + nice_name + " (Lv." + str(level) + ")")
		else:
			special_list.append(icon + " " + nice_name)
	
	var special_text = "Special: "
	if special_list.size() > 0:
		special_text += ", ".join(special_list)
	else:
		special_text += "None"
	info_special.text = special_text
	
	info_panel.visible = true

func get_feature_icon(feature: String) -> String:
	match feature.to_lower():
		"capital": return "⭐"
		"port": return "⚓"
		"naval_shipyard": return "⚙️"
		"airfield": return "✈️"
		"fort": return "🛡️"
		"research_center": return "🔬"
		"coal_plant": return "🏭"
		"gas_plant": return "🔥"
		"oil_rig": return "⛽"
		"major_factory": return "🛠️"
		"nuclear_plant": return "☢️"
		"fusion_plant": return "⚡"
		"mission_control": return "📡"
		"spaceport": return "🚀"
		"dam": return "🌊"
		_: return "📍"

func hide_info_panel():
	if info_panel:
		info_panel.visible = false
