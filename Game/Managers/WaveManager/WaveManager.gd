extends Node
class_name WaveManager

var nextWave : Wave = null

signal remaining_waves_updated(remainingWaves : int)
signal wave_completed
signal all_waves_completed

func _ready():
	assert(getWaves().size() > 0, "Wavemanager must manage at least 1 wave.")

	setupWaves()

func getWaves() -> Array[Wave]:
	var waves : Array[Wave] = []
	var children : Array[Node] = get_children()
	for child in children:
		var wave = child as Wave
		if wave and !wave.is_queued_for_deletion():
			waves.append(wave)
	return waves

func getRemainingWaves() -> Array[Wave]:
	var waves : Array[Wave] = []
	for wave in getWaves():
		if !wave.isWaveStarted:
			waves.append(wave)

	return waves

func setupWaves():
	for wave in getWaves():
		Util.safeConnect(wave.wave_completed, _on_wave_completed)

	setupNextWave()

func setupNextWave():
	var remainingWaves : Array[Wave] = getRemainingWaves()

	if remainingWaves.is_empty():
		return

	nextWave = remainingWaves[0]

func _on_wave_completed():
	wave_completed.emit()
	if getWaves().is_empty():
		all_waves_completed.emit()

func startWave():
	nextWave.startWave()
	remaining_waves_updated.emit(getRemainingWaves().size())
	setupNextWave()

