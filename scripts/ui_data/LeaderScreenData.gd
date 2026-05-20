# scripts/ui_data/LeaderScreenData.gd
class_name LeaderScreenData
extends Resource

## Snapshot for the Leader Assignment screen. Built by LeaderManager.get_leader_screen_data().

@export var country_tag: String = ""

@export var total_leaders: int = 0
@export var available_leaders: int = 0
@export var injured_leaders: int = 0
@export var captured_leaders: int = 0

@export var leaders: Array[Dictionary] = []
@export var national_positions: Dictionary = {}  # position_id -> leader_id
