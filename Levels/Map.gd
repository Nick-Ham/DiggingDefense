extends TileMap
class_name Map

enum TILE_TYPE {NONE, GROUND, WALL, BEDROCK}

var TILES : Dictionary = {
	"" : TILE_TYPE.NONE,
	"Dirt" : TILE_TYPE.GROUND,
	"DirtWall" : TILE_TYPE.WALL,
	"Bedrock" : TILE_TYPE.BEDROCK
}

var TILE_ATLAS_COORD : Dictionary = {
	"" : Vector2i(-1, -1),
	"Dirt" : Vector2i(0, 0),
	"Ore" : Vector2i(3, 3)
}

var extracterPacked : PackedScene = preload("res://Game/Structures/Extracter.tscn")

const customDataNameLayer : String = "TileName"

var turrets : Dictionary = {}
var extracters : Dictionary = {}
var effects : Dictionary = {}

func registerEffect(inEffect : EnvironmentalEffect) -> void:
	var effectGlobalPosition = inEffect.global_position
	var effectLocalPosition = to_local(effectGlobalPosition)
	effects[local_to_map(effectLocalPosition)] = inEffect

func getExtracters() -> Array:
	return extracters.keys() as Array

func getExtracterAtPosition(inPosition : Vector2i) -> Extracter:
	return extracters.get(inPosition)

func getEffectAtPosition(inPosition : Vector2i) -> EnvironmentalEffect:
	return effects.get(inPosition)

func getTurretAtPosition(inPosition : Vector2i) -> Turret:
	return turrets.get(inPosition)

func isTileOre(inPosition : Vector2i) -> bool:
	var atlasCoords : Vector2i = get_cell_atlas_coords(2, inPosition)
	if atlasCoords == TILE_ATLAS_COORD["Ore"]:
		return true

	return false

func getTileTypeAtPosition(inPosition : Vector2i) -> TILE_TYPE:
	var tileData : TileData = get_cell_tile_data(0, inPosition)
	if !tileData:
		return TILE_TYPE.NONE

	var customTileData : String = tileData.get_custom_data(customDataNameLayer)
	var tileType : TILE_TYPE = TILES.get(customTileData)
	if !tileType:
		return TILE_TYPE.NONE

	return tileType

func tryBreakTileAtPosition(inMapCoordinate : Vector2i) -> bool:
	var tileType : TILE_TYPE = getTileTypeAtPosition(inMapCoordinate)

	if tileType != TILE_TYPE.WALL:
		return false

	var effect : Effect = effects.get(inMapCoordinate) as Effect
	if effect:
		set_cell(1, inMapCoordinate, -1)
		effects.erase(effect)

	var tileKey : String = TILES.find_key(TILE_TYPE.GROUND)
	set_cell(0, inMapCoordinate, 1, TILE_ATLAS_COORD.get(tileKey))

	return true

func trySpawnTurret(inTurretData : TurretData, inMapCoordinate : Vector2i) -> bool:
	var turret : Turret = turrets.get(inMapCoordinate)
	if turret:
		return false

	var newTurretInstance : Turret = inTurretData.packedScene.instantiate()
	newTurretInstance.global_position = to_global(map_to_local(inMapCoordinate))
	add_child(newTurretInstance)
	turrets[inMapCoordinate] = newTurretInstance

	return true

func tryCreateExtracter(inPosition : Vector2i) -> bool:
	var extracter : Extracter = extracters.get(inPosition)
	if extracter:
		return false

	var newExtracterInstance : Extracter = extracterPacked.instantiate()
	newExtracterInstance.global_position = to_global(map_to_local(inPosition))
	add_child(newExtracterInstance)
	extracters[inPosition] = newExtracterInstance

	return true

func globalToTileCoordinate(inGlobalPosition : Vector2) -> Vector2i:
	return local_to_map(to_local(inGlobalPosition))

func printTileInfo(inGridPosition : Vector2i) -> void:
	var effectAtCoord : EnvironmentalEffect = getEffectAtPosition(inGridPosition)
	var tileTypeAtCoord : TILE_TYPE = getTileTypeAtPosition(inGridPosition)
	var effectString : String = "Effect: "
	if effectAtCoord:
		effectString += str(effectAtCoord.effectName)
	else:
		effectString += "None"
	var tileTypeString : String = "TileType: "
	tileTypeString += str(TILE_TYPE.keys()[tileTypeAtCoord])
	print(effectString + " " + tileTypeString)
