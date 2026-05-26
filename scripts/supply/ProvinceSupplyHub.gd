class_name ProvinceSupplyHub
extends RefCounted

enum DepotKind { CAPITAL, PORT, AIRPORT, SPACEPORT, CITY, PLAYER }

var province_id: int = -1
var owner_tag: String = ""
var kinds: Array[int] = []
var port_level: int = 0
var airport_level: int = 0
var spaceport_level: int = 0
var infrastructure: int = 0
var development_level: int = 1
var industry_slots: int = 0
var storage_capacity: float = 0.0
var is_player_depot: bool = false


func has_kind(kind: DepotKind) -> bool:
	return kind in kinds


func hub_score() -> float:
	var score := float(infrastructure)
	score += float(port_level) * 2.5
	score += float(airport_level) * 2.0
	score += float(spaceport_level) * 3.0
	if has_kind(DepotKind.CAPITAL):
		score += 10.0
	return score
