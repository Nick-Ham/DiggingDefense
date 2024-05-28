extends Node
class_name GameMode

@export_category("Local")
@export var level : Level

func _ready() -> void:
	pass

func getLevel() -> Level:
	return level

