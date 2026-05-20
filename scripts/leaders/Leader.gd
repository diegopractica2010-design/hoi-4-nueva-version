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


func add_trait(trait_id: String, level: int = 1) -> void:
	if not traits.has(trait_id):
		traits.append(trait_id)
	trait_levels[trait_id] = level


func has_trait(trait_id: String) -> bool:
	return traits.has(trait_id)


func get_attack_modifier() -> float:
	var base := 0.015 * float(attack_skill)
	if has_trait("aggressive"):
		base += 0.06
	if has_trait("desert_fox"):
		base += 0.07
	if has_trait("arctic_bear"):
		base += 0.05
	return base


func get_defense_modifier() -> float:
	var base := 0.015 * float(defense_skill)
	if has_trait("cautious"):
		base += 0.05
	if has_trait("arctic_bear"):
		base += 0.06
	return base


func get_organization_modifier() -> float:
	return 0.012 * float(organization_skill)


func get_logistics_modifier() -> float:
	var base := 0.012 * float(logistics_skill)
	if has_trait("logistics_wizard"):
		base += 0.07
	return base


func get_planning_modifier() -> float:
	return 0.01 * float(planning_skill)
