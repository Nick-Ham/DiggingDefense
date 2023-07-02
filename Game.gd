extends Node

@export var IS_DEBUG : bool = false

var gameMode : GameMode

func setGameMode(inGameMode : GameMode):
	gameMode = inGameMode

func getGameMode():
	return gameMode
