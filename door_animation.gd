extends AnimatedSprite2D

@onready var player: CharacterBody2D = $"../Player"

func _on_door_animation_timer_timeout() -> void:
	stop()
	frame = 5

func _on_door_area_area_entered(area: Area2D) -> void:
	if player.inputC == 1:
		play()
		get_child(0).start()
