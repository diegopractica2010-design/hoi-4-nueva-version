class_name ReliabilityProfile
extends RefCounted

## Snapshot of reliability economics for one design on a production line (UI, combat, logistics).

var template_id: String = ""
var paper_reliability: float = 0.0
var effective_reliability: float = 0.0
var design_maturity: float = 0.0
var new_design_penalty_percent: float = 0.0
var refinement_bonus: float = 0.0
var maintenance_index: float = 0.0
var supply_cost_multiplier: float = 1.0
var combat_readiness: float = 1.0
var breakdown_risk: float = 0.0
var units_produced: int = 0
var active_refinement_id: String = ""
var active_refinement_progress: float = 0.0
## Nominal cargo tons from template base_stats (transports / merchant hulls).
var base_cargo_capacity: float = 0.0
## After cargo-hold module and weapon-slot penalties from production_line_rules logistics section.
var effective_cargo_capacity: float = 0.0
var cargo_capacity_ratio: float = 1.0
var armed_weapon_slots: int = 0
## Supply draw for logistics (base supply_need + cargo tonnage + armed overhead).
var logistics_supply_demand: float = 0.0
var combat_soft_attack: float = 0.0
var combat_hard_attack: float = 0.0
var combat_air_attack: float = 0.0
var combat_anti_air: float = 0.0
var combat_anti_ship: float = 0.0


func has_cargo_role() -> bool:
	return base_cargo_capacity > 0.0 or effective_cargo_capacity > 0.0


func is_immature() -> bool:
	return design_maturity < 0.85


func is_field_ready() -> bool:
	return design_maturity >= 0.85 and effective_reliability >= paper_reliability * 0.9
