extends Node

func _ready() -> void:
	print("VIS| ===== INICIO VERIFICACION VISUAL =====")
	var loader := ScenarioLoader.new()
	add_child(loader)
	loader.load_scenario("1879")

	# Instanciar el WorldMap (MapRenderer) y darle los datos del mapa.
	var world: MapRenderer = preload("res://scenes/WorldMap.tscn").instantiate()
	add_child(world)
	var md := loader.get_map_data()
	world.initialize(md.provinces, md.geometry, md.adjacency_system, md.countries)
	print("VIS| provincias renderizadas=%d" % world.province_nodes.size())

	# Colocar una formación de Chile en Santiago (90) y dibujar iconos.
	var fs := LeaderManager.get_formations_for_country("CHL")
	if not fs.is_empty():
		fs[0].province_id = 90
	UnitMovementSystem.set_player_tag("CHL")
	world.draw_unit_icons()
	var icon_layer := world.get_node_or_null("ProvinceContainers/UnitIcons")
	print("VIS| iconos de unidad dibujados=%d" % (icon_layer.get_child_count() if icon_layer != null else -1))

	# Probar resaltados (no deben fallar).
	world.highlight_selected_province(90)
	world.highlight_valid_move_targets(UnitMovementSystem.get_adjacent_provinces(90))
	print("VIS| resaltado selección pid=%d destinos=%d" % [world._move_selected_pid, world._move_target_pids.size()])
	world.clear_province_highlight()
	world.clear_move_highlights()
	print("VIS| tras limpiar: sel=%d destinos=%d" % [world._move_selected_pid, world._move_target_pids.size()])

	print("VIS| ===== FIN VERIFICACION =====")
	get_tree().quit()
