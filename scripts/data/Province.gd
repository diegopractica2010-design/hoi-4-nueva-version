# scripts/data/Province.gd
class_name Province
extends Resource

#region Identity / map
@export var id: int = 0
@export var name: String = ""
@export var terrain: String = "plains"
@export var is_sea: bool = false
## Map-local position (e.g. label anchor or province centroid in province space).
@export var coordinates: Vector2 = Vector2.ZERO
## Neighboring province IDs (same convention as province_adjacency.json).
@export var adjacencies: Array[int] = []
#endregion

#region Politics
@export var owner_tag: String = ""
@export var controller_tag: String = ""
@export var core_for: Array[String] = []
#endregion

#region Economy & stats
@export var development_level: int = 1
@export var infrastructure: int = 1
@export var factories: int = 0
@export var population: int = 0
## Resource tag -> numeric amount (e.g. iron, coal).
@export var resources: Dictionary = {}
@export var victory_points: int = 0
#endregion

#region Modding / rules
## Feature tag -> numeric level (0 omits feature; booleans coerce to 1).
@export var special_features: Dictionary = {}
@export var tags: Array[String] = []
#endregion


func get_movement_cost() -> float:
	var terrain_mult := _base_terrain_movement_multiplier()
	var infra := float(clampi(infrastructure, 0, 50))
	var dev := float(clampi(development_level, 0, 50))
	var infra_factor := 1.0 / (1.0 + infra * 0.04)
	var dev_factor := 1.0 / (1.0 + dev * 0.02)
	if is_sea:
		return terrain_mult * infra_factor
	return terrain_mult * infra_factor * dev_factor


func has_feature(feature: String) -> bool:
	return get_feature_level(feature) > 0


func get_feature_level(feature: String) -> int:
	var key := _resolved_feature_key(feature)
	if key.is_empty():
		return 0
	var v: Variant = special_features[key]
	match typeof(v):
		TYPE_INT:
			return v
		TYPE_FLOAT:
			return int(v)
		TYPE_BOOL:
			return 1 if v else 0
		_:
			return 1


func _resolved_feature_key(feature: String) -> String:
	var needle := feature.strip_edges()
	if needle.is_empty():
		return ""
	if special_features.has(needle):
		return needle
	var lower := needle.to_lower()
	for k in special_features:
		var sk := str(k)
		if sk.to_lower() == lower:
			return sk
	return ""


func _base_terrain_movement_multiplier() -> float:
	match str(terrain).to_lower():
		"urban", "metro":
			return 0.9
		"hills":
			return 1.35
		"mountains":
			return 2.15
		"desert", "jungle":
			return 1.45
		"tundra", "forest":
			return 1.25
		"marshes", "swamp":
			return 1.5
		"sea", "ocean":
			return 1.0
		"coastal":
			return 1.1
		_:
			return 1.0
