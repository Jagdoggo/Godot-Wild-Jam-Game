extends Node2D

@export var rooms : Array[Room]
@export var start_position : Vector2i

@onready var castle_tiles: TileMapLayer = $"Castle Tiles"

class current_tile:
	var pos : Vector2i
	var connected_u : bool = false
	var connected_d : bool = false
	var connected_l : bool = false
	var connected_r : bool = false
	var room : Room
	
	func _init() -> void:
		if pos.y == 0:
			connected_d = true

var current_tiles : Array[current_tile]

func generate():
	var tileset = castle_tiles.tile_set
	create_tile(Vector2i(0,0),rooms[0])

func create_tile(pos : Vector2i,room : Room):
	var tile = current_tile.new()
	tile.pos = pos
	tile.room = room
	tile.connected_u = !room.connects_u
	tile.connected_d = !room.connects_d
	tile.connected_l = !room.connects_l
	tile.connected_r = !room.connects_r

func connect_tile(tile : current_tile,room : Room,side : int):
	var new_tile_pos : Vector2i
	match side:
		0:
			tile.connected_u = true
			new_tile_pos = tile.pos + Vector2i.UP
		1:
			tile.connected_d = true
			new_tile_pos = tile.pos + Vector2i.DOWN
		2:
			tile.connected_l = true
			new_tile_pos = tile.pos + Vector2i.LEFT
		3:
			tile.connected_r = true
			new_tile_pos = tile.pos + Vector2i.RIGHT

func _ready() -> void:
	generate()
