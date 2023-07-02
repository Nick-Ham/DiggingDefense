extends Node2D
class_name HQFinder

@export var navAgent : NavigationAgent2D

var target : HQ

func getDirection():
	if !target:
		setTarget()
		return Vector2()
	return (navAgent.get_next_path_position() - global_position).normalized()

func setTarget():
	target = Game.getGameMode().getLevel().getHQ()
	if !target:
		return
	navAgent.target_position = target.global_position

func _physics_process(_delta):
	if !target:
		return
	
	navAgent.get_next_path_position()
