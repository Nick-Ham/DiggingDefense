extends Node2D
class_name ChainLightningEffect

@export_category("Config")
@export var jumpDelay : float = 1.0
@export var maxChainSize : int = 3

@export_category("Local")
@export var jumpArea : Area2D
@export var damage : Damage
@export var line : Line2D

var totalTime : float = 0.0
var trackedTargets : Array[Character]
var currentTargets : Array[Character]
var source : Node2D = null
var effectTimeoutStarted : bool = false

var jumpFailed : bool = false

func _ready() -> void:
	assert(jumpArea)
	assert(damage)
	assert(line)

func _process(delta: float) -> void:
	updateLine()

func _physics_process(delta: float) -> void:
	totalTime += delta

	if totalTime > jumpDelay:
		totalTime -= jumpDelay

		if jumpFailed:
			currentTargets.pop_front()
			return

		var newTarget : Character = findNewTarget()
		if !newTarget:
			jumpFailed = true
			if trackedTargets.is_empty():
				return

			if trackedTargets.back() == null || trackedTargets.back().is_queued_for_deletion():
				return

			damage.dealDamage(trackedTargets.back())
			return

		jumpToTarget(newTarget)

func setInitialTarget(inTarget : Character) -> void:
	totalTime = 0.0

	trackedTargets.clear()
	currentTargets.clear()
	trackedTargets.append(inTarget)
	currentTargets.append(inTarget)

	line.visible = true
	updateLine()

	Util.safeConnect(inTarget.character_destroyed, _on_target_destroyed)
	damage.dealDamage(inTarget)

func findNewTarget() -> Character:
	var foundBodies : Array[Node2D] = jumpArea.get_overlapping_bodies()

	var foundCharacters : Array[Character] = []
	for body in foundBodies:
		var character : Character = body as Character
		if !character:
			continue

		if character in trackedTargets:
			continue

		foundCharacters.append(character)

	if foundCharacters.is_empty():
		return null

	var closestCharacter : Character = foundCharacters[0]
	var minDistance : float = global_position.distance_squared_to(closestCharacter.global_position)

	for character in foundCharacters:
		var newDistance : float = global_position.distance_squared_to(character.global_position)
		if newDistance < minDistance:
			minDistance = newDistance
			closestCharacter = character

	return closestCharacter

func jumpToTarget(inTarget : Character) -> void:
	trackedTargets.append(inTarget)
	currentTargets.append(inTarget)
	if currentTargets.size() > maxChainSize:
		currentTargets.pop_front()

	Util.safeConnect(inTarget.character_destroyed, _on_target_destroyed)
	damage.dealDamage(inTarget as Node)

	global_position = inTarget.global_position
	updateLine()

func updateLine() -> void:
	line.clear_points()

	for each in currentTargets:
		if each == null:
			continue

		line.add_point(to_local(each.getVisualCenterGlobalPosition()))

func _on_target_destroyed(inTarget : Character) -> void:
	trackedTargets.erase(inTarget)
	currentTargets.erase(inTarget)
