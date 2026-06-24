extends Node

const Log = preload("res://scripts/core/Logger.gd")

signal relation_changed(from_tag: String, to_tag: String, old_value: int, new_value: int)
signal war_declared(attacker: String, defender: String)
signal peace_signed(attacker: String, defender: String, winner: String)
signal alliance_formed(tag_a: String, tag_b: String)
signal alliance_broken(tag_a: String, tag_b: String)
signal guarantee_given(guarantor: String, protected: String)
signal guarantee_revoked(guarantor: String, protected: String)

const RELATION_MIN: int = -200
const RELATION_MAX: int = 200
const ALLIANCE_THRESHOLD: int = 80
const GUARANTEE_THRESHOLD: int = 50

var relations: Dictionary = {}
var wars: Dictionary = {}
var alliances: Dictionary = {}
var guarantees: Dictionary = {}

func _ready() -> void:
	Log.info("DiplomacyManager initialized", "DiplomacyManager")

func set_relation(from: String, to: String, value: int) -> void:
	var key = _key(from, to)
	var old = relations.get(key, 0)
	var clamped = clampi(value, RELATION_MIN, RELATION_MAX)
	relations[key] = clamped
	relation_changed.emit(from, to, old, clamped)

func get_relation(from: String, to: String) -> int:
	return relations.get(_key(from, to), 0)

func modify_relation(from: String, to: String, delta: int) -> void:
	set_relation(from, to, get_relation(from, to) + delta)

func declare_war(attacker: String, defender: String) -> bool:
	if is_at_war(attacker, defender):
		return false
	var war_id = attacker + "_vs_" + defender
	var d := TimeManager.get_current_date()
	var date_str := "%04d-%02d-%02d" % [d.get("year", 0), d.get("month", 1), d.get("day", 1)]
	wars[war_id] = {
		"attacker": attacker,
		"defender": defender,
		"start_date": date_str,
		"score": {}
	}
	Log.info(attacker + " declared war on " + defender, "DiplomacyManager")
	war_declared.emit(attacker, defender)
	if has_alliance(attacker, defender):
		break_alliance(attacker, defender)
	return true

func sign_peace(attacker: String, defender: String, winner: String) -> bool:
	var war_id = attacker + "_vs_" + defender
	var alt_id = defender + "_vs_" + attacker
	if war_id in wars:
		wars.erase(war_id)
	elif alt_id in wars:
		wars.erase(alt_id)
	else:
		return false
	Log.info("Peace: " + winner + " wins " + attacker + " vs " + defender, "DiplomacyManager")
	peace_signed.emit(attacker, defender, winner)
	return true

func is_at_war(tag_a: String, tag_b: String) -> bool:
	var direct = tag_a + "_vs_" + tag_b
	var reverse = tag_b + "_vs_" + tag_a
	return direct in wars or reverse in wars

func is_nation_at_war(tag: String) -> bool:
	for war_id in wars:
		var w = wars[war_id]
		if w.attacker == tag or w.defender == tag:
			return true
	return false

func get_wars_for(tag: String) -> Array:
	var result = []
	for war_id in wars:
		var w = wars[war_id]
		if w.attacker == tag or w.defender == tag:
			result.append(w)
	return result

func form_alliance(tag_a: String, tag_b: String) -> bool:
	if has_alliance(tag_a, tag_b):
		return false
	var key = _alliance_key(tag_a, tag_b)
	alliances[key] = [tag_a, tag_b]
	Log.info("Alliance formed: " + tag_a + " + " + tag_b, "DiplomacyManager")
	alliance_formed.emit(tag_a, tag_b)
	modify_relation(tag_a, tag_b, 20)
	return true

func break_alliance(tag_a: String, tag_b: String) -> bool:
	var key = _alliance_key(tag_a, tag_b)
	if key not in alliances:
		return false
	alliances.erase(key)
	Log.info("Alliance broken: " + tag_a + " and " + tag_b, "DiplomacyManager")
	alliance_broken.emit(tag_a, tag_b)
	modify_relation(tag_a, tag_b, -30)
	return true

func has_alliance(tag_a: String, tag_b: String) -> bool:
	if tag_a == tag_b:
		return true
	return _alliance_key(tag_a, tag_b) in alliances

func give_guarantee(guarantor: String, protected: String) -> bool:
	var key = _key(guarantor, protected)
	if key in guarantees:
		return false
	guarantees[key] = { "guarantor": guarantor, "protected": protected }
	Log.info(guarantor + " guarantees " + protected, "DiplomacyManager")
	guarantee_given.emit(guarantor, protected)
	modify_relation(guarantor, protected, 10)
	return true

func revoke_guarantee(guarantor: String, protected: String) -> bool:
	var key = _key(guarantor, protected)
	if key not in guarantees:
		return false
	guarantees.erase(key)
	Log.info(guarantor + " revoked guarantee of " + protected, "DiplomacyManager")
	guarantee_revoked.emit(guarantor, protected)
	modify_relation(guarantor, protected, -15)
	return true

func has_guarantee(guarantor: String, protected: String) -> bool:
	return _key(guarantor, protected) in guarantees

func get_guarantees_for(tag: String) -> Array:
	var result = []
	for key in guarantees:
		var g = guarantees[key]
		if g.guarantor == tag or g.protected == tag:
			result.append(g)
	return result

func get_allies(tag: String) -> Array:
	var result = []
	for key in alliances:
		var pair = alliances[key]
		if pair[0] == tag:
			result.append(pair[1])
		elif pair[1] == tag:
			result.append(pair[0])
	return result

func get_status_between(tag_a: String, tag_b: String) -> String:
	if tag_a == tag_b:
		return "self"
	if is_at_war(tag_a, tag_b):
		return "war"
	if has_alliance(tag_a, tag_b):
		return "allied"
	if has_guarantee(tag_a, tag_b) or has_guarantee(tag_b, tag_a):
		return "guaranteed"
	return "neutral"

func _key(a: String, b: String) -> String:
	return a + "_" + b if a < b else b + "_" + a

func _alliance_key(a: String, b: String) -> String:
	return a + "_" + b if a < b else b + "_" + a
