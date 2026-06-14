extends Node

# NOTA: NO declaramos `class_name VictoryConditions` a propósito.
# Este script se registra como autoload singleton llamado "VictoryConditions".
# Usar class_name en un autoload hace que el analizador de GDScript emita
# "Class 'VictoryConditions' hides an autoload singleton" y el autoload NO carga
# (mismo patrón documentado en TimeManager.gd y MapManager.gd — deuda DT-02).
# Sin class_name, el singleton sigue siendo accesible globalmente como `VictoryConditions`
# y el patrón defensivo `if typeof(VictoryConditions) != TYPE_NIL:` funciona.

## Evaluador de condiciones de victoria para el escenario de la Guerra del Pacífico (1879).
##
## Se registra como autoload ("VictoryConditions"). Cada día de juego comprueba si
## alguna nación ha cumplido su condición de victoria y, en ese caso, emite
## `victory_achieved`. La UI puede consultar `get_victory_status()` para mostrar el
## progreso hacia la victoria.
##
## "Controlar" una provincia = quién la ocupa militarmente (controller_tag),
## no quién la posee nominalmente (owner_tag).

# Emitida una sola vez cuando se alcanza una condición de victoria.
signal victory_achieved(winner_tag: String, condition_name: String, description: String)

# --- Provincias clave del teatro (IDs reales del escenario 1879) ---
const PROV_ANTOFAGASTA := 841
const PROV_TARAPACA := 842
const PROV_IQUIQUE := 843
const PROV_ARICA := 844
const PROV_LIMA := 71

# Las tres provincias del salitre que decide la guerra.
const SALTPETER_PROVINCES: Array[int] = [PROV_ANTOFAGASTA, PROV_TARAPACA, PROV_IQUIQUE]

# Fecha límite histórica (Tratado de Valparaíso / fin efectivo): 1884-04-04.
const DEADLINE_YEAR := 1884
const DEADLINE_MONTH := 4
const DEADLINE_DAY := 4

# Fecha a partir de la cual Bolivia puede reclamar una victoria de recuperación.
const BOLIVIA_RECOVERY_YEAR := 1880
const BOLIVIA_RECOVERY_MONTH := 1
const BOLIVIA_RECOVERY_DAY := 1

# Una victoria MILITAR no puede decidirse en las primeras semanas: la guerra debe
# desarrollarse como una campaña. Antes de esta fecha solo cuentan las condiciones
# por fecha límite. (Evita que la guerra termine en el mes 1 por el combate instantáneo.)
const MILITARY_VICTORY_MIN_YEAR := 1880
const MILITARY_VICTORY_MIN_MONTH := 1
const MILITARY_VICTORY_MIN_DAY := 1

# Días por mes (sin años bisiestos), coherente con TimeManager.
const MONTH_DAYS: Array[int] = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

## Tag de la nación del jugador. Lo fija el sistema de carga de escenario.
var player_tag: String = "CHL"

# Estado interno.
var _scenario_loaded: bool = false
var _victory_triggered: bool = false
var _loader: Node = null


func _ready() -> void:
	# Escuchar el reloj central: comprobamos las condiciones cada día de juego.
	if typeof(TimeManager) != TYPE_NIL and TimeManager.has_signal("game_day_advanced"):
		if not TimeManager.game_day_advanced.is_connected(_on_game_day_advanced):
			TimeManager.game_day_advanced.connect(_on_game_day_advanced)

	if typeof(BattleManager) != TYPE_NIL:
		if not BattleManager.province_captured.is_connected(_on_province_captured):
			BattleManager.province_captured.connect(_on_province_captured)

	# Intentar enlazar con ScenarioLoader si ya está en el árbol (puede no estarlo aún).
	_try_connect_loader()


## Busca el nodo ScenarioLoader y se conecta a su señal `scenario_loaded` (best-effort).
func _try_connect_loader() -> void:
	if _loader != null and is_instance_valid(_loader):
		return
	_loader = get_node_or_null("/root/ScenarioLoader")
	if _loader != null and _loader.has_signal("scenario_loaded"):
		if not _loader.scenario_loaded.is_connected(_on_scenario_loaded):
			_loader.scenario_loaded.connect(_on_scenario_loaded)


## Llamada cuando un escenario termina de cargar.
func _on_scenario_loaded() -> void:
	_scenario_loaded = true
	_victory_triggered = false


## ¿Es el escenario activo el de 1879? Detección robusta vía la fecha de inicio del reloj.
func _is_1879_scenario() -> bool:
	if typeof(TimeManager) == TYPE_NIL:
		return false
	return str(TimeManager.get_scenario_start_date()).begins_with("1879")


# === Comprobación diaria =====================================================

func _on_game_day_advanced(_year: int, _month: int, _day: int) -> void:
	# Enlace perezoso: si el escenario cargó antes de que pudiéramos conectar la señal,
	# el simple hecho de que el reloj avance confirma que hay un escenario activo.
	if not _scenario_loaded:
		_try_connect_loader()
		if _is_1879_scenario():
			_scenario_loaded = true

	if _victory_triggered or not _scenario_loaded:
		return

	# Las condiciones usan IDs de provincia específicos de 1879; no evaluar en otros escenarios.
	if not _is_1879_scenario():
		return

	if typeof(MapManager) == TYPE_NIL or not MapManager.has_province_data():
		return

	_evaluate_victory_conditions()


func _on_province_captured(_province_id: int, _new_owner: String, _old_owner: String) -> void:
	_check_victory_conditions()


func _check_victory_conditions() -> void:
	if _victory_triggered:
		return
	if not _scenario_loaded:
		_try_connect_loader()
		if _is_1879_scenario():
			_scenario_loaded = true
	if not _scenario_loaded or not _is_1879_scenario():
		return
	if typeof(MapManager) == TYPE_NIL or not MapManager.has_province_data():
		return
	_evaluate_victory_conditions()


## Evalúa todas las condiciones en orden de prioridad. La primera que se cumpla gana.
func _evaluate_victory_conditions() -> void:
	var saltpeter_chl := _saltpeter_count_controlled_by("CHL")
	var past_deadline := _current_date_value() >= _date_value(DEADLINE_YEAR, DEADLINE_MONTH, DEADLINE_DAY)
	var past_bolivia_window := _current_date_value() > _date_value(
		BOLIVIA_RECOVERY_YEAR, BOLIVIA_RECOVERY_MONTH, BOLIVIA_RECOVERY_DAY
	)
	# Las victorias militares solo cuentan tras una campaña (no en las primeras semanas).
	var military_allowed := _current_date_value() >= _date_value(
		MILITARY_VICTORY_MIN_YEAR, MILITARY_VICTORY_MIN_MONTH, MILITARY_VICTORY_MIN_DAY
	)

	# 1) CHILE — victoria militar: controla las 3 provincias del salitre.
	if military_allowed and saltpeter_chl == SALTPETER_PROVINCES.size():
		_trigger_victory(
			"CHL",
			"victoria_militar",
			"Chile controla Antofagasta, Tarapacá e Iquique: dominio total del salitre."
		)
		return

	# 2) PERÚ — victoria militar: EXPULSA a Chile del litoral salitrero.
	#    Debe controlar las 3 provincias del salitre (incluida Antofagasta, que Chile
	#    ocupa al inicio) Y conservar Lima. No puede cumplirse en el turno 1 porque
	#    Chile arranca controlando Antofagasta (841).
	var saltpeter_per := _saltpeter_count_controlled_by("PER")
	if military_allowed and saltpeter_per == SALTPETER_PROVINCES.size() and _controls(PROV_LIMA, "PER"):
		_trigger_victory(
			"PER",
			"victoria_militar",
			"Perú expulsa a Chile del litoral: recupera todo el salitre y conserva Lima."
		)
		return

	# 3) BOLIVIA — recuperación: recupera Antofagasta después del 1 de enero de 1880.
	if past_bolivia_window and _controls(PROV_ANTOFAGASTA, "BOL"):
		_trigger_victory(
			"BOL",
			"recuperacion",
			"Bolivia recupera Antofagasta y su salida al mar."
		)
		return

	# 4) CHILE — victoria histórica (límite de tiempo): llegado el 4 de abril de 1884,
	#    controla al menos 2 de las 3 provincias del salitre.
	if past_deadline and saltpeter_chl >= 2:
		_trigger_victory(
			"CHL",
			"victoria_historica",
			"Al término de la guerra, Chile retiene el corazón salitrero del litoral."
		)
		return

	# 5) PERÚ/BOLIVIA — resistencia: llegado el límite, Chile NO controla a la vez
	#    Antofagasta y Tarapacá.
	if past_deadline and not (_controls(PROV_ANTOFAGASTA, "CHL") and _controls(PROV_TARAPACA, "CHL")):
		_trigger_victory(
			"PER",
			"resistencia_aliada",
			"La alianza Perú-Bolivia resiste: Chile no logra asegurar el litoral salitrero."
		)
		return


## Marca la victoria (una sola vez) y emite la señal.
func _trigger_victory(winner_tag: String, condition_name: String, description: String) -> void:
	if _victory_triggered:
		return
	_victory_triggered = true
	victory_achieved.emit(winner_tag, condition_name, description)


# === Estado para la UI =======================================================

## Resumen del progreso hacia la victoria, consumible por la interfaz.
func get_victory_status() -> Dictionary:
	return {
		"saltpeter_provinces_chl": _saltpeter_count_controlled_by("CHL"),
		"lima_owner": _holder_of(PROV_LIMA),
		"antofagasta_owner": _holder_of(PROV_ANTOFAGASTA),
		"days_remaining": _days_until_deadline(),
		"war_active": _is_war_active(),
	}


# === Helpers de control de provincias ========================================

## Devuelve quién ocupa militarmente la provincia (controller_tag; si está vacío, owner_tag).
func _holder_of(province_id: int) -> String:
	if typeof(MapManager) == TYPE_NIL:
		return ""
	var province: Province = MapManager.get_province(province_id)
	if province == null:
		return ""
	var holder := province.controller_tag.strip_edges()
	if holder.is_empty():
		holder = province.owner_tag.strip_edges()
	return holder.to_upper()


## ¿Controla `tag` la provincia indicada?
func _controls(province_id: int, tag: String) -> bool:
	return _holder_of(province_id) == tag.strip_edges().to_upper()


## Cuántas de las 3 provincias del salitre controla `tag` (0-3).
func _saltpeter_count_controlled_by(tag: String) -> int:
	var count := 0
	for province_id in SALTPETER_PROVINCES:
		if _controls(province_id, tag):
			count += 1
	return count


# === Helpers de fecha ========================================================

## Convierte una fecha a un número de día absoluto (sin años bisiestos, igual que TimeManager).
func _date_value(year: int, month: int, day: int) -> int:
	var days := year * 365
	var m := clampi(month, 1, 12)
	for i in range(m - 1):
		days += MONTH_DAYS[i]
	days += day - 1
	return days


func _current_date_value() -> int:
	if typeof(TimeManager) == TYPE_NIL:
		return 0
	return _date_value(
		TimeManager.get_current_year(),
		TimeManager.get_current_month(),
		TimeManager.get_current_day()
	)


## Días que faltan hasta el 4 de abril de 1884 (nunca negativo).
func _days_until_deadline() -> int:
	var remaining := _date_value(DEADLINE_YEAR, DEADLINE_MONTH, DEADLINE_DAY) - _current_date_value()
	return maxi(0, remaining)


## La guerra sigue activa mientras no se haya decidido y no se haya pasado el límite histórico.
func _is_war_active() -> bool:
	if not _scenario_loaded or _victory_triggered:
		return false
	return _current_date_value() < _date_value(DEADLINE_YEAR, DEADLINE_MONTH, DEADLINE_DAY)
