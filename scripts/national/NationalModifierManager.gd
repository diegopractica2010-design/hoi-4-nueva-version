# scripts/national/NationalModifierManager.gd
extends Node

## Lightweight system for temporary national-level modifiers (debuffs and buffs).
## Used by Agent influence missions, future National Spirits, Focuses, Events, etc.
##
## Effects are simple dictionaries with modifiers, duration, and source tracking.

signal national_modifier_applied(country_tag: String, effect_id: String)
signal national_modifier_expired(country_tag: String, effect_id: String)

var country_modifiers: Dictionary = {}  # country_tag -> Array[Dictionary]

var _current_year: int = 1936


func _ready() -> void:
	# Connect to yearly advancement if LeaderManager exists
	if typeof(LeaderManager) != TYPE_NIL:
		LeaderManager.game_year_advanced.connect(_on_game_year_advanced)


func _on_game_year_advanced(year: int) -> void:
	set_current_year(year)
	tick_modifiers(12)  # Advance one year worth of modifiers


func set_current_year(year: int) -> void:
	_current_year = year


# === Core API ===

## Applies a temporary national effect.
## effect_data should follow the standard structure:
## {
##   "effect_id": String (unique),
##   "source": String (e.g. "agent_mission", "national_focus"),
##   "source_detail": String (optional),
##   "modifiers": Dictionary (e.g. {"stability": -5.0, "prestige_gain": -0.2}),
##   "duration_months": int,
##   "remaining_months": int,
##   "is_debuff": bool (optional)
## }
func apply_national_effect(country_tag: String, effect_data: Dictionary) -> bool:
	var tag := country_tag.strip_edges().to_upper()
	if tag.is_empty() or effect_data.is_empty():
		return false

	var effect := effect_data.duplicate(true)

	# Ensure required fields
	if not effect.has("effect_id"):
		effect["effect_id"] = "%s_%s_%d" % [tag, effect.get("source", "unknown"), Time.get_unix_time_from_system()]

	if not effect.has("remaining_months"):
		effect["remaining_months"] = int(effect.get("duration_months", 6))

	if not effect.has("duration_months"):
		effect["duration_months"] = int(effect["remaining_months"])

	if not effect.has("modifiers"):
		effect["modifiers"] = {}

	if not effect.has("source"):
		effect["source"] = "unknown"

	if not country_modifiers.has(tag):
		country_modifiers[tag] = []

	# Remove any existing effect with the same ID (refresh behavior)
	remove_effect(tag, effect["effect_id"])

	country_modifiers[tag].append(effect)
	national_modifier_applied.emit(tag, effect["effect_id"])
	return true


## Advances all modifiers by the given number of months.
func tick_modifiers(months: int = 12) -> void:
	for country_tag in country_modifiers.keys():
		var effects: Array = country_modifiers[country_tag]
		var to_remove: Array = []

		for i in range(effects.size()):
			var effect: Dictionary = effects[i]
			var remaining := int(effect.get("remaining_months", 0)) - months
			effect["remaining_months"] = remaining

			if remaining <= 0:
				to_remove.append(i)
				national_modifier_expired.emit(country_tag, str(effect.get("effect_id", "")))

		# Remove expired effects (in reverse order)
		for i in range(to_remove.size() - 1, -1, -1):
			effects.remove_at(to_remove[i])

		if effects.is_empty():
			country_modifiers.erase(country_tag)


## Returns the combined modifier value for a given key across all active effects for the country.
## Positive and negative values are summed.
func get_national_modifier(country_tag: String, key: String) -> float:
	var tag := country_tag.strip_edges().to_upper()
	if not country_modifiers.has(tag):
		return 0.0

	var total := 0.0
	for effect in country_modifiers[tag] as Array:
		var mods: Dictionary = effect.get("modifiers", {})
		if mods.has(key):
			total += float(mods[key])

	return total


## Returns all currently active effects for a country.
func get_active_effects(country_tag: String) -> Array[Dictionary]:
	var tag := country_tag.strip_edges().to_upper()
	if not country_modifiers.has(tag):
		return []
	return (country_modifiers[tag] as Array).duplicate(true)


## Removes a specific effect by ID.
func remove_effect(country_tag: String, effect_id: String) -> bool:
	var tag := country_tag.strip_edges().to_upper()
	if not country_modifiers.has(tag):
		return false

	var effects: Array = country_modifiers[tag]
	for i in range(effects.size()):
		if str(effects[i].get("effect_id", "")) == effect_id:
			effects.remove_at(i)
			national_modifier_expired.emit(tag, effect_id)
			if effects.is_empty():
				country_modifiers.erase(tag)
			return true
	return false


## Clears all modifiers for a country (useful on scenario reset).
func clear_country_modifiers(country_tag: String) -> void:
	var tag := country_tag.strip_edges().to_upper()
	if country_modifiers.has(tag):
		country_modifiers.erase(tag)


## Clears everything (for full reset).
func clear_all_modifiers() -> void:
	country_modifiers.clear()


# === Convenience Helpers ===

## Quick way for Influence-type effects to apply stability and/or prestige changes.
func apply_influence_effect(country_tag: String, stability_change: float = 0.0, prestige_change: float = 0.0, duration_months: int = 12, source: String = "influence") -> String:
	var tag := country_tag.strip_edges().to_upper()
	var modifiers := {}
	if stability_change != 0.0:
		modifiers["stability"] = stability_change
	if prestige_change != 0.0:
		modifiers["prestige_gain"] = prestige_change

	if modifiers.is_empty():
		return ""

	var effect := {
		"source": source,
		"modifiers": modifiers,
		"duration_months": duration_months,
		"remaining_months": duration_months,
		"is_debuff": stability_change < 0.0 or prestige_change < 0.0
	}

	apply_national_effect(tag, effect)
	return str(effect.get("effect_id", ""))
