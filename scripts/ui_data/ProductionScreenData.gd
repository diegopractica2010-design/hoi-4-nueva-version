# scripts/ui_data/ProductionScreenData.gd
class_name ProductionScreenData
extends Resource

## Snapshot for the Production Assignment screen. Built by ProductionManager.get_production_screen_data().

@export var country_tag: String = ""
@export var total_factories: int = 0
@export var total_production_lines: int = 0

@export var factories: Array[Dictionary] = []
@export var designs_in_production: Dictionary = {}  # design_id -> total daily output

@export var average_efficiency: float = 1.0
@export var factories_in_retooling: int = 0
