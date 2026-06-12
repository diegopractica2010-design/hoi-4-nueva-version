extends Node

# NOTA: NO declaramos `class_name UnitMovementSystem` a propósito.
# Este script se registra como autoload singleton llamado "UnitMovementSystem".
# Usar class_name en un autoload provoca el error "Class '...' hides an autoload singleton"
# y el autoload NO carga (deuda DT-02, igual que TimeManager/MapManager/VictoryConditions).
# Sin class_name, el singleton sigue accesible globalmente como `UnitMovementSystem`.

## Sistema de entrada para seleccionar y mover formaciones militares por el mapa de provincias.
##
## Modelo de ubicación: cada Formation tiene `province_id` (provincia donde está) e
## `is_moving` (ejecutando orden). El movimiento es entre provincias ADYACENTES
## (un salto por orden), validado contra data/provinces/province_adjacency.json.

signal formation_selected(formation_id: String, province_id: int)
signal move_order_issued(formation_id: String, from_province: int, to_province: int)
signal move_completed(formation_id: String, province_id: int)
signal movement_invalid(reason: String)

const ADJACENCY_PATH := "res://data/provinces/province_adjacency.json"

var selected_formation_id: String = ""
var selected_province_id: int = -1
var player_tag: String = "CHL"

# province_id (int) -> Array[int] de provincias adyacentes.
var _adjacency: Dictionary = {}


func _ready() -> void:
	# Cargar el grafo de adyacencia de provincias.
	_load_adjacency()

	# Sincronizar la nación del jugador con la fuente única (si está disponible).
	if typeof(SaveLoadManager) != TYPE_NIL and "current_player_tag" in SaveLoadManager:
		var tag := str(SaveLoadManager.current_player_tag).strip_edges().to_upper()
		if not tag.is_empty():
			player_tag = tag

	# Conectar a la señal de clic de provincia de MapManager (existe: `province_selected`).
	if typeof(MapManager) != TYPE_NIL and MapManager.has_signal("province_selected"):
		if not MapManager.province_selected.is_connected(on_province_clicked):
			MapManager.province_selected.connect(on_province_clicked)
	else:
		# Si MapManager no tuviera señal de clic, habría que añadirla (o llamar a
		# on_province_clicked() directamente desde la capa de UI / MapRenderer).
		push_warning("UnitMovementSystem: MapManager no expone 'province_selected'; llamar a on_province_clicked() manualmente.")


## 1) Carga province_adjacency.json y normaliza las claves a int.
func _load_adjacency() -> void:
	_adjacency = {}
	if not FileAccess.file_exists(ADJACENCY_PATH):
		push_warning("UnitMovementSystem: no se encontró %s" % ADJACENCY_PATH)
		return
	var file := FileAccess.open(ADJACENCY_PATH, FileAccess.READ)
	if file == null:
		return
	var json := JSON.new()
	var parse := json.parse(file.get_as_text())
	file.close()
	if parse != OK or typeof(json.data) != TYPE_DICTIONARY:
		push_warning("UnitMovementSystem: adyacencia inválida en %s" % ADJACENCY_PATH)
		return
	# El archivo tiene forma {"version": 1, "adjacency": {"1": [2,43], ...}}.
	var raw: Variant = (json.data as Dictionary).get("adjacency", {})
	if typeof(raw) != TYPE_DICTIONARY:
		return
	for key in (raw as Dictionary).keys():
		var pid := int(str(key))
		var neighbors: Array[int] = []
		var raw_neighbors: Variant = (raw as Dictionary)[key]
		if typeof(raw_neighbors) == TYPE_ARRAY:
			for n in raw_neighbors as Array:
				neighbors.append(int(n))
		_adjacency[pid] = neighbors


## 2) Llamada cuando el jugador hace clic en una provincia del mapa.
func on_province_clicked(province_id: int) -> void:
	# --- Caso A: no hay formación seleccionada → intentar seleccionar una propia aquí.
	if selected_formation_id.is_empty():
		var formation := _first_friendly_formation_in(province_id)
		if formation != null:
			selected_formation_id = formation.formation_id
			selected_province_id = province_id
			_highlight_province(province_id)
			formation_selected.emit(formation.formation_id, province_id)
		# Si no hay formación propia aquí, no hacemos nada (clic en vacío).
		return

	# --- Caso B: ya hay una formación seleccionada.

	# B1: clic en la MISMA provincia → deseleccionar.
	if province_id == selected_province_id:
		_clear_selection()
		return

	# B2: clic en OTRA provincia propia con formación → cambiar la selección a esa.
	var other := _first_friendly_formation_in(province_id)
	if other != null:
		selected_formation_id = other.formation_id
		selected_province_id = province_id
		_highlight_province(province_id)
		formation_selected.emit(other.formation_id, province_id)
		return

	# B3: clic en provincia NO adyacente → inválido.
	if not is_province_adjacent(selected_province_id, province_id):
		movement_invalid.emit("Province not adjacent")
		return

	# B4: provincia adyacente → validar y mover.
	if can_move_to(selected_formation_id, province_id):
		execute_move(selected_formation_id, province_id)
	else:
		movement_invalid.emit("No se puede mover a la provincia %d" % province_id)


## 3) ¿Es to_id adyacente a from_id?
func is_province_adjacent(from_id: int, to_id: int) -> bool:
	if not _adjacency.has(from_id):
		return false
	return to_id in (_adjacency[from_id] as Array)


## 4) ¿Puede la formación moverse a la provincia objetivo?
func can_move_to(formation_id: String, target_province_id: int) -> bool:
	if typeof(LeaderManager) == TYPE_NIL:
		return false
	var formation: Formation = LeaderManager.get_formation(formation_id)
	if formation == null:
		return false
	# Debe pertenecer al jugador.
	if formation.country_tag.strip_edges().to_upper() != player_tag.strip_edges().to_upper():
		return false
	# No puede estar ya moviéndose (ni en combate).
	if formation.is_moving or formation.is_in_combat:
		return false
	# El objetivo debe ser adyacente a la provincia actual de la formación.
	if not is_province_adjacent(formation.province_id, target_province_id):
		return false
	return true


## 5) Ejecuta el movimiento: actualiza la provincia de la formación y emite señales.
func execute_move(formation_id: String, target_province_id: int) -> void:
	if typeof(LeaderManager) == TYPE_NIL:
		return
	var formation: Formation = LeaderManager.get_formation(formation_id)
	if formation == null:
		return
	# Guardar el origen para la señal antes de actualizar.
	var from_province := formation.province_id
	# Mover (un salto entre provincias adyacentes).
	formation.province_id = target_province_id
	# Limpiar la selección tras emitir la orden.
	_clear_selection()
	# Señales: orden emitida (origen→destino) y movimiento completado (instantáneo en MVP).
	move_order_issued.emit(formation_id, from_province, target_province_id)
	move_completed.emit(formation_id, target_province_id)


## 6) Formaciones de una nación que pueden moverse (existen, no en combate ni moviéndose).
func get_movable_formations(country_tag: String) -> Array:
	var result: Array = []
	if typeof(LeaderManager) == TYPE_NIL:
		return result
	for formation in LeaderManager.get_formations_for_country(country_tag):
		if formation != null and not formation.is_moving and not formation.is_in_combat:
			result.append(formation.formation_id)
	return result


## 7) Provincias adyacentes a una dada.
func get_adjacent_provinces(province_id: int) -> Array:
	return (_adjacency.get(province_id, []) as Array).duplicate()


## 8) Fija la nación del jugador.
func set_player_tag(tag: String) -> void:
	var clean := tag.strip_edges().to_upper()
	if not clean.is_empty():
		player_tag = clean


# === Helpers internos ========================================================

## Primera formación del jugador situada en la provincia dada (o null).
func _first_friendly_formation_in(province_id: int) -> Formation:
	if typeof(LeaderManager) == TYPE_NIL:
		return null
	for formation in LeaderManager.get_formations_for_country(player_tag):
		if formation != null and formation.province_id == province_id:
			return formation
	return null


## Resalta una provincia. ProvinceMapVisuals no expone hoy un método de resaltado,
## así que el resaltado real lo hace quien escuche `formation_selected` (la capa de UI).
## Si en el futuro existe una API de resaltado, se invocaría aquí.
func _highlight_province(_province_id: int) -> void:
	pass


## Limpia la selección actual.
func _clear_selection() -> void:
	selected_formation_id = ""
	selected_province_id = -1
