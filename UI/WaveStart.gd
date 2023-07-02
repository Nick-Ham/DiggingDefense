extends CanvasLayer
class_name WaveStart

signal ui_wave_start

@export var button : Button

var isWaveStartEnabled : bool = false

func _ready():
	button.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	if isWaveStartEnabled:
		emit_signal("ui_wave_start")

func activateWaveStartScreen():
	visible = true
	isWaveStartEnabled = true

func deactivateWaveStartScreen():
	visible = false
	isWaveStartEnabled = false
