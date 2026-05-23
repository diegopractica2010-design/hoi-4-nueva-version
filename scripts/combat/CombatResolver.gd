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

	var leader: Leader = null
	var leader_id := ""
	var terrain_bonus := 0.0
	if not army_id.is_empty() and typeof(LeaderManager) != TYPE_NIL:
		leader = LeaderManager.get_leader_for_army(army_id)
		if leader != null:
			leader_id = leader.leader_id

	var combat_stats := base_stats
	if not leader_id.is_empty():
		combat_stats = apply_training_path_modifiers(leader_id, base_stats)

	var final_soft := float(combat_stats.get("soft_attack", 0.0))
	var final_hard := float(combat_stats.get("hard_attack", 0.0))
	var final_readiness := float(combat_stats.get("readiness", 1.0))
	var final_org := float(combat_stats.get("organization", 1.0))

	if leader != null and not leader.is_injured and not leader.is_captured:
		final_soft += leader.get_attack_modifier() * 10.0
		final_hard += leader.get_attack_modifier() * 6.0
		final_org += leader.get_organization_modifier()
		final_readiness += leader.get_logistics_modifier() * 0.5

		terrain_bonus = leader.get_terrain_modifier(terrain)
		final_soft += terrain_bonus * 8.0
		final_hard += terrain_bonus * 5.0

	var training_path_bonus := float(combat_stats.get("training_path_soft_bonus", 0.0))

	return {
		"soft_attack": final_soft,
		"hard_attack": final_hard,
		"readiness": clampf(final_readiness, 0.3, 1.8),
		"organization": clampf(final_org, 0.4, 1.5),
		"supply_consumption": float(combat_stats.get("supply_consumption", 1.0)),
		"has_shortages": bool(base_stats.get("has_shortages", false)),
		"leader_name": leader.name if leader != null else "No Leader",
		"leader_id": leader_id,
		"leader_attack_bonus": leader.get_attack_modifier() if leader != null else 0.0,
		"training_path_soft_bonus": training_path_bonus,
		"training_path_modifiers": combat_stats.get("training_path_modifiers", {}),
		"terrain": terrain,
		"terrain_bonus_applied": terrain_bonus,
	}


# ============================================
# TRAINING PATH - COMBAT INTEGRATION
# ============================================

## Applies training path combat bonuses to a leader's core combat stat dictionary (additive).
func apply_training_path_combat_bonuses(leader_id: String, stats: Dictionary) -> Dictionary:
	if leader_id.is_empty() or typeof(LeaderManager) == TYPE_NIL:
		return stats

	var modifiers := LeaderManager.get_leader_training_path_combat_modifiers(leader_id)
	if modifiers.is_empty():
		return stats

	var modified_stats := stats.duplicate()

	if modifiers.has("attack") and modified_stats.has("attack"):
		modified_stats["attack"] = float(modified_stats["attack"]) + float(modifiers["attack"])
	if modifiers.has("defense") and modified_stats.has("defense"):
		modified_stats["defense"] = float(modified_stats["defense"]) + float(modifiers["defense"])
	if modifiers.has("initiative") and modified_stats.has("initiative"):
		modified_stats["initiative"] = float(modified_stats["initiative"]) + float(modifiers["initiative"])
	if modifiers.has("breakthrough") and modified_stats.has("breakthrough"):
		modified_stats["breakthrough"] = float(modified_stats["breakthrough"]) + float(modifiers["breakthrough"])
	if modifiers.has("planning") and modified_stats.has("planning"):
		modified_stats["planning"] = float(modified_stats["planning"]) + float(modifiers["planning"])

	return modified_stats


## Applies training path bonuses to division combat stats (before trait-based leader modifiers).
func apply_training_path_modifiers(leader_id: String, base_stats: Dictionary) -> Dictionary:
	if leader_id.is_empty() or typeof(LeaderManager) == TYPE_NIL:
		return base_stats

	var modifiers := LeaderManager.get_leader_training_path_combat_modifiers(leader_id)
	if modifiers.is_empty():
		return base_stats

	var modified := apply_training_path_combat_bonuses(leader_id, base_stats)
	var soft_bonus := 0.0
	var hard_bonus := 0.0

	if modifiers.has("attack"):
		var attack_levels := float(modifiers["attack"])
		soft_bonus += attack_levels * 1.5
		hard_bonus += attack_levels * 0.9

	if modifiers.has("defense"):
		var defense_levels := float(modifiers["defense"])
		modified["organization"] = float(modified.get("organization", 1.0)) + defense_levels * 0.05

	if modifiers.has("initiative"):
		var init_levels := float(modifiers["initiative"])
		modified["readiness"] = float(modified.get("readiness", 1.0)) + init_levels * 0.04

	if modifiers.has("planning"):
		var plan_levels := float(modifiers["planning"])
		modified["readiness"] = float(modified.get("readiness", 1.0)) + plan_levels * 0.03

	if modifiers.has("breakthrough"):
		var breakthrough := float(modifiers["breakthrough"])
		soft_bonus += breakthrough * 8.0
		hard_bonus += breakthrough * 5.0

	if modifiers.has("combined_arms_sync"):
		var sync := float(modifiers["combined_arms_sync"])
		soft_bonus += sync * 8.0
		hard_bonus += sync * 5.0
		modified["combined_arms_sync"] = float(modified.get("combined_arms_sync", 0.0)) + sync

	if modifiers.has("organization_recovery"):
		var recovery := float(modifiers["organization_recovery"])
		modified["organization"] = float(modified.get("organization", 1.0)) + recovery * 0.5
		modified["organization_recovery"] = float(modified.get("organization_recovery", 0.0)) + recovery

	modified["soft_attack"] = float(modified.get("soft_attack", 0.0)) + soft_bonus
	modified["hard_attack"] = float(modified.get("hard_attack", 0.0)) + hard_bonus
	modified["training_path_soft_bonus"] = soft_bonus
	modified["training_path_modifiers"] = modifiers
	return modified


## Call once when a battle concludes (not during power previews).
func resolve_combat_experience(
	attacker_army_id: String = "",
	defender_army_id: String = "",
	intensity: float = 1.0,
	battle_result: Dictionary = {},
) -> Dictionary:
	return resolve_battle_aftermath(attacker_army_id, defender_army_id, battle_result, intensity)


## Awards combat XP, rolls leader casualties, returns summary for UI/debug.
func resolve_battle_aftermath(
	attacker_army_id: String = "",
	defender_army_id: String = "",
	battle_result: Dictionary = {},
	intensity: float = 1.0,
) -> Dictionary:
	var results := {
		"attacker_casualty": {},
		"defender_casualty": {},
		"attacker_xp": 0,
		"defender_xp": 0,
	}
	if typeof(LeaderManager) == TYPE_NIL:
		return results

	var xp_context := battle_result.duplicate()
	if not xp_context.has("intensity"):
		xp_context["intensity"] = intensity

	var attacker_leader_id := LeaderManager.get_leader_id_for_army(attacker_army_id)
	var defender_leader_id := LeaderManager.get_leader_id_for_army(defender_army_id)

	if not xp_context.is_empty() or attacker_leader_id != "" or defender_leader_id != "":
		var normalized := _normalize_battle_result(xp_context, intensity)
		award_xp_from_combat(attacker_leader_id, defender_leader_id, normalized)
		if attacker_leader_id != "":
			results["attacker_xp"] = _total_combat_xp_for_leader(attacker_leader_id, normalized, 1.0)
		if defender_leader_id != "":
			var defender_scale := 1.0
			if str(normalized.get("outcome", "")) != "heroic_defense":
				defender_scale = 0.85
			results["defender_xp"] = _total_combat_xp_for_leader(
				defender_leader_id,
				normalized,
				defender_scale,
			)
	elif not attacker_army_id.is_empty() or not defender_army_id.is_empty():
		# Legacy fallback when no battle_result dict is provided.
		if not attacker_army_id.is_empty():
			LeaderManager.award_combat_experience_for_army(attacker_army_id, intensity)
		if not defender_army_id.is_empty():
			LeaderManager.award_combat_experience_for_army(defender_army_id, intensity * 0.65)

	if not attacker_army_id.is_empty():
		results["attacker_casualty"] = LeaderManager.roll_combat_battle_casualty(
			attacker_army_id,
			intensity,
		)
	if not defender_army_id.is_empty():
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


# ============================================
# XP SYSTEM - Combat Integration
# ============================================

## Awards XP to leaders after a battle has resolved. Call after combat is finalized.
func award_xp_from_combat(
	attacker_leader_id: String,
	defender_leader_id: String,
	battle_result: Dictionary,
) -> void:
	if typeof(LeaderManager) == TYPE_NIL:
		return

	if not attacker_leader_id.is_empty():
		_apply_combat_xp_to_leader(attacker_leader_id, battle_result, 1.0)

	if not defender_leader_id.is_empty():
		var defender_scale := 1.0
		if str(battle_result.get("outcome", "")) != "heroic_defense":
			defender_scale = 0.85
		_apply_combat_xp_to_leader(defender_leader_id, battle_result, defender_scale)


func _apply_combat_xp_to_leader(
	leader_id: String,
	battle_result: Dictionary,
	scale: float = 1.0,
) -> int:
	var xp_data := _calculate_combat_xp(battle_result, leader_id)
	var total := int(xp_data.get("total_xp", 12))
	total = maxi(int(float(total) * clampf(scale, 0.25, 4.0)), 1)
	xp_data["total_xp"] = total
	LeaderManager.award_combat_xp(leader_id, xp_data)
	return total


func _total_combat_xp_for_leader(
	leader_id: String,
	battle_result: Dictionary,
	scale: float = 1.0,
) -> int:
	var xp_data := _calculate_combat_xp(battle_result, leader_id)
	var total := int(xp_data.get("total_xp", 12))
	return maxi(int(float(total) * clampf(scale, 0.25, 4.0)), 1)


## Calculates how much XP should be awarded based on battle outcome.
func _calculate_combat_xp(battle_result: Dictionary, leader_id: String = "") -> Dictionary:
	var base_xp := 12
	var bonus := 0

	var outcome: String = str(battle_result.get("outcome", "defeat"))

	match outcome:
		"major_victory":
			bonus = 60
		"heroic_defense":
			bonus = 80
		"high_risk_success":
			bonus = 40
		"minor_victory", "delay_success":
			bonus = 20
		"defeat":
			bonus = 0
		"crushing_defeat":
			bonus = 0

	var battle_scale: float = float(battle_result.get("battle_scale", 1.0))
	bonus = int(float(bonus) * clampf(battle_scale, 0.25, 4.0))

	var defeat_bonus := 0
	if outcome in ["defeat", "crushing_defeat"] and not leader_id.is_empty():
		defeat_bonus = _get_defeat_learning_bonus(leader_id)

	return {
		"base_xp": base_xp,
		"bonus_xp": bonus,
		"defeat_learning_bonus": defeat_bonus,
		"total_xp": base_xp + bonus + defeat_bonus,
	}


## Trait-based bonus XP when a leader fights through a defeat.
func _get_defeat_learning_bonus(leader_id: String) -> int:
	if leader_id.is_empty() or typeof(LeaderManager) == TYPE_NIL:
		return 0

	var leader := LeaderManager.get_leader(leader_id)
	if leader == null:
		return 0

	var bonus := 0
	if int(leader.trait_levels.get("methodical", 0)) > 0:
		bonus += 8
	if int(leader.trait_levels.get("iron_will", 0)) > 0:
		bonus += 10
	if int(leader.trait_levels.get("cautious", 0)) > 0:
		bonus += 6
	return bonus


func _normalize_battle_result(battle_result: Dictionary, intensity: float = 1.0) -> Dictionary:
	var result := battle_result.duplicate()
	if not result.has("intensity"):
		result["intensity"] = intensity
	if result.has("outcome"):
		return result
	if bool(result.get("is_major_victory", false)):
		result["outcome"] = "major_victory"
	elif bool(result.get("is_heroic_defense", false)):
		result["outcome"] = "heroic_defense"
	elif bool(result.get("was_high_risk", false)) and bool(result.get("success", false)):
		result["outcome"] = "high_risk_success"
	elif bool(result.get("success", false)):
		result["outcome"] = "minor_victory"
	else:
		result["outcome"] = "defeat"
	return result
