extends Node2D
class_name HQ

@export var health : HealthBar
@export var sprite : Sprite2D

func _ready():
	bindEvents()

func bindEvents():
	if health:
		health.health_depleted.connect(_on_health_depleted)

func _on_health_depleted():
	SignalBus.emit_signal("hq_destroyed", Game.getGameMode().getLevel(), self)
