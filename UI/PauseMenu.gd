extends CanvasLayer
class_name PauseMenu

@export_category("Local")
@export var quitButton : Button

signal unpause

func _ready() -> void:
	get_tree().paused = true
	Util.safeConnect(quitButton.pressed, _on_quit_button_pressed)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Escape"):
		get_tree().paused = false
		unpause.emit()
		queue_free()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
