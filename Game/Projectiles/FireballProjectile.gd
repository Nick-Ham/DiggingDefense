extends CharacterBody2D
class_name FireballProjectile

@export_category("Config")
@export var projectileSpeed : float = 3.0

@export_category("Local")
@export var enemyDetector : Area2D

var fireEffectPacked : PackedScene = preload("res://Game/Effects/FireEffect.tscn")

func _ready() -> void:
	Util.safeConnect(enemyDetector.body_entered, _on_body_entered)

func _physics_process(delta: float) -> void:
	var forwardVector : Vector2 = Vector2.RIGHT.rotated(global_rotation)

	var collision : KinematicCollision2D = move_and_collide(forwardVector * projectileSpeed) as KinematicCollision2D
	if collision:
		queue_free()

func _on_body_entered(inBody : PhysicsBody2D) -> void:
	var bodyAsCharacter : Character = inBody as Character
	if !bodyAsCharacter.characterType == Character.CHARACTER_TYPE.ENEMY:
		return

	var newFireEffectInstance : FireEffect = fireEffectPacked.instantiate()
	newFireEffectInstance.position = bodyAsCharacter.to_local(bodyAsCharacter.getVisualCenterGlobalPosition())
	bodyAsCharacter.add_child(newFireEffectInstance)
