extends Timer
class_name Lifetime

@export var lifetimeDuration : float = 1

func _ready():
	timeout.connect(_on_timeout)
	start(lifetimeDuration)

func _on_timeout():
	get_parent().queue_free()
