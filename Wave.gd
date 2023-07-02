extends Node
class_name Wave

func getSpawnGroups() -> Array[SpawnGroup]:
	var spawnGroups : Array[SpawnGroup]
	for child in get_children():
		spawnGroups.append(child)

	return spawnGroups

