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
