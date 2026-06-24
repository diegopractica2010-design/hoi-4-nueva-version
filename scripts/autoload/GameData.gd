extends Node

## Global design/production data. Loaded once at startup.

var world = null
var design_data = null
var selected_nation_tag: String = ""


func _ready() -> void:
	var DesignDataLoader = load("res://scripts/core/DesignDataLoader.gd")
	design_data = DesignDataLoader.new()
	design_data.load_all()


func create_production_line(line_id: String):
	return ProductionManager.create_line(line_id)


func get_production_line(line_id: String):
	return ProductionManager.get_line(line_id)
