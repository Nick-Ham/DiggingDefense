extends CharacterBody2D
class_name Character

enum CHARACTER_TYPE {ENEMY, PLAYER}

@export_category("GameplayConfig")
@export var characterType : CHARACTER_TYPE

@export_category("SpriteConfig")
@export var idleAnimationName : String = "idle"
@export var movingAnimationName : String = "moving"
@export var MAX_LEAN_DEGREES : float = 15

@export_category("MovementConfig")
@export var ACCELERATION : float = 1400 # lower makes changing directions feel bad
@export var MAX_SPEED : float = 150
@export var MIN_SPEED : float = 5
@export var FRICTION : float = .92

@export_category("Local")
@export var sprite : AnimatedSprite2D
@export var visualCenterMarker : Marker2D

var direction = Vector2()
var nudgeToApply = Vector2()
var controller : Controller = null
var lastKnownDirection = Vector2()
var facingLeft = false

signal character_destroyed(character : Character)

func _ready() -> void:
	assert(sprite)
	assert(visualCenterMarker)

func _process(_delta):
	updateSprite()

func _physics_process(delta):
	updateVelocity(delta)

func updateVelocity(delta):
	velocity += direction * ACCELERATION * delta
	velocity = velocity.limit_length(MAX_SPEED)

	velocity += nudgeToApply * delta
	nudgeToApply = Vector2()
	move_and_slide()

	if velocity.length_squared() > MIN_SPEED:
		if direction.x == 0:
			velocity.x *= FRICTION
		if direction.y == 0:
			velocity.y *= FRICTION
	else:
		velocity = Vector2()

	direction = Vector2()

func updateSprite():
	if lastKnownDirection != Vector2():
		sprite.animation = movingAnimationName
		sprite.play()
	else:
		sprite.animation = idleAnimationName
		sprite.rotation_degrees = 0

	var leanDirection = 1
	if facingLeft:
		leanDirection = -1
	sprite.rotation_degrees = MAX_LEAN_DEGREES * (velocity.length() / MAX_SPEED) * leanDirection
	sprite.flip_h = facingLeft

func isMoving():
	if direction == Vector2() && velocity.length_squared() < MIN_SPEED:
		return false
	return true

func bindController(inController):
	if controller:
		controller.inputDirectionChanged.disconnect(_on_input_direction_changed)

	controller = inController
	controller.inputDirectionChanged.connect(_on_input_direction_changed)

func _on_input_direction_changed(newInputDirection):
	if !canMove():
		return

	direction = newInputDirection
	lastKnownDirection = newInputDirection

	if newInputDirection.x != 0:
		facingLeft = newInputDirection.x < 0

func _on_action_pressed(action):
	pass

func canMove():
	return true

func nudge(inVelocity : Vector2):
	nudgeToApply += inVelocity

func getVisualCenterGlobalPosition() -> Vector2:
	return visualCenterMarker.global_position

func kill() -> void:
	character_destroyed.emit(self as Character)
	queue_free()
