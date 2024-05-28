extends CanvasLayer

@export var debugText : RichTextLabel

var lastDelta = 0
var lastPDelta = 0

func _process(delta):
	lastDelta = delta
	debugText.text = "FPS: " + str(Engine.get_frames_per_second())
	debugText.text += "\nDelta: " + str(lastDelta)
	debugText.text += "\nDeltaP: " + str(lastPDelta)

func _physics_process(delta):
	lastPDelta = delta
