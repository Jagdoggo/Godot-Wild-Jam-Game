extends CharacterBody2D

@export var speed : float = 250

@onready var sprite: AnimatedSprite2D = $Sprite

func _physics_process(delta: float) -> void:
	var input = Input.get_vector("Left","Right","Up","Down")
	if Input.is_action_pressed("Left"):
		sprite.play("walk left")
	if Input.is_action_pressed("Right"):
		sprite.play("walk right")
	if Input.is_action_pressed("Up"):
		sprite.play("walk up")
	if Input.is_action_pressed("Down"):
		sprite.play("walk down")
	if input == Vector2.ZERO:
		sprite.stop()
	velocity = input * speed
	move_and_slide()
