extends Node2D
class_name DamageCounter

@export var counterTimer : Timer
@export var counterText : RichTextLabel

var alphaRate = 100
var randRot

func _ready():
	randRot = randi()%40 - 20

func setScale(inScale : Vector2):
	scale = inScale

func trigger(damage : int):
	counterText.text = str(damage)
	scale.x *= 1 + clamp(damage/25.0, 0, 1)
	scale.y *= 1 + clamp(damage/25.0, 0, 1)

func _process(delta):
	position.y -= 15 * delta
	scale.x *= 1 +  + (.2 * delta)
	scale.y *= 1 + (.2 * delta)
	rotation_degrees += randRot * delta
	counterText.modulate.a *= .98
	counterText.modulate.r *= 1.02
	counterText.modulate = counterText.modulate.darkened(.02)

func _on_timer_timeout():
	queue_free()
