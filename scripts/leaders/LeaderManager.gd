# scripts/leaders/LeaderManager.gd
extends Node

## Registry for leaders, army assignments, and national command positions.

const POSITION_CHIEF_OF_ARMY := "chief_of_army"
const POSITION_CHIEF_OF_NAVY := "chief_of_navy"
const POSITION_CHIEF_OF_AIR_FORCE := "chief_of_air_force"
const POSITION_HEAD_OF_STATE := "head_of_state"

const TOP_POSITIONS: Array[String] = [
	POSITION_CHIEF_OF_ARMY,
	POSITION_CHIEF_OF_NAVY,
	POSITION_CHIEF_OF_AIR_FORCE,
	POSITION_HEAD_OF_STATE,
]

const TRAITS_PATH := "res://data/leaders/leader_traits.json"
const HISTORICAL_LEADERS_1936_PATH := "res://data/leaders/historical_leaders_1936.json"
const MAX_SKILL := 10

var leaders: Dictionary = {}  # leader_id -> Leader
var country_leaders: Dictionary = {}  # country_tag -> { position_id -> leader_id }
var trait_definitions: Dictionary = {}


func _ready() -> void:
	_load_trait_definitions()
	load_leaders_from_json(HISTORICAL_LEADERS_1936_PATH)


func register_leader(leader: Leader) -> void:
	if leader == null or leader.leader_id.is_empty():
		push_warning("LeaderManager: cannot register leader without leader_id")
		return
	leaders[leader.leader_id] = leader


func assign_leader_to_army(leader_id: String, army_id: String) -> bool:
	var leader: Leader = leaders.get(leader_id) as Leader
	if leader == null:
		return false
	leader.assigned_army_id = army_id
	return true


func unassign_leader_from_army(leader_id: String) -> void:
	var leader: Leader = leaders.get(leader_id) as Leader
	if leader != null:
		leader.assigned_army_id = ""


func get_leader(leader_id: String) -> Leader:
	return leaders.get(leader_id) as Leader


func get_leader_for_army(army_id: String) -> Leader:
	for leader_id in leaders:
		var leader: Leader = leaders[leader_id] as Leader
		if leader != null and leader.assigned_army_id == army_id:
			return leader
	return null


func set_country_position(country_tag: String, position_id: String, leader_id: String) -> bool:
	if not TOP_POSITIONS.has(position_id):
		push_warning("LeaderManager: unknown position '%s'" % position_id)
		return false
	var leader: Leader = leaders.get(leader_id) as Leader
	if leader == null:
		return false
	if leader.country_tag != country_tag:
		push_warning(
			"LeaderManager: leader %s (%s) does not match country %s"
			% [leader_id, leader.country_tag, country_tag]
		)
		return false
	if not country_leaders.has(country_tag):
		country_leaders[country_tag] = {}
	(country_leaders[country_tag] as Dictionary)[position_id] = leader_id
	return true


func get_country_position_leader(country_tag: String, position_id: String) -> Leader:
	if not country_leaders.has(country_tag):
		return null
	var positions: Dictionary = country_leaders[country_tag]
	return leaders.get(str(positions.get(position_id, ""))) as Leader


func get_leaders_for_country(country_tag: String) -> Array[Leader]:
	var out: Array[Leader] = []
	for leader_id in leaders:
		var leader: Leader = leaders[leader_id] as Leader
		if leader != null and leader.country_tag == country_tag:
			out.append(leader)
	return out


func promote_leader(leader_id: String) -> bool:
	var leader: Leader = leaders.get(leader_id) as Leader
	if leader == null:
		return false
	leader.attack_skill = mini(leader.attack_skill + 1, MAX_SKILL)
	leader.defense_skill = mini(leader.defense_skill + 1, MAX_SKILL)
	leader.organization_skill = mini(leader.organization_skill + 1, MAX_SKILL)
	leader.logistics_skill = mini(leader.logistics_skill + 1, MAX_SKILL)
	leader.planning_skill = mini(leader.planning_skill + 1, MAX_SKILL)
	return true


func get_trait_definition(trait_id: String) -> Dictionary:
	var key := str(trait_id)
	if trait_definitions.has(key):
		return trait_definitions[key] as Dictionary
	return {}


func _load_trait_definitions() -> void:
	if not ResourceLoader.exists(TRAITS_PATH):
		return
	var file := FileAccess.open(TRAITS_PATH, FileAccess.READ)
	if file == null:
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	file.close()
	if typeof(parsed) == TYPE_DICTIONARY:
		trait_definitions = parsed


func load_leaders_from_json(path: String) -> int:
	if not ResourceLoader.exists(path):
		return 0
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return 0
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	file.close()
	if typeof(parsed) != TYPE_DICTIONARY:
		return 0

	var loaded := 0
	var block: Variant = (parsed as Dictionary).get("leaders", [])
	if typeof(block) != TYPE_ARRAY:
		return 0
	for entry in block as Array:
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		var leader := _leader_from_dict(entry as Dictionary)
		if leader == null:
			continue
		register_leader(leader)
		loaded += 1
	return loaded


func _leader_from_dict(data: Dictionary) -> Leader:
	var leader_id := str(data.get("leader_id", ""))
	if leader_id.is_empty():
		return null
	var leader := Leader.new()
	leader.leader_id = leader_id
	leader.name = str(data.get("name", ""))
	leader.country_tag = str(data.get("country_tag", ""))
	leader.leader_type = str(data.get("leader_type", "general"))
	leader.attack_skill = clampi(int(data.get("attack_skill", 3)), 0, MAX_SKILL)
	leader.defense_skill = clampi(int(data.get("defense_skill", 3)), 0, MAX_SKILL)
	leader.organization_skill = clampi(int(data.get("organization_skill", 3)), 0, MAX_SKILL)
	leader.logistics_skill = clampi(int(data.get("logistics_skill", 3)), 0, MAX_SKILL)
	leader.planning_skill = clampi(int(data.get("planning_skill", 3)), 0, MAX_SKILL)
	leader.experience = int(data.get("experience", 0))
	leader.battles_fought = int(data.get("battles_fought", 0))
	leader.is_injured = bool(data.get("is_injured", false))
	leader.is_captured = bool(data.get("is_captured", false))
	leader.assigned_army_id = str(data.get("assigned_army_id", ""))

	var traits_block: Variant = data.get("traits", [])
	if typeof(traits_block) == TYPE_ARRAY:
		for trait_id in traits_block as Array:
			leader.add_trait(str(trait_id))
	return leader
