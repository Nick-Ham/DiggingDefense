extends Node2D
class_name Drill

@export var drillSprite : Sprite2D

var isActive = false

func setActive(inIsActive):
	isActive = inIsActive
	if isActive:
		activateDrill()
	else:
		deactivateDrill()

func activateDrill():
	visible = true

func deactivateDrill():
	visible = false

func _process(delta):
	if !isActive:
		return
	
	look_at(get_global_mouse_position())
	Game.getGameMode().getLevel().getMap().attemptToDestroyTile(drillSprite.global_position)
