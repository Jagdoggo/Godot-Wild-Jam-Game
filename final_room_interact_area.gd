extends Area2D

@export var enemy_scene : PackedScene
@export var ranged_enemy_scene : PackedScene
@export var count : int = 20

@onready var time_machine_parts: AnimatedSprite2D = $"Time Machine Parts"
@onready var time_machine: AnimatedSprite2D = $"Time Machine"

var activated : bool = false
var completed : bool = false

var boss : Sprite2D
var is_ready : bool = false

func _ready() -> void:
	await $"..".finished
	for area in get_overlapping_areas():
		if area.has_meta("area"):
			area.queue_free()
	if Global.dungeon_level > 9:
		boss = load("res://trash_bot.tscn").instantiate()
		boss.player = $"../Player"
		add_child(boss)
		boss.start.connect(start)
		time_machine.show()
	else:
		time_machine_parts.frame = Global.dungeon_level
		time_machine_parts.show()
	is_ready = true

func _process(delta: float) -> void:
	if !is_ready:
		return
	if Global.dungeon_level < 10:
		if Input.is_action_just_pressed("Action") and !activated:
			for body in get_overlapping_bodies():
				if body.name == "Player":
					$"Start SFX".play()
					activated = true
					for i in range(count):
						var enemy = enemy_scene.instantiate()
						enemy.position = Vector2(randf_range(-160.0,160.0),randf_range(-160.0,160.0))
						enemy.target = $"../Player"
						if enemy.position.abs().x < 32:
							enemy.position.x = 32
						if enemy.position.abs().y < 32:
							enemy.position.y = 32
						add_child(enemy)
						if randf_range(0,1) < float(Global.dungeon_level) / 10:
							var ranged = ranged_enemy_scene.instantiate()
							ranged.target = $"../Player"
							ranged.position = Vector2(randf_range(-160,160),randf_range(-160,160))
							if ranged.position.abs().x < 32:
								ranged.position.x = 32
							if ranged.position.abs().y < 32:
								ranged.position.y = 32
							add_child.call_deferred(ranged)
		if activated and !completed:
			var found : bool = false
			for child in get_children():
				if child is CharacterBody2D:
					found = true
			if !found:
				$"Sucess SFX".play()
				$Label.show()
				completed = true
	else:
		if !boss and !completed:
			completed = true
			$"Sucess SFX".play()
			await get_tree().create_timer(3).timeout
			_on_time_machine_animation_finished()

func start():
	time_machine.play("default")

func _on_time_machine_animation_finished() -> void:
	get_tree().paused = true
