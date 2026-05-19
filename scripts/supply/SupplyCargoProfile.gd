class_name SupplyCargoProfile
extends RefCounted

var cargo_tons: float = 0.0
var prefers_air: bool = false
var prefers_sea: bool = false
var land_ok: bool = true


static func from_template(template: UnitTemplate, rules: SupplyRules, tonnage_override: float = -1.0) -> SupplyCargoProfile:
	var profile := SupplyCargoProfile.new()
	if template == null:
		return profile
	var routing := rules.get_block("routing")
	profile.cargo_tons = tonnage_override if tonnage_override >= 0.0 else template.get_stat("cargo_capacity", 0.0)
	var min_air := float(routing.get("min_cargo_capacity_for_airlift", 500.0))
	var min_sea := float(routing.get("min_cargo_capacity_for_sealift", 2000.0))
	var archetype := template.visual_archetype.to_lower()
	var base_type := template.base_type.to_lower()

	if profile.cargo_tons >= min_air or archetype.contains("transport") or base_type == "air":
		profile.prefers_air = profile.cargo_tons <= min_sea or base_type == "air"
	if profile.cargo_tons >= min_sea or base_type == "naval" or archetype.contains("cargo"):
		profile.prefers_sea = true
	if base_type == "naval":
		profile.land_ok = false
	elif base_type == "air":
		profile.land_ok = false
	return profile


static func general_supplies(tons: float) -> SupplyCargoProfile:
	var p := SupplyCargoProfile.new()
	p.cargo_tons = tons
	p.land_ok = true
	return p
