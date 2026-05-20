# scripts/combat/CombatWidthCalculator.gd
class_name CombatWidthCalculator
extends Node

const RULES_PATH := "res://data/combat/combat_width_rules.json"

var rules: Dictionary = {}


func _ready() -> void:
	ensure_rules_loaded()


func ensure_rules_loaded() -> void:
	if not rules.is_empty():
		return
	_load_rules()


func _load_rules() -> void:
	if not ResourceLoader.exists(RULES_PATH):
		push_warning("CombatWidthCalculator: rules file not found: " + RULES_PATH)
		return
	var file := FileAccess.open(RULES_PATH, FileAccess.READ)
	if file == null:
		push_warning("CombatWidthCalculator: could not open: " + RULES_PATH)
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	file.close()
	if typeof(parsed) == TYPE_DICTIONARY:
		rules = parsed
	else:
		push_warning("CombatWidthCalculator: invalid rules JSON")


func get_combat_width(province_infrastructure_level: int, terrain: String) -> float:
	ensure_rules_loaded()
	var base := float(rules.get("base_combat_width", 10))
	var infra_mod := _get_infrastructure_modifier(province_infrastructure_level)
	var terrain_mod := _get_terrain_modifier(terrain)
	return base * infra_mod * terrain_mod


func get_effective_combat_width(attacker_infra: int, defender_infra: int, terrain: String) -> float:
	var attacker_width := get_combat_width(attacker_infra, terrain)
	var defender_width := get_combat_width(defender_infra, terrain)
	return (attacker_width + defender_width) / 2.0


func _get_infrastructure_modifier(level: int) -> float:
	var infra_block: Variant = rules.get("infrastructure_modifiers", {})
	if typeof(infra_block) != TYPE_DICTIONARY:
		return 1.0
	var key := "level_%d" % clampi(level, 0, 5)
	return float((infra_block as Dictionary).get(key, 1.0))


func _get_terrain_modifier(terrain: String) -> float:
	var terrain_block: Variant = rules.get("terrain_modifiers", {})
	if typeof(terrain_block) != TYPE_DICTIONARY:
		return 1.0
	return float((terrain_block as Dictionary).get(terrain.to_lower(), 1.0))
