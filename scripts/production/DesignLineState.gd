class_name DesignLineState
extends RefCounted

## Per-design memory on a production line (tooling, maturity, refinement).

var template_id: String = ""
var tooling_efficiency: float = 0.0
var reliability_refinement_bonus: float = 0.0
## 0.0 = brand-new design, 1.0 = fully shaken down / field-proven.
var design_maturity: float = 0.0
## Multiplier on maintenance costs; reduced by refinement projects (lower is better).
var maintenance_burden_multiplier: float = 1.0
var maturity_from_projects: float = 0.0
var units_produced: int = 0
var days_on_design: float = 0.0
var completed_refinements: Dictionary = {}


func get_refinement_completions(project_id: String) -> int:
	return int(completed_refinements.get(project_id, 0))


func record_refinement_completion(project_id: String) -> void:
	completed_refinements[project_id] = get_refinement_completions(project_id) + 1


func duplicate_state() -> DesignLineState:
	var copy := DesignLineState.new()
	copy.template_id = template_id
	copy.tooling_efficiency = tooling_efficiency
	copy.reliability_refinement_bonus = reliability_refinement_bonus
	copy.design_maturity = design_maturity
	copy.maintenance_burden_multiplier = maintenance_burden_multiplier
	copy.maturity_from_projects = maturity_from_projects
	copy.units_produced = units_produced
	copy.days_on_design = days_on_design
	copy.completed_refinements = completed_refinements.duplicate()
	return copy
