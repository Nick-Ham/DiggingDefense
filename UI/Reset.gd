extends CanvasLayer
class_name Reset

signal ui_reset_level

@export var button : Button

var isResetEnabled : bool = false

func _ready():
	deactivateResetScreen()
	button.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	if isResetEnabled:
		emit_signal("ui_reset_level")

func activateResetScreen():
	visible = true
	isResetEnabled = true

func deactivateResetScreen():
	visible = false
	isResetEnabled = false
