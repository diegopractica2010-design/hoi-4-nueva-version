# scripts/data/MapScenarioData.gd
class_name MapScenarioData
extends RefCounted

## Single snapshot of everything needed to initialize the map view / renderer.
var provinces: Dictionary[int, Province] = {}
var geometry: Dictionary = {}
var adjacency_system: AdjacencySystem
var countries: Dictionary[String, Variant] = {}


static func coerce_countries(source: Dictionary) -> Dictionary[String, Variant]:
	var out: Dictionary[String, Variant] = {}
	for tag_var in source.keys():
		var tag := str(tag_var).strip_edges().to_upper()
		if tag.is_empty():
			continue
		out[tag] = source[tag_var]
	return out


static func coerce_provinces(source: Dictionary) -> Dictionary[int, Province]:
	var out: Dictionary[int, Province] = {}
	for pid_var in source.keys():
		var entry: Variant = source[pid_var]
		if entry is Province:
			out[int(pid_var)] = entry as Province
	return out


func _init(
	p_provinces: Dictionary = {},
	p_geometry: Dictionary = {},
	p_adjacency: AdjacencySystem = null,
	p_countries: Dictionary = {},
) -> void:
	provinces = coerce_provinces(p_provinces)
	geometry = p_geometry
	adjacency_system = p_adjacency
	countries = coerce_countries(p_countries)
