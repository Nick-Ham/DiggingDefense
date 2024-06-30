extends Turret
class_name FireballTurret

@export_category("Config")
@export var detectionWidth : float = 40.0

@export_category("Local")
@export var enemyDetector : Area2D
@export var reloadTimer : Timer
@export var rangeDetectorRayCast : RayCast2D
@export var collisionShape : CollisionShape2D

var fireballProjectilePacked : PackedScene = preload("res://Game/Projectiles/FireballProjectile.tscn")

var trackedCharacters : Array[Character]

func _ready() -> void:
	assert(enemyDetector)
	assert(reloadTimer)
	assert(rangeDetectorRayCast)
	assert(collisionShape)

	var map : Map = get_parent() as Map
	Util.safeConnect(map.map_updated, _on_map_updated)

	var physicsSettleDelay : SceneTreeTimer = get_tree().create_timer(0.05)
	Util.safeConnect(physicsSettleDelay.timeout, updateRangeCollider)
	Util.safeConnect(reloadTimer.timeout, _on_reload_timer_timeout)
	Util.safeConnect(enemyDetector.body_entered, _on_enemy_detector_body_entered)
	Util.safeConnect(enemyDetector.body_exited, _on_enemy_detector_body_exited)

func _on_enemy_detector_body_entered(inBody : PhysicsBody2D) -> void:
	var character : Character = inBody as Character
	if !character:
		return

	if character in trackedCharacters:
		return

	trackedCharacters.append(character)
	Util.safeConnect(character.character_destroyed, _on_tracked_character_destroyed)
	call_deferred("tryFire")

func _on_enemy_detector_body_exited(inBody : PhysicsBody2D) -> void:
	var character : Character = inBody as Character
	if !character:
		return

	trackedCharacters.erase(character)

func _on_tracked_character_destroyed(inCharacter : Character) -> void:
	trackedCharacters.erase(inCharacter)

func _on_reload_timer_timeout() -> void:
	tryFire()

func tryFire() -> void:
	if !reloadTimer.is_stopped() || trackedCharacters.is_empty():
		return

	var level : Level = get_tree().current_scene as Level

	var fireballProjectileInstance : FireballProjectile = fireballProjectilePacked.instantiate() as FireballProjectile
	fireballProjectileInstance.global_position = rangeDetectorRayCast.global_position
	fireballProjectileInstance.global_rotation = global_rotation
	level.add_child(fireballProjectileInstance)
	reloadTimer.start()

func _on_map_updated() -> void:
	var physicsSettleDelay : SceneTreeTimer = get_tree().create_timer(0.05)
	Util.safeConnect(physicsSettleDelay.timeout, updateRangeCollider)

func updateRangeCollider() -> void:
	if rangeDetectorRayCast.is_colliding():
		var distanceToCollision : float = rangeDetectorRayCast.get_collision_point().distance_to(global_position)
		collisionShape.shape.extents = Vector2(distanceToCollision / 2.0, detectionWidth / 2.0)
		enemyDetector.position = Vector2(distanceToCollision / 2.0, 0.0)
