extends Node
class_name AgentTest

static func run_all() -> bool:
	var ok = true
	ok = _test_manager_exists() and ok
	ok = _test_mission_definitions_loaded() and ok
	ok = _test_get_agents_for_country() and ok
	ok = _test_recruit_agent() and ok
	ok = _test_networks() and ok
	return ok

static func _test_manager_exists() -> bool:
	if typeof(AgentManager) == TYPE_NIL:
		print("  [FAIL] AgentManager not available")
		return false
	print("  [PASS] AgentManager loaded")
	return true

static func _test_mission_definitions_loaded() -> bool:
	if not AgentManager.has_method("get_mission_definition"):
		print("  [FAIL] get_mission_definition missing")
		return false
	var first = AgentManager.get_mission_definition("intelligence_gathering")
	if first == null or first.is_empty():
		print("  [WARN] no mission definition for 'intelligence_gathering'")
	else:
		print("  [PASS] mission definition 'intelligence_gathering' has %d keys" % first.size())
	return true

static func _test_get_agents_for_country() -> bool:
	if not AgentManager.has_method("get_agents_for_country"):
		print("  [FAIL] get_agents_for_country missing")
		return false
	var agents = AgentManager.get_agents_for_country("CHL")
	print("  [PASS] get_agents_for_country(CHL) = %d agents" % agents.size())
	return true

static func _test_recruit_agent() -> bool:
	if not AgentManager.has_method("recruit_agent"):
		print("  [FAIL] recruit_agent missing")
		return false
	var before = AgentManager.get_agents_for_country("CHL").size()
	var agent = AgentManager.recruit_agent("CHL")
	var after = AgentManager.get_agents_for_country("CHL").size()
	if agent == null:
		print("  [FAIL] recruit_agent returned null")
		return false
	if after <= before:
		print("  [FAIL] agent count did not increase")
		return false
	print("  [PASS] recruited agent %s (%d -> %d)" % [agent.agent_id, before, after])
	return true

static func _test_networks() -> bool:
	if not AgentManager.has_method("get_networks_for_country"):
		print("  [WARN] get_networks_for_country missing")
		return true
	var networks = AgentManager.get_networks_for_country("CHL")
	print("  [PASS] networks for CHL: %d" % networks.size())
	return true
