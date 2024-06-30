extends Effect
class_name SlimedEffect

var ragingFireEffectPacked : PackedScene = preload("res://Game/Effects/RagingFireEffect.tscn")

func _ready() -> void:
	var wasBurning : bool = false
	for each in get_parent().get_children():
		if each is FireEffect:
			each.queue_free()
			wasBurning = true

	for each in get_parent().get_children():
		if each == self:
			continue

		if each is SlimedEffect:
			each.queue_free()

	if wasBurning:
		var parentCharacter : Character = get_parent() as Character
		assert(parentCharacter, "Effect added to non-character.")

		var ragingFireEffect : RagingFireEffect = ragingFireEffectPacked.instantiate()
		ragingFireEffect.position = parentCharacter.to_local(parentCharacter.getVisualCenterGlobalPosition())
		parentCharacter.add_child(ragingFireEffect)
		queue_free()
