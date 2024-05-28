extends Node2D
class_name HQFinder

@export_category("Config")
@export var shouldDisplayDebug : bool = false

@export_category("Local")
@export var navAgent : NavigationAgent2D

var target : HQ
var debugLine : Line2D = null

func _ready() -> void:
	if shouldDisplayDebug:
		debugLine = Line2D.new()
		add_child(debugLine)
		debugLine.default_color = Color(1, 0, 1)
		debugLine.width = 1.0

func _process(delta: float) -> void:
	if shouldDisplayDebug:
		debugLine.clear_points()
		debugLine.add_point(Vector2())
		debugLine.add_point(to_local(navAgent.get_next_path_position()))

func getDirection():
	if !target:
		setTarget()
		return Vector2()
	return (navAgent.get_next_path_position() - global_position).normalized()

func setTarget():
	var level : Level = get_tree().current_scene as Level
	var targetHq : HQ = level.getHQs().pick_random()
	target = targetHq
	if !target:
		return
	navAgent.target_position = target.global_position

func _physics_process(_delta):
	if !target:
		return

	navAgent.get_next_path_position()
