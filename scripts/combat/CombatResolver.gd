class_name CombatResolver
extends Node

## Central place for resolving battles. Starts with equipment-driven effective combat power.


func get_effective_combat_power(division_template_id: String, unit_id: String = "") -> Dictionary:
	var base_stats: Dictionary = ProductionManager.get_division_final_combat_stats(
		division_template_id, unit_id,
	)

	if base_stats.is_empty():
		return {}

	# Placeholder for future modifiers (terrain, weather, leaders, etc.)
	var final_soft := float(base_stats.get("soft_attack", 0.0))
	var final_hard := float(base_stats.get("hard_attack", 0.0))
	var final_readiness := float(base_stats.get("readiness", 1.0))
	var final_org := 1.0  # Will come from unit state later

	return {
		"soft_attack": final_soft * final_readiness,
		"hard_attack": final_hard * final_readiness,
		"readiness": final_readiness,
		"organization": final_org,
		"supply_consumption": float(base_stats.get("supply_consumption", 1.0)),
		"has_shortages": bool(base_stats.get("has_shortages", false)),
	}


func get_combat_width_for_battle(
	attacker_province_id: int,
	defender_province_id: int,
	terrain: String = "",
) -> float:
	var attacker_infra := 2
	var defender_infra := 2
	var battle_terrain := terrain

	var loader := _find_scenario_loader()
	if loader != null:
		if loader.provinces.has(attacker_province_id):
			var attacker: Province = loader.provinces[attacker_province_id]
			attacker_infra = attacker.infrastructure
			if battle_terrain.is_empty():
				battle_terrain = attacker.terrain
		if loader.provinces.has(defender_province_id):
			var defender: Province = loader.provinces[defender_province_id]
			defender_infra = defender.infrastructure
			if battle_terrain.is_empty():
				battle_terrain = defender.terrain

	if battle_terrain.is_empty():
		battle_terrain = "plains"

	var calculator := CombatWidthCalculator.new()
	var width := calculator.get_effective_combat_width(attacker_infra, defender_infra, battle_terrain)
	calculator.free()
	return width


func _find_scenario_loader() -> ScenarioLoader:
	var tree := Engine.get_main_loop()
	if tree == null:
		return null
	var runner := tree.root.find_child("ScenarioLoader", true, false)
	return runner as ScenarioLoader
