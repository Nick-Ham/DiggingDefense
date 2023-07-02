extends Effect

@export var damage : Damage
@export var fireTick : Timer

func _ready():
	fireTick.timeout.connect(_on_timer_timeout)

func setupEffect(newTargetHealth : HealthBar):
	super(newTargetHealth)
	damage.dealDamage(targetHealth.owner)

func _on_timer_timeout():
	damage.dealDamage(targetHealth.owner)
