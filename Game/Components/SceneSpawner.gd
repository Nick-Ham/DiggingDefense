extends Node
class_name SceneSpawner

@export var scenePath : PackedScene
@export var spawnCount : int
@export var spawnRadius : float


func instanceScene(newParent, newPosition) -> Node:
	var instance = scenePath.instantiate()
	instance.global_position = newPosition + getRandomOffset()
	newParent.add_child(instance)
	
	return instance

func instanceMultiple(newParent, newPosition) -> Array:
	var newInstances = Array()
	for each in spawnCount:
		var instance = scenePath.instantiate()
		instance.global_position = newPosition + getRandomOffset()
		newParent.add_child(instance)
		newInstances.append(instance)
	
	return newInstances

func getRandomOffset():
	return Vector2(randf_range(-spawnRadius, spawnRadius), randf_range(-spawnRadius, spawnRadius))
