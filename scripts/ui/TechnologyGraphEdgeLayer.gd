# scripts/ui/TechnologyGraphEdgeLayer.gd
extends Control

func _draw() -> void:
	var graph_view := get_parent().get_parent().get_parent() as TechnologyGraphView
	if graph_view != null:
		graph_view.paint_edges(self)
