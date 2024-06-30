extends EnvironmentalEffect
class_name SlimeEnvironmentalEffect

var slimedEffectPacked : PackedScene = preload("res://Game/Effects/SlimedEffect.tscn")

func applyEffect(body):
	var character = body as Character
	if !character:
		return

	if character.characterType != Character.CHARACTER_TYPE.ENEMY:
		return

	var characterHealth : Health
	for child in character.get_children():
		var healthBar = child as Health
		if healthBar:
			characterHealth = healthBar

	if !characterHealth:
		return

	var slimedEffectInstance : SlimedEffect = slimedEffectPacked.instantiate()
	slimedEffectInstance.position = character.to_local(character.getVisualCenterGlobalPosition())
	character.add_child(slimedEffectInstance)
