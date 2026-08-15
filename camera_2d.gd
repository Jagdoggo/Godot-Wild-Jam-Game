extends Camera2D

@onready var player: Area2D = $"../Player"

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if position.x <= player.position.x + 50 && position.x >= player.position.x - 50:
		pass
	elif position.x > player.position.x:
		position.x -= 250 * delta
	elif position.x < player.position.x:
		position.x += 250 * delta
	elif position.x > player.position.x + 500:
		position.x -= 500 * delta
	elif position.x < player.position.x - 500:
		position.x += 500 * delta
	if position.y <= player.position.y + 50 && position.y >= player.position.y - 50:
		pass
	elif position.y > player.position.y:
		position.y -= 250 * delta
	elif position.y < player.position.y:
		position.y += 250 * delta
	elif position.y > player.position.y + 500:
		position.y -= 500 * delta
	elif position.y < player.position.y - 500:
		position.y += 500 * delta
