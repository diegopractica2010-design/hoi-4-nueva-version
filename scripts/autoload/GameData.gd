extends Node

## Global design/production data. Loaded once at startup.

var design_data: DesignDataLoader = DesignDataLoader.new()
var selected_nation_tag: String = ""


func _ready() -> void:
	design_data.load_all()


func create_production_line(line_id: String) -> ProductionLine:
	return ProductionManager.create_line(line_id)


func get_production_line(line_id: String) -> ProductionLine:
	return ProductionManager.get_line(line_id)
