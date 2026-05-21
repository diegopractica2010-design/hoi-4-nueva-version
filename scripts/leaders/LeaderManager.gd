# scripts/leaders/LeaderManager.gd
extends Node

## Registry for leaders, army assignments, and national command positions.

const POSITION_CHIEF_OF_ARMY := "chief_of_army"
const POSITION_CHIEF_OF_NAVY := "chief_of_navy"
const POSITION_CHIEF_OF_AIR_FORCE := "chief_of_air_force"
const POSITION_CHIEF_OF_SPACE_FORCE := "chief_of_space_force"

const NATIONAL_POSITIONS: Array[String] = [
	POSITION_CHIEF_OF_ARMY,
	POSITION_CHIEF_OF_NAVY,
	POSITION_CHIEF_OF_AIR_FORCE,
	POSITION_CHIEF_OF_SPACE_FORCE,
]

const NATIONAL_POSITION_CHANGE_COST: Dictionary = {
	"stability": 5.0,
	"prestige": 3.0,
}

const TRAITS_PATH := "res://data/leaders/leader_traits.json"
const HISTORICAL_LEADERS_1936_PATH := "res://data/leaders/historical_leaders_1936.json"
const MAX_SKILL := 10

var leaders: Dictionary = {}  # leader_id -> Leader
var formations: Dictionary = {}  # formation_id -> Formation
var country_positions: Dictionary = {}  # country_tag -> { position_id -> leader_id }
var trait_definitions: Dictionary = {}

# === Screen data caching ===
var _leader_screen_cache: Dictionary = {}  # country_tag -> LeaderScreenData


func _ready() -> void:
	_load_trait_definitions()
	load_leaders_from_json(HISTORICAL_LEADERS_1936_PATH)


func register_leader(leader: Leader) -> void:
	if leader == null or leader.leader_id.is_empty():
		push_warning("LeaderManager: cannot register leader without leader_id")
		return
	leaders[leader.leader_id] = leader
	invalidate_leader_cache(leader.country_tag)


func assign_leader_to_army(leader_id: String, army_id: String) -> bool:
	if formations.has(army_id):
		return assign_leader_to_formation(leader_id, army_id)

	var leader: Leader = leaders.get(leader_id) as Leader
	if leader == null:
		return false
	_unassign_leader_from_current_formation(leader)
	leader.assigned_army_id = army_id
	invalidate_leader_cache(leader.country_tag)
	return true


func unassign_leader_from_army(leader_id: String) -> void:
	var leader: Leader = leaders.get(leader_id) as Leader
	if leader == null:
		return
	_unassign_leader_from_current_formation(leader)
	leader.assigned_army_id = ""
	invalidate_leader_cache(leader.country_tag)


func get_leader(leader_id: String) -> Leader:
	return leaders.get(leader_id) as Leader


func get_leader_for_army(army_id: String) -> Leader:
	var formation: Formation = get_formation(army_id)
	if formation != null and formation.has_leader():
		return get_leader(formation.leader_id)

	for leader_key in leaders:
		var leader: Leader = leaders[leader_key] as Leader
		if leader != null and leader.assigned_army_id == army_id:
			return leader
	return null


# === Formation registry & assignment ===

func register_formation(formation: Formation) -> void:
	if formation == null or formation.formation_id.is_empty():
		push_warning("LeaderManager: cannot register formation without formation_id")
		return
	formations[formation.formation_id] = formation
	invalidate_leader_cache(formation.country_tag)


func get_formation(formation_id: String) -> Formation:
	return formations.get(formation_id) as Formation


func get_formations_for_country(country_tag: String) -> Array[Formation]:
	var result: Array[Formation] = []
	for formation_id in formations:
		var formation: Formation = formations[formation_id] as Formation
		if formation != null and formation.country_tag == country_tag:
			result.append(formation)
	return result


func assign_leader_to_formation(leader_id: String, formation_id: String) -> bool:
	var leader: Leader = get_leader(leader_id)
	var formation: Formation = get_formation(formation_id)

	if leader == null or formation == null:
		return false

	if not _is_leader_valid_for_formation(leader, formation):
		push_warning(
			"LeaderManager: leader type mismatch — %s cannot lead %s (%s)"
			% [leader.leader_type, formation.name, formation.formation_type]
		)
		return false

	_unassign_leader_from_current_formation(leader)

	var previous_leader: Leader = get_leader(formation.leader_id)
	if previous_leader != null and previous_leader != leader:
		_unassign_leader_from_current_formation(previous_leader)

	formation.assign_leader(leader)
	leader.assigned_army_id = formation_id
	invalidate_leader_cache(leader.country_tag)
	return true


func unassign_leader_from_formation(formation_id: String) -> void:
	var formation: Formation = get_formation(formation_id)
	if formation == null or not formation.has_leader():
		return

	var leader: Leader = get_leader(formation.leader_id)
	formation.remove_leader()
	if leader != null:
		leader.assigned_army_id = ""
		invalidate_leader_cache(leader.country_tag)


## Register division templates from SupplyManager as land formations for a country.
func register_division_formations_for_country(country_tag: String) -> void:
	if SupplyManager == null or SupplyManager.division_templates == null:
		return

	SupplyManager.division_templates.load_all()

	for div_id in SupplyManager.division_templates.get_all_division_ids():
		var div_template: DivisionTemplate = SupplyManager.division_templates.get_division(div_id)
		if div_template == null:
			continue

		var division_country := div_template.country_tag
		if division_country.is_empty():
			division_country = _infer_division_country_tag(div_id)
		if division_country != country_tag:
			continue

		if formations.has(div_id):
			continue

		register_formation(Formation.from_division_template(div_id, div_template, country_tag))


func clear_all_formations() -> void:
	formations.clear()


## Formations for [param country_tag] that do not have a leader assigned.
func get_available_formations(country_tag: String) -> Array[Dictionary]:
	var available: Array[Dictionary] = []

	register_division_formations_for_country(country_tag)

	for formation_id in formations:
		var formation: Formation = formations[formation_id] as Formation
		if formation == null:
			continue
		if formation.country_tag != country_tag:
			continue
		if formation.has_leader():
			continue

		available.append({
			"formation_id": formation.formation_id,
			"name": formation.name,
			"type": formation.formation_type,
			"category": formation.get_category(),
		})

	return available


func _unassign_leader_from_current_formation(leader: Leader) -> void:
	if leader == null or leader.assigned_army_id.is_empty():
		return

	var current: Formation = get_formation(leader.assigned_army_id)
	if current != null and current.leader_id == leader.leader_id:
		current.remove_leader()


func _is_leader_valid_for_formation(leader: Leader, formation: Formation) -> bool:
	match formation.formation_type:
		Formation.TYPE_FLEET, Formation.TYPE_TASK_FORCE, Formation.TYPE_SHIP:
			return leader.leader_type == "admiral"
		Formation.TYPE_AIR_WING, Formation.TYPE_AIR_SQUADRON, Formation.TYPE_AIR_GROUP:
			return leader.leader_type == "air_marshal"
		Formation.TYPE_SPACE_WING, Formation.TYPE_ORBITAL_GROUP:
			return leader.leader_type == "space_commander"
		Formation.TYPE_DIVISION, Formation.TYPE_ARMY, Formation.TYPE_ARMY_GROUP, Formation.TYPE_GARRISON, Formation.TYPE_BRIGADE:
			return leader.leader_type in ["general", "field_marshal"]
		_:
			return true


func _infer_division_country_tag(division_id: String) -> String:
	var div_key := division_id.to_lower()
	const PREFIX_TAGS: Array[Dictionary] = [
		{"prefix": "german_", "tag": "GER"},
		{"prefix": "us_", "tag": "USA"},
		{"prefix": "sov_", "tag": "SOV"},
		{"prefix": "fra_", "tag": "FRA"},
		{"prefix": "uk_", "tag": "ENG"},
		{"prefix": "eng_", "tag": "ENG"},
		{"prefix": "ita_", "tag": "ITA"},
		{"prefix": "jap_", "tag": "JAP"},
		{"prefix": "ger_", "tag": "GER"},
	]
	for entry in PREFIX_TAGS:
		if div_key.begins_with(str(entry.get("prefix", ""))):
			return str(entry.get("tag", ""))
	return ""


# === National top positions (chiefs of staff) ===

func get_valid_leader_types_for_position(position: String) -> Array[String]:
	match position:
		POSITION_CHIEF_OF_NAVY:
			return ["admiral"]
		POSITION_CHIEF_OF_AIR_FORCE:
			return ["air_marshal"]
		POSITION_CHIEF_OF_SPACE_FORCE:
			return ["space_commander"]
		POSITION_CHIEF_OF_ARMY:
			return ["general", "field_marshal"]
		_:
			return ["general", "field_marshal", "admiral", "air_marshal"]


func can_assign_national_position(
	country_tag: String,
	position: String,
	new_leader_id: String,
) -> Dictionary:
	var result := {
		"can_assign": true,
		"cost": NATIONAL_POSITION_CHANGE_COST.duplicate(),
		"reason": "",
	}

	if not NATIONAL_POSITIONS.has(position):
		result["can_assign"] = false
		result["reason"] = "Invalid position"
		return result

	var leader: Leader = leaders.get(new_leader_id) as Leader
	if leader == null:
		result["can_assign"] = false
		result["reason"] = "Leader not found"
		return result
	if leader.country_tag != country_tag:
		result["can_assign"] = false
		result["reason"] = "Leader does not match country"
		return result

	var valid_types := get_valid_leader_types_for_position(position)
	if not valid_types.has(leader.leader_type):
		result["can_assign"] = false
		result["reason"] = "Leader type not eligible for this position"
		return result

	return result


func set_country_position(
	country_tag: String,
	position: String,
	leader_id: String,
	apply_cost: bool = true,
) -> bool:
	if not NATIONAL_POSITIONS.has(position):
		push_warning("LeaderManager: invalid national position: " + position)
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

	if not country_positions.has(country_tag):
		country_positions[country_tag] = {}

	if apply_cost:
		print(
			"Changing %s position for %s. Cost will be applied (future system)."
			% [position, country_tag]
		)

	(country_positions[country_tag] as Dictionary)[position] = leader_id
	print(
		"Set %s as %s for %s"
		% [leader.name, position, country_tag]
	)
	invalidate_leader_cache(country_tag)
	return true


func get_country_position_leader(country_tag: String, position: String) -> Leader:
	if not country_positions.has(country_tag):
		return null
	var positions: Dictionary = country_positions[country_tag]
	var leader_id := str(positions.get(position, ""))
	if leader_id.is_empty():
		return null
	return leaders.get(leader_id) as Leader


func get_national_bonuses(country_tag: String) -> Dictionary:
	var bonuses := {
		"army_attack": 0.0,
		"army_organization": 0.0,
		"naval_combat": 0.0,
		"air_support": 0.0,
		"planning_speed": 0.0,
	}

	var chief_army := get_country_position_leader(country_tag, POSITION_CHIEF_OF_ARMY)
	if chief_army != null:
		bonuses["army_attack"] = float(bonuses["army_attack"]) + chief_army.get_attack_modifier() * 0.8
		bonuses["army_organization"] = (
			float(bonuses["army_organization"]) + chief_army.get_organization_modifier() * 0.7
		)
		bonuses["planning_speed"] = float(bonuses["planning_speed"]) + chief_army.get_planning_modifier() * 1.2

	var chief_navy := get_country_position_leader(country_tag, POSITION_CHIEF_OF_NAVY)
	if chief_navy != null:
		bonuses["naval_combat"] = float(bonuses["naval_combat"]) + chief_navy.get_attack_modifier() * 0.9

	var chief_air := get_country_position_leader(country_tag, POSITION_CHIEF_OF_AIR_FORCE)
	if chief_air != null:
		bonuses["air_support"] = float(bonuses["air_support"]) + chief_air.get_attack_modifier() * 0.6

	return bonuses


func get_leaders_for_country(country_tag: String) -> Array[Leader]:
	var out: Array[Leader] = []
	for leader_id in leaders:
		var leader: Leader = leaders[leader_id] as Leader
		if leader != null and leader.country_tag == country_tag:
			out.append(leader)
	return out


# === Leader Assignment screen support ===
# Screen snapshots are cached per country; invalidate_leader_cache() on state changes.

func get_available_leaders(country_tag: String) -> Array[Leader]:
	var result: Array[Leader] = []
	for leader_id in leaders:
		var leader: Leader = leaders[leader_id] as Leader
		if leader == null or leader.country_tag != country_tag:
			continue
		if leader.assigned_army_id.is_empty() and not leader.is_captured:
			result.append(leader)
	return result


func get_armies_without_leader(_country_tag: String) -> Array[String]:
	# Placeholder until Army registry exists.
	return []


func get_leader_summary(leader_id: String) -> Dictionary:
	var leader: Leader = get_leader(leader_id)
	if leader == null:
		return {}

	return {
		"leader_id": leader_id,
		"name": leader.name,
		"country_tag": leader.country_tag,
		"leader_type": leader.leader_type,
		"attack_skill": leader.attack_skill,
		"defense_skill": leader.defense_skill,
		"organization_skill": leader.organization_skill,
		"logistics_skill": leader.logistics_skill,
		"planning_skill": leader.planning_skill,
		"traits": leader.traits.duplicate(),
		"experience": leader.experience,
		"battles_fought": leader.battles_fought,
		"is_injured": leader.is_injured,
		"is_captured": leader.is_captured,
		"assigned_army_id": leader.assigned_army_id,
	}


func get_country_leader_overview(country_tag: String) -> Dictionary:
	var summaries: Array = []
	for leader in get_leaders_for_country(country_tag):
		summaries.append(get_leader_summary(leader.leader_id))

	var positions: Dictionary = {}
	if country_positions.has(country_tag):
		positions = (country_positions[country_tag] as Dictionary).duplicate()

	return {
		"country_tag": country_tag,
		"total_leaders": summaries.size(),
		"available_count": get_available_leaders(country_tag).size(),
		"leaders": summaries,
		"national_positions": positions,
	}


func get_leader_screen_data(country_tag: String, use_cache: bool = true) -> LeaderScreenData:
	if use_cache and _leader_screen_cache.has(country_tag):
		return _leader_screen_cache[country_tag] as LeaderScreenData

	var data := _build_leader_screen_data(country_tag)
	_leader_screen_cache[country_tag] = data
	return data


func invalidate_leader_cache(country_tag: String) -> void:
	_leader_screen_cache.erase(country_tag)


func clear_all_leader_caches() -> void:
	_leader_screen_cache.clear()


func _build_leader_screen_data(country_tag: String) -> LeaderScreenData:
	var data := LeaderScreenData.new()
	data.country_tag = country_tag

	var country_leader_list := get_leaders_for_country(country_tag)
	data.total_leaders = country_leader_list.size()

	var available := 0
	var injured := 0
	var captured := 0
	var assigned := 0

	var by_type: Dictionary = {}
	var by_availability: Dictionary = {
		"available": [],
		"assigned": [],
		"injured": [],
		"captured": [],
	}
	var by_skill_tier: Dictionary = {}

	for leader in country_leader_list:
		var summary := get_leader_summary(leader.leader_id)
		summary["skill_tier"] = _get_skill_tier(leader)
		summary["leader_type_name"] = _get_leader_type_name(leader.leader_type)
		data.leaders.append(summary)

		if leader.is_captured:
			captured += 1
			_append_leader_to_group(by_availability, "captured", summary)
		elif leader.is_injured:
			injured += 1
			_append_leader_to_group(by_availability, "injured", summary)
		elif not leader.assigned_army_id.is_empty():
			assigned += 1
			_append_leader_to_group(by_availability, "assigned", summary)
		else:
			available += 1
			_append_leader_to_group(by_availability, "available", summary)

		var leader_type := leader.leader_type if not leader.leader_type.is_empty() else "general"
		_append_leader_to_group(by_type, leader_type, summary)
		_append_leader_to_group(by_skill_tier, str(summary.get("skill_tier", "average")), summary)

	data.available_leaders = available
	data.injured_leaders = injured
	data.captured_leaders = captured
	data.leaders_assigned_to_armies = assigned
	data.leaders_by_type = by_type
	data.leaders_by_availability = by_availability
	data.leaders_by_skill_tier = by_skill_tier

	if country_positions.has(country_tag):
		data.national_positions = (country_positions[country_tag] as Dictionary).duplicate()
		data.national_position_bonuses = get_national_bonuses(country_tag)

	data.has_many_injured = (
		data.total_leaders > 0 and float(injured) > float(data.total_leaders) * 0.25
	)
	data.has_no_chief_of_army = not data.national_positions.has(POSITION_CHIEF_OF_ARMY)

	return data


# === Leader helper methods ===

func _get_skill_tier(leader: Leader) -> String:
	var avg_skill := (
		float(leader.attack_skill)
		+ float(leader.defense_skill)
		+ float(leader.logistics_skill)
		+ float(leader.planning_skill)
	) / 4.0

	if avg_skill >= 8.0:
		return "elite"
	if avg_skill >= 6.0:
		return "veteran"
	if avg_skill >= 4.0:
		return "average"
	return "green"


func _get_leader_type_name(leader_type: String) -> String:
	match leader_type:
		"general":
			return "General"
		"admiral":
			return "Admiral"
		"air_marshal":
			return "Air Marshal"
		"space_commander":
			return "Space Commander"
		_:
			return leader_type.capitalize()


func _append_leader_to_group(group_dict: Dictionary, key: String, summary: Dictionary) -> void:
	if not group_dict.has(key):
		group_dict[key] = []
	(group_dict[key] as Array).append(summary)


# === Experience, traits, injury, capture, promotion ===

func award_battle_experience(leader_id: String, amount: int = 25) -> void:
	var leader: Leader = leaders.get(leader_id) as Leader
	if leader == null:
		return
	leader.add_experience(amount)
	_check_for_trait_gain(leader)
	invalidate_leader_cache(leader.country_tag)


func _check_for_trait_gain(leader: Leader) -> void:
	if leader.battles_fought >= 15 and not leader.has_trait("logistics_wizard"):
		if randf() < 0.25:
			leader.add_trait("logistics_wizard", 1)
			print("%s has gained the trait: Logistics Wizard!" % leader.name)

	if leader.battles_fought >= 25 and randf() < 0.15:
		if not leader.has_trait("desert_fox") and randf() < 0.3:
			leader.add_trait("desert_fox", 1)
			print("%s has gained the trait: Desert Fox!" % leader.name)


func handle_injury_or_capture(leader_id: String) -> void:
	var leader: Leader = leaders.get(leader_id) as Leader
	if leader == null:
		return

	if randf() < 0.04:
		leader.is_injured = true
		print("%s has been injured!" % leader.name)

	if randf() < 0.015:
		leader.is_captured = true
		print("%s has been captured!" % leader.name)

	invalidate_leader_cache(leader.country_tag)


func promote_leader(leader_id: String) -> bool:
	var leader: Leader = leaders.get(leader_id) as Leader
	if leader == null:
		return false
	leader.attack_skill = mini(leader.attack_skill + 1, MAX_SKILL)
	leader.defense_skill = mini(leader.defense_skill + 1, MAX_SKILL)
	leader.organization_skill = mini(leader.organization_skill + 1, MAX_SKILL)
	leader.logistics_skill = mini(leader.logistics_skill + 1, MAX_SKILL)
	leader.planning_skill = mini(leader.planning_skill + 1, MAX_SKILL)
	print("%s has been promoted!" % leader.name)
	invalidate_leader_cache(leader.country_tag)
	return true


func create_and_register_new_leader(country_tag: String, leader_type: String = "general") -> Leader:
	var generator := LeaderGenerator.new()
	var new_leader := generator.generate_leader(country_tag, leader_type)
	generator.free()
	register_leader(new_leader)
	return new_leader


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
