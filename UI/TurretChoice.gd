extends MarginContainer
class_name TurretChoice

@export_category("Local")
@export var button : Button
@export var textureRect : TextureRect
@export var turretCost : Label

signal choice_selected(turretDataSelected : TurretData)

var turretData : TurretData = null

func _ready() -> void:
	assert(button)
	assert(textureRect)
	assert(turretCost)

	Util.safeConnect(button.pressed, _on_choice_selected)

func update() -> void:
	if !turretData:
		return

	textureRect.texture = turretData.texture
	turretCost.text = str(turretData.baseCost)
	button.disabled = !canAffordTurret()

func canAffordTurret() -> bool:
	var level : Level = get_tree().current_scene as Level
	var walletManager : WalletManager = level.getWalletManager()

	return walletManager.canAffordCost(turretData.baseCost)

func setTurretData(inTurretData : TurretData) -> void:
	turretData = inTurretData
	update()

func _on_choice_selected() -> void:
	choice_selected.emit(turretData)
