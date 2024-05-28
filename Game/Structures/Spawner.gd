extends Node2D
class_name Spawner

@export_category("Config")
@export var spawnLimit : int = 20
@export var spawnRadius : float = 10.0

@export_category("Local")
@export var detector : Area2D

var targetHQ : HQ

func trySpawn(scene : PackedScene) -> Node2D:
	assert(scene)

	if detector.get_overlapping_bodies().size() > spawnLimit:
		return null

	var level : Level = get_tree().current_scene as Level
	var newInstance = scene.instantiate() as Node2D
	newInstance.global_position = global_position + RandUtil.getRandomOffset(spawnRadius)
	level.add_child(newInstance)


	return newInstance
