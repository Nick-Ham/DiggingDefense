extends Turret
class_name StaticTurret

@export_category("Config")
@export var maxCharge : float = 0.5
@export var chargeSpeed : float = 1.0

@export_category("Local")
@export var sprite : Sprite2D
@export var turretLaserStart : Marker2D
@export var attackLine : Line2D
@export var reloadTimer : Timer

var chainLightningEffectPacked : PackedScene = preload("res://Game/Effects/ChainLightningEffect.tscn")

var charge : float = 0.0
var trackedTargets : Array[EnemyCharacter]

func _ready() -> void:
	assert(sprite)
	assert(turretLaserStart)
	assert(attackLine)
	assert(reloadTimer)

	Util.safeConnect(body_entered, _on_body_entered)
	Util.safeConnect(body_exited, _on_body_exited)

func _on_body_entered(inBody : Node2D) -> void:
	var enemyCharacter : EnemyCharacter = inBody as EnemyCharacter
	if !enemyCharacter:
		return

	if enemyCharacter in trackedTargets:
		return

	trackedTargets.append(enemyCharacter)
	Util.safeConnect(enemyCharacter.character_destroyed, _on_character_destroyed)
	attackLine.visible = true

func _on_character_destroyed(inCharacter : Character) -> void:
	trackedTargets.erase(inCharacter)

func _on_body_exited(inBody : Node2D) -> void:
	trackedTargets.erase(inBody)

func _process(delta: float) -> void:
	if trackedTargets.is_empty():
		charge = clampf(charge - chargeSpeed * delta, 0.0, maxCharge)
		attackLine.visible = false
		return

	attackLine.visible = true
	attackLine.clear_points()
	attackLine.add_point(turretLaserStart.position)
	attackLine.add_point(to_local(trackedTargets[0].getVisualCenterGlobalPosition()))

	charge = clampf(charge + chargeSpeed * delta, 0.0, maxCharge)

	if is_equal_approx(charge, maxCharge) and reloadTimer.is_stopped():
		reloadTimer.start()
		var newChainLightningEffectInstance : ChainLightningEffect = chainLightningEffectPacked.instantiate() as ChainLightningEffect
		get_tree().current_scene.add_child(newChainLightningEffectInstance)
		newChainLightningEffectInstance.global_position = trackedTargets[0].global_position
		newChainLightningEffectInstance.setInitialTarget(trackedTargets[0])

