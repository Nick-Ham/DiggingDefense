extends Node2D
class_name DirectionalTurretPlacementHelper

var placementStarted : bool = false
var turretGlobalPosition : Vector2 = Vector2()
var turretMapPosition : Vector2i = Vector2i()
var turretData : TurretData = null
var sprite : Sprite2D = null

var lastRotation : float = 0.0

func startPlacement(inTurretData : TurretData, inMapCoord : Vector2i) -> void:
	var level : Level = get_tree().current_scene as Level
	var map : Map = level.getMap() as Map

	placementStarted = true
	turretData = inTurretData
	turretMapPosition = inMapCoord
	turretGlobalPosition = map.to_global(map.map_to_local(inMapCoord))

	global_position = turretGlobalPosition
	sprite = Sprite2D.new()
	add_child(sprite)
	sprite.texture = turretData.texture
	var newShaderMaterial = ShaderMaterial.new()
	newShaderMaterial.shader = preload("res://Shader/Hologram.tres")
	sprite.material = newShaderMaterial

func _process(delta: float) -> void:
	if !placementStarted:
		return

	lastRotation = round(get_angle_to(get_global_mouse_position()) / (PI/2.0)) * PI/2.0
	sprite.rotation = lastRotation

func placeTurret() -> void:
	var level : Level = get_tree().current_scene as Level
	var map : Map = level.getMap() as Map

	var spawnSuccess : bool = map.trySpawnTurret(turretData, turretMapPosition)
	if spawnSuccess:
		var walletManager : WalletManager = level.getWalletManager() as WalletManager
		walletManager.pay(turretData.baseCost)

	var spawnedTurret : Turret = map.getTurretAtPosition(turretMapPosition) as Turret
	spawnedTurret.rotation = lastRotation
	spawnedTurret.initializeTurret()

	queue_free()

func cancelPlacement() -> void:
	queue_free()
