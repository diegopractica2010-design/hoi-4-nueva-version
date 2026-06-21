extends Node
class_name EconomyTest

static func run_all() -> bool:
	var ok = true
	ok = _test_income_manager_exists() and ok
	ok = _test_factory_manager_exists() and ok
	ok = _test_nation_monthly_income() and ok
	ok = _test_factory_crud() and ok
	ok = _test_production_manager() and ok
	return ok

static func _test_income_manager_exists() -> bool:
	if typeof(NationalIncomeManager) == TYPE_NIL:
		print("  [FAIL] NationalIncomeManager not available")
		return false
	if not NationalIncomeManager.has_method("get_nation_monthly_income"):
		print("  [FAIL] get_nation_monthly_income missing")
		return false
	print("  [PASS] NationalIncomeManager loaded")
	return true

static func _test_factory_manager_exists() -> bool:
	if typeof(FactoryManager) == TYPE_NIL:
		print("  [FAIL] FactoryManager not available")
		return false
	if not FactoryManager.has_method("get_factories_in_province"):
		print("  [FAIL] get_factories_in_province missing")
		return false
	print("  [PASS] FactoryManager loaded")
	return true

static func _test_nation_monthly_income() -> bool:
	var chl_income = NationalIncomeManager.get_nation_monthly_income("CHL")
	var per_income = NationalIncomeManager.get_nation_monthly_income("PER")
	var bol_income = NationalIncomeManager.get_nation_monthly_income("BOL")
	if chl_income < 0 or per_income < 0 or bol_income < 0:
		print("  [FAIL] negative income: CHL=%.1f PER=%.1f BOL=%.1f" % [chl_income, per_income, bol_income])
		return false
	print("  [PASS] Monthly income: CHL=%.1f PER=%.1f BOL=%.1f" % [chl_income, per_income, bol_income])
	return true

static func _test_factory_crud() -> bool:
	var found_pid = ""
	for pid in FactoryManager.province_to_factories:
		if not FactoryManager.province_to_factories[pid].is_empty():
			found_pid = str(pid)
			break
	if found_pid.is_empty():
		print("  [WARN] no factories found in any province")
		return true
	var factories = FactoryManager.get_factories_in_province(int(found_pid))
	print("  [PASS] province %s has %d factories" % [found_pid, factories.size()])
	return true

static func _test_production_manager() -> bool:
	if typeof(ProductionManager) == TYPE_NIL:
		print("  [FAIL] ProductionManager not available")
		return false
	if not ProductionManager.has_method("get_line"):
		print("  [FAIL] get_line missing")
		return false
	print("  [PASS] ProductionManager loaded")
	return true
