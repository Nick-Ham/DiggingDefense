extends Node
class_name RandUtil

static func rollDice(chance : float):
	var randRoll = randf()
	return chance > randRoll

static func getRandomOffset(inMaxRadius : float) -> Vector2:
	return Vector2(randf_range(-inMaxRadius, inMaxRadius), randf_range(-inMaxRadius, inMaxRadius))
