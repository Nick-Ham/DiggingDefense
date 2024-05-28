extends Node2D
class_name HealthBar

@export_category("Config")
@export var visibleAlways : bool = true
@export var visibleWhenDamaged : bool = true
@export var showDamageNumbers : bool = true
@export var targetHealth : Health

@export_category("Local")
@export var progressBar : Range

var damageCounterPacked : PackedScene = preload("res://Game/Components/DamageCounter.tscn")

func _ready() -> void:
	assert(targetHealth)

	progressBar.max_value = targetHealth.getMaxHealth()
	progressBar.value = targetHealth.getCurrentHealth()

	updateVisibility()

	bindToHealth(targetHealth)

func updateVisibility() -> void:
	visible = visibleAlways or (visibleWhenDamaged and !isAtMax())

func isAtMax() -> bool:
	return targetHealth.getMaxHealth() == targetHealth.getCurrentHealth()

func bindToHealth(inHealth : Health) -> void:
	Util.safeConnect(inHealth.health_changed, _on_health_changed)

func _on_health_changed(lostHealth : int) -> void:
	progressBar.value = targetHealth.getCurrentHealth()

	if showDamageNumbers:
		createDamageNumber(lostHealth)

	updateVisibility()

func createDamageNumber(inDamage : int) -> void:
	var newDamageCounterInstance : DamageCounter = damageCounterPacked.instantiate() as DamageCounter

	var parentCharacter : Character = get_parent() as Character
	var parent : Node2D = get_parent() as Node2D
	if parentCharacter:
		newDamageCounterInstance.global_position = parentCharacter.getVisualCenterGlobalPosition()
	elif parent:
		newDamageCounterInstance.global_position = global_position
	else:
		newDamageCounterInstance.queue_free()
		return

	get_tree().current_scene.add_child(newDamageCounterInstance)
	newDamageCounterInstance.trigger(inDamage)
