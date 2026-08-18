extends Area2D

@export var damage : float = 25

func _process(delta: float) -> void:
	position += Vector2.LEFT.rotated(rotation) * 1000 * delta


func _on_body_entered(body: Node2D) -> void:
	if body == self:
		return
	if body.name == "Player" and !body.invincible:
		body.health -= damage
		body.invincible = true
		body.invincible_timer.start()
	queue_free()
