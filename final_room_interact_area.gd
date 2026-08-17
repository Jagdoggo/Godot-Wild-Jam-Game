extends Area2D

@export var enemy_scene : PackedScene

@export var count : int = 20

var activated : bool = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Action") and !activated:
		for body in get_overlapping_bodies():
			if body.name == "Player":
				activated = true
				for i in range(count):
					var enemy = enemy_scene.instantiate()
					enemy.position = Vector2(randf_range(-160.0,160.0),randf_range(-160.0,160.0))
					enemy.target = $"../Player"
					add_child(enemy)
