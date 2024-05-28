extends Node
class_name SceneSpawner

@export var scenePath : PackedScene
@export var spawnCount : int
@export var spawnRadius : float


func instanceScene(newParent, newPosition) -> Node:
	var instance = scenePath.instantiate()
	instance.global_position = newPosition + RandUtil.getRandomOffset(spawnRadius)
	newParent.add_child(instance)

	return instance

func instanceMultiple(newParent, newPosition) -> Array:
	var newInstances = Array()
	for each in spawnCount:
		var instance = scenePath.instantiate()
		instance.global_position = newPosition + RandUtil.getRandomOffset(spawnRadius)
		newParent.add_child(instance)
		newInstances.append(instance)

	return newInstances
