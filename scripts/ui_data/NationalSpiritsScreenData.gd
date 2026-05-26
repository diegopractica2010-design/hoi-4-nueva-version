# scripts/ui_data/NationalSpiritsScreenData.gd
class_name NationalSpiritsScreenData
extends Resource

@export var country_tag: String = ""
@export var permanent_spirit_count: int = 0
@export var temporary_effect_count: int = 0
@export var permanent_spirits: Array[Dictionary] = []
@export var temporary_effects: Array[Dictionary] = []
@export var spirit_categories: Array[String] = []
@export var effect_sources: Array[String] = []
