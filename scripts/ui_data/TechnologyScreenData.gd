# scripts/ui_data/TechnologyScreenData.gd
class_name TechnologyScreenData
extends Resource

@export var country_tag: String = ""
@export var current_year: int = 1936
@export var domain_filter: String = "all"
@export var selected_tech_id: String = ""

@export var research_slots_max: int = 2
@export var research_slots_used: int = 0
@export var daily_rp: float = 1.0
@export var daily_rp_tooltip: String = ""

@export var available_count: int = 0
@export var completed_count: int = 0
@export var locked_count: int = 0
@export var in_progress_count: int = 0
@export var compromised_count: int = 0

@export var domains_present: Array[String] = []
@export var research_entries: Array[Dictionary] = []
@export var active_research: Array[Dictionary] = []
@export var inspector: Dictionary = {}

@export var era_epoch_filter: String = "all"
@export var graph_nodes: Array[Dictionary] = []
@export var graph_edges: Array[Dictionary] = []

@export var doctrine_xp: int = 0
@export var doctrine_xp_hint: String = ""
@export var doctrine_training_entries: Array[Dictionary] = []
@export var primary_leader_id: String = ""
@export var primary_leader_name: String = ""
@export var agent_tech_summary: Dictionary = {}

## Map integration (Phase F — build mode highlights on WorldMap).
@export var map_integration_note: String = ""
@export var map_build_mode_active: bool = false
@export var map_build_target_tech_id: String = ""
@export var map_build_target_label: String = ""
@export var map_eligible_province_count: int = -1
@export var map_legend_bbcode: String = ""
