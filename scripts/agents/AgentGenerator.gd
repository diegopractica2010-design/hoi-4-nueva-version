# scripts/agents/AgentGenerator.gd
class_name AgentGenerator
extends Node

const POSSIBLE_FIRST_NAMES := [
	"Alexei", "Elena", "Marcus", "Sofia", "Johan", "Lila", "Victor", "Anya",
	"Thomas", "Isabelle", "Klaus", "Freya", "Hiroshi", "Mei", "Dmitri", "Natasha"
]

const POSSIBLE_LAST_NAMES := [
	"Voss", "Kovacs", "Lang", "Moreau", "Schmidt", "Petrov", "Tanaka", "Rossi",
	"Bauer", "Dubois", "Kowalski", "Santos", "Yamamoto", "Ivanov", "Laurent"
]


static func generate_agent(country_tag: String, year: int = 1936) -> Agent:
	var agent := Agent.new()

	agent.agent_id = "%s_agent_%d" % [country_tag.to_lower(), Time.get_unix_time_from_system()]
	agent.country_tag = country_tag
	agent.name = _generate_name()
	agent.birth_year = year - randi_range(25, 42)
	agent.start_year = year
	agent.level = randi_range(1, 3)
	agent.experience = randi_range(50, 250) * agent.level

	# Generate varied skill profiles
	agent.intelligence = randi_range(3, 8)
	agent.sabotage = randi_range(2, 7)
	agent.influence = randi_range(3, 8)
	agent.technology = randi_range(2, 7)
	agent.counter_intelligence = randi_range(2, 6)

	# Give some agents a specialty
	var specialty := randi() % 4
	match specialty:
		0:
			agent.intelligence = min(10, agent.intelligence + 2)
		1:
			agent.sabotage = min(10, agent.sabotage + 2)
		2:
			agent.influence = min(10, agent.influence + 2)
		3:
			agent.technology = min(10, agent.technology + 2)

	agent.status = "available"
	agent.current_mission_id = ""
	agent.mission_progress = 0.0

	return agent


static func _generate_name() -> String:
	var first := POSSIBLE_FIRST_NAMES[randi() % POSSIBLE_FIRST_NAMES.size()]
	var last := POSSIBLE_LAST_NAMES[randi() % POSSIBLE_LAST_NAMES.size()]
	return "%s %s" % [first, last]