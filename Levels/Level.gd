extends Node2D
class_name Level

var pauseMenuPacked : PackedScene = preload("res://UI/PauseMenu.tscn")
var inGameGuiPacked : PackedScene = preload("res://UI/GameGui.tscn")

@export_category("Config")
@export var levelSettings : LevelSettings

@export_category("Local")
@export var spawners : Array[Spawner]
@export var hqs : Array[HQ]
@export var map : Map
@export var waveManager : WaveManager

signal level_won
signal level_lost

var livingHQs : Array[HQ]
var gameGui : GameGui = null
var pauseMenu : PauseMenu = null

var turretCreationManager : TurretCreationManager = null
var walletManager : WalletManager = null
var trackedWaveManager : WaveManager = null

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Escape"):
		if !pauseMenu:
			pauseMenu = pauseMenuPacked.instantiate() as PauseMenu
			add_child(pauseMenu)

func getLevelSettings() -> LevelSettings:
	return levelSettings

func _ready():
	assert(levelSettings)
	assert(spawners.size() > 0)
	assert(hqs.size() > 0)
	assert(map)
	assert(waveManager)

	livingHQs = hqs.duplicate(true)
	bindToHq()
	GameInstance.registerLevel(self)

	turretCreationManager = TurretCreationManager.new()
	add_child(turretCreationManager)

	walletManager = WalletManager.new()
	add_child(walletManager)

	setupGameGui()

	Util.safeConnect(waveManager.wave_completed, _on_wave_completed)
	Util.safeConnect(waveManager.all_waves_completed, _on_all_waves_completed)

func getWalletManager() -> WalletManager:
	return walletManager

func getMap() -> Map:
	return map

func bindToHq() -> void:
	for each in livingHQs:
		Util.safeConnect(each.hq_destroyed, _on_hq_destroyed)

func _on_hq_destroyed() -> void:
	for hq in getHQs():
		if hq and hq.isHqDestroyed:
			livingHQs.erase(hq)

	if livingHQs.is_empty():
		level_lost.emit()

func setupGameGui() -> void:
	gameGui = inGameGuiPacked.instantiate() as GameGui
	add_child(gameGui)
	bindToGui(gameGui)
	gameGui.injectWaveManager(waveManager)
	gameGui.injectWalletManager(walletManager)

func bindToGui(inGameGui : GameGui) -> void:
	Util.safeConnect(inGameGui.start_wave, _on_start_wave)

func _on_start_wave() -> void:
	waveManager.startWave()

func getHQs() -> Array[HQ]:
	return hqs

func _on_wave_completed() -> void:
	walletManager.completeWaveIncome()

func _on_all_waves_completed() -> void:
	level_won.emit()
