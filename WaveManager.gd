extends Node
class_name WaveManager

@export var spawner : Spawner
@export var waves : Array[WaveResource]

enum WAVE_STATE {
	PREPARING,
	AWAITING_START,
	IN_PROGRESS,
	WAVES_COMPLETE
}

var waveState : WAVE_STATE = WAVE_STATE.PREPARING

var WAVE_DURATION : float = .5
var waveTimer : Timer
var currentWave : WaveResource
var completedWaves : int = 0
var currentSpawnCount : int = 0

func _ready():
	validateWaves()
	setupNextWave()
	bindSignals()

func bindSignals():
	if SignalBus.start_wave.is_connected(_on_start_wave):
		SignalBus.start_wave.disconnect(_on_start_wave)
	SignalBus.start_wave.connect(_on_start_wave)

func _on_start_wave():
	startWave()

func setupNextWave():
	currentWave = waves[completedWaves]
	setupWaveTimer()
	waveState = WAVE_STATE.AWAITING_START
	SignalBus.emit_signal("wave_manager_state_changed", self, waveState)

func startWave():
	waveTimer.start()
	waveState = WAVE_STATE.IN_PROGRESS
	SignalBus.emit_signal("wave_manager_state_changed", self, waveState)

func setupWaveTimer():
	if !waveTimer:
		waveTimer = Timer.new()
		waveTimer.timeout.connect(_on_wave_timer_timeout)
		add_child(waveTimer)

	waveTimer.wait_time = WAVE_DURATION as float / currentWave.count as float

func _on_wave_timer_timeout():
	if waveState != WAVE_STATE.IN_PROGRESS:
		return

	var spawnSuccessful = spawner.trySpawn(currentWave.scene)
	if !spawnSuccessful:
		waveTimer.start()
		return

	currentSpawnCount += 1

	if currentWave.count > currentSpawnCount:
		waveTimer.start()
		return

	endWave()

func endWave():
	currentSpawnCount = 0
	completedWaves += 1

	if waves.size() > completedWaves:
		setupNextWave()
		return

	waveState = WAVE_STATE.WAVES_COMPLETE
	SignalBus.emit_signal("wave_manager_state_changed", self, waveState)

func validateWaves():
	for wave in waves:
		if !wave.getCount() > 0:
			print_debug("WaveResource must have a count > 0")
		if !wave.getScene():
			print_debug("WaveResource must have a scene")
