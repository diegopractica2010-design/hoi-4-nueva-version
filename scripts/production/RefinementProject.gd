class_name RefinementProject
extends RefCounted

var id: String = ""
var display_name: String = ""
var category: String = "refinement"
var template_id: String = ""
var days_total: float = 0.0
var days_elapsed: float = 0.0
var reliability_gain: float = 0.0
var maturity_gain: float = 0.0
var maintenance_reduction: float = 0.0
var cost: Dictionary = {}
var blocks_production: bool = false
var production_penalty: float = 0.0
var max_completions: int = 1
var tradeoff_summary: String = ""


static func from_def(def: Dictionary, for_template_id: String) -> RefinementProject:
	var project := RefinementProject.new()
	project.id = str(def.get("id", ""))
	project.display_name = str(def.get("name", project.id))
	project.category = str(def.get("category", "refinement"))
	project.template_id = for_template_id
	project.days_total = float(def.get("days", 1))
	project.reliability_gain = float(def.get("reliability_gain", 0))
	project.maturity_gain = float(def.get("maturity_gain", 0))
	project.maintenance_reduction = float(def.get("maintenance_reduction", 0))
	project.cost = _dict_from_variant(def.get("cost", {}))
	project.blocks_production = bool(def.get("blocks_production", false))
	project.production_penalty = float(def.get("production_penalty", 0.0))
	project.max_completions = int(def.get("max_completions", 1))
	project.tradeoff_summary = str(def.get("tradeoff_summary", ""))
	return project


func advance(days: float) -> void:
	days_elapsed = minf(days_elapsed + days, days_total)


func is_complete() -> bool:
	return days_elapsed >= days_total - 0.001


func progress_ratio() -> float:
	if days_total <= 0.0:
		return 1.0
	return clampf(days_elapsed / days_total, 0.0, 1.0)


static func _dict_from_variant(raw: Variant) -> Dictionary:
	if typeof(raw) != TYPE_DICTIONARY:
		return {}
	return raw.duplicate(true)
