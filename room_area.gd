extends Area2D

@export var enemy_scene : PackedScene
@export var ranged_enemy_scene : PackedScene
@export var player : CharacterBody2D

var enemies : int
var activated : bool = false

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and !activated:
		activated = true
		for i in range(enemies):
			var enemy = enemy_scene.instantiate()
			enemy.target = player
			enemy.position = Vector2(randf_range(-2,2),randf_range(-2,2))
			add_child.call_deferred(enemy)
			if randf_range(0,1) < float(Global.dungeon_level) / 10:
				var ranged = ranged_enemy_scene.instantiate()
				ranged.target = player
				ranged.position = Vector2(randf_range(-2,2),randf_range(-2,2))
				add_child.call_deferred(ranged)
