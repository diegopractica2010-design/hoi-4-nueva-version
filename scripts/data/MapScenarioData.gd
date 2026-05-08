# scripts/data/MapScenarioData.gd
class_name MapScenarioData
extends RefCounted

## Single snapshot of everything needed to initialize the map view / renderer.
var provinces: Dictionary = {}
var geometry: Dictionary = {}
var adjacency_system: AdjacencySystem
var countries: Dictionary = {}


func _init(
	p_provinces: Dictionary = {},
	p_geometry: Dictionary = {},
	p_adjacency: AdjacencySystem = null,
	p_countries: Dictionary = {},
) -> void:
	provinces = p_provinces
	geometry = p_geometry
	adjacency_system = p_adjacency
	countries = p_countries
