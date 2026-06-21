# scripts/production/EquipmentShortageTracker.gd
class_name EquipmentShortageTracker
extends RefCounted


# Returns how much of each equipment type is missing for a unit.
func calculate_shortages(required: Dictionary, current_stock: Dictionary) -> Dictionary:
	var shortages := {}
	for equipment in required:
		var needed := int(required[equipment])
		var have := int(current_stock.get(equipment, 0))
		if have < needed:
			shortages[equipment] = needed - have
	return shortages


# Returns a 0.0 – 1.0 readiness multiplier based on shortages.
func get_readiness_from_shortages(shortages: Dictionary, required: Dictionary) -> float:
	if required.is_empty():
		return 1.0

	var total_needed := 0
	var total_missing := 0

	for eq in required:
		total_needed += int(required[eq])
		if shortages.has(eq):
			total_missing += shortages[eq]

	if total_needed == 0:
		return 1.0

	var shortage_ratio := float(total_missing) / float(total_needed)
	return clampf(1.0 - (shortage_ratio * 0.7), 0.3, 1.0)  # Max 70% penalty
