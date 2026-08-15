extends Node2D

@export var rooms : Array[Room]
@export var start_position : Vector2i

@onready var castle_tiles: TileMapLayer = $"Castle Tiles"

func generate():
	var tileset = castle_tiles.tile_set
	castle_tiles.set_pattern(start_position,tileset.get_pattern(rooms[0].pattern_index))
