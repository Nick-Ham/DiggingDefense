extends Controller
class_name EnemyController

@export var hqFinder : HQFinder

func determineInputDirection():
	inputDirection = hqFinder.getDirection()
