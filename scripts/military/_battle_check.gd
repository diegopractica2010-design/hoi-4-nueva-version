extends Node

func _ready() -> void:
	print("BAT| ===== INICIO VERIFICACION BATALLA =====")
	var loader := ScenarioLoader.new()
	add_child(loader)
	loader.load_scenario("1879")

	BattleManager.battle_started.connect(func(pid, atk, defe):
		print("BAT| battle_started prov=%d %s vs %s" % [pid, atk, defe]))
	BattleManager.battle_resolved.connect(func(pid, win, lose, res):
		print("BAT| battle_resolved prov=%d winner=%s loser=%s atkPow=%.1f defPow=%.1f bajasA=%d bajasD=%d" % [
			pid, win, lose, res["attacker_power"], res["defender_power"],
			res["attacker_casualties"], res["defender_casualties"]]))
	BattleManager.province_captured.connect(func(pid, new_owner, old_owner):
		print("BAT| province_captured prov=%d %s -> %s" % [pid, old_owner, new_owner]))

	var chl := LeaderManager.get_formations_for_country("CHL")
	var per := LeaderManager.get_formations_for_country("PER")
	if chl.is_empty() or per.is_empty():
		print("BAT| faltan formaciones"); get_tree().quit(); return

	var P := 92
	var prov: Province = MapManager.get_province(P)
	prov.owner_tag = "PER"
	prov.controller_tag = "PER"
	print("BAT| provincia %d controlada por %s al inicio" % [P, prov.controller_tag])

	# Colocar atacante (CHL) y defensor (PER) en la misma provincia.
	per[0].province_id = P
	chl[0].province_id = P

	# Simular que CHL acaba de moverse a P (dispara la detección de batalla).
	BattleManager._on_formation_moved(chl[0].formation_id, P)

	var after: Province = MapManager.get_province(P)
	print("BAT| provincia %d controlada por %s tras la batalla" % [P, after.controller_tag])
	print("BAT| historial de batallas=%d" % BattleManager.get_battle_history().size())
	print("BAT| ===== FIN VERIFICACION =====")
	get_tree().quit()
