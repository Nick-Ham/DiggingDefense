extends Node
class_name WaveManager

enum WAVE_STATE {
	PREPARING,
	AWAITING_START,
	IN_PROGRESS,
	WAVES_COMPLETE
}

var waveState : WAVE_STATE = WAVE_STATE.PREPARING
var currentWave : Wave
var completedWaves : int = 0

func _ready():
	bindSignals()
	setupWaves()

func getWaves() -> Array[Wave]:
	var waves : Array[Wave] = []
	for child in get_children():
		var wave = child as Wave
		if wave:
			waves.append(wave)
	return waves

func setupWaves():
	var waves = getWaves()
	if waves.size() <= 0:
		endWaves()
	
	setupNextWave()

func setupNextWave():
	var waves = getWaves()
	
	if !waves.size() > completedWaves:
		endWaves()
		return
	
	currentWave = waves[completedWaves]
	waveState = WAVE_STATE.AWAITING_START
	SignalBus.emit_signal("wave_manager_state_changed", self, waveState)

func bindSignals():
	if SignalBus.start_wave.is_connected(_on_start_wave):
		SignalBus.start_wave.disconnect(_on_start_wave)
	SignalBus.start_wave.connect(_on_start_wave)
	
	if SignalBus.wave_completed.is_connected(_on_wave_completed):
		SignalBus.wave_completed.disconnect(_on_wave_completed)
	SignalBus.wave_completed.connect(_on_wave_completed)

func _on_wave_completed():
	waveState = WAVE_STATE.PREPARING
	SignalBus.emit_signal("wave_manager_state_changed", self, waveState)
	
	completedWaves += 1
	setupNextWave()

func _on_start_wave():
	waveState = WAVE_STATE.IN_PROGRESS
	SignalBus.emit_signal("wave_manager_state_changed", self, waveState)
	currentWave.startWave()

func endWaves():
	waveState = WAVE_STATE.WAVES_COMPLETE
	SignalBus.emit_signal("wave_manager_state_changed", self, waveState)

