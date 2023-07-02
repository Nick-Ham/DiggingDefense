extends TileMap
class_name Map

var TILE_TYPE = {
	"none" : -1,
	"ground" : 0,
	"wall" : 2
}

func attemptToDestroyTile(inGlobalCoordinate):
	var tileCoord = local_to_map(to_local(inGlobalCoordinate))
	
	var tileID = get_cell_source_id(0, tileCoord)
	if canDestroyTile(tileID):
		return
	
	fillAdjacentCells(tileCoord)
	replaceCell(tileCoord)

var ADJACENCY = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]
func fillAdjacentCells(tileCoord):
	for each in ADJACENCY:
		var adjacentCell = tileCoord + each
		if get_cell_source_id(0, adjacentCell) == -1:
			setCellType(adjacentCell, "wall")

func replaceCell(tileCoord):
	setCellType(tileCoord, "ground")

func setCellType(tileCoord, type):
	set_cell(0, tileCoord, TILE_TYPE[type], Vector2i())

func canDestroyTile(tileID):
	return tileID == TILE_TYPE["none"] or tileID == TILE_TYPE["ground"]
