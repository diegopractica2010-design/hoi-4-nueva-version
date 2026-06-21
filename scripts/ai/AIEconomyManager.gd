extends Node

const Logger = preload("res://scripts/core/Logger.gd")

const FACTORY_PRIORITY_MILITARY: float = 1.5
const FACTORY_PRIORITY_CIVILIAN: float = 1.0
const FACTORY_PRIORITY_NAVAL: float = 0.8

var _days_since_last_eval: int = 0
var EVAL_INTERVAL_DAYS: int = 14

var _ai_config: Dictionary = {}

func _ready() -> void:
	Logger.info("AIEconomyManager initialized", "AIEconomyManager")
	if typeof(TimeManager) != TYPE_NIL and TimeManager.has_signal("game_day_advanced"):
		if not TimeManager.game_day_advanced.is_connected(_on_game_day_advanced):
			TimeManager.game_day_advanced.connect(_on_game_day_advanced)

func _on_game_day_advanced(_year: int, _month: int, _day: int) -> void:
	_days_since_last_eval += 1
	if _days_since_last_eval >= EVAL_INTERVAL_DAYS:
		_days_since_last_eval = 0
		_evaluate_all_economy()

func _evaluate_all_economy() -> void:
	var tags := _get_ai_tags()
	for tag in tags:
		_evaluate_nation_economy(tag)

func _get_ai_tags() -> Array[String]:
	if typeof(AIManager) != TYPE_NIL and AIManager.has_method("get_ai_tags"):
		return AIManager.get_ai_tags()
	if typeof(AIManager) != TYPE_NIL:
		return AIManager.ai_tags
	return []

func set_ai_config(tag: String, config: Dictionary) -> void:
	_ai_config[tag] = config

func get_ai_config(tag: String) -> Dictionary:
	if _ai_config.has(tag):
		return _ai_config[tag]
	var defaults := {
		"factory_aggressiveness": 0.5,
		"research_focus": "balanced",
		"production_focus": "balanced",
		"prefer_military": false,
	}
	_ai_config[tag] = defaults
	return defaults

func _evaluate_nation_economy(tag: String) -> void:
	Logger.info("AIEconomy: evaluating " + tag, "AIEconomyManager")
	_evaluate_factory_construction(tag)
	_evaluate_production(tag)
	_evaluate_technology_research(tag)

func _evaluate_factory_construction(tag: String) -> void:
	if typeof(FactoryManager) == TYPE_NIL or typeof(NationalIncomeManager) == TYPE_NIL:
		return
	if not NationalIncomeManager.has_method("get_national_stockpile"):
		return
	var stockpile: Dictionary = NationalIncomeManager.get_national_stockpile(tag)
	var civ_factories: int = stockpile.get("civilian_factories", 0)
	var mil_factories: int = stockpile.get("military_factories", 0)
	var config := get_ai_config(tag)

	var total := civ_factories + mil_factories
	if total < 3:
		_build_factory(tag, "civilian")
	elif config.get("prefer_military", false) or _is_nation_at_war(tag):
		var mil_pct := float(mil_factories) / max(total, 1)
		if mil_pct < 0.4:
			_build_factory(tag, "military")
		else:
			_build_factory(tag, "civilian")
	elif civ_factories < mil_factories * 1.5:
		_build_factory(tag, "civilian")
	else:
		_build_factory(tag, "military")

func _build_factory(tag: String, factory_type: String) -> void:
	if typeof(FactoryManager) == TYPE_NIL:
		return
	if not FactoryManager.has_method("get_provinces_for_factory_construction"):
		return
	var provinces: Array[int] = FactoryManager.get_provinces_for_factory_construction(tag)
	if provinces.is_empty():
		return
	var province_id: int = provinces[0]
	if FactoryManager.has_method("create_factory_for_province"):
		FactoryManager.create_factory_for_province(province_id, tag, 0, factory_type)
		Logger.info("AIEconomy: " + tag + " building " + factory_type + " factory in province " + str(province_id), "AIEconomyManager")

func _evaluate_production(tag: String) -> void:
	if typeof(ProductionManager) == TYPE_NIL:
		return
	if not ProductionManager.has_method("get_production_lines_for_nation"):
		return
	var lines: Array = ProductionManager.get_production_lines_for_nation(tag)
	var config := get_ai_config(tag)
	var line_count := lines.size()
	var target_lines: int = _get_target_production_lines(tag)

	if line_count < target_lines:
		var designs := _get_available_designs(tag)
		if designs.is_empty():
			return
		if config.get("production_focus", "balanced") == "air" and _has_air_design(designs):
			var air_design := _pick_design_of_type(designs, "air")
			if air_design != null:
				_start_production_line(tag, air_design)
		elif config.get("production_focus", "balanced") == "naval" and _has_naval_design(designs):
			var naval_design := _pick_design_of_type(designs, "naval")
			if naval_design != null:
				_start_production_line(tag, naval_design)
		elif config.get("production_focus", "balanced") != "balanced":
			var land_design := _pick_design_of_type(designs, "land")
			if land_design != null:
				_start_production_line(tag, land_design)
		else:
			var design := designs[0] if designs.size() > 0 else null
			if design != null:
				_start_production_line(tag, design)

func _get_target_production_lines(tag: String) -> int:
	if typeof(FactoryManager) == TYPE_NIL:
		return 2
	var total_factories := 0
	if FactoryManager.has_method("count_factories_for_owner"):
		total_factories = FactoryManager.count_factories_for_owner(tag)
	return max(1, total_factories / 3)

func _get_available_designs(tag: String) -> Array:
	if typeof(DesignManager) == TYPE_NIL:
		return []
	if DesignManager.has_method("get_available_designs_for_nation"):
		return DesignManager.get_available_designs_for_nation(tag)
	if DesignManager.has_method("get_designs_for_nation"):
		return DesignManager.get_designs_for_nation(tag)
	return []

func _has_air_design(designs: Array) -> bool:
	return _pick_design_of_type(designs, "air") != null

func _has_naval_design(designs: Array) -> bool:
	return _pick_design_of_type(designs, "naval") != null

func _pick_design_of_type(designs: Array, type: String) -> Variant:
	for d in designs:
		if typeof(d) == TYPE_DICTIONARY and d.get("type", "") == type:
			return d
		if typeof(d) == TYPE_OBJECT and d.has_method("get_type") and d.get_type() == type:
			return d
	return null

func _start_production_line(tag: String, design: Variant) -> void:
	if typeof(ProductionManager) == TYPE_NIL:
		return
	var design_id := ""
	if typeof(design) == TYPE_DICTIONARY:
		design_id = str(design.get("id", ""))
	elif typeof(design) == TYPE_OBJECT:
		if design.has_method("get_design_id"):
			design_id = design.get_design_id()
	if design_id.is_empty():
		return
	if ProductionManager.has_method("create_line"):
		ProductionManager.create_line(tag, design_id)
		Logger.info("AIEconomy: " + tag + " started production line for " + design_id, "AIEconomyManager")

func _evaluate_technology_research(tag: String) -> void:
	if typeof(TechnologyManager) == TYPE_NIL:
		return
	if not TechnologyManager.has_method("get_available_techs"):
		return
	var available: Array = TechnologyManager.get_available_techs(tag)
	if available.is_empty():
		return
	var config := get_ai_config(tag)
	var chosen: Variant = _choose_tech(tag, available, config.get("research_focus", "balanced"))
	if chosen != null:
		var tech_id := ""
		if typeof(chosen) == TYPE_DICTIONARY:
			tech_id = str(chosen.get("id", ""))
		elif typeof(chosen) == TYPE_STRING:
			tech_id = chosen
		if not tech_id.is_empty():
			TechnologyManager.start_research(tag, tech_id)
			Logger.info("AIEconomy: " + tag + " started researching " + tech_id, "AIEconomyManager")

func _choose_tech(tag: String, available_techs: Array, focus: String) -> Variant:
	if available_techs.is_empty():
		return null
	if focus == "military":
		return _filter_tech_by_category(available_techs, ["weapons", "armor", "artillery"])
	elif focus == "economic":
		return _filter_tech_by_category(available_techs, ["industry", "infrastructure", "economy"])
	elif focus == "naval":
		return _filter_tech_by_category(available_techs, ["naval", "ship"])
	elif focus == "air":
		return _filter_tech_by_category(available_techs, ["air", "aviation"])
	else:
		var priority := ["industry", "weapons", "armor", "infrastructure", "economy", "air", "naval"]
		for cat in priority:
			var result := _filter_tech_by_category(available_techs, [cat])
			if result != null:
				return result
		return available_techs[0]

func _filter_tech_by_category(available: Array, categories: Array) -> Variant:
	for t in available:
		var tech_cat := ""
		if typeof(t) == TYPE_DICTIONARY:
			tech_cat = str(t.get("category", "")).to_lower()
		elif typeof(t) == TYPE_OBJECT and t.has_method("get_category"):
			tech_cat = t.get_category().to_lower()
		for cat in categories:
			if tech_cat.find(cat) >= 0:
				return t
	return null

func _is_nation_at_war(tag: String) -> bool:
	if typeof(DiplomacyManager) == TYPE_NIL:
		return false
	return DiplomacyManager.get_wars_for(tag).size() > 0

func get_save_data() -> Dictionary:
	return {
		"days_since_last_eval": _days_since_last_eval,
		"ai_config": _ai_config.duplicate(true),
	}

func load_save_data(data: Dictionary) -> void:
	_days_since_last_eval = int(data.get("days_since_last_eval", 0))
	_ai_config = (data.get("ai_config", {}) as Dictionary).duplicate(true)

func get_economy_status(tag: String) -> String:
	var status := "=== AI ECONOMY STATUS (" + tag + ") ===\n"
	status += "Config: " + str(get_ai_config(tag)) + "\n"
	if typeof(ProductionManager) != TYPE_NIL and ProductionManager.has_method("get_production_lines_for_nation"):
		var lines := ProductionManager.get_production_lines_for_nation(tag)
		status += "Production lines: " + str(lines.size()) + "\n"
	if typeof(TechnologyManager) != TYPE_NIL:
		status += "Researching: " + str(_get_current_research(tag)) + "\n"
	return status

func _get_current_research(tag: String) -> String:
	if typeof(TechnologyManager) == TYPE_NIL:
		return "none"
	if TechnologyManager.has_method("get_current_research"):
		return str(TechnologyManager.get_current_research(tag))
	return "none"
