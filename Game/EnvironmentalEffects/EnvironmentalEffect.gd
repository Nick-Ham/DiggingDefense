extends Area2D
class_name EnvironmentalEffect

@export_category("Config")
@export var effectName : String = ""

var affectedCharacters : Array[Character] = []

func _ready():
	assert(effectName != "", "EnvironmentalEffect must have an effectName.")

	var parentMap : Map = get_parent() as Map
	assert(parentMap, "EnvironmentalEffect should be spawned using the Map tilemap editor.")
	parentMap.registerEffect(self)

	Util.safeConnect(body_entered, _on_environment_effect_entered)

func _on_environment_effect_entered(body):
	if body in affectedCharacters:
		return

	applyEffect(body)
	affectedCharacters.append(body)

func applyEffect(body):
	return
