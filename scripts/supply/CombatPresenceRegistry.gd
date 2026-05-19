class_name CombatPresenceRegistry
extends RefCounted

## Per-province force totals for supply interdiction (fed by combat / intel systems).

var _by_province: Dictionary = {}


func clear() -> void:
	_by_province.clear()


func get_report(province_id: int) -> ProvinceForceReport:
	if not _by_province.has(province_id):
		_by_province[province_id] = ProvinceForceReport.new(province_id)
	return _by_province[province_id]


func add_land_presence(province_id: int, owner_tag: String, brigade_equiv: float) -> void:
	var r := get_report(province_id)
	r.add_land(owner_tag, brigade_equiv)


func add_air_presence(province_id: int, owner_tag: String, strength: float) -> void:
	var r := get_report(province_id)
	r.add_air(owner_tag, strength)


func add_naval_presence(province_id: int, owner_tag: String, strength: float, at_port: bool) -> void:
	var r := get_report(province_id)
	r.add_naval(owner_tag, strength, at_port)


func add_unit(
	province_id: int,
	owner_tag: String,
	template: UnitTemplate,
	count: float = 1.0,
) -> void:
	if template == null:
		return
	var brigade := _brigade_weight(template) * count
	match template.base_type.to_lower():
		"naval", "submarine":
			add_naval_presence(province_id, owner_tag, brigade, true)
		"air":
			add_air_presence(province_id, owner_tag, brigade)
		_:
			add_land_presence(province_id, owner_tag, brigade)


static func _brigade_weight(template: UnitTemplate) -> float:
	match template.size_category.to_lower():
		"light":
			return 0.35
		"heavy", "superheavy":
			return 1.4
		"medium":
			return 0.75
		_:
			return 0.5


func set_report(province_id: int, report: ProvinceForceReport) -> void:
	_by_province[province_id] = report


func all_province_ids() -> Array:
	return _by_province.keys()
