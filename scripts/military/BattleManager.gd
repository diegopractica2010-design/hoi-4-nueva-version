extends Node

# NOTA: NO declaramos `class_name BattleManager` a propósito.
# Se registra como autoload singleton "BattleManager". Usar class_name en un autoload
# provoca "Class '...' hides an autoload singleton" y el autoload NO carga (deuda DT-02,
# igual que TimeManager/MapManager/VictoryConditions/UnitMovementSystem).
# Sin class_name, el singleton sigue accesible globalmente como `BattleManager`.

## Detecta cuando una formación enemiga ocupa la misma provincia tras un movimiento,
## resuelve la batalla con CombatResolver y actualiza la propiedad de la provincia.

signal battle_started(province_id: int, attacker_tag: String, defender_tag: String)
signal battle_resolved(province_id: int, winner_tag: String, loser_tag: String, result: Dictionary)
signal province_captured(province_id: int, new_owner: String, old_owner: String)

const HISTORY_MAX := 10

# Instancia propia de CombatResolver (no es autoload; se usa con .new()).
var _resolver: CombatResolver = null

# Historial de las últimas batallas (más reciente al final).
var _battle_history: Array = []


func _ready() -> void:
	# Crear el resolutor de combate (extends Node; lo añadimos al árbol para que sus
	# helpers internos —p. ej. localizar el ScenarioLoader— funcionen).
	_resolver = CombatResolver.new()
	_resolver.name = "BattleManagerCombatResolver"
	add_child(_resolver)

	# Conectar a la señal de movimiento completado del sistema de movimiento.
	if typeof(UnitMovementSystem) != TYPE_NIL and UnitMovementSystem.has_signal("move_completed"):
		if not UnitMovementSystem.move_completed.is_connected(_on_formation_moved):
			UnitMovementSystem.move_completed.connect(_on_formation_moved)
	else:
		push_warning("BattleManager: UnitMovementSystem no disponible; las batallas no se dispararán por movimiento.")


## Se llama cuando una formación termina de moverse a una provincia.
func _on_formation_moved(formation_id: String, province_id: int) -> void:
	if typeof(LeaderManager) == TYPE_NIL:
		return

	# 1) Nación de la formación que se movió (el atacante entrante).
	var moved: Formation = LeaderManager.get_formation(formation_id)
	if moved == null:
		return
	var mover_tag := moved.country_tag.strip_edges().to_upper()

	# 2-3) Buscar una formación enemiga (otra nación) en la misma provincia.
	var defender: Formation = null
	for fid in LeaderManager.formations.keys():
		var f: Formation = LeaderManager.formations[fid] as Formation
		if f == null or f.formation_id == formation_id:
			continue
		if f.province_id == province_id and f.country_tag.strip_edges().to_upper() != mover_tag:
			defender = f
			break

	# 4) Sin enemigo → movimiento pacífico.
	if defender == null:
		return

	# 5) Enemigo presente → resolver batalla (el que entró es el atacante).
	_resolve_battle(province_id, formation_id, defender.formation_id)


func _resolve_battle(province_id: int, attacker_id: String, defender_id: String) -> void:
	if typeof(LeaderManager) == TYPE_NIL:
		return
	var attacker: Formation = LeaderManager.get_formation(attacker_id)
	var defender: Formation = LeaderManager.get_formation(defender_id)
	if attacker == null or defender == null:
		return

	var attacker_tag := attacker.country_tag.strip_edges().to_upper()
	var defender_tag := defender.country_tag.strip_edges().to_upper()
	var province: Province = _get_province(province_id)
	var province_name := province.name if province != null else "Provincia %d" % province_id

	# 1) Señal de inicio.
	battle_started.emit(province_id, attacker_tag, defender_tag)

	# 4-6) Poder de combate: SUMA de todas las formaciones de cada bando presentes en la
	# provincia (concentrar el ejército decide la batalla) + habilidad de los líderes.
	# Azar reducido (0.92-1.08) para que las decisiones pesen más que la suerte.
	var attacker_power := _side_power(province_id, attacker_tag, false) * randf_range(0.92, 1.08)
	var defender_power := _side_power(province_id, defender_tag, true) * randf_range(0.92, 1.08)

	var attacker_wins := attacker_power >= defender_power
	var winner_tag := attacker_tag if attacker_wins else defender_tag
	var loser_tag := defender_tag if attacker_wins else attacker_tag

	# Intensidad de la batalla: más reñida (poderes parecidos) = más intensa.
	var max_power := maxf(attacker_power, defender_power)
	var min_power := minf(attacker_power, defender_power)
	var intensity := clampf(min_power / max_power, 0.2, 1.0) if max_power > 0.0 else 1.0

	# 7) Secuelas (bajas + XP) vía la API real de CombatResolver (usa formation_id como army_id).
	var aftermath: Dictionary = {}
	if _resolver != null:
		var battle_result := {
			"outcome": "attacker_victory" if attacker_wins else "defender_victory",
			"winner_tag": winner_tag,
			"intensity": intensity,
		}
		# attacker.province_id = province the attacker moved FROM (origin terrain)
		# province_id = the combat province (defender's terrain)
		aftermath = _resolver.resolve_battle_aftermath(
			attacker_id, defender_id, battle_result, intensity,
			attacker.province_id, province_id,
		)

	var attacker_casualties := _sum_casualties(aftermath.get("attacker_casualty", {}))
	var defender_casualties := _sum_casualties(aftermath.get("defender_casualty", {}))

	# 8) Diccionario de resultado.
	var result := {
		"attacker_tag": attacker_tag,
		"defender_tag": defender_tag,
		"winner_tag": winner_tag,
		"loser_tag": loser_tag,
		"attacker_power": attacker_power,
		"defender_power": defender_power,
		"province_id": province_id,
		"province_name": province_name,
		"attacker_casualties": attacker_casualties,
		"defender_casualties": defender_casualties,
	}

	# 9-10) Aplicar el desenlace.
	if attacker_wins:
		_capture_province(province_id, attacker_tag, defender_tag)
		# El defensor se retira a una provincia adyacente que controle (si la hay).
		_retreat_formation(defender, province_id, defender_tag)
	else:
		# El atacante se retira; la provincia queda con el defensor.
		_retreat_formation(attacker, province_id, attacker_tag)

	# 11) Señal de batalla resuelta + historial.
	battle_resolved.emit(province_id, winner_tag, loser_tag, result)
	_battle_history.append(result)
	while _battle_history.size() > HISTORY_MAX:
		_battle_history.pop_front()


func _capture_province(province_id: int, new_owner: String, old_owner: String) -> void:
	# Actualizar dueño + controlador vía MapManager (la API real es update_province_owner,
	# no set_province_owner). Saltamos la captura interna de fábricas para hacerla aquí
	# explícitamente (como pide la tarea) y evitar duplicarla.
	if typeof(MapManager) != TYPE_NIL and MapManager.has_method("update_province_owner"):
		MapManager.update_province_owner(province_id, new_owner, new_owner, true)
	else:
		# Respaldo: actualizar el dato de la provincia directamente.
		var p: Province = _get_province(province_id)
		if p != null:
			p.owner_tag = new_owner
			p.controller_tag = new_owner

	# Captura de fábricas de la provincia para el nuevo dueño.
	if typeof(FactoryManager) != TYPE_NIL and FactoryManager.has_method("capture_province_factories"):
		FactoryManager.capture_province_factories(province_id, new_owner)

	province_captured.emit(province_id, new_owner, old_owner)


## Últimas 10 batallas (más reciente al final).
func get_battle_history() -> Array:
	return _battle_history.duplicate()


# === Helpers =================================================================

## Poder de combate escalar de una formación en una provincia.
## Intenta la API real de CombatResolver (que devuelve un Dictionary de stats); si la
## formación no tiene plantilla con stats registrados, usa una heurística por terreno.
func _combat_power(formation: Formation, province: Province, is_defender: bool) -> float:
	if formation == null:
		return 0.0
	var terrain := "plains"
	var pid := -1
	var dev := -1
	var infra := -1
	if province != null:
		terrain = province.terrain
		pid = province.id
		dev = province.development_level
		infra = province.infrastructure

	var power := 0.0
	if _resolver != null:
		# No hay campo de plantilla en Formation; usamos formation_id como mejor aproximación
		# (y formation_id como army_id para los bonus de líder/nación).
		var stats: Dictionary = _resolver.get_effective_combat_power(
			formation.formation_id, "", formation.formation_id, terrain, pid, dev, infra,
		)
		# Agregamos todos los valores numéricos del Dictionary a un escalar comparable.
		for key in stats.keys():
			var v: Variant = stats[key]
			if typeof(v) == TYPE_FLOAT or typeof(v) == TYPE_INT:
				power += float(v)

	# Heurística de respaldo si no hubo stats reales (formaciones de prueba sin plantilla).
	if power <= 0.0:
		power = 10.0
		if infra > 0:
			power += float(infra)
		if dev > 0:
			power += float(dev)

	# Habilidad del líder asignado (ataque o defensa según el rol): premia comandar bien.
	if not formation.leader_id.is_empty() and typeof(LeaderManager) != TYPE_NIL:
		var leader = LeaderManager.get_leader(formation.leader_id)
		if leader != null:
			var skill := int(leader.defense_skill if is_defender else leader.attack_skill)
			power += float(skill) * 2.0

	# Ventaja defensiva: terreno + fortificación.
	if is_defender and province != null:
		power *= 1.15
		if province.has_feature("fort"):
			power *= 1.0 + 0.1 * float(province.get_feature_level("fort"))
	return power


## Poder total de un bando en una provincia = suma de TODAS sus formaciones presentes.
## Hace que concentrar el ejército sea una decisión decisiva (stacking).
func _side_power(province_id: int, tag: String, is_defender: bool) -> float:
	if typeof(LeaderManager) == TYPE_NIL:
		return 0.0
	var province: Province = _get_province(province_id)
	var clean := tag.strip_edges().to_upper()
	var total := 0.0
	for fid in LeaderManager.formations:
		var f: Formation = LeaderManager.formations[fid]
		if f == null or f.province_id != province_id:
			continue
		if f.country_tag.strip_edges().to_upper() != clean:
			continue
		total += _combat_power(f, province, is_defender)
	# Dificultad: la IA pelea más fuerte/débil según el nivel elegido. Solo se
	# aplica a los bandos controlados por la IA (no al del jugador); en batallas
	# IA-vs-IA el factor afecta a ambos y se cancela.
	if typeof(AIManager) != TYPE_NIL and clean != AIManager.player_tag:
		total *= AIManager.get_ai_combat_multiplier()
	return total


## Retira una formación a una provincia adyacente que controle su nación; si no hay
## ninguna, queda desplazada (province_id = -1).
func _retreat_formation(formation: Formation, from_province: int, owner_tag: String) -> void:
	if formation == null:
		return
	var owner := owner_tag.strip_edges().to_upper()
	if typeof(UnitMovementSystem) != TYPE_NIL:
		for adj_var in UnitMovementSystem.get_adjacent_provinces(from_province):
			var adj := int(adj_var)
			var p: Province = _get_province(adj)
			if p != null and _holder_of(p) == owner:
				formation.province_id = adj
				return
	# Sin refugio adyacente: la formación queda fuera del mapa (desplazada/dispersada).
	formation.province_id = -1


## Provincia por ID desde MapManager (preferido) o ScenarioLoader (fallback).
func _get_province(province_id: int) -> Province:
	if typeof(MapManager) != TYPE_NIL and MapManager.has_method("get_province"):
		var p: Province = MapManager.get_province(province_id)
		if p != null:
			return p
	var loader := get_node_or_null("/root/ScenarioLoader")
	if loader != null and loader.has_method("get_province"):
		return loader.call("get_province", province_id)
	return null


## Quién controla la provincia (controller_tag; si vacío, owner_tag), en mayúsculas.
func _holder_of(province: Province) -> String:
	if province == null:
		return ""
	var holder := province.controller_tag.strip_edges()
	if holder.is_empty():
		holder = province.owner_tag.strip_edges()
	return holder.to_upper()


## Suma los valores de un diccionario de bajas (equipo -> cantidad) a un entero.
func _sum_casualties(casualty: Variant) -> int:
	if typeof(casualty) != TYPE_DICTIONARY:
		return 0
	var total := 0.0
	for key in (casualty as Dictionary).keys():
		var v: Variant = (casualty as Dictionary)[key]
		if typeof(v) == TYPE_FLOAT or typeof(v) == TYPE_INT:
			total += float(v)
	return int(round(total))
