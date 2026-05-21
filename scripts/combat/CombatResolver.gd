class_name CombatResolver
extends Node

## Central place for resolving battles. Equipment stats, leaders, terrain, and width.


func get_effective_combat_power(
	division_template_id: String,
	unit_id: String = "",
	army_id: String = "",
	terrain: String = "plains",
) -> Dictionary:
	var base_stats := ProductionManager.get_division_final_combat_stats(division_template_id, unit_id)

	if base_stats.is_empty():
		return {}

	var final_soft := float(base_stats.get("soft_attack", 0.0))
	var final_hard := float(base_stats.get("hard_attack", 0.0))
	var final_readiness := float(base_stats.get("readiness", 1.0))
	var final_org := 1.0

	# Leader modifiers
	var leader: Leader = null
	var terrain_bonus := 0.0
	if not army_id.is_empty() and LeaderManager != null:
		leader = LeaderManager.get_leader_for_army(army_id)

	if leader != null and not leader.is_injured and not leader.is_captured:
		final_soft += leader.get_attack_modifier() * 10.0
		final_hard += leader.get_attack_modifier() * 6.0
		final_org += leader.get_organization_modifier()
		final_readiness += leader.get_logistics_modifier() * 0.5

		terrain_bonus = leader.get_terrain_modifier(terrain)
		final_soft += terrain_bonus * 8.0
		final_hard += terrain_bonus * 5.0

	return {
		"soft_attack": final_soft,
		"hard_attack": final_hard,
		"readiness": clampf(final_readiness, 0.3, 1.8),
		"organization": clampf(final_org, 0.4, 1.5),
		"supply_consumption": float(base_stats.get("supply_consumption", 1.0)),
		"has_shortages": bool(base_stats.get("has_shortages", false)),
		"leader_name": leader.name if leader != null else "No Leader",
		"leader_attack_bonus": leader.get_attack_modifier() if leader != null else 0.0,
		"terrain": terrain,
		"terrain_bonus_applied": terrain_bonus,
	}


## Call once when a battle concludes (not during power previews).
func resolve_combat_experience(
	attacker_army_id: String = "",
	defender_army_id: String = "",
	intensity: float = 1.0,
) -> Dictionary:
	var results := {
		"attacker_casualty": {},
		"defender_casualty": {},
	}
	if typeof(LeaderManager) == TYPE_NIL:
		return results
	if not attacker_army_id.is_empty():
		LeaderManager.award_combat_experience_for_army(attacker_army_id, intensity)
		results["attacker_casualty"] = LeaderManager.roll_combat_battle_casualty(
			attacker_army_id,
			intensity,
		)
	if not defender_army_id.is_empty():
		LeaderManager.award_combat_experience_for_army(defender_army_id, intensity * 0.65)
		results["defender_casualty"] = LeaderManager.roll_combat_battle_casualty(
			defender_army_id,
			intensity * 0.65,
		)
	return results


## Call when a formation is eliminated; ~30% chance of leader death or capture.
func resolve_formation_destroyed(formation_id: String) -> Dictionary:
	if typeof(LeaderManager) == TYPE_NIL or formation_id.is_empty():
		return {"type": "none", "leader_id": ""}
	return LeaderManager.handle_formation_destroyed(formation_id)


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
	var loader_node: Node = tree.root.find_child("ScenarioLoader", true, false)
	return loader_node as ScenarioLoader
