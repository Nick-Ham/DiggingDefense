extends Effect
class_name FireEffect

@export var damage : Damage
@export var fireTick : Timer
@export var ragingFireEffectSpawner : SceneSpawner

func _ready():
	fireTick.timeout.connect(_on_timer_timeout)

func setupEffect():
	super()
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
		var ragingFireEffect : RagingFireEffect = ragingFireEffectSpawner.instanceScene(get_parent(), Vector2.ZERO)
		ragingFireEffect.setupEffect()
		queue_free()

func _on_timer_timeout():
	damage.dealDamage(get_parent())
