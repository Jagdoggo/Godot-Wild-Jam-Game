extends Node2D

@export var loot_level : int 

@onready var open_area: Area2D = $"Open Area"
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var label: Label = $Label

var player : CharacterBody2D

func _process(delta: float) -> void:
	label.text = str(loot_level)
	if Input.is_action_just_pressed("Action"):
		for body in open_area.get_overlapping_bodies():
			if body.name == "Player":
				player = body
				sprite.play("open")

func _on_sprite_animation_finished() -> void:
	player.damage += float(loot_level)/8
	print(player.damage)
