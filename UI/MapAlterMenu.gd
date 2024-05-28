extends Control
class_name MapAlterMenu

@export_category("Local")
@export var createTurretButton : Button
@export var createExtractorButton : Button
@export var breakWallButton : Button

signal open_turret_select(inTargetTile : Vector2i)
signal create_extracter(inTargetTile : Vector2i)
signal break_wall(inTargetTile : Vector2i)

var targetMapTile : Vector2i
var tileConditions : TurretCreationManager.TileConditions = null

func _ready() -> void:
	assert(createTurretButton)
	assert(createExtractorButton)
	assert(breakWallButton)

	Util.safeConnect(createTurretButton.pressed, _on_create_turret_button_pressed)
	Util.safeConnect(createExtractorButton.pressed, _on_create_extracter_button_pressed)
	Util.safeConnect(breakWallButton.pressed, _on_break_wall_button_pressed)

func _on_create_extracter_button_pressed() -> void:
	create_extracter.emit(targetMapTile)

func setTargetMapTile(inCoord : Vector2i) -> void:
	targetMapTile = inCoord

func getTargetMapTile() -> Vector2i:
	return targetMapTile

func setTileConditions(inTileConditions : TurretCreationManager.TileConditions) -> void:
	tileConditions = inTileConditions
	refreshView()

func refreshView() -> void:
	if !tileConditions:
		createTurretButton.disabled = true
		createExtractorButton.disabled = true
		breakWallButton.disabled = true
		return

	createTurretButton.disabled = !tileConditions.isTurretPlaceable
	createExtractorButton.disabled = !tileConditions.isExtracterPlaceable
	breakWallButton.disabled = !tileConditions.isBreakable

func _on_create_turret_button_pressed() -> void:
	open_turret_select.emit(targetMapTile)

func _on_break_wall_button_pressed() -> void:
	break_wall.emit(targetMapTile)
