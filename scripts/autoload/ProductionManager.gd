extends Node

@onready var factory_manager: FactoryManager = get_node_or_null("/root/FactoryManager")

## National production coordinator: multiple lines, design families, focus/doctrine modifiers.

signal line_registered(line_id: String)
signal line_removed(line_id: String)
signal stance_changed(stance_id: String)
signal modifier_registered(modifier_id: String, source: String)
signal modifier_removed(modifier_id: String)
signal day_advanced(report: Dictionary)
signal family_experience_changed(family_id: String, total_units: int)
signal production_completed(line_id: String, design_id: String, count: int)
signal production_progress_updated(line_id: String, progress: float)

const GLOBAL_MODIFIERS_PATH := "res://data/production/global_modifiers.json"
const STANCE_TAG := "stance"
const RETOOLING_RULES_PATH := "res://data/production/retooling_similarity.json"

var production_stance: String = "balanced"

## Active production lines: line_id -> ProductionLine
var _lines: Dictionary = {}

# === Retooling system ===
var retooling_rules: Dictionary = {}

var _active_modifiers: Dictionary = {}
var _family_units_produced: Dictionary = {}
var _stance_presets: Dictionary = {}
var _doctrine_presets: Dictionary = {}
var _focus_presets: Dictionary = {}
var _rules: Dictionary = {}
## National resource pool used to pay refinement / shakedown project costs.
var national_stockpile: Dictionary = {}


func _ready() -> void:
	_rules = GameData.design_data.production_rules
	_load_modifier_presets()
	_load_retooling_rules()


func _get_base_daily_points() -> float:
	return ProductionCostCalculator.get_base_daily_points()


func _load_retooling_rules() -> void:
	retooling_rules = {}
	if not ResourceLoader.exists(RETOOLING_RULES_PATH):
		push_warning("retooling_similarity.json not found — using defaults")
		return
	var file := FileAccess.open(RETOOLING_RULES_PATH, FileAccess.READ)
	if file == null:
		push_warning("Failed to load retooling_similarity.json")
		return
	var text := file.get_as_text()
	var parsed: Variant = JSON.parse_string(text)
	if typeof(parsed) == TYPE_DICTIONARY:
		retooling_rules = parsed
	else:
		push_warning("Invalid retooling_similarity.json")


func get_category_similarity(old_category: String, new_category: String) -> float:
	if retooling_rules.is_empty():
		return 0.20

	var sim_table: Dictionary = retooling_rules.get("similarity", {})
	if sim_table.has(old_category):
		var row: Variant = sim_table[old_category]
		if typeof(row) == TYPE_DICTIONARY and (row as Dictionary).has(new_category):
			return float((row as Dictionary)[new_category])
	return float(retooling_rules.get("default_floor", 0.20))


func get_retooling_params(
	old_category: String,
	new_category: String,
	tech_modifier: float = 1.0,
	focus_modifier: float = 1.0,
) -> Dictionary:
	var similarity := get_category_similarity(old_category, new_category)

	var base_retool := float(retooling_rules.get("base_retool_days", 90.0))
	var base_recovery := float(retooling_rules.get("recovery_days", 45.0))
	var floor_efficiency := float(retooling_rules.get("default_floor", 0.20))
	var retained_rules: Dictionary = retooling_rules.get("retained_efficiency", {})
	var retained_base := float(retained_rules.get("base", 0.15))
	var retained_scale := float(retained_rules.get("similarity_scale", 0.80))

	var retained := maxf(floor_efficiency, retained_base + similarity * retained_scale)
	retained *= tech_modifier * focus_modifier
	retained = clampf(retained, floor_efficiency, 0.95)

	var tech_div := maxf(tech_modifier, 0.1)
	var focus_div := maxf(focus_modifier, 0.1)
	var retool_days := base_retool * (1.0 - similarity * 0.65) / tech_div
	retool_days = maxf(25.0, retool_days)

	var recovery_days := base_recovery * (1.0 - similarity * 0.4) / focus_div
	recovery_days = maxf(10.0, recovery_days)

	return {
		"similarity": similarity,
		"retained_efficiency": retained,
		"retool_days": retool_days,
		"recovery_days": recovery_days,
	}


func _retool_group_for_design(design_id: String, category_override: String = "") -> String:
	if not category_override.is_empty():
		return RetoolingSimilarityTable.map_production_category_to_group(category_override)
	return RetoolingSimilarityTable.category_group_for_design(design_id)


func create_line(line_id: String) -> ProductionLine:
	if line_id.is_empty():
		push_warning("ProductionManager.create_line requires a non-empty line_id")
		return null
	if _lines.has(line_id):
		push_warning("Production line already exists: " + line_id)
		return _lines[line_id] as ProductionLine

	var line := ProductionLine.new(GameData.design_data, line_id)
	line.set_modifier_resolver(_resolve_modifiers_for_line)
	line.unit_completed.connect(_on_line_unit_completed.bind(line_id))
	_lines[line_id] = line
	line_registered.emit(line_id)
	return line


func remove_line(line_id: String) -> bool:
	if not _lines.has(line_id):
		return false
	_lines.erase(line_id)
	line_removed.emit(line_id)
	return true


func get_line(line_id: String) -> ProductionLine:
	return _lines.get(line_id)


func get_line_ids() -> Array[String]:
	var ids: Array[String] = []
	for key in _lines:
		ids.append(str(key))
	return ids


func has_line(line_id: String) -> bool:
	return _lines.has(line_id)


func set_line_template(line_id: String, template_id: String) -> Dictionary:
	var line := get_line(line_id)
	if line == null:
		return {"success": false, "error": "unknown_line"}

	_refresh_line_modifiers(line)
	var result := line.set_template(template_id)
	if not bool(result.get("success", false)):
		return result

	var retool_days := float(result.get("retooling_days", 0.0))
	if retool_days > 0.0:
		var previous_id := str(result.get("previous_template_id", ""))
		var family_discount := _same_family_retool_discount(previous_id, template_id)
		var mods := _resolve_modifiers_for_line(line)
		line.apply_retooling_adjustment(mods.retooling_days_multiplier, family_discount)
		result["retooling_days"] = line.get_retooling_days_remaining()
		result["family_retool_discount"] = family_discount

	return result


func advance_days(days: float) -> Dictionary:
	var report := {
		"days_advanced": days,
		"lines": {},
		"total_units_completed": 0,
	}

	for line_id in _lines:
		var line: ProductionLine = _lines[line_id]
		_refresh_line_modifiers(line)
		var line_report: Dictionary = line.advance_days(days)
		report["lines"][line_id] = line_report
		report["total_units_completed"] += int(line_report.get("units_completed", 0))

	day_advanced.emit(report)
	return report


func register_modifier(modifier: ProductionModifier) -> void:
	if modifier == null or modifier.id.is_empty():
		push_warning("ProductionManager.register_modifier: invalid modifier")
		return
	_active_modifiers[modifier.id] = modifier
	modifier_registered.emit(modifier.id, modifier.source)


func unregister_modifier(modifier_id: String) -> void:
	if not _active_modifiers.has(modifier_id):
		return
	_active_modifiers.erase(modifier_id)
	modifier_removed.emit(modifier_id)


func clear_modifiers_by_source(source_prefix: String) -> void:
	var to_remove: Array[String] = []
	for modifier_id in _active_modifiers:
		var mod: ProductionModifier = _active_modifiers[modifier_id]
		if mod.source.begins_with(source_prefix):
			to_remove.append(modifier_id)
	for modifier_id in to_remove:
		unregister_modifier(modifier_id)


func set_production_stance(stance_id: String) -> bool:
	var preset: Dictionary = _stance_presets.get(stance_id, {})
	if preset.is_empty() and stance_id != "balanced":
		push_warning("Unknown production stance: " + stance_id)
		return false

	_clear_modifiers_with_tag(STANCE_TAG)
	production_stance = stance_id
	if not preset.is_empty():
		var mod := ProductionModifier.from_dict(preset)
		if STANCE_TAG not in mod.tags:
			mod.tags.append(STANCE_TAG)
		register_modifier(mod)
	stance_changed.emit(stance_id)
	return true


func apply_doctrine(doctrine_id: String) -> bool:
	var preset: Dictionary = _doctrine_presets.get(doctrine_id, {})
	if preset.is_empty():
		push_warning("Unknown doctrine modifier: " + doctrine_id)
		return false
	register_modifier(ProductionModifier.from_dict(preset))
	return true


func revoke_doctrine(doctrine_id: String) -> void:
	var preset: Dictionary = _doctrine_presets.get(doctrine_id, {})
	if preset.is_empty():
		return
	unregister_modifier(str(preset.get("id", "")))


func apply_focus(focus_id: String) -> bool:
	var preset: Dictionary = _focus_presets.get(focus_id, {})
	if preset.is_empty():
		push_warning("Unknown focus modifier: " + focus_id)
		return false
	register_modifier(ProductionModifier.from_dict(preset))
	return true


func revoke_focus(focus_id: String) -> void:
	var preset: Dictionary = _focus_presets.get(focus_id, {})
	if preset.is_empty():
		return
	unregister_modifier(str(preset.get("id", "")))


func get_family_units_produced(family_id: String) -> int:
	return int(_family_units_produced.get(family_id, 0))


func get_active_modifier_ids() -> Array[String]:
	var ids: Array[String] = []
	for key in _active_modifiers:
		ids.append(str(key))
	return ids


func set_stockpile(resources: Dictionary) -> void:
	national_stockpile = resources.duplicate(true)


func add_stockpile(resources: Dictionary) -> void:
	for resource in resources:
		national_stockpile[resource] = float(national_stockpile.get(resource, 0.0)) + float(resources[resource])


func can_afford(cost: Dictionary) -> bool:
	for resource in cost:
		if float(national_stockpile.get(resource, 0.0)) < float(cost[resource]):
			return false
	return true


func pay_cost(cost: Dictionary) -> bool:
	if not can_afford(cost):
		return false
	for resource in cost:
		national_stockpile[resource] = float(national_stockpile.get(resource, 0.0)) - float(cost[resource])
	return true


func get_line_reliability_profile(line_id: String) -> ReliabilityProfile:
	var line := get_line(line_id)
	if line == null:
		return ReliabilityProfile.new()
	return line.get_reliability_profile()


func list_line_refinement_options(line_id: String) -> Array[Dictionary]:
	var line := get_line(line_id)
	if line == null:
		return []
	return line.list_refinement_options()


func start_line_refinement(line_id: String, project_id: String, pay_upfront: bool = true) -> Dictionary:
	var line := get_line(line_id)
	if line == null:
		return {"success": false, "reason": "unknown_line"}

	var eligibility := line.can_start_refinement(project_id)
	if not bool(eligibility.get("can_start", false)):
		return {"success": false, "reason": str(eligibility.get("reason", "blocked"))}

	var def := GameData.design_data.get_refinement_def(project_id)
	var cost: Dictionary = def.get("cost", {}) if typeof(def.get("cost", {})) == TYPE_DICTIONARY else {}
	if pay_upfront and not cost.is_empty() and not pay_cost(cost):
		return {"success": false, "reason": "cannot_afford", "cost": cost}

	if not line.start_refinement(project_id):
		return {"success": false, "reason": "start_failed"}

	return {
		"success": true,
		"project_id": project_id,
		"line_id": line_id,
		"cost_paid": cost,
		"tradeoff_summary": str(def.get("tradeoff_summary", "")),
	}


func _refresh_line_modifiers(line: ProductionLine) -> void:
	line.set_runtime_modifiers(_resolve_modifiers_for_line(line))


func _resolve_modifiers_for_line(line: ProductionLine) -> ProductionModifiers:
	var mods := ProductionModifiers.new()

	for modifier_id in _active_modifiers:
		mods.absorb(_active_modifiers[modifier_id])

	var template := line.get_current_template()
	if template != null and not template.design_family.is_empty():
		mods.design_family_output_bonus = _compute_family_output_bonus(template.design_family)
		mods.design_family_output_bonus += _compute_cross_line_synergy(template.design_family)

	var state := line.get_current_state()
	if state != null:
		mods.time_on_design_output_bonus = _compute_time_on_design_bonus(state.days_on_design)

	return mods


func _compute_family_output_bonus(family_id: String) -> float:
	var family_rules: Dictionary = _rules.get("design_families", {})
	var per_10 := float(family_rules.get("output_bonus_per_10_national_units", 0.02))
	var max_bonus := float(family_rules.get("max_family_output_bonus", 0.18))
	var units := float(get_family_units_produced(family_id))
	return minf(floor(units / 10.0) * per_10, max_bonus)


func _compute_cross_line_synergy(family_id: String) -> float:
	var family_rules: Dictionary = _rules.get("design_families", {})
	var per_line := float(family_rules.get("cross_line_synergy_per_active_line", 0.01))
	var max_synergy := float(family_rules.get("max_cross_line_synergy", 0.06))
	var active_lines := maxi(_count_active_lines_for_family(family_id) - 1, 0)
	return minf(float(active_lines) * per_line, max_synergy)


func _compute_time_on_design_bonus(days_on_design: float) -> float:
	var ramp_rules: Dictionary = _rules.get("efficiency_ramp", {})
	var days_to_max := float(ramp_rules.get("days_to_max_time_bonus", 120))
	var max_bonus := float(ramp_rules.get("max_time_on_design_output_bonus", 0.12))
	var ratio := clampf(days_on_design / maxf(days_to_max, 1.0), 0.0, 1.0)
	return max_bonus * ratio


func _count_active_lines_for_family(family_id: String) -> int:
	var count := 0
	for line_id in _lines:
		var line: ProductionLine = _lines[line_id]
		var template := line.get_current_template()
		if template != null and template.design_family == family_id:
			count += 1
	return count


func _same_family_retool_discount(previous_template_id: String, new_template_id: String) -> float:
	if previous_template_id.is_empty() or previous_template_id == new_template_id:
		return 0.0
	var previous_family := _template_design_family(previous_template_id)
	var new_family := _template_design_family(new_template_id)
	if previous_family.is_empty() or previous_family != new_family:
		return 0.0
	return float(_rules.get("design_families", {}).get("same_family_retool_discount", 0.30))


func _template_design_family(template_id: String) -> String:
	var template := GameData.design_data.get_template(template_id)
	return template.design_family if template != null else ""


func _on_line_unit_completed(
	template_id: String,
	_reliability: float,
	_profile: ReliabilityProfile,
	line_id: String,
) -> void:
	var template := GameData.design_data.get_template(template_id)
	if template == null or template.design_family.is_empty():
		return
	var family_id := template.design_family
	var total := int(_family_units_produced.get(family_id, 0)) + 1
	_family_units_produced[family_id] = total
	family_experience_changed.emit(family_id, total)


func _load_modifier_presets() -> void:
	var data := _load_json_dict(GLOBAL_MODIFIERS_PATH)
	_stance_presets = _preset_block(data, "production_stances")
	_doctrine_presets = _preset_block(data, "doctrines")
	_focus_presets = _preset_block(data, "focuses")
	set_production_stance("balanced")


func _preset_block(data: Dictionary, key: String) -> Dictionary:
	var raw = data.get(key, {})
	return raw if typeof(raw) == TYPE_DICTIONARY else {}


func _load_json_dict(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		push_warning("Missing JSON: " + path)
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	if not file:
		return {}
	var json := JSON.new()
	if json.parse(file.get_as_text()) != OK or typeof(json.data) != TYPE_DICTIONARY:
		return {}
	return json.data


func _clear_modifiers_with_tag(tag: String) -> void:
	var to_remove: Array[String] = []
	for modifier_id in _active_modifiers:
		var mod: ProductionModifier = _active_modifiers[modifier_id]
		if tag in mod.tags:
			to_remove.append(modifier_id)
	for modifier_id in to_remove:
		unregister_modifier(modifier_id)


func get_line_efficiency(line_id: String) -> float:
	var line := get_line(line_id)
	if line == null:
		return 1.0
	return line.get_factory_efficiency()


func assign_line_to_factory(line_id: String, factory_id: int) -> bool:
	if factory_manager == null:
		return false

	var factory := factory_manager.get_factory(factory_id)
	if factory == null:
		push_warning("FactoryManager: Factory %d not found" % factory_id)
		return false

	var line := get_line(line_id)
	if line == null:
		push_warning("ProductionManager: line '%s' not found" % line_id)
		return false

	line.factory_id = factory_id
	if not line.design_id.is_empty():
		factory.sync_production_design(line.design_id)
	elif not line.current_template_id.is_empty():
		factory.sync_production_design(line.current_template_id)

	if not factory_manager.assign_production_line_to_factory(factory_id, line_id):
		return false

	line.refresh_required_progress()

	print(
		"Assigned line '%s' to factory %d (Province %d, Slot %d)"
		% [line_id, factory_id, Factory.province_from_id(factory_id), Factory.slot_from_id(factory_id)]
	)
	return true


func get_factory_efficiency(factory_id: int) -> float:
	if factory_manager:
		return factory_manager.get_factory_efficiency(factory_id)
	return 1.0


func get_factories_producing(design_id: String) -> Array[Factory]:
	var result: Array[Factory] = []
	if factory_manager == null or design_id.is_empty():
		return result
	for fid in factory_manager.factories:
		var f: Factory = factory_manager.factories[fid]
		if f != null and f.current_production_design == design_id:
			result.append(f)
	return result


func get_total_output_for_design(design_id: String) -> float:
	var total := 0.0
	for f in get_factories_producing(design_id):
		total += f.get_daily_output_estimate()
	return total


func reassign_factory(factory_id: int, new_design_id: String, new_category: String = "") -> bool:
	if factory_manager == null:
		return false

	var factory := factory_manager.get_factory(factory_id)
	if factory == null:
		push_warning("Cannot reassign - factory %d not found" % factory_id)
		return false

	var old_design := factory.current_production_design
	if old_design == new_design_id:
		return true

	var old_group := _retool_group_for_design(old_design)
	var new_group := _retool_group_for_design(new_design_id, new_category)
	var params := get_retooling_params(old_group, new_group)

	for line_id in factory.assigned_lines:
		var line := get_line(line_id)
		if line == null:
			continue
		line.reset_progress()
		line.design_id = new_design_id
		if GameData.design_data != null and GameData.design_data.get_template(new_design_id) != null:
			line.set_template(new_design_id)
		else:
			line.refresh_design_production_cost()

	factory.start_retooling(
		old_design,
		new_design_id,
		float(params.get("retool_days", 90.0)),
		float(params.get("recovery_days", 45.0)),
		float(params.get("retained_efficiency", 0.2)),
	)

	print(
		"Retooling Factory %d: %s → %s | Retained: %.0f%% | Retool: %.0f days | Recovery: %.0f days"
		% [
			factory_id,
			old_design,
			new_design_id,
			float(params.get("retained_efficiency", 0.0)) * 100.0,
			float(params.get("retool_days", 0.0)),
			float(params.get("recovery_days", 0.0)),
		]
	)
	return true


func get_concentration_bonus(design_id: String) -> float:
	var count := get_factories_producing(design_id).size()
	if count <= 1:
		return 1.0
	# +4% per additional factory, capped at +25%
	var bonus := 1.0 + (count - 1) * 0.04
	return minf(bonus, 1.25)


func get_effective_daily_output(design_id: String) -> float:
	var base := get_total_output_for_design(design_id)
	return base * get_concentration_bonus(design_id)


func get_design_production_info(design_id: String) -> Dictionary:
	var factories := get_factories_producing(design_id)
	var template := GameData.design_data.get_template(design_id) if GameData.design_data else null
	var breakdown: Dictionary = (
		template.get_production_cost_breakdown(GameData.design_data)
		if template != null
		else {}
	)
	var unit_cost := float(breakdown.get("total", 0.0))
	var category := str(breakdown.get("category", ""))
	var era := str(breakdown.get("era", ""))
	var daily_pp := _get_base_daily_points() * get_concentration_bonus(design_id)
	return {
		"design_id": design_id,
		"production_cost": unit_cost,
		"production_category": category,
		"production_era": era,
		"cost_breakdown": breakdown,
		"factory_count": factories.size(),
		"base_daily_points": get_total_output_for_design(design_id),
		"concentration_bonus": get_concentration_bonus(design_id),
		"effective_daily_points": get_effective_daily_output(design_id),
		"estimated_days_per_unit": ProductionCostCalculator.estimate_build_days(
			unit_cost, daily_pp
		) if unit_cost > 0.0 and daily_pp > 0.0 else 0.0,
		"factories": factories.map(func(f: Factory) -> int: return f.factory_id),
	}


func daily_production_tick() -> void:
	advance_production(1.0)


func advance_production(days: float) -> void:
	if days <= 0.0:
		return

	for line_id in _lines:
		var line: ProductionLine = _lines[line_id]
		if line.factory_id == 0 or line.design_id.is_empty():
			continue

		if factory_manager == null:
			continue
		var factory := factory_manager.get_factory(line.factory_id)
		if factory == null:
			continue

		if factory.is_retooling:
			factory.advance_retooling(days)

		var base_efficiency := factory.current_efficiency
		var current_eff := factory.get_current_efficiency() if factory.is_retooling else 1.0
		var concentration := get_concentration_bonus(line.design_id)
		var daily_points := _get_base_daily_points() * base_efficiency * current_eff * concentration * days
		line.add_progress(daily_points)
		production_progress_updated.emit(line_id, line.progress)

		var cost := line.design_production_cost
		while cost > 0.0 and line.progress >= cost:
			_complete_item(line, line_id)


func _complete_item(line: ProductionLine, line_id: String) -> void:
	line.completed_count += 1
	line.progress -= line.design_production_cost
	production_completed.emit(line_id, line.design_id, 1)
	print("Production complete: %s (Total: %d)" % [line.design_id, line.completed_count])


func get_line_progress_info(line_id: String) -> Dictionary:
	var line := get_line(line_id)
	if line == null:
		return {}
	var template := line.get_current_template()
	var cost_breakdown: Dictionary = (
		template.get_production_cost_breakdown(GameData.design_data, line.get_effective_loadout())
		if template != null
		else {}
	)
	return {
		"line_id": line_id,
		"design_id": line.design_id,
		"factory_id": line.factory_id,
		"progress": line.progress,
		"design_production_cost": line.design_production_cost,
		"required_progress": line.design_production_cost,
		"percent_complete": line.get_progress_percent(),
		"completed_count": line.completed_count,
		"cost_breakdown": cost_breakdown,
		"estimated_days_remaining": ProductionCostCalculator.estimate_build_days(
			maxf(line.design_production_cost - line.progress, 0.0),
			_get_base_daily_points() * line.get_factory_efficiency() * get_concentration_bonus(line.design_id),
		),
	}
