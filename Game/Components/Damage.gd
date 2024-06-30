@icon("res://Assets/Icons/DamageIcon.png")
extends Node
class_name Damage

@export var damageValue : int = 0

func dealDamage(target : Node):
	for child in target.get_children():
		var targetHealth = child as Health
		if targetHealth:
			targetHealth.takeDamage(damageValue)

