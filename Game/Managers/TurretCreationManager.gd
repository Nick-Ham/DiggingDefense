extends Node
class_name TurretCreationManager

class TileConditions:
	var isTurretPlaceable : bool = false
	var isExtracterPlaceable : bool = false
	var isBreakable : bool = false

	func isEditableTile() -> bool:
		return isTurretPlaceable || isBreakable || isExtracterPlaceable

@onready var mapAlterMenuPacked : PackedScene = preload("res://UI/MapAlterMenu.tscn")
@onready var turretChoiceSelectorPacked : PackedScene = preload("res://UI/TurretChoiceSelector.tscn")

var currentMapAlterMenu : MapAlterMenu = null
var currentTurretChoiceMenu : TurretChoiceSelector = null
var currentaDirectionalTurretPlacer : DirectionalTurretPlacementHelper = null

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("MouseClickRight"):
		if is_instance_valid(currentTurretChoiceMenu):
			currentTurretChoiceMenu.cancelChoose()
			currentTurretChoiceMenu = null
			return

		if is_instance_valid(currentaDirectionalTurretPlacer):
			currentaDirectionalTurretPlacer.cancelPlacement()
			currentaDirectionalTurretPlacer = null
			return

		summonMapAlterMenu()

	if event.is_action_pressed("MouseClickLeft"):
		if is_instance_valid(currentaDirectionalTurretPlacer):
			currentaDirectionalTurretPlacer.placeTurret()

func determineTileConditions(inMapPosition : Vector2i) -> TileConditions:
	var level : Level = get_tree().current_scene as Level
	var map : Map = level.getMap() as Map
	var walletManager : WalletManager = level.getWalletManager() as WalletManager

	var tileConditions : TileConditions = TileConditions.new()
	var tileType : Map.TILE_TYPE = map.getTileTypeAtPosition(inMapPosition) as Map.TILE_TYPE

	var tileHasTurret : bool = is_instance_valid(map.getTurretAtPosition(inMapPosition))

	var tileContainsOre : bool = map.isTileOre(inMapPosition)
	var tileHasExtracter : bool = is_instance_valid(map.getExtracterAtPosition(inMapPosition))
	var canAffordExtracter : bool = walletManager.canAffordCost(level.getLevelSettings().extracterCost)

	if tileType == Map.TILE_TYPE.WALL && !tileHasTurret && !tileHasExtracter:
		tileConditions.isTurretPlaceable = true

		if tileContainsOre && canAffordExtracter:
			tileConditions.isExtracterPlaceable = true

		tileConditions.isBreakable = true

	return tileConditions

func summonMapAlterMenu() -> void:
	var rootNode : Node2D = get_tree().current_scene as Node2D
	var mousePosition : Vector2 = rootNode.get_global_mouse_position()
	var level : Level = rootNode as Level
	var mapPosition : Vector2i = level.getMap().globalToTileCoordinate(mousePosition)

	if currentMapAlterMenu:
		var previousMapPosition : Vector2i = currentMapAlterMenu.getTargetMapTile()
		currentMapAlterMenu.queue_free()
		currentMapAlterMenu = null

		if mapPosition == previousMapPosition:
			return

	var tileConditions : TileConditions = determineTileConditions(mapPosition)
	if !tileConditions.isEditableTile():
		return

	var mapAlterMenuInstance : MapAlterMenu = mapAlterMenuPacked.instantiate() as MapAlterMenu
	mapAlterMenuInstance.global_position = mousePosition
	get_tree().current_scene.add_child(mapAlterMenuInstance)
	currentMapAlterMenu = mapAlterMenuInstance

	mapAlterMenuInstance.setTargetMapTile(mapPosition)
	mapAlterMenuInstance.setTileConditions(tileConditions)

	Util.safeConnect(mapAlterMenuInstance.open_turret_select, _on_open_turret_select)
	Util.safeConnect(mapAlterMenuInstance.create_extracter, _on_create_extracter)
	Util.safeConnect(mapAlterMenuInstance.break_wall, _on_break_wall)

func _on_create_extracter(inPosition : Vector2i) -> void:
	var level : Level = get_tree().current_scene as Level
	var map : Map = level.getMap()

	var spawnSuccess : bool = map.tryCreateExtracter(inPosition)
	if spawnSuccess:
		var walletManager : WalletManager = level.getWalletManager()
		walletManager.pay(level.getLevelSettings().extracterCost)

	if currentMapAlterMenu:
		currentMapAlterMenu.queue_free()
		currentMapAlterMenu = null

func _on_open_turret_select(inTargetTile : Vector2i) -> void:
	var lastMenuPosition : Vector2 = currentMapAlterMenu.global_position
	currentMapAlterMenu.queue_free()
	currentMapAlterMenu = null

	currentTurretChoiceMenu = turretChoiceSelectorPacked.instantiate() as TurretChoiceSelector
	currentTurretChoiceMenu.global_position = lastMenuPosition
	currentTurretChoiceMenu.setTargetTile(inTargetTile)
	get_tree().current_scene.add_child(currentTurretChoiceMenu)

	var _on_choose_cancelled_callable : Callable = func() -> void:
		currentTurretChoiceMenu = null
	currentTurretChoiceMenu.choose_cancelled.connect(_on_choose_cancelled_callable)

	Util.safeConnect(currentTurretChoiceMenu.turret_selected, _on_turret_selected)

func _on_turret_selected(inSelectedTurretData : TurretData, inTargetTile : Vector2i) -> void:
	if inSelectedTurretData.useDirectionalPlacement:
		createDirectionalTurret(inSelectedTurretData, inTargetTile)
	else:
		createTurret(inSelectedTurretData, inTargetTile)

	currentTurretChoiceMenu.queue_free()
	currentTurretChoiceMenu = null

func createDirectionalTurret(inSelectedTurretData : TurretData, inTargetTile : Vector2i) -> void:
	currentaDirectionalTurretPlacer = DirectionalTurretPlacementHelper.new()
	add_child(currentaDirectionalTurretPlacer)
	currentaDirectionalTurretPlacer.startPlacement(inSelectedTurretData, inTargetTile)

func createTurret(inSelectedTurretData : TurretData, inTargetTile : Vector2i) -> void:
	var level : Level = get_tree().current_scene as Level
	var map : Map = level.getMap()

	var spawnSuccess : bool = map.trySpawnTurret(inSelectedTurretData, inTargetTile)
	if spawnSuccess:
		var walletManager : WalletManager = level.getWalletManager()
		walletManager.pay(inSelectedTurretData.baseCost)
		var turret : Turret = map.getTurretAtPosition(inTargetTile) as Turret
		turret.initializeTurret()

func _on_break_wall(inMapCoord : Vector2i) -> void:
	var level : Level = get_tree().current_scene as Level
	var map : Map = level.getMap() as Map

	map.tryBreakTileAtPosition(inMapCoord)

	if currentMapAlterMenu:
		currentMapAlterMenu.queue_free()
		currentMapAlterMenu = null
