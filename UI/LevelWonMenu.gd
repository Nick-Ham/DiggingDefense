extends CanvasLayer
class_name LevelWonMenu

@export_category("Local")
@export var nextLevelButton : Button
@export var quitButton : Button

signal next_level
signal quit_level

func _ready() -> void:
	assert(nextLevelButton)
	assert(quitButton)

	bindToMenu()

func bindToMenu() -> void:
	Util.safeConnect(nextLevelButton.pressed, _on_next_level_button_pressed)
	Util.safeConnect(quitButton.pressed, _on_quit_button_pressed)

func _on_next_level_button_pressed() -> void:
	next_level.emit()

func _on_quit_button_pressed() -> void:
	quit_level.emit()
