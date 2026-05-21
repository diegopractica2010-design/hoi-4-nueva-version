# scripts/formations/FormationSpawner.gd
class_name FormationSpawner
extends Node

const TEST_FORMATION_TYPES: Array[String] = [
	Formation.TYPE_DIVISION,
	Formation.TYPE_DIVISION,
	Formation.TYPE_FLEET,
	Formation.TYPE_AIR_WING,
	Formation.TYPE_GARRISON,
	Formation.TYPE_TASK_FORCE,
]


func spawn_test_formations_for_country(country_tag: String, count: int = 6) -> void:
	if country_tag.is_empty() or count <= 0:
		return

	for i in count:
		var formation := Formation.new()
		formation.formation_id = "%s_formation_%d" % [country_tag, i]
		formation.country_tag = country_tag
		formation.formation_type = TEST_FORMATION_TYPES[i % TEST_FORMATION_TYPES.size()]

		match formation.formation_type:
			Formation.TYPE_DIVISION:
				formation.name = "Division %d" % i
			Formation.TYPE_FLEET:
				formation.name = "Fleet %d" % i
			Formation.TYPE_AIR_WING:
				formation.name = "Air Wing %d" % i
			Formation.TYPE_GARRISON:
				formation.name = "Garrison %d" % i
			Formation.TYPE_TASK_FORCE:
				formation.name = "Naval Task Force %d" % i
			_:
				formation.name = "Formation %d" % i

		LeaderManager.register_formation(formation)

	print("Spawned %d test formations for %s" % [count, country_tag])
