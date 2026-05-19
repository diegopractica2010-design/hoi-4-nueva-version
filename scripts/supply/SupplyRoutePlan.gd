class_name SupplyRoutePlan
extends RefCounted

## One planned supply path with timing and risk summary for UI / simulation.

var route_id: String = ""
var owner_tag: String = ""
var source_province_id: int = -1
var target_province_id: int = -1
var province_path: Array[int] = []
var segment_modes: Array[String] = []
var total_days: float = 0.0
var baseline_days: float = 0.0
var extra_days_from_reroute: float = 0.0
var interdiction_chance: float = 0.0
var interdiction_breakdown: Dictionary = {}
var uses_port: bool = false
var uses_airport: bool = false
var uses_spaceport: bool = false
var cargo_tons_per_day: float = 0.0
var routing_mode: String = "land"
var is_player_override: bool = false


func path_length() -> int:
	return province_path.size()


func primary_mode() -> String:
	if segment_modes.is_empty():
		return "land"
	var sea := 0
	var air := 0
	for m in segment_modes:
		match m:
			"sea":
				sea += 1
			"air":
				air += 1
	if sea > air and sea > 0:
		return "sea"
	if air > 0:
		return "air"
	return "land"


func summary_lines() -> PackedStringArray:
	var lines := PackedStringArray()
	lines.append(
		"Arrival: %.1f days (%+.1f vs default route)" % [total_days, extra_days_from_reroute],
	)
	lines.append("Mode: %s" % routing_mode)
	lines.append("Interdiction risk: %.0f%%" % (interdiction_chance * 100.0))
	if cargo_tons_per_day > 0.0:
		lines.append("Cargo: %.0f t/day along route" % cargo_tons_per_day)
	if uses_port:
		lines.append("Uses sealift / port hubs")
	if uses_airport:
		lines.append("Uses airlift / airports")
	if uses_spaceport:
		lines.append("Uses spaceport hub")
	for key in interdiction_breakdown:
		var v := float(interdiction_breakdown[key])
		if v > 0.001:
			lines.append("  %s: +%.0f%%" % [key, v * 100.0])
	return lines
