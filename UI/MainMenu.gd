extends CanvasLayer
class_name MainMenu

@export_category("Local")
@export var startGameButton : Button

signal start_game

func _ready() -> void:
	bindEvents()
	GameInstance.registerMainMenu(self)

func bindEvents() -> void:
	Util.safeConnect(startGameButton.pressed, _on_start_game_button_pressed)

func _on_start_game_button_pressed() -> void:
	start_game.emit()
