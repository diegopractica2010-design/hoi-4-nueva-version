extends Node

func _ready() -> void:
	print("P4| ===== INICIO VALIDACION FASE 4 =====")
	var dm = get_node_or_null("/root/DesignManager")
	var fm = get_node_or_null("/root/FactoryManager")
	var pm = get_node_or_null("/root/ProductionManager")
	var tm = get_node_or_null("/root/TimeManager")
	print("P4| DesignManager presente=%s" % (dm != null))
	print("P4| FactoryManager presente=%s" % (fm != null))
	print("P4| ProductionManager presente=%s" % (pm != null))
	print("P4| TimeManager presente=%s" % (tm != null))

	# Inyeccion de dependencia: DesignManager debe haberse conectado a TimeManager
	if dm != null and tm != null and tm.has_signal("game_year_advanced"):
		print("P4| DesignManager conectado a TimeManager.game_year_advanced=%s" % tm.game_year_advanced.is_connected(dm._on_game_year_advanced))

	# Integracion basica: metodos esperados por FactoryManager/ProductionManager
	if dm != null:
		print("P4| DM tiene try_grant_captured_designs_from_factory=%s" % dm.has_method("try_grant_captured_designs_from_factory"))
		print("P4| DM tiene mark_design_used=%s" % dm.has_method("mark_design_used"))
		print("P4| DM get_current_year=%s" % str(dm.get_current_year()))

	# Escenario 1879
	print("P4| --- ESCENARIO 1879 ---")
	var loader = ScenarioLoader.new()
	add_child(loader)
	var ok: bool = loader.load_scenario("1879")
	print("P4| load_scenario('1879') ok=%s" % ok)
	print("P4| provincias=%d paises=%d" % [loader.provinces.size(), loader.countries.size()])

	print("P4| ===== FIN VALIDACION FASE 4 =====")
	get_tree().quit()
