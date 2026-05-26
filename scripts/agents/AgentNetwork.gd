# scripts/agents/AgentNetwork.gd
## Represents a persistent operative network / resistance cell in a specific province.
## Agents can establish and run these networks over time.

class_name AgentNetwork
extends Resource

@export var network_id: String = ""
@export var province_id: int = 0
@export var controlling_country: String = ""   # The country running the network
@export var lead_agent_id: String = ""         # The main agent running it (can be rotated)

@export var strength: float = 0.0              # 0.0 - 100.0 (grows by recruiting locals)
@export var local_operatives: int = 0

@export var focus: String = "intelligence"     # intelligence, supply_disruption, infrastructure_sabotage, etc.

@export var last_activity_month: int = 0
@export var detection_risk_accumulated: float = 0.0

var total_intel_gathered: int = 0
var total_disruption_caused: float = 0.0

func get_effectiveness() -> float:
	# Base effectiveness from strength + operatives
	var base := clampf(strength / 100.0, 0.0, 1.0)
	var operative_bonus := clampf(float(local_operatives) * 0.04, 0.0, 0.35)
	return clampf(base + operative_bonus, 0.1, 1.5)


func is_active() -> bool:
	return strength > 5.0 and not lead_agent_id.is_empty()
