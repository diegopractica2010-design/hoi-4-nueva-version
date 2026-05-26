# scripts/map/ProvinceEffects.gd
## Aggregates base province stats (infrastructure + development) with
## national spirits and temporary modifiers to produce final effective values.
##
## This is the clean layer for "what does this province actually do right now?"

class_name ProvinceEffects
extends RefCounted

var province: Province = null
var national_modifiers: Dictionary = {}   # from NationalModifierManager or combined

func _init(p_province: Province, p_national_mods: Dictionary = {}):
	province = p_province
	national_modifiers = p_national_mods if p_national_mods else {}

# --- Supply ---
func get_effective_throughput_multiplier() -> float:
	var base := province.get_supply_throughput_modifier() if province else 1.0
	var nat := float(national_modifiers.get("supply_throughput", 0.0))
	return base * (1.0 + nat)

func get_effective_local_supply_generation() -> float:
	var base := province.get_local_supply_generation_modifier() if province else 0.0
	var nat := float(national_modifiers.get("local_supply", 0.0))
	return maxf(0.0, base + nat)

# --- Combat ---
func get_effective_combat_width_multiplier() -> float:
	var base := province.get_combat_width_modifier() if province else 1.0
	var nat := float(national_modifiers.get("combat_width", 0.0))
	return base * (1.0 + nat)

func get_effective_organization_recovery() -> float:
	var base := province.get_organization_recovery_modifier() if province else 1.0
	var nat := float(national_modifiers.get("organization_recovery", 0.0))
	return base * (1.0 + nat)

func get_effective_attrition_multiplier() -> float:
	var base := province.get_attrition_modifier() if province else 1.0
	var nat := float(national_modifiers.get("attrition_reduction", 0.0))
	# national attrition_reduction reduces the multiplier (good)
	return maxf(0.3, base * (1.0 - nat))

# --- Logistics / Movement ---
func get_effective_logistics_quality() -> float:
	var base := province.get_logistics_quality() if province else 50.0
	var nat := float(national_modifiers.get("logistics_quality", 0.0))
	return base + nat

func get_effective_reinforcement_speed() -> float:
	var base := province.get_reinforcement_speed_modifier() if province else 1.0
	var nat := float(national_modifiers.get("reinforcement_speed", 0.0))
	return base * (1.0 + nat)
