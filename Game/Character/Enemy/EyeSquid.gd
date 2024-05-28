extends EnemyCharacter
class_name EyeSquid

@export var healthBar : HealthBar

func bindSignals():
	healthBar.health_depleted.connect(_on_health_depleted)

func _on_reached_target(target : Node2D):
	super._on_reached_target(target)
	damage.dealDamage(target)
	queue_free()

func _on_health_depleted():
	queue_free()
