extends Character
class_name PlayerCharacter

@export var drill : Drill

func _on_action_pressed(action):
	drill.setActive(action)
