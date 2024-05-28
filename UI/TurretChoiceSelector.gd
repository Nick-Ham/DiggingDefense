extends Control
class_name TurretChoiceSelector

var turretChoicePacked : PackedScene = preload("res://UI/TurretChoice.tscn")

@export_category("Local")
@export var gridContainer : GridContainer

var targetTile : Vector2i = Vector2i()

signal choose_cancelled
signal turret_selected(inTurretDataSelected : TurretData, inMapCoord : Vector2i)

func _ready() -> void:
	updateGrid()

func cancelChoose() -> void:
	choose_cancelled.emit()
	queue_free()

func _on_turret_choice_selected(inTurretDataSelected : TurretData) -> void:
	turret_selected.emit(inTurretDataSelected, targetTile)

func setTargetTile(inMapCoord : Vector2i) -> void:
	targetTile = inMapCoord

func updateGrid() -> void:
	for each in gridContainer.get_children():
		queue_free()

	for turretData in fetchTurretData().turrets:
		var newTurretChoice : TurretChoice = turretChoicePacked.instantiate() as TurretChoice
		gridContainer.add_child(newTurretChoice)
		newTurretChoice.setTurretData(turretData)

	for child in gridContainer.get_children():
		var turretChoice : TurretChoice = child as TurretChoice
		Util.safeConnect(turretChoice.choice_selected, _on_turret_choice_selected)

func fetchTurretData() -> TurretCollection:
	return GameInstance.getTurretCollection()

