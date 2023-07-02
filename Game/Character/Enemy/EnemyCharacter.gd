extends Character
class_name EnemyCharacter

var hasReachedTarget = false

@export var damage : Damage

@onready var originalMAX_SPEED = MAX_SPEED
@onready var timeScalar = randf_range(.2,4)

func _ready():
	sprite.speed_scale = randf_range(.3, 2)
	bindSignals()

func bindSignals():
	pass

func canMove():
	return !hasReachedTarget

func _on_reached_target(target : Node2D):
	hasReachedTarget = true

func _physics_process(delta):
	var time = timeScalar * Time.get_ticks_msec()/1000.0
	MAX_SPEED = originalMAX_SPEED * (cos(time) * .25 + .75)
	super(delta)

func _on_avoidance_velocity_to_add(newVelocity : Vector2):
	nudge(newVelocity)

func attack(target : Node2D):
	pass
