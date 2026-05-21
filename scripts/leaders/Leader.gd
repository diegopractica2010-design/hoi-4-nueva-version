# scripts/leaders/Leader.gd
class_name Leader
extends Resource

@export var leader_id: String = ""
@export var name: String = ""
@export var country_tag: String = ""
@export var leader_type: String = "general"  # general, admiral, air_marshal, etc.

# Skills range from 0 to 10
@export var attack_skill: int = 3
@export var defense_skill: int = 3
@export var organization_skill: int = 3
@export var logistics_skill: int = 3
@export var planning_skill: int = 3
@export var initiative_skill: int = 3

@export var traits: Array[String] = []
@export var experience: int = 0
@export var battles_fought: int = 0
@export var is_injured: bool = false
@export var is_captured: bool = false
@export var assigned_army_id: String = ""

var trait_levels: Dictionary = {}  # trait_id -> level


func add_experience(amount: int) -> void:
	experience += amount
	battles_fought += 1


func add_trait_unchecked(trait_id: String, level: int = 1) -> void:
	if trait_id.is_empty():
		return
	if not traits.has(trait_id):
		traits.append(trait_id)
	trait_levels[trait_id] = maxi(level, 1)


func add_trait(trait_id: String, level: int = 1) -> bool:
	if trait_id.is_empty():
		return false
	if typeof(LeaderManager) != TYPE_NIL:
		return LeaderManager.try_add_trait_to_leader(self, trait_id, level)
	add_trait_unchecked(trait_id, level)
	return true


func has_trait(trait_id: String) -> bool:
	return traits.has(trait_id)


func get_trait_level(trait_id: String) -> int:
	if not has_trait(trait_id):
		return 0
	return maxi(int(trait_levels.get(trait_id, 1)), 1)


func _get_trait_effects() -> Dictionary:
	if typeof(LeaderManager) != TYPE_NIL:
		return LeaderManager.get_leader_trait_effects(self)
	return {}


func _effect_float(key: String) -> float:
	return float(_get_trait_effects().get(key, 0.0))


func _effective_skill(base_skill: int, effect_key: String) -> int:
	return clampi(base_skill + int(_get_trait_effects().get(effect_key, 0)), 0, 10)


func get_attack_modifier() -> float:
	var base := 0.015 * float(_effective_skill(attack_skill, "attack"))
	base += _effect_float("armor_attack")
	base += _effect_float("breakthrough")
	base += _effect_float("naval_combat")
	base += _effect_float("combined_arms_sync")
	base += _effect_float("air_support")
	return base


func get_defense_modifier() -> float:
	var base := 0.015 * float(_effective_skill(defense_skill, "defense"))
	base += _effect_float("organization_recovery") * 0.5
	return base


func get_organization_modifier() -> float:
	var base := 0.012 * float(_effective_skill(organization_skill, "organization"))
	base += _effect_float("organization_recovery")
	base += _effect_float("morale")
	return base


func get_logistics_modifier() -> float:
	var base := 0.012 * float(_effective_skill(logistics_skill, "logistics"))
	base += absf(_effect_float("supply_consumption")) * 0.5
	base += _effect_float("attrition_reduction") * 0.4
	base += _effect_float("reinforcement_speed") * 0.3
	return base


func get_planning_modifier() -> float:
	return 0.01 * float(_effective_skill(planning_skill, "planning"))


func get_initiative_modifier() -> float:
	return 0.012 * float(_effective_skill(initiative_skill, "initiative"))


func get_supply_consumption_modifier() -> float:
	return _effect_float("supply_consumption")


func get_breakthrough_modifier() -> float:
	return _effect_float("breakthrough")


func get_combat_width_modifier() -> float:
	return _effect_float("combat_width")


func get_casualties_modifier() -> float:
	return _effect_float("casualties")


# === Terrain-specific trait bonuses ===

func get_terrain_modifier(terrain: String) -> float:
	var terrain_lower := terrain.to_lower()
	var bonus := 0.0

	match terrain_lower:
		"desert":
			bonus += _effect_float("desert_attack")
			bonus += _effect_float("desert_defense") * 0.5
		"arctic", "snow", "tundra":
			bonus += _effect_float("arctic_attack")
			bonus += _effect_float("arctic_defense") * 0.5
		"jungle", "forest":
			bonus += _effect_float("jungle_attack")
			bonus += _effect_float("jungle_defense") * 0.5
		"mountain":
			bonus += _effect_float("mountain_attack")
			bonus += _effect_float("mountain_defense") * 0.5
		"sea", "ocean", "naval":
			bonus += _effect_float("naval_combat")

	return bonus
