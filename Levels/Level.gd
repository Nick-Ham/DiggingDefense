extends Node2D
class_name Level

@export var map : Map
@export var waveManager : WaveManager

var spawners : Array[Spawner] = []
var livingHQs : Array[HQ] = []
var hq : HQ

signal last_hq_destroyed

func _ready():
	findSpawners()
	findHQ()
	bindSignals()

func findHQ():
	for each in get_children():
		if each is HQ:
			hq = each
			livingHQs.append(hq)

func findSpawners():
	for each in get_children():
		if each is Spawner:
			spawners.append(each)

func getHQ():
	return hq

func getMap():
	return map

func getWaveManager():
	return waveManager

func bindSignals():
	SignalBus.hq_destroyed.connect(_on_hq_destroyed)

func _on_hq_destroyed(level : Level, inHq : HQ):
	if level == self && inHq in livingHQs:
		livingHQs.erase(hq)
		updateLevelState()

func updateLevelState():
	if livingHQs.is_empty():
		emit_signal("last_hq_destroyed")
