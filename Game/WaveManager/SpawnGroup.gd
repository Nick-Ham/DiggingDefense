extends Node
class_name SpawnGroup

@export var spawner : Spawner
@export var scene : PackedScene
@export_range(1, 2, 1, "or_greater") var count : int = 1
@export_range(.1, 5, .01, "or_greater") var spawnInterval : float = .1

var spawnTimer : Timer
var amountSpawned : int = 0
var spawningComplete : bool = false

func getSpawningComplete() -> bool:
	return spawningComplete

func startSpawning():
	if count <= 0:
		print_debug("Attempted to spawn a group of 0.")
		return
	
	if !spawnTimer:
		spawnTimer = Timer.new()
		spawnTimer.one_shot = true
		add_child(spawnTimer)
		spawnTimer.timeout.connect(_on_spawn_timer_timeout)
	
	spawnTimer.wait_time = spawnInterval
	spawnTimer.start()

func _on_spawn_timer_timeout():
	if spawningComplete:
		return
	
	var spawnSuccessful = spawner.trySpawn(scene)
	
	if !spawnSuccessful:
		spawnTimer.start()
		return
	
	amountSpawned += 1
	
	if amountSpawned < count:
		spawnTimer.start()
		return
	
	spawningComplete = true
	SignalBus.emit_signal("spawn_group_spawning_completed")

