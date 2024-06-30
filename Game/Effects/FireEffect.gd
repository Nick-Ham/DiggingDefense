extends Effect
class_name FireEffect

@export_category("Local")
@export var damage : Damage
@export var fireTick : Timer

var ragingFireEffectPacked : PackedScene = preload("res://Game/Effects/RagingFireEffect.tscn")

func _ready():
	fireTick.timeout.connect(_on_timer_timeout)
	setupEffect()

func setupEffect():
	damage.dealDamage(get_parent())

	for each in get_parent().get_children():
		if each == self:
			continue
		if each is FireEffect:
			each.queue_free()

	var wasSlimed = false
	for each in get_parent().get_children():
		if each is SlimedEffect:
			each.queue_free()
			wasSlimed = true

	if wasSlimed:
		var parentCharacter : Character = get_parent() as Character
		assert(parentCharacter, "Effect added to non-character.")

		var ragingFireEffect : RagingFireEffect = ragingFireEffectPacked.instantiate()
		ragingFireEffect.position = parentCharacter.to_local(parentCharacter.getVisualCenterGlobalPosition())
		parentCharacter.add_child(ragingFireEffect)
		queue_free()

func _on_timer_timeout():
	damage.dealDamage(get_parent())
