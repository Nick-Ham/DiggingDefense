extends Area2D
class_name EnemyInformer

@export var Target : Node2D

func _ready():
	if !Target:
		print_debug(owner.name + ": EnemyInformer.gd requires Target")
		#get_tree().quit()
	
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	var enemyCharacter = body as EnemyCharacter
	if !enemyCharacter:
		return
	
	enemyCharacter._on_reached_target(Target)
