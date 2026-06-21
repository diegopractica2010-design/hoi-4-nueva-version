# scripts/formations/Formation.gd
class_name Formation
extends Resource

const TYPE_DIVISION := "division"
const TYPE_ARMY := "army"
const TYPE_ARMY_GROUP := "army_group"
const TYPE_GARRISON := "garrison"
const TYPE_BRIGADE := "brigade"
const TYPE_FLEET := "fleet"
const TYPE_TASK_FORCE := "task_force"
const TYPE_SHIP := "ship"
const TYPE_AIR_WING := "air_wing"
const TYPE_AIR_SQUADRON := "air_squadron"
const TYPE_AIR_GROUP := "air_group"
const TYPE_SPACE_WING := "space_wing"
const TYPE_ORBITAL_GROUP := "orbital_group"

const CATEGORY_LAND := "land"
const CATEGORY_NAVAL := "naval"
const CATEGORY_AIR := "air"
const CATEGORY_SPACE := "space"

@export var formation_id: String = ""
@export var name: String = ""
@export var formation_type: String = TYPE_DIVISION
@export var country_tag: String = ""
@export var leader_id: String = ""
@export var parent_formation_id: String = ""
@export var is_training: bool = false
@export var is_in_combat: bool = false
## Provincia donde se encuentra la formación (-1 = sin desplegar en el mapa).
## Lo usa UnitMovementSystem para seleccionar y mover formaciones por el mapa.
@export var province_id: int = -1
## True mientras la formación ejecuta una orden de movimiento (bloquea nuevas órdenes).
@export var is_moving: bool = false

var assigned_leader: Leader = null

## 0.0 = full supply, 1.0 = sin suministro. Decae cuando la formación recibe suministro completo.
@export var supply_shortfall: float = 0.0
## Salud actual de la formación (0.0 = destruida, 1.0 = intacta).
@export var strength: float = 1.0
## Salud máxima (punto de referencia para daños).
@export var max_strength: float = 1.0
## Ancho de combate que ocupa esta formación en batalla (afecta penalización por apilamiento).
@export var combat_width: int = 10


## Aplica un faltante de suministro. Si el faltante es menor que el actual, el valor decae lentamente.
func apply_supply_shortfall(shortfall: float) -> void:
	supply_shortfall = clampf(supply_shortfall + shortfall * 0.1, 0.0, 1.0)


## Reduce el shortfall cuando la formación recibe suministro completo (llamado desde SupplyManager).
func reduce_supply_shortfall(amount: float) -> void:
	supply_shortfall = maxf(0.0, supply_shortfall - amount)


## Retorna el multiplicador de efectividad en combate por suministro (1.0 = óptimo, 0.3 = sin suministro).
func get_supply_multiplier() -> float:
	return 1.0 - supply_shortfall * 0.7


## Reduce la salud en un porcentaje (0.0–1.0) de la salud máxima.
func apply_damage(damage_percent: float) -> void:
	strength = maxf(0.0, strength - max_strength * clampf(damage_percent, 0.0, 1.0))


## Retorna true si la formación está destruida (sin salud).
func is_destroyed() -> bool:
	return strength <= 0.0


func has_leader() -> bool:
	return not leader_id.is_empty()


func assign_leader(leader: Leader) -> bool:
	if leader == null:
		return false
	leader_id = leader.leader_id
	assigned_leader = leader
	return true


func remove_leader() -> void:
	leader_id = ""
	assigned_leader = null


func get_category() -> String:
	match formation_type:
		TYPE_FLEET, TYPE_TASK_FORCE, TYPE_SHIP:
			return CATEGORY_NAVAL
		TYPE_AIR_WING, TYPE_AIR_SQUADRON, TYPE_AIR_GROUP:
			return CATEGORY_AIR
		TYPE_SPACE_WING, TYPE_ORBITAL_GROUP:
			return CATEGORY_SPACE
		_:
			return CATEGORY_LAND


static func from_division_template(
	division_id: String,
	div_template: DivisionTemplate,
	country: String,
) -> Formation:
	var formation := Formation.new()
	formation.formation_id = division_id
	formation.name = div_template.display_name if not div_template.display_name.is_empty() else division_id
	formation.formation_type = TYPE_DIVISION
	formation.country_tag = country
	return formation
