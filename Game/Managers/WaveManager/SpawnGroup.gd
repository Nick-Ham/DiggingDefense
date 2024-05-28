extends Node
class_name SpawnGroup

@export var spawner : Spawner
@export var scene : PackedScene
@export_range(1, 2, 1, "or_greater") var count : int = 1
@export_range(.05, 5, .01, "or_greater") var spawnInterval : float = .1

var spawnTimer : Timer
var amountSpawned : int = 0
var spawningComplete : bool = false
var lastCreepDestroyed : bool = false

var spawnedCharacters : Array[Character]

signal spawning_completed
signal last_creep_destroyed

func getLastCreepDestroyed() -> bool:
	return lastCreepDestroyed

func getSpawningComplete() -> bool:
	return spawningComplete

func startSpawning():
	assert(count > 0, "Must spawn a group > 0")

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

	var newCreep : Character = spawner.trySpawn(scene) as Character
	var spawnSuccessful : bool = is_instance_valid(newCreep)

	if !spawnSuccessful:
		spawnTimer.start()
		return

	spawnedCharacters.push_back(newCreep)
	Util.safeConnect(newCreep.character_destroyed, _on_character_destroyed)

	amountSpawned += 1

	if amountSpawned < count:
		spawnTimer.start()
		return

	spawningComplete = true
	spawning_completed.emit()

func _on_character_destroyed(inCharacter : Character) -> void:
	spawnedCharacters.erase(inCharacter)
	if spawnedCharacters.is_empty():
		lastCreepDestroyed = true
		last_creep_destroyed.emit()
