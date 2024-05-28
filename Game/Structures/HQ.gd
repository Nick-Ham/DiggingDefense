extends Node2D
class_name HQ

@export var health : Health
@export var sprite : Sprite2D

signal hq_destroyed

var isHqDestroyed : bool = false

func _ready():
	assert(health)
	assert(sprite)

	Util.safeConnect(health.health_depleted, _on_health_depleted)

func _on_health_depleted():
	isHqDestroyed = true
	hq_destroyed.emit()
