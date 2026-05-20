# scripts/ui_data/LeaderScreenData.gd
class_name LeaderScreenData
extends Resource

@export var country_tag: String = ""

# === Top Summary Bar ===
@export var total_leaders: int = 0
@export var available_leaders: int = 0
@export var injured_leaders: int = 0
@export var captured_leaders: int = 0
@export var leaders_assigned_to_armies: int = 0

# === National Positions ===
@export var national_positions: Dictionary = {}
@export var national_position_bonuses: Dictionary = {}

# === Main Leader List ===
@export var leaders: Array[Dictionary] = []

# === Grouped Data ===
@export var leaders_by_type: Dictionary = {}
@export var leaders_by_availability: Dictionary = {}
@export var leaders_by_skill_tier: Dictionary = {}

# === Quick Status Flags ===
@export var has_many_injured: bool = false
@export var has_no_chief_of_army: bool = false
