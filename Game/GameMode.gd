extends Node
class_name GameMode

@export var level : Level
@export var sceneSpawner : SceneSpawner
@export var resetUI : Reset
@export var waveStartUI : WaveStart

signal level_loaded
signal level_ended

func _init():
	Game.setGameMode(self)

func _ready():
	bindSignals()
	emit_signal("level_loaded")

func _enter_tree():
	bindSignals()

func getLevel():
	return level

func bindSignals():
	if level.last_hq_destroyed.is_connected(_on_level_last_hq_destroyed):
		level.last_hq_destroyed.disconnect(_on_level_last_hq_destroyed)
	level.last_hq_destroyed.connect(_on_level_last_hq_destroyed)

	if resetUI.ui_reset_level.is_connected(_on_ui_reset_level):
		resetUI.ui_reset_level.disconnect(_on_ui_reset_level)
	resetUI.ui_reset_level.connect(_on_ui_reset_level)

	if waveStartUI.ui_wave_start.is_connected(_on_try_wave_start):
		waveStartUI.ui_wave_start.disconnect(_on_try_wave_start)
	waveStartUI.ui_wave_start.connect(_on_try_wave_start)

	if SignalBus.wave_manager_state_changed.is_connected(_on_wave_manager_state_changed):
		SignalBus.wave_manager_state_changed.disconnect(_on_wave_manager_state_changed)
	SignalBus.wave_manager_state_changed.connect(_on_wave_manager_state_changed)

func _on_try_wave_start():
	SignalBus.emit_signal("start_wave")

func _on_wave_manager_state_changed(waveManager : WaveManager, newWaveState : WaveManager.WAVE_STATE):
	if !newWaveState == WaveManager.WAVE_STATE.AWAITING_START:
		waveStartUI.deactivateWaveStartScreen()
		return

	waveStartUI.activateWaveStartScreen()

func _on_level_last_hq_destroyed():
	resetUI.activateResetScreen()

	get_tree().paused = true

func _on_ui_reset_level():
	resetUI.deactivateResetScreen()

	level.queue_free()
	remove_child(level)

	level = sceneSpawner.instanceScene(self, Vector2())
	bindSignals()

	get_tree().paused = false

