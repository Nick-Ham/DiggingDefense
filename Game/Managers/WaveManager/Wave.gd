extends Node
class_name Wave

signal wave_spawning_completed
signal wave_completed

var isWaveStarted : bool = false
var isWaveCompleted : bool = false

func _ready():
	bindSignals()

func bindSignals():
	for group in getSpawnGroups():
		Util.safeConnect(group.spawning_completed, _on_spawning_completed)
		Util.safeConnect(group.last_creep_destroyed, _on_last_creep_destroyed)

func startWave() -> void:
	for spawnGroup in getSpawnGroups():
		spawnGroup.startSpawning()

	isWaveStarted = true

func _on_spawning_completed() -> void:
	for spawnGroup in getSpawnGroups():
		if !spawnGroup.getSpawningComplete():
			return

	wave_spawning_completed.emit()

func _on_last_creep_destroyed() -> void:
	for spawnGroup in getSpawnGroups():
		if !spawnGroup.getLastCreepDestroyed():
			return

	isWaveCompleted = true
	queue_free()
	wave_completed.emit()

func getSpawnGroups() -> Array[SpawnGroup]:
	var spawnGroups : Array[SpawnGroup] = []
	for child in get_children():
		spawnGroups.append(child)

	return spawnGroups

