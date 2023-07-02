extends Node2D
class_name Spawner

@export var spawnMarker : Sprite2D
@export var sceneSpawner : SceneSpawner
@export var detector : Area2D

@export var spawnLimit : int = 10

var targetHQ : HQ

func ready():
	spawnMarker.visible = false

func trySpawn(scene : PackedScene) -> bool:
	sceneSpawner.scenePath = scene
	# this is garbage and needs to be removed
	
	if detector.get_overlapping_bodies().size() > spawnLimit:
		return false
	
	var newInstance = sceneSpawner.instanceScene(Game.getGameMode().getLevel(), spawnMarker.global_position)
	
	if !newInstance:
		return false
	
	return true
