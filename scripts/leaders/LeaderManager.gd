# scripts/leaders/LeaderManager.gd
extends Node

## Registry for leaders, army assignments, and national command positions.

signal leader_died(leader_id: String, cause: String)
signal leader_captured(leader_id: String, cause: String)
signal leader_retirement_offered(leader_id: String)
signal leader_retired(leader_id: String)
signal leader_introduced(leader_id: String)
signal game_year_advanced(year: int)

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

const TRAITS_PATH := "res://data/leaders/traits.json"
const LEGACY_TRAITS_PATH := "res://data/leaders/leader_traits.json"
const HISTORICAL_LEADERS_1936_PATH := "res://data/leaders/historical_leaders_1936.json"
const HISTORICAL_LEADERS_1918_PATH := "res://data/leaders/historical_leaders_1918.json"
const SCENARIO_LEADER_PATHS: Dictionary = {
	"1918": HISTORICAL_LEADERS_1918_PATH,
	"1936": HISTORICAL_LEADERS_1936_PATH,
}
const MAX_SKILL := 10
const MAX_TRAITS_PER_LEADER := 6
const MAX_LEGENDARY_TRAITS := 2
const RARITY_LEGENDARY := "legendary"
const XP_BASE_COMBAT := 25
const XP_COMBAT_MULTIPLIER := 2.75
const XP_COST_BY_RARITY: Dictionary = {
	"common": 100,
	"notable": 200,
	"rare": 350,
	"legendary": 600,
}
const ROMAN_LEVELS: Array[String] = ["", "I", "II", "III", "IV"]

## Yearly mortality chart (max age exclusive upper bound in loop).
## Per-battle while assigned to an active formation (not yearly natural death).
const COMBAT_DEATH_CHANCE_PER_BATTLE := 0.0003
## When the leader's formation is destroyed, death or capture combined chance.
const FORMATION_DESTROYED_FATE_CHANCE := 0.30
## Share of destroyed-formation fate rolls that kill rather than capture.
const FORMATION_DESTROYED_DEATH_SHARE := 0.45
const RETIREMENT_HONORS_PRESTIGE := 3.0
const RETIREMENT_HONORS_UNITY := 2.0

const AGE_MORTALITY_BRACKETS: Array[Dictionary] = [
	{"max_age": 50, "death": 0.003, "retire": 0.005},
	{"max_age": 60, "death": 0.008, "retire": 0.020},
	{"max_age": 65, "death": 0.018, "retire": 0.050},
	{"max_age": 70, "death": 0.035, "retire": 0.120},
	{"max_age": 75, "death": 0.065, "retire": 0.220},
	{"max_age": 80, "death": 0.110, "retire": 0.300},
	{"max_age": 999, "death": 0.180, "retire": 0.350},
]

var leaders: Dictionary = {}  # leader_id -> Leader
var leader_pool: Dictionary = {}  # leader_id -> Dictionary (not yet available by year)
var pending_retirements: Array[String] = []
var formations: Dictionary = {}  # formation_id -> Formation
var country_positions: Dictionary = {}  # country_tag -> { position_id -> leader_id }
var trait_definitions: Dictionary = {}
var current_year: int = 1936
var _historical_leaders_source_path: String = ""
## Per-country morale bonuses from honored retirements (stub until national UI exists).
var national_prestige: Dictionary = {}  # country_tag -> float
var national_unity: Dictionary = {}  # country_tag -> float

# === Screen data caching ===
var _leader_screen_cache: Dictionary = {}  # country_tag -> LeaderScreenData


func _ready() -> void:
	_load_trait_definitions()
	set_current_year(1936)
	load_historical_leaders(HISTORICAL_LEADERS_1936_PATH, 1936)


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
		if not leader.is_available_for_command():
			continue
		if leader.is_injured:
			continue
		if leader.assigned_army_id.is_empty():
			result.append(leader)
	return result


func get_current_year() -> int:
	return current_year


func set_current_year(year: int) -> void:
	current_year = maxi(year, 1)


func get_leader_age(leader: Leader) -> int:
	if leader == null:
		return 0
	return maxi(current_year - leader.birth_year, 18)


func get_pool_leader_count(country_tag: String = "") -> int:
	if country_tag.is_empty():
		return leader_pool.size()
	var count := 0
	for entry in leader_pool.values():
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		if str((entry as Dictionary).get("country_tag", "")) == country_tag:
			count += 1
	return count


func is_leader_entry_active_for_year(entry: Dictionary, year: int) -> bool:
	var start := int(entry.get("start_year", 0))
	if start > 0 and year < start:
		return false
	var end := int(entry.get("end_year", 0))
	if end > 0 and year > end:
		return false
	return true


func get_yearly_death_chance(leader: Leader) -> float:
	if leader == null or leader.is_deceased or leader.is_retired:
		return 0.0
	var age := get_leader_age(leader)
	var base := _base_chance_for_age(age, "death")
	base *= _mortality_situation_multiplier(leader, true)
	base *= leader.health
	if leader.stayed_past_retirement:
		base *= 1.25
	return clampf(base, 0.0, 0.35)


func get_yearly_retirement_chance(leader: Leader) -> float:
	if leader == null or leader.is_deceased or leader.is_retired:
		return 0.0
	var age := get_leader_age(leader)
	var base := _base_chance_for_age(age, "retire")
	base *= _mortality_situation_multiplier(leader, false)
	if leader.stayed_past_retirement:
		base *= 1.35
	return clampf(base, 0.0, 0.45)


func _base_chance_for_age(age: int, kind: String) -> float:
	for bracket in AGE_MORTALITY_BRACKETS:
		if age < int(bracket.get("max_age", 999)):
			return float(bracket.get(kind, 0.0))
	return 0.0


func get_combat_death_chance_per_battle(leader: Leader, intensity: float = 1.0) -> float:
	if leader == null or not leader.is_available_for_command() or not leader.is_in_combat_role():
		return 0.0
	var chance := COMBAT_DEATH_CHANCE_PER_BATTLE * clampf(intensity, 0.25, 4.0)
	chance *= _combat_casualty_trait_multiplier(leader)
	if leader.is_injured:
		chance *= 1.5
	return clampf(chance, 0.0, 0.01)


func get_formation_destroyed_fate_chance(leader: Leader) -> float:
	if leader == null or not leader.is_available_for_command():
		return 0.0
	if leader.assigned_army_id.is_empty():
		return 0.0
	return clampf(
		FORMATION_DESTROYED_FATE_CHANCE * _combat_casualty_trait_multiplier(leader),
		0.0,
		0.5,
	)


func roll_combat_battle_casualty(
	army_or_formation_id: String,
	intensity: float = 1.0,
) -> Dictionary:
	var leader: Leader = get_leader_for_army(army_or_formation_id)
	if leader == null:
		return {"type": "none", "leader_id": ""}

	var chance := get_combat_death_chance_per_battle(leader, intensity)
	if chance <= 0.0:
		return {"type": "none", "leader_id": leader.leader_id}

	if randf() < chance:
		var leader_id := leader.leader_id
		_remove_leader(leader_id, "combat", true)
		leader_died.emit(leader_id, "combat")
		return {"type": "death", "leader_id": leader_id, "cause": "combat", "chance": chance}

	return {"type": "none", "leader_id": leader.leader_id, "chance": chance}


func handle_formation_destroyed(formation_id: String) -> Dictionary:
	var leader: Leader = get_leader_for_army(formation_id)
	if leader == null:
		return {"type": "none", "leader_id": ""}

	var leader_id := leader.leader_id
	var fate_chance := get_formation_destroyed_fate_chance(leader)
	if randf() >= fate_chance:
		return {"type": "survived", "leader_id": leader_id, "chance": fate_chance}

	_unassign_leader_from_current_formation(leader)
	_clear_leader_from_national_positions(leader_id)

	if randf() < FORMATION_DESTROYED_DEATH_SHARE:
		_remove_leader(leader_id, "formation_destroyed", true)
		leader_died.emit(leader_id, "formation_destroyed")
		return {
			"type": "death",
			"leader_id": leader_id,
			"cause": "formation_destroyed",
			"chance": fate_chance,
		}

	leader.is_captured = true
	print("%s has been captured after their command was destroyed!" % leader.name)
	invalidate_leader_cache(leader.country_tag)
	leader_captured.emit(leader_id, "formation_destroyed")
	return {
		"type": "captured",
		"leader_id": leader_id,
		"cause": "formation_destroyed",
		"chance": fate_chance,
	}


func _combat_casualty_trait_multiplier(leader: Leader) -> float:
	var mult := 1.0
	if leader.has_trait("iron_will"):
		mult *= 0.75
	if leader.has_trait("reckless"):
		mult *= 1.35
	if leader.has_trait("cautious"):
		mult *= 0.9
	if leader.duty_post == "rear_area":
		mult *= 0.5
	return mult


func _mortality_situation_multiplier(leader: Leader, for_death: bool) -> float:
	var mult := 1.0
	if leader.duty_post == "training":
		mult *= 0.55 if for_death else 0.7
	elif leader.duty_post == "rear_area":
		mult *= 0.4 if for_death else 0.6
	if leader.experience >= 800:
		mult *= 0.85 if for_death else 0.9
	if leader.has_trait("iron_will"):
		mult *= 0.8 if for_death else 0.9
	if leader.has_trait("reckless") or leader.has_trait("arrogant"):
		mult *= 1.25 if for_death else 1.1
	if leader.has_trait("political_liability"):
		mult *= 1.15 if for_death else 1.2
	if leader.has_trait("logistics_wizard"):
		mult *= 0.92 if for_death else 0.95
	if leader.is_injured:
		mult *= 1.35 if for_death else 1.0
	return mult


func check_leader_mortality(year: int = -1) -> Array[Dictionary]:
	if year > 0:
		set_current_year(year)
	var events: Array[Dictionary] = []
	for leader_id in leaders.keys():
		var leader: Leader = leaders[leader_id] as Leader
		if leader == null or not leader.is_available_for_command():
			continue
		if leader_id in pending_retirements:
			continue

		var death_chance := get_yearly_death_chance(leader)
		if randf() < death_chance:
			_remove_leader(leader_id, "natural", true)
			events.append({"type": "death", "leader_id": leader_id, "cause": "natural"})
			leader_died.emit(leader_id, "natural")
			continue

		var retire_chance := get_yearly_retirement_chance(leader)
		if randf() < retire_chance:
			pending_retirements.append(leader_id)
			events.append({"type": "retirement_offer", "leader_id": leader_id})
			leader_retirement_offered.emit(leader_id)

	return events


func resolve_retirement(leader_id: String, let_retire: bool, ask_to_stay: bool = false) -> bool:
	if leader_id not in pending_retirements:
		return false
	pending_retirements.erase(leader_id)
	var leader: Leader = leaders.get(leader_id) as Leader
	if leader == null:
		return false

	if let_retire:
		apply_retirement_honors(leader.country_tag)
		_remove_leader(leader_id, "retirement", false)
		leader_retired.emit(leader_id)
		return true

	if ask_to_stay:
		var agree_chance := 0.55
		if leader.has_trait("charismatic"):
			agree_chance += 0.1
		if leader.has_trait("iron_will"):
			agree_chance += 0.08
		if randf() < agree_chance:
			leader.stayed_past_retirement = true
			print("%s agrees to serve one more year." % leader.name)
			return true

	apply_retirement_honors(leader.country_tag)
	_remove_leader(leader_id, "retirement", false)
	leader_retired.emit(leader_id)
	return true


func apply_retirement_honors(country_tag: String) -> void:
	if country_tag.is_empty():
		return
	national_prestige[country_tag] = (
		float(national_prestige.get(country_tag, 50.0)) + RETIREMENT_HONORS_PRESTIGE
	)
	national_unity[country_tag] = (
		float(national_unity.get(country_tag, 50.0)) + RETIREMENT_HONORS_UNITY
	)


func get_national_prestige(country_tag: String) -> float:
	return float(national_prestige.get(country_tag, 50.0))


func get_national_unity(country_tag: String) -> float:
	return float(national_unity.get(country_tag, 50.0))


func advance_game_year() -> Dictionary:
	current_year += 1
	var introduced := introduce_eligible_leaders_for_year(current_year)
	var mortality_events := check_leader_mortality()
	game_year_advanced.emit(current_year)
	return {
		"year": current_year,
		"introduced": introduced,
		"mortality_events": mortality_events,
	}


func introduce_eligible_leaders_for_year(year: int = -1) -> int:
	var target_year := year if year > 0 else current_year
	var introduced := 0
	for leader_id in leader_pool.keys():
		var entry: Variant = leader_pool[leader_id]
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		if not is_leader_entry_active_for_year(entry as Dictionary, target_year):
			continue
		if leaders.has(leader_id):
			continue
		var leader := _leader_from_dict(entry as Dictionary)
		if leader == null:
			continue
		register_leader(leader)
		leader_pool.erase(leader_id)
		introduced += 1
		leader_introduced.emit(leader_id)
		print("%s has entered command (%d)." % [leader.name, target_year])
	return introduced


func _remove_leader(leader_id: String, cause: String, is_death: bool) -> void:
	var leader: Leader = leaders.get(leader_id) as Leader
	if leader == null:
		return
	_unassign_leader_from_current_formation(leader)
	_clear_leader_from_national_positions(leader_id)
	if is_death:
		leader.is_deceased = true
		print("%s has died (%s)." % [leader.name, cause])
	else:
		leader.is_retired = true
		print("%s has retired." % leader.name)
	leaders.erase(leader_id)
	invalidate_leader_cache(leader.country_tag)


func _clear_leader_from_national_positions(leader_id: String) -> void:
	for country_tag in country_positions.keys():
		var positions: Dictionary = country_positions[country_tag] as Dictionary
		for position_key in positions.keys():
			if str(positions[position_key]) == leader_id:
				positions.erase(position_key)


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
		"initiative_skill": leader.initiative_skill,
		"traits": leader.traits.duplicate(),
		"trait_levels": leader.trait_levels.duplicate(),
		"trait_display": get_trait_display_list(leader),
		"experience": leader.experience,
		"battles_fought": leader.battles_fought,
		"birth_year": leader.birth_year,
		"start_year": leader.start_year,
		"end_year": leader.end_year,
		"age": get_leader_age(leader),
		"health": leader.health,
		"duty_post": leader.duty_post,
		"is_injured": leader.is_injured,
		"is_captured": leader.is_captured,
		"is_retired": leader.is_retired,
		"is_deceased": leader.is_deceased,
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

func award_battle_experience(leader_id: String, amount: int = 25, count_as_battle: bool = true) -> void:
	var leader: Leader = leaders.get(leader_id) as Leader
	if leader == null:
		return
	leader.add_experience(amount, count_as_battle)
	_check_for_trait_gain(leader)
	invalidate_leader_cache(leader.country_tag)


func award_combat_experience_for_army(army_id: String, intensity: float = 1.0) -> void:
	if army_id.is_empty():
		return
	var leader: Leader = get_leader_for_army(army_id)
	if leader == null or leader.is_injured or leader.is_captured:
		return
	var amount := int(float(XP_BASE_COMBAT) * clampf(intensity, 0.25, 4.0) * XP_COMBAT_MULTIPLIER)
	award_battle_experience(leader.leader_id, amount, true)


func get_trait_level_up_cost(leader: Leader, trait_id: String) -> int:
	if leader == null or trait_id.is_empty():
		return 0
	var rarity := get_trait_rarity(trait_id)
	var base_cost := int(XP_COST_BY_RARITY.get(rarity, 100))
	var target_level := 1
	if leader.has_trait(trait_id):
		target_level = mini(leader.get_trait_level(trait_id) + 1, get_trait_max_level(trait_id))
	return base_cost * target_level


func can_spend_xp_on_trait(leader: Leader, trait_id: String) -> Dictionary:
	if leader == null:
		return {"ok": false, "reason": "no_leader"}
	if get_trait_definition(trait_id).is_empty():
		return {"ok": false, "reason": "unknown_trait"}
	var cost := get_trait_level_up_cost(leader, trait_id)
	if leader.experience < cost:
		return {"ok": false, "reason": "insufficient_xp", "cost": cost}
	if not can_add_trait(leader, trait_id, 1):
		return {"ok": false, "reason": "blocked", "cost": cost}
	return {"ok": true, "cost": cost}


func spend_xp_on_trait(leader_id: String, trait_id: String) -> Dictionary:
	var leader: Leader = leaders.get(leader_id) as Leader
	var check := can_spend_xp_on_trait(leader, trait_id)
	if not bool(check.get("ok", false)):
		return {"success": false, "reason": str(check.get("reason", "blocked"))}

	var cost := int(check.get("cost", 0))
	if not try_add_trait_to_leader(leader, trait_id, 1):
		return {"success": false, "reason": "failed"}
	leader.experience -= cost
	invalidate_leader_cache(leader.country_tag)
	return {
		"success": true,
		"cost": cost,
		"trait_id": trait_id,
		"new_level": leader.get_trait_level(trait_id),
	}


func get_trait_display_list(leader: Leader) -> Array:
	if leader == null:
		return []
	var rows: Array = []
	for trait_id in leader.traits:
		var level := leader.get_trait_level(trait_id)
		var def := get_trait_definition(trait_id)
		var display_name := str(def.get("name", trait_id))
		var roman := ROMAN_LEVELS[mini(level, ROMAN_LEVELS.size() - 1)]
		var max_level := get_trait_max_level(trait_id)
		var effects := get_trait_effects_at_level(trait_id, level)
		rows.append({
			"id": trait_id,
			"name": display_name,
			"level": level,
			"max_level": max_level,
			"roman": roman,
			"rarity": get_trait_rarity(trait_id),
			"description": str(def.get("description", "")),
			"effects_text": format_trait_effects_text(effects),
			"can_level_up": can_add_trait(leader, trait_id, 1),
			"level_up_cost": get_trait_level_up_cost(leader, trait_id),
		})
	return rows


func format_trait_effects_text(effects: Dictionary) -> String:
	if effects.is_empty():
		return ""
	var parts: PackedStringArray = []
	for effect_key in effects.keys():
		var key := str(effect_key)
		var value: float = float(effects[effect_key])
		parts.append("%s: %s" % [_format_effect_label(key), _format_effect_value(key, value)])
	return ", ".join(parts)


func _format_effect_label(effect_key: String) -> String:
	match effect_key:
		"attack":
			return "Attack"
		"defense":
			return "Defense"
		"logistics":
			return "Logistics"
		"planning":
			return "Planning"
		"initiative":
			return "Initiative"
		"organization":
			return "Organization"
		"supply_consumption":
			return "Supply use"
		"breakthrough":
			return "Breakthrough"
		"combined_arms_sync":
			return "Combined arms"
		"organization_recovery":
			return "Org recovery"
		"reinforcement_speed":
			return "Reinforcement"
		"attrition_reduction":
			return "Attrition"
		"casualties":
			return "Casualties"
		"naval_combat":
			return "Naval combat"
		"armor_attack":
			return "Armor attack"
		"combat_width":
			return "Combat width"
		"desert_attack":
			return "Desert attack"
		"desert_defense":
			return "Desert defense"
		"arctic_attack":
			return "Arctic attack"
		"arctic_defense":
			return "Arctic defense"
		"jungle_attack":
			return "Jungle attack"
		"jungle_defense":
			return "Jungle defense"
		"mountain_attack":
			return "Mountain attack"
		"mountain_defense":
			return "Mountain defense"
		_:
			return effect_key.replace("_", " ").capitalize()


func _format_effect_value(effect_key: String, value: float) -> String:
	if effect_key in ["attack", "defense", "logistics", "planning", "initiative", "organization"]:
		if value >= 0.0:
			return "+%d" % int(value)
		return "%d" % int(value)
	if effect_key == "supply_consumption":
		return "%+d%%" % int(value * 100.0)
	if absf(value) < 1.0:
		return "%+d%%" % int(value * 100.0)
	return "%+.2f" % value


func _check_for_trait_gain(leader: Leader) -> void:
	if leader.battles_fought >= 15 and not leader.has_trait("logistics_wizard"):
		if randf() < 0.25 and try_add_trait_to_leader(leader, "logistics_wizard", 1):
			print("%s has gained the trait: Logistics Wizard!" % leader.name)

	if leader.battles_fought >= 25 and randf() < 0.15:
		if not leader.has_trait("desert_fox") and randf() < 0.3:
			if try_add_trait_to_leader(leader, "desert_fox", 1):
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


func get_trait_max_level(trait_id: String) -> int:
	var def := get_trait_definition(trait_id)
	if def.is_empty():
		return 1
	return maxi(int(def.get("max_level", 1)), 1)


func get_trait_rarity(trait_id: String) -> String:
	var def := get_trait_definition(trait_id)
	return str(def.get("rarity", "common"))


func get_trait_effects_at_level(trait_id: String, level: int) -> Dictionary:
	var def := get_trait_definition(trait_id)
	if def.is_empty():
		return {}
	var by_level: Variant = def.get("effects_by_level", {})
	if typeof(by_level) != TYPE_DICTIONARY:
		return {}
	var clamped_level := clampi(level, 1, get_trait_max_level(trait_id))
	var level_key := str(clamped_level)
	if not (by_level as Dictionary).has(level_key):
		return {}
	var effects: Variant = (by_level as Dictionary)[level_key]
	if typeof(effects) != TYPE_DICTIONARY:
		return {}
	return (effects as Dictionary).duplicate()


func get_leader_trait_effects(leader: Leader) -> Dictionary:
	if leader == null:
		return {}
	var combined: Dictionary = {}
	for trait_id in leader.traits:
		var level := leader.get_trait_level(trait_id)
		var effects := get_trait_effects_at_level(trait_id, level)
		for effect_key in effects.keys():
			var key := str(effect_key)
			combined[key] = float(combined.get(key, 0.0)) + float(effects[effect_key])
	return combined


func count_traits_by_rarity(leader: Leader, rarity: String) -> int:
	var count := 0
	for trait_id in leader.traits:
		if get_trait_rarity(trait_id) == rarity:
			count += 1
	return count


func traits_conflict(leader: Leader, trait_id: String) -> bool:
	var def := get_trait_definition(trait_id)
	if def.is_empty():
		return false
	var exclusive: Variant = def.get("exclusive_with", [])
	if typeof(exclusive) != TYPE_ARRAY:
		return false
	for other_id in exclusive as Array:
		if leader.has_trait(str(other_id)):
			return true
	for existing_id in leader.traits:
		var existing_def := get_trait_definition(existing_id)
		var existing_exclusive: Variant = existing_def.get("exclusive_with", [])
		if typeof(existing_exclusive) == TYPE_ARRAY:
			for blocked_id in existing_exclusive as Array:
				if str(blocked_id) == trait_id:
					return true
	return false


func can_add_trait(leader: Leader, trait_id: String, level: int = 1) -> bool:
	if leader == null or trait_id.is_empty():
		return false
	if get_trait_definition(trait_id).is_empty():
		push_warning("LeaderManager: unknown trait '%s'" % trait_id)
		return false
	if traits_conflict(leader, trait_id):
		return false
	if leader.has_trait(trait_id):
		var next_level := leader.get_trait_level(trait_id) + level
		if next_level > get_trait_max_level(trait_id):
			return false
		return true
	if leader.traits.size() >= MAX_TRAITS_PER_LEADER:
		return false
	if get_trait_rarity(trait_id) == RARITY_LEGENDARY:
		if count_traits_by_rarity(leader, RARITY_LEGENDARY) >= MAX_LEGENDARY_TRAITS:
			return false
	return true


func try_add_trait_to_leader(leader: Leader, trait_id: String, level: int = 1) -> bool:
	if not can_add_trait(leader, trait_id, level):
		return false
	if leader.has_trait(trait_id):
		var new_level := mini(
			leader.get_trait_level(trait_id) + level,
			get_trait_max_level(trait_id)
		)
		leader.trait_levels[trait_id] = new_level
	else:
		leader.add_trait_unchecked(trait_id, clampi(level, 1, get_trait_max_level(trait_id)))
	invalidate_leader_cache(leader.country_tag)
	return true


func level_trait(leader_id: String, trait_id: String, levels: int = 1) -> bool:
	var leader: Leader = leaders.get(leader_id) as Leader
	if leader == null:
		return false
	return try_add_trait_to_leader(leader, trait_id, levels)


func _load_trait_definitions() -> void:
	trait_definitions = _read_trait_json_file(TRAITS_PATH)
	if trait_definitions.is_empty():
		trait_definitions = _read_trait_json_file(LEGACY_TRAITS_PATH)


func _read_trait_json_file(path: String) -> Dictionary:
	if not ResourceLoader.exists(path):
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	file.close()
	if typeof(parsed) != TYPE_DICTIONARY:
		return {}
	return parsed as Dictionary


func get_leaders_path_for_scenario(scenario_name: String) -> String:
	var key := scenario_name.strip_edges().to_lower()
	if SCENARIO_LEADER_PATHS.has(key):
		return str(SCENARIO_LEADER_PATHS[key])
	if ResourceLoader.exists("res://data/leaders/historical_leaders_%s.json" % key):
		return "res://data/leaders/historical_leaders_%s.json" % key
	return HISTORICAL_LEADERS_1936_PATH


func load_leaders_for_scenario(scenario_name: String, start_year: int = -1) -> int:
	if start_year > 0:
		set_current_year(start_year)
	var path := get_leaders_path_for_scenario(scenario_name)
	return reload_leaders_from_json(path, current_year)


func reload_leaders_from_json(path: String, as_of_year: int = -1) -> int:
	leaders.clear()
	leader_pool.clear()
	pending_retirements.clear()
	country_positions.clear()
	clear_all_leader_caches()
	var year := as_of_year if as_of_year > 0 else current_year
	return load_historical_leaders(path, year)


func load_leaders_from_json(path: String) -> int:
	return load_historical_leaders(path)


# === Historical Leaders Loading ===

func load_historical_leaders(
	path: String = HISTORICAL_LEADERS_1936_PATH,
	as_of_year: int = -1,
) -> int:
	if not FileAccess.file_exists(path):
		push_warning("Historical leaders file not found: %s" % path)
		return 0

	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_warning("Historical leaders file could not be opened: %s" % path)
		return 0

	var json_text := file.get_as_text()
	file.close()

	var json := JSON.new()
	var error := json.parse(json_text)
	if error != OK:
		push_warning(
			"Failed to parse historical leaders JSON: %s" % json.get_error_message()
		)
		return 0

	var data: Variant = json.get_data()
	if typeof(data) != TYPE_DICTIONARY:
		push_warning("Historical leaders JSON root must be a dictionary")
		return 0

	_historical_leaders_source_path = path
	var year := as_of_year if as_of_year > 0 else current_year
	var entries: Array = _historical_leader_entries_from_data(data as Dictionary)
	var loaded := 0
	var pooled := 0
	for entry in entries:
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		var entry_dict := entry as Dictionary
		var leader_id := str(entry_dict.get("leader_id", ""))
		if leader_id.is_empty():
			continue
		if not is_leader_entry_active_for_year(entry_dict, year):
			leader_pool[leader_id] = entry_dict.duplicate(true)
			pooled += 1
			continue
		var leader := _leader_from_dict(entry_dict)
		if leader == null:
			continue
		register_leader(leader)
		loaded += 1

	print(
		"Loaded %d leaders (%d in pool) from %s for year %d"
		% [loaded, pooled, path, year]
	)
	return loaded


func _historical_leader_entries_from_data(data: Dictionary) -> Array:
	var entries: Array = []
	var leaders_block: Variant = data.get("leaders", null)
	if typeof(leaders_block) == TYPE_ARRAY:
		for entry in leaders_block as Array:
			if typeof(entry) == TYPE_DICTIONARY:
				entries.append(entry)
		return entries

	# Flat map format: { "ger_rommel": { ... }, ... }
	for leader_key in data.keys():
		var leader_data: Variant = data[leader_key]
		if typeof(leader_data) != TYPE_DICTIONARY:
			continue
		var entry: Dictionary = (leader_data as Dictionary).duplicate()
		if not entry.has("leader_id"):
			entry["leader_id"] = str(leader_key)
		entries.append(entry)
	return entries


func _leader_from_dict(data: Dictionary) -> Leader:
	var leader := LeaderGenerator.create_leader_from_data(data)
	if leader == null or leader.leader_id.is_empty():
		return null
	return leader
