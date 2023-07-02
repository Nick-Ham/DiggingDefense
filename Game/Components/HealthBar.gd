extends Node2D
class_name HealthBar

@export var ALWAYS_VISIBLE : bool = false
@export var VISIBLE_WHEN_DAMAGED : bool = false
@export var MAX_HEALTH : int = 1
@export var DAMAGE_COUNTER_SCALE : Vector2 = Vector2(1, 1)
var health : int = 1

@export_category("Local")
@export var sceneSpawner : SceneSpawner
@export var progressBar : ProgressBar

signal health_depleted
signal health_damaged

var damageCounterOffset : Vector2 = Vector2(10, 0)

func _ready():
	health = MAX_HEALTH
	
	progressBar.visible = ALWAYS_VISIBLE
	progressBar.max_value = MAX_HEALTH
	progressBar.value = health

func dealDamage(damage : int):
	if health <= 0:
		return
	
	health -= damage
	
	if ALWAYS_VISIBLE or VISIBLE_WHEN_DAMAGED:
		var newDamageCounter : DamageCounter = sceneSpawner.instanceScene(Game.getGameMode().getLevel(), global_position + damageCounterOffset)
		newDamageCounter.setScale(DAMAGE_COUNTER_SCALE)
		newDamageCounter.trigger(damage)
		
		progressBar.visible = true
		progressBar.value = health
	
	if health <= 0:
		emit_signal("health_depleted")
