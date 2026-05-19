class_name RetoolingCalculator
extends RefCounted

## Similarity-based retooling cost between two unit templates.


static func compute_similarity(from_template: UnitTemplate, to_template: UnitTemplate, rules: Dictionary) -> float:
	if from_template == null or to_template == null:
		return 0.0
	if from_template.id == to_template.id:
		return 1.0

	var retooling_rules: Dictionary = rules.get("retooling", {})
	var weights: Dictionary = retooling_rules.get("similarity_weights", {})
	var score := 0.0

	if from_template.base_type == to_template.base_type and not from_template.base_type.is_empty():
		score += float(weights.get("same_base_type", 0.25))

	if from_template.size_category == to_template.size_category and not from_template.size_category.is_empty():
		score += float(weights.get("same_size_category", 0.20))

	if from_template.visual_archetype == to_template.visual_archetype and not from_template.visual_archetype.is_empty():
		score += float(weights.get("same_visual_archetype", 0.15))

	var shared_weight := float(weights.get("shared_module", 0.40))
	var shared_ratio := _shared_module_ratio(from_template, to_template)
	score += shared_weight * shared_ratio

	return clampf(score, 0.0, 1.0)


static func compute_retooling_days(similarity: float, rules: Dictionary) -> float:
	var retooling_rules: Dictionary = rules.get("retooling", {})
	var max_days := float(retooling_rules.get("max_penalty_days", 42))
	var min_days := float(retooling_rules.get("min_penalty_days", 3))
	var dissimilarity := 1.0 - clampf(similarity, 0.0, 1.0)
	return lerpf(min_days, max_days, dissimilarity)


static func _shared_module_ratio(from_template: UnitTemplate, to_template: UnitTemplate) -> float:
	var from_ids := from_template.get_module_ids()
	var to_ids := to_template.get_module_ids()
	if from_ids.is_empty() and to_ids.is_empty():
		return 1.0

	var from_set: Dictionary = {}
	for module_id in from_ids:
		from_set[module_id] = true

	var shared := 0
	for module_id in to_ids:
		if from_set.has(module_id):
			shared += 1

	var union_size := from_set.size()
	for module_id in to_ids:
		if not from_set.has(module_id):
			union_size += 1

	if union_size <= 0:
		return 0.0
	return float(shared) / float(union_size)
