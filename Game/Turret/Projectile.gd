extends CharacterBody2D
class_name Projectile

@export var speed : int = 1
@export var sprite : Sprite2D
@export var effectSpawner : SceneSpawner

var facing : Turret.DIRECTION = Turret.DIRECTION.RIGHT

var movementDirection = {
	Turret.DIRECTION.RIGHT : Vector2(1, 0),
	Turret.DIRECTION.LEFT : Vector2(-1, 0),
	Turret.DIRECTION.UP : Vector2(0, -1),
	Turret.DIRECTION.DOWN : Vector2(0, 1)
}

func _physics_process(delta):
	velocity = movementDirection[facing] * speed * delta
	var collision = move_and_collide(velocity)
	if collision:
		queue_free()

func setFacing(newFacing : Turret.DIRECTION):
	facing = newFacing
	updateDirection()

func updateDirection():
	if facing == Turret.DIRECTION.LEFT:
		rotation_degrees = 180
	elif facing == Turret.DIRECTION.RIGHT:
		rotation_degrees = 0
	elif facing == Turret.DIRECTION.UP:
		rotation_degrees = -90
	elif facing == Turret.DIRECTION.DOWN:
		rotation_degrees = 90


func _on_character_hit_box_body_entered(body):
	var character = body as Character
	if !character:
		return
	
	if character.characterType != Character.CHARACTER_TYPE.ENEMY:
		return
	
	var characterHealth : HealthBar
	for child in character.get_children():
		var healthBar = child as HealthBar
		if healthBar:
			characterHealth = healthBar
	
	if !characterHealth:
		return
	
	var newEffect : Effect = effectSpawner.instanceScene(body, Vector2())
	newEffect.setupEffect(characterHealth)
	
