# scripts/ui_data/AgentScreenData.gd
class_name AgentScreenData
extends Resource

@export var country_tag: String = ""

@export var total_agents: int = 0
@export var available_agents: int = 0
@export var on_mission_agents: int = 0
@export var compromised_agents: int = 0
@export var inactive_agents: int = 0

@export var agents: Array[Dictionary] = []
@export var target_countries: Array[String] = []
@export var mission_categories: Array[String] = []
@export var intel_reports: Array[Dictionary] = []
@export var recent_operations: Array[Dictionary] = []
