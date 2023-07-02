extends Node2D
class_name Turret

enum DIRECTION {LEFT, RIGHT, UP, DOWN}

@export var reloadDuration : float = 1
@export var facing : DIRECTION
@export var sprite : Sprite2D
@export var reloadTimer : Timer
@export var projectileSpawnPosition : Node2D
@export var sceneSpawner : SceneSpawner

var readyToFire : bool = true

func _ready():
	updateSpriteDirection()
	reloadTimer.wait_time = reloadDuration
	reloadTimer.start()
	

func updateSpriteDirection():
	match facing:
		DIRECTION.LEFT:
			sprite.rotation_degrees = 180
		DIRECTION.RIGHT:
			sprite.rotation_degrees = 0
		DIRECTION.UP:
			sprite.rotation_degrees = -90
		DIRECTION.DOWN:
			sprite.rotation_degrees = 90

func fire():
	readyToFire = false
	reloadTimer.start()
	var newScene : Projectile = sceneSpawner.instanceScene(Game.getGameMode().getLevel(), projectileSpawnPosition.global_position)
	newScene.setFacing(facing)

func _on_reload_timer_timeout():
	readyToFire = true
	fire()
