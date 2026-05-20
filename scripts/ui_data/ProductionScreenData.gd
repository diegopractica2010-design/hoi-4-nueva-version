# scripts/ui_data/ProductionScreenData.gd
class_name ProductionScreenData
extends Resource

@export var country_tag: String = ""

# === Top Summary Bar ===
@export var total_factories: int = 0
@export var total_production_lines: int = 0
@export var average_efficiency: float = 1.0
@export var factories_in_retooling: int = 0
@export var estimated_daily_output: float = 0.0

# === Main Factory List ===
@export var factories: Array[Dictionary] = []

# === Grouped Data (for filters) ===
@export var factories_by_type: Dictionary = {}
@export var factories_by_status: Dictionary = {}

# === Designs Currently Being Produced ===
@export var designs_in_production: Dictionary = {}

# === Quick Status Flags ===
@export var has_critical_efficiency: bool = false
@export var has_many_retooling: bool = false
