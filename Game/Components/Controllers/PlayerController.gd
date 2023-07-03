extends Controller
class_name PlayerController

func determineInputDirection():
	inputDirection = Vector2()
	if Input.is_action_pressed("Down"):
		inputDirection.y += 1
	if Input.is_action_pressed("Up"):
		inputDirection.y -= 1
	if Input.is_action_pressed("Right"):
		inputDirection.x += 1
	if Input.is_action_pressed("Left"):
		inputDirection.x -= 1
	
	if Input.is_action_just_pressed("Space"):
		setAction(true)
	if Input.is_action_just_released("Space"):
		setAction(false)
	
	
