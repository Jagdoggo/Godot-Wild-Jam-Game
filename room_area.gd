extends Area2D

@export var enemy_scene : PackedScene
@export var player : CharacterBody2D

var enemies : int
var activated : bool = false

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and !activated:
		activated = true
		for i in range(enemies):
			print("eneming")
			var enemy = enemy_scene.instantiate()
			enemy.target = player
			enemy.position = position
			add_child.call_deferred(enemy)
