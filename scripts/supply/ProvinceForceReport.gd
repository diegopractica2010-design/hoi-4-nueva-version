class_name ProvinceForceReport
extends RefCounted

var province_id: int = -1
var land_by_tag: Dictionary = {}
var air_by_tag: Dictionary = {}
var naval_by_tag: Dictionary = {}
var naval_at_port_by_tag: Dictionary = {}


func _init(p_province_id: int = -1) -> void:
	province_id = p_province_id


func add_land(tag: String, amount: float) -> void:
	land_by_tag[tag] = float(land_by_tag.get(tag, 0.0)) + amount


func add_air(tag: String, amount: float) -> void:
	air_by_tag[tag] = float(air_by_tag.get(tag, 0.0)) + amount


func add_naval(tag: String, amount: float, at_port: bool) -> void:
	naval_by_tag[tag] = float(naval_by_tag.get(tag, 0.0)) + amount
	if at_port:
		naval_at_port_by_tag[tag] = float(naval_at_port_by_tag.get(tag, 0.0)) + amount


func total_land(tag: String) -> float:
	return float(land_by_tag.get(tag, 0.0))


func total_air(tag: String) -> float:
	return float(air_by_tag.get(tag, 0.0))


func total_naval_at_port(tag: String) -> float:
	return float(naval_at_port_by_tag.get(tag, 0.0))
