extends Node
class_name WalletManager

var oreCount : int = 0

signal ore_count_updated(newTotal : int)

func _ready() -> void:
	var level : Level = get_tree().current_scene as Level
	oreCount = level.getLevelSettings().initialOre

func completeWaveIncome() -> void:
	var level : Level = get_tree().current_scene as Level
	var map : Map = level.getMap() as Map

	var hqs : Array[HQ] = level.getHQs()
	var incomeFromHqs : int = level.getLevelSettings().hqIncome * hqs.size()

	var extracters : Array = map.getExtracters()
	var incomeFromExtracters : int = level.getLevelSettings().extracterIncome * extracters.size()

	addOre(incomeFromHqs + incomeFromExtracters)

func canAffordCost(inCost : int) -> bool:
	return inCost <= oreCount

func pay(inCost : int) -> void:
	oreCount -= inCost
	ore_count_updated.emit(oreCount)

func addOre(inOreCount : int) -> void:
	oreCount += inOreCount
	ore_count_updated.emit(oreCount)

func setOreCount(inCount : int) -> void:
	oreCount  = inCount

func getOreCount() -> int:
	return oreCount
