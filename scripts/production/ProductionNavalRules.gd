## Naval production geography: shipyards and naval lines require port access.
class_name ProductionNavalRules
extends RefCounted

const NAVAL_CATEGORIES: Array[String] = [
	"destroyer",
	"cruiser",
	"battleship",
	"carrier",
	"submarine",
	"ship",
	"naval",
]


static func is_naval_category(category: String) -> bool:
	var c := category.strip_edges().to_lower()
	if c.is_empty():
		return false
	if c in NAVAL_CATEGORIES:
		return true
	return c.contains("ship")


static func is_naval_design(design_id: String) -> bool:
	if design_id.is_empty() or GameData.design_data == null:
		return false
	var template := GameData.design_data.get_template(design_id)
	if template == null:
		return false
	return is_naval_category(ProductionCostCalculator.infer_category(template))


static func factory_can_build_naval(factory: Factory) -> bool:
	if factory == null:
		return false
	return factory.factory_type == "shipyard"


static func province_allows_shipyard(province: Province) -> bool:
	return province != null and province.resolve_has_port()
