extends CanvasLayer
class_name LevelLostMenu

@export_category("Local")
@export var restartButton : Button
@export var quitButton : Button

signal restart_level
signal quit_level

func _ready() -> void:
	assert(restartButton)
	assert(quitButton)

	bindToMenu()

func bindToMenu() -> void:
	Util.safeConnect(restartButton.pressed, _on_restart_button_pressed)
	Util.safeConnect(quitButton.pressed, _on_quit_button_pressed)

func _on_restart_button_pressed() -> void:
	restart_level.emit()

func _on_quit_button_pressed() -> void:
	quit_level.emit()
