class_name SupplyRules
extends RefCounted

const DEFAULT_PATH := "res://data/supply/supply_rules.json"

var data: Dictionary = {}


static func load_from_path(path: String = DEFAULT_PATH) -> SupplyRules:
	var rules := SupplyRules.new()
	rules.data = rules._load_json(path)
	return rules


func get_block(key: String) -> Dictionary:
	var block: Variant = data.get(key, {})
	return block if typeof(block) == TYPE_DICTIONARY else {}


func get_float(block_key: String, field: String, default_value: float = 0.0) -> float:
	return float(get_block(block_key).get(field, default_value))


func consumption_rate(mode: String) -> float:
	var rates := get_block("consumption_rates")
	return float(rates.get(mode, rates.get("combat", 1.0)))


func _load_json(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		push_warning("SupplyRules: missing ", path)
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {}
	var parser := JSON.new()
	if parser.parse(file.get_as_text()) != OK or typeof(parser.data) != TYPE_DICTIONARY:
		push_warning("SupplyRules: invalid JSON ", path)
		return {}
	return parser.data
