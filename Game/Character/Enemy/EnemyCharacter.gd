extends Character
class_name EnemyCharacter

@export_category("Local")
@export var damage : Damage
@export var health : Health

@onready var originalMAX_SPEED = MAX_SPEED
@onready var timeScalar = randf_range(.2,4)

func _ready():
	sprite.speed_scale = randf_range(.3, 2)
	Util.safeConnect(health.health_depleted, _on_health_depleted)

func _on_health_depleted() -> void:
	kill()

func _physics_process(delta):
	var time = timeScalar * Time.get_ticks_msec()/1000.0
	MAX_SPEED = originalMAX_SPEED * (cos(time) * .25 + .75)
	super(delta)

func _on_avoidance_velocity_to_add(newVelocity : Vector2):
	nudge(newVelocity)
