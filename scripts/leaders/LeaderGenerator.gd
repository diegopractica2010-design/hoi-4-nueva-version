# scripts/leaders/LeaderGenerator.gd
class_name LeaderGenerator
extends Node

const SPECIAL_TRAITS: Array[String] = [
	"desert_fox",
	"arctic_bear",
	"sea_wolf",
	"jungle_panther",
	"mountain_specialist",
	"logistics_wizard",
]


func generate_leader(country_tag: String, leader_type: String = "general") -> Leader:
	var leader := Leader.new()
	leader.leader_id = "%s_gen_%d" % [country_tag, Time.get_unix_time_from_system()]
	leader.country_tag = country_tag
	leader.leader_type = leader_type
	leader.name = _generate_name(country_tag)

	leader.attack_skill = randi_range(1, 6)
	leader.defense_skill = randi_range(1, 6)
	leader.organization_skill = randi_range(2, 7)
	leader.logistics_skill = randi_range(1, 6)
	leader.planning_skill = randi_range(1, 6)

	if randf() < 0.15:
		var trait_id := SPECIAL_TRAITS[randi() % SPECIAL_TRAITS.size()]
		LeaderManager.try_add_trait_to_leader(leader, trait_id, 1)

	if randf() < 0.08:
		LeaderManager.try_add_trait_to_leader(leader, "reckless", 1)

	return leader


func _generate_name(country_tag: String) -> String:
	return "%s Commander %d" % [country_tag, randi_range(100, 999)]
