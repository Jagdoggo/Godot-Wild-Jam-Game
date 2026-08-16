extends AnimatedSprite2D

@onready var player: CharacterBody2D = $"../Player"

func _on_door_area_body_entered(body: Node2D) -> void:
	if player.inputC:
		play()
		await animation_finished
		$DoorStaticBody.queue_free()
