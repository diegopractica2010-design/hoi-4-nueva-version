extends Node

func _ready() -> void:
	print("MOV| ===== INICIO VERIFICACION MOVIMIENTO =====")
	var loader := ScenarioLoader.new()
	add_child(loader)
	loader.load_scenario("1879")

	UnitMovementSystem.set_player_tag("CHL")

	# Tomar una formación de Chile y colocarla en Santiago (provincia 90).
	var formations := LeaderManager.get_formations_for_country("CHL")
	if formations.is_empty():
		print("MOV| no hay formaciones CHL"); get_tree().quit(); return
	var f: Formation = formations[0]
	f.province_id = 90
	print("MOV| formación '%s' colocada en provincia %d" % [f.formation_id, f.province_id])

	var adj := UnitMovementSystem.get_adjacent_provinces(90)
	print("MOV| adyacentes a 90 = %s" % str(adj))
	if adj.is_empty():
		print("MOV| provincia 90 sin adyacencias"); get_tree().quit(); return
	var target: int = int(adj[0])

	# 1) Clic en 90 → debe seleccionar la formación.
	UnitMovementSystem.on_province_clicked(90)
	print("MOV| tras clic en 90: seleccionada='%s' prov=%d" % [
		UnitMovementSystem.selected_formation_id, UnitMovementSystem.selected_province_id])

	# 2) Validaciones.
	print("MOV| is_province_adjacent(90,%d)=%s" % [target, UnitMovementSystem.is_province_adjacent(90, target)])
	print("MOV| can_move_to('%s',%d)=%s" % [f.formation_id, target, UnitMovementSystem.can_move_to(f.formation_id, target)])

	# 3) Clic en provincia adyacente → debe ejecutar el movimiento.
	UnitMovementSystem.on_province_clicked(target)
	print("MOV| tras mover: formación.province_id=%d (esperado %d) | selección='%s'" % [
		f.province_id, target, UnitMovementSystem.selected_formation_id])

	# 4) Clic en provincia NO adyacente con la formación re-colocada y re-seleccionada.
	f.province_id = 90
	UnitMovementSystem.on_province_clicked(90)
	UnitMovementSystem.on_province_clicked(9999)  # inexistente / no adyacente
	print("MOV| movimiento a no-adyacente: formación sigue en %d (esperado 90)" % f.province_id)

	print("MOV| ===== FIN VERIFICACION =====")
	get_tree().quit()
