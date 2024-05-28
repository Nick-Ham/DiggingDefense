extends EnemyCharacter
class_name ZombieCharacter

func _on_reached_target(target : Node2D):
	damage.dealDamage(target)
	kill()
