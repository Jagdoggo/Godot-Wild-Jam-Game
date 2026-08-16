extends Node2D

@export var rooms : Array[Room]
@export var start_position : Vector2i
@export var iterations : int = 500
@export var loot_room_chance : int = 5
@export var loot_scene : PackedScene

@onready var castle_tiles: TileMapLayer = $"Nav Region/Castle Tiles"
@onready var nav_region: NavigationRegion2D = $"Nav Region"
@onready var floor: TileMapLayer = $Floor

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
var tile_positions : Array[Vector2i]
var tileset : TileSet
var rand_tile_index : int
var rand_tile_side : int
var rand_room : Room

var dirs : Array[Vector2i] = [Vector2i.UP,Vector2i.DOWN,Vector2i.LEFT,Vector2i.RIGHT]

signal found_tile_index
signal found_tile_side
signal found_room

func generate():
	create_tile(Vector2i(0,0),rooms[0])
	for i in range(iterations):
		pick_tile()
		await found_tile_index
		pick_room()
		await found_room
		connect_tile(current_tiles[rand_tile_index],rand_room,rand_tile_side)
	for tile in current_tiles:
		castle_tiles.set_pattern(start_position+(tile.pos*4),tileset.get_pattern(tile.room.pattern_index))
		if tile.room.is_loot_room and randi_range(1,loot_room_chance) == 1:
			var loot = loot_scene.instantiate()
			loot.position = (start_position+(tile.pos*4)+Vector2i(2,2)) * tileset.tile_size
			add_child(loot)
		for x in range(4):
			for y in range(4):
				floor.set_cell(start_position+(tile.pos*4)+Vector2i(x,y),0,Vector2i(5,0))
	nav_region.bake_navigation_polygon()

func pick_tile():
	var index = randi_range(0,current_tiles.size()-1)
	var random_tile = current_tiles[index]
	if random_tile.connected_d and random_tile.connected_l and random_tile.connected_r and random_tile.connected_u:
		pick_tile()
	else:
		rand_tile_index = index
		pick_tile_side()
		await found_tile_side
		found_tile_index.emit.call_deferred()

func pick_tile_side():
	var side = randi_range(0,3)
	if side == 0 and current_tiles[rand_tile_index].connected_u:
		pick_tile_side()
		return
	if side == 1 and current_tiles[rand_tile_index].connected_d:
		pick_tile_side()
		return
	if side == 2 and current_tiles[rand_tile_index].connected_l:
		pick_tile_side()
		return
	if side == 3 and current_tiles[rand_tile_index].connected_r:
		pick_tile_side()
		return
	elif dirs[side] + current_tiles[rand_tile_index].pos in tile_positions:
		pick_room()
		return
	rand_tile_side = side
	found_tile_side.emit.call_deferred()

func pick_room():
	var room = rooms.pick_random()
	if !room.connects_u and rand_tile_side == 0:
		pick_room()
		return
	elif !room.connects_d and rand_tile_side == 1:
		pick_room()
		return
	elif !room.connects_l and rand_tile_side == 2:
		pick_room()
		return
	elif !room.connects_r and rand_tile_side == 3:
		pick_room()
		return
	rand_room = room
	found_room.emit.call_deferred()

func create_tile(pos : Vector2i,room : Room):
	var tile = current_tile.new()
	tile.pos = pos
	tile.room = room
	tile.connected_u = !room.connects_u
	tile.connected_d = !room.connects_d
	tile.connected_l = !room.connects_l
	tile.connected_r = !room.connects_r
	if pos.y == 0:
		tile.connected_d = true
	tile_positions.append(tile.pos)
	current_tiles.append(tile)

func connect_tile(tile : current_tile,room : Room,side : int):
	var new_tile_pos : Vector2i
	var new_tile = current_tile.new()
	match side:
		0:
			tile.connected_u = true
			new_tile.connected_d = true
			new_tile_pos = tile.pos + Vector2i.UP
		1:
			tile.connected_d = true
			new_tile.connected_u = true
			new_tile_pos = tile.pos + Vector2i.DOWN
		2:
			tile.connected_l = true
			new_tile.connected_r = true
			new_tile_pos = tile.pos + Vector2i.LEFT
		3:
			tile.connected_r = true
			new_tile.connected_l = true
			new_tile_pos = tile.pos + Vector2i.RIGHT
	if !room.connects_u:
		new_tile.connected_u = true
	if !room.connects_d:
		new_tile.connected_d = true
	if !room.connects_l:
		new_tile.connected_l = true
	if !room.connects_r:
		new_tile.connected_r = true
	new_tile.pos = new_tile_pos
	new_tile.room = room
	if new_tile.pos.y == 0:
		new_tile.connected_d = true
	for i in range(4):
		var pos = new_tile_pos + dirs[i]
		if pos in tile_positions:
			match i:
				0:
					new_tile.connected_u = true
					current_tiles[tile_positions.find(pos)].connected_d = true
				1:
					new_tile.connected_d = true
					current_tiles[tile_positions.find(pos)].connected_u = true
				2:
					new_tile.connected_l = true
					current_tiles[tile_positions.find(pos)].connected_r = true
				3:
					new_tile.connected_r = true
					current_tiles[tile_positions.find(pos)].connected_l = true
	tile_positions.append(new_tile_pos)
	current_tiles.append(new_tile)

func _ready() -> void:
	tileset = castle_tiles.tile_set
	generate()
