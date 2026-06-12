extends Node

# NOTA: NO declaramos `class_name NationalIncomeManager` a propósito.
# Este script se registra como autoload singleton llamado "NationalIncomeManager".
# Usar class_name en un autoload provoca el error del analizador
# "Class '...' hides an autoload singleton" y el autoload NO carga
# (mismo patrón documentado en TimeManager.gd / MapManager.gd — deuda DT-02).
# Sin class_name, el singleton sigue accesible globalmente como `NationalIncomeManager`.

## Ingreso económico mensual por nación.
##
## Cada mes lee los recursos de todas las provincias que cada nación CONTROLA
## (controller_tag) y convierte ese recurso en oro según unas tasas. El oro del
## jugador se suma al stockpile de ProductionManager (que modela un único almacén,
## el del jugador); el de las naciones IA se acumula en un dict interno para uso futuro.

const RULES_PATH := "res://data/economy/resource_income_rules.json"

# Tasas por defecto si falta el archivo de reglas (oro por unidad de recurso/mes).
const DEFAULT_RATES: Dictionary = {
	"nitrates": 2.5,  # recurso estratégico principal de la guerra
	"guano": 1.8,
	"silver": 2.0,
	"copper": 1.2,
	"tin": 0.8,
	"coal": 0.6,
	"iron": 0.5,
}
const DEFAULT_RATE := 0.3

var _income_rules: Dictionary = {}
var _last_month_processed: int = -1

# Oro acumulado por nación IA (tag -> oro). El jugador va a ProductionManager.
var _ai_income: Dictionary = {}


func _ready() -> void:
	# Procesamos el ingreso en el día 1 de cada mes, escuchando el reloj diario.
	# (TimeManager también expone game_month_advanced; usamos el diario + guarda de día 1
	#  según la especificación de esta tarea.)
	if typeof(TimeManager) != TYPE_NIL and TimeManager.has_signal("game_day_advanced"):
		if not TimeManager.game_day_advanced.is_connected(_on_game_day_advanced):
			TimeManager.game_day_advanced.connect(_on_game_day_advanced)

	_load_income_rules()


## Carga las tasas de ingreso desde JSON; si no existe el archivo, usa los defaults.
func _load_income_rules() -> void:
	_income_rules = {}
	if not FileAccess.file_exists(RULES_PATH):
		return
	var file := FileAccess.open(RULES_PATH, FileAccess.READ)
	if file == null:
		return
	var json := JSON.new()
	var parse := json.parse(file.get_as_text())
	file.close()
	if parse != OK or typeof(json.data) != TYPE_DICTIONARY:
		push_warning("NationalIncomeManager: reglas de ingreso inválidas en %s, usando defaults" % RULES_PATH)
		return
	var data: Dictionary = json.data
	# Aceptamos {"rules": {...}} (formato canónico) o {"rates": {...}} (compatibilidad).
	var rates: Variant = data.get("rules", data.get("rates", {}))
	if typeof(rates) == TYPE_DICTIONARY:
		for resource in (rates as Dictionary).keys():
			_income_rules[str(resource)] = float((rates as Dictionary)[resource])
	if data.has("default_rate"):
		_income_rules["__default__"] = float(data["default_rate"])


func _on_game_day_advanced(_year: int, month: int, day: int) -> void:
	# Solo el día 1 de cada mes, y una sola vez por mes.
	if day == 1 and month != _last_month_processed:
		_last_month_processed = month
		_process_monthly_income()


## Recorre todas las provincias, acumula ingreso por nación controladora y lo aplica.
func _process_monthly_income() -> void:
	var provinces := _get_all_provinces()
	if provinces.is_empty():
		return

	# Acumulador: tag de nación -> oro generado este mes.
	var accumulators: Dictionary = {}
	for province_id in provinces.keys():
		var province: Province = provinces[province_id]
		if province == null:
			continue
		var holder := _holder_of(province)
		if holder.is_empty():
			continue
		var resources: Dictionary = province.resources
		if typeof(resources) != TYPE_DICTIONARY:
			continue
		var province_income := 0.0
		for resource in resources.keys():
			province_income += float(resources[resource]) * _get_income_rate(str(resource))
		if province_income > 0.0:
			accumulators[holder] = float(accumulators.get(holder, 0.0)) + province_income

	var player_tag := _resolve_player_tag()
	for tag in accumulators.keys():
		var income: float = accumulators[tag]
		if income <= 0.0:
			continue
		# DEBUG temporal: verificar que el sistema de ingresos corre (se puede quitar luego).
		print("[NationalIncomeManager] Monthly income processed for ", tag, ": +", income, " gold")
		if tag == player_tag:
			# El stockpile de ProductionManager modela al jugador.
			if typeof(ProductionManager) != TYPE_NIL and ProductionManager.has_method("add_stockpile"):
				ProductionManager.add_stockpile({"gold": income})
		else:
			# Naciones IA: acumular para uso futuro de la IA.
			_ai_income[tag] = float(_ai_income.get(tag, 0.0)) + income


## Tasa de oro para un recurso (reglas cargadas → defaults).
func _get_income_rate(resource: String) -> float:
	if _income_rules.has(resource):
		return float(_income_rules[resource])
	if DEFAULT_RATES.has(resource):
		return float(DEFAULT_RATES[resource])
	# Default genérico: el del archivo si se cargó, si no la constante.
	return float(_income_rules.get("__default__", DEFAULT_RATE))


## Estimación del ingreso mensual de una nación según el control actual de provincias.
## Usado por la UI para mostrar la economía.
func get_nation_monthly_income(country_tag: String) -> float:
	var tag := country_tag.strip_edges().to_upper()
	if tag.is_empty():
		return 0.0
	var total := 0.0
	for province_id in _get_all_provinces().keys():
		var province: Province = _get_all_provinces()[province_id]
		if province == null or _holder_of(province) != tag:
			continue
		var resources: Dictionary = province.resources
		if typeof(resources) != TYPE_DICTIONARY:
			continue
		for resource in resources.keys():
			total += float(resources[resource]) * _get_income_rate(str(resource))
	return total


## Oro acumulado por una nación IA (0 si es el jugador o no tiene).
func get_ai_accumulated_income(country_tag: String) -> float:
	return float(_ai_income.get(country_tag.strip_edges().to_upper(), 0.0))


# === Save / Load =============================================================

func get_save_data() -> Dictionary:
	return {"last_month_processed": _last_month_processed}


func load_save_data(data: Dictionary) -> void:
	_last_month_processed = int(data.get("last_month_processed", -1))


# === Helpers =================================================================

## Diccionario id->Province desde MapManager (preferido) o ScenarioLoader (fallback).
func _get_all_provinces() -> Dictionary:
	if typeof(MapManager) != TYPE_NIL and MapManager.has_method("has_province_data") and MapManager.has_province_data():
		return MapManager.get_all_provinces()
	var loader := get_node_or_null("/root/ScenarioLoader")
	if loader != null and "provinces" in loader:
		return loader.provinces
	return {}


## Quién controla la provincia (controller_tag; si vacío, owner_tag), en mayúsculas.
func _holder_of(province: Province) -> String:
	if province == null:
		return ""
	var holder := province.controller_tag.strip_edges()
	if holder.is_empty():
		holder = province.owner_tag.strip_edges()
	return holder.to_upper()


## Nación del jugador (desde SaveLoadManager; por defecto "CHL").
func _resolve_player_tag() -> String:
	if typeof(SaveLoadManager) != TYPE_NIL and "current_player_tag" in SaveLoadManager:
		var tag := str(SaveLoadManager.current_player_tag).strip_edges().to_upper()
		if not tag.is_empty():
			return tag
	return "CHL"
