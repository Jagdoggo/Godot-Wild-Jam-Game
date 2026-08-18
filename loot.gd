extends Node2D

@export var loot_level : int 
@export var sprites : Array[AnimatedSprite2D]

@onready var open_area: Area2D = $"Open Area"
@onready var label: Label = $Label

var player : CharacterBody2D

func _ready() -> void:
	if loot_level/(Global.dungeon_level+1) <= sprites.size():
		sprites[(loot_level/(Global.dungeon_level+1))-1].visible = true

func _process(delta: float) -> void:
	label.text = str(loot_level)
	if Input.is_action_just_pressed("Action"):
		for body in open_area.get_overlapping_bodies():
			if body.name == "Player":
				player = body
				if loot_level/(Global.dungeon_level+1) <= sprites.size():
					sprites[(loot_level/(Global.dungeon_level+1))-1].play("open")

func _on_sprite_animation_finished() -> void:
	$SFX.play()
	player.damage += float(loot_level)/8
	process_mode = Node.PROCESS_MODE_DISABLED
