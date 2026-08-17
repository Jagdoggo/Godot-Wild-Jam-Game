extends AnimatedSprite2D

@onready var player: CharacterBody2D = $"../Player"
@onready var break_particles: CPUParticles2D = $"DoorStaticBody/Break Particles"

func _on_door_area_body_entered(body: Node2D) -> void:
	if player.inputC:
		play()
		$SFX.play()
		break_particles.emitting = true
		await animation_finished
		$DoorStaticBody.queue_free()
