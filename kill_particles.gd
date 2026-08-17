extends CPUParticles2D

@export var kill : bool = false

func _ready() -> void:
	if kill:
		$KilledSFX.play()

func _on_finished() -> void:
	queue_free()
