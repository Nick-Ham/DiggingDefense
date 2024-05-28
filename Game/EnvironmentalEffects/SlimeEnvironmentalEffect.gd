extends EnvironmentalEffect
class_name SlimeEnvironmentalEffect

@export_category("Local")
@export var effectSpawner : SceneSpawner

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

	var newEffect : Effect = effectSpawner.instanceScene(body, Vector2())
	newEffect.setupEffect()
