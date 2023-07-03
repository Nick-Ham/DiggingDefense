extends Node
class_name Wave

func _ready():
	bindSignals()

func bindSignals():
	if SignalBus.spawn_group_spawning_completed.is_connected(_on_spawn_group_spawning_completed):
		SignalBus.spawn_group_spawning_completed.disconnect(_on_spawn_group_spawning_completed)
	SignalBus.spawn_group_spawning_completed.connect(_on_spawn_group_spawning_completed)

func startWave():
	for spawnGroup in getSpawnGroups():
		spawnGroup.startSpawning()

func _on_spawn_group_spawning_completed():
	for spawnGroup in getSpawnGroups():
		if !spawnGroup.getSpawningComplete():
			return
	
	SignalBus.emit_signal("wave_completed")

func getSpawnGroups() -> Array[SpawnGroup]:
	var spawnGroups : Array[SpawnGroup] = []
	for child in get_children():
		spawnGroups.append(child)

	return spawnGroups

