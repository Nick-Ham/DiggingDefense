extends Effect
class_name RagingFireEffect

@export var damage : Damage
@export var fireTick : Timer

func _ready():
	fireTick.timeout.connect(_on_timer_timeout)

func setupEffect():
	super()
	damage.dealDamage(get_parent())
	clearOtherFire(get_parent())

func _on_timer_timeout():
	damage.dealDamage(get_parent())

func clearOtherFire(target : Node):
	for each in target.get_children():
		if each == self:
			continue
		if each is RagingFireEffect:
			each.queue_free()
