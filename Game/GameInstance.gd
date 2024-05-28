extends Node

var baseGameTurretCollection : TurretCollection = preload("res://Resources/BaseGameTurretCollection.tres")
var mainMenuPacked : PackedScene = preload("res://UI/MainMenu.tscn")
var levelLostMenuPacked : PackedScene = preload("res://UI/LevelLostMenu.tscn")
var levelWonMenuPacked : PackedScene = preload("res://UI/LevelWonMenu.tscn")
var firstLevelPacked : PackedScene = preload("res://Levels/TestLevels/TestLevel2.tscn")

var mainMenu : MainMenu = null
var currentLevelPackedScene : PackedScene = null

func _ready() -> void:
	#Engine.time_scale = 5.0
	return

func registerMainMenu(inMenu : MainMenu) -> void:
	mainMenu = inMenu

	Util.safeConnect(mainMenu.start_game, _on_start_game)

func registerLevel(inLevel : Level) -> void:
	Util.safeConnect(inLevel.level_lost, _on_level_lost)
	Util.safeConnect(inLevel.level_won, _on_level_won)

func _on_level_lost() -> void:
	get_tree().paused = true
	var levelLostMenuInstance : LevelLostMenu = levelLostMenuPacked.instantiate()
	get_tree().current_scene.add_child(levelLostMenuInstance)
	bindToLevelLostMenu(levelLostMenuInstance)

func _on_level_won() -> void:
	get_tree().paused = true
	var levelWonMenuInstance : LevelWonMenu = levelWonMenuPacked.instantiate()
	get_tree().current_scene.add_child(levelWonMenuInstance)
	bindToLevelWonMenu(levelWonMenuInstance)

func bindToLevelWonMenu(inLevelWonMenu : LevelWonMenu) -> void:
	Util.safeConnect(inLevelWonMenu.next_level, _on_next_level)
	Util.safeConnect(inLevelWonMenu.quit_level, _on_quit_level)

func _on_next_level() -> void:
	_on_restart_level()

func bindToLevelLostMenu(inLevelLostMenu : LevelLostMenu) -> void:
	Util.safeConnect(inLevelLostMenu.restart_level, _on_restart_level)
	Util.safeConnect(inLevelLostMenu.quit_level, _on_quit_level)

func _on_quit_level() -> void:
	get_tree().quit()

func _on_restart_level() -> void:
	setupLevel(currentLevelPackedScene)
	get_tree().paused = false

func _on_start_game() -> void:
	setupLevel(firstLevelPacked)

func setupLevel(inLevelPacked : PackedScene) -> void:
	get_tree().change_scene_to_file(inLevelPacked.resource_path)
	currentLevelPackedScene = inLevelPacked

func getTurretCollection() -> TurretCollection:
	return baseGameTurretCollection
