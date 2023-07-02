extends Node2D
class_name Effect

var targetHealth

func setupEffect(newTargetHealth : HealthBar):
	global_position = newTargetHealth.global_position
	targetHealth = newTargetHealth
