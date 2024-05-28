extends Node
class_name Controller

signal inputDirectionChanged(newDirection : Vector2)
signal actionChanged(isPressed : bool)

var inputDirection : Vector2 = Vector2()

func _ready():
	var character = get_parent() as Character
	character.bindController(self)

func _process(_delta):
	determineInputDirection()
	emit_signal("inputDirectionChanged", inputDirection)

func determineInputDirection():
	inputDirection = Vector2()

func getInputDirection():
	return inputDirection
