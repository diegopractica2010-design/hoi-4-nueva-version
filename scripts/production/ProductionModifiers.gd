class_name ProductionModifiers
extends RefCounted

## Aggregated modifiers applied to one production line for the current tick/design.

var output_multiplier: float = 1.0
var reliability_multiplier: float = 1.0
var reliability_flat_bonus: float = 0.0
var retooling_days_multiplier: float = 1.0
var tooling_gain_multiplier: float = 1.0
var new_design_experience_rate_multiplier: float = 1.0
var cost_multiplier: float = 1.0
var design_family_output_bonus: float = 0.0
var time_on_design_output_bonus: float = 0.0


func reset() -> void:
	output_multiplier = 1.0
	reliability_multiplier = 1.0
	reliability_flat_bonus = 0.0
	retooling_days_multiplier = 1.0
	tooling_gain_multiplier = 1.0
	new_design_experience_rate_multiplier = 1.0
	cost_multiplier = 1.0
	design_family_output_bonus = 0.0
	time_on_design_output_bonus = 0.0


func absorb(modifier: ProductionModifier) -> void:
	output_multiplier *= modifier.output_multiplier
	reliability_multiplier *= modifier.reliability_multiplier
	reliability_flat_bonus += modifier.reliability_flat_bonus
	retooling_days_multiplier *= modifier.retooling_days_multiplier
	tooling_gain_multiplier *= modifier.tooling_gain_multiplier
	new_design_experience_rate_multiplier *= modifier.new_design_experience_rate_multiplier
	cost_multiplier *= modifier.cost_multiplier


func get_total_output_multiplier() -> float:
	return output_multiplier * (1.0 + design_family_output_bonus + time_on_design_output_bonus)
