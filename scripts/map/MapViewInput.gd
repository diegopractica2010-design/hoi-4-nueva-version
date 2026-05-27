# scripts/map/MapViewInput.gd
## Map camera navigation helpers — keep pan/zoom responsive while simulation is paused
## (Engine.time_scale == 0 yields zero _process delta otherwise).
class_name MapViewInput
extends RefCounted

static var _last_real_usec: int = 0

const _PAUSE_DELTA_FALLBACK := 1.0 / 60.0
const _PAUSE_DELTA_MAX := 0.05

## Use in _process camera movement: respects time scale when running, wall clock when paused.
static func motion_delta(scaled_delta: float) -> float:
	if Engine.time_scale > 0.001:
		_last_real_usec = Time.get_ticks_usec()
		return scaled_delta
	var now := Time.get_ticks_usec()
	var dt := _PAUSE_DELTA_FALLBACK
	if _last_real_usec > 0:
		dt = clampf(float(now - _last_real_usec) / 1_000_000.0, 0.0, _PAUSE_DELTA_MAX)
	_last_real_usec = now
	return maxf(dt, _PAUSE_DELTA_FALLBACK * 0.25)


## True when the hovered GUI should block map edge-scroll (not TopInfoBar strip).
static func edge_pan_blocked_by_gui(viewport: Viewport) -> bool:
	if viewport == null:
		return false
	var hovered: Control = viewport.gui_get_hovered_control()
	if hovered == null:
		return false
	var node: Node = hovered
	while node != null:
		if node.name == "TopInfoBar":
			return false
		if node is Window:
			return true
		if node is Panel:
			var panel_name := str(node.name)
			if panel_name in [
				"InfoPanel",
				"SaveManagerPopup",
				"MainMenuPopup",
				"SupplyMenuPanel",
			]:
				return true
		node = node.get_parent()
	return hovered.mouse_filter == Control.MOUSE_FILTER_STOP
