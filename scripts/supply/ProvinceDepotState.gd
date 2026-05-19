class_name ProvinceDepotState
extends RefCounted

var province_id: int = -1
var storage_capacity: float = 0.0
var stockpile: float = 0.0
var throughput_capacity: float = 0.0
var inbound_per_day: float = 0.0
var outbound_per_day: float = 0.0


func _init(pid: int = -1, capacity: float = 0.0) -> void:
	province_id = pid
	storage_capacity = capacity
	throughput_capacity = capacity * 0.15
	stockpile = capacity * 0.65


func apply_inflow(tons: float) -> float:
	var room := maxf(storage_capacity - stockpile, 0.0)
	var accepted := minf(tons, room)
	stockpile += accepted
	inbound_per_day = accepted
	return tons - accepted


func pull_outflow(requested: float) -> float:
	var sent := minf(minf(requested, stockpile), throughput_capacity)
	stockpile -= sent
	outbound_per_day = sent
	return sent


func fill_ratio() -> float:
	if storage_capacity <= 0.0:
		return 0.0
	return clampf(stockpile / storage_capacity, 0.0, 1.0)
