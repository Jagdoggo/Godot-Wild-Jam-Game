extends CharacterBody2D

@export var speed : float = 250

@onready var sprite: AnimatedSprite2D = $Sprite

func _physics_process(_delta: float) -> void:
	var input = Input.get_vector("Left","Right","Up","Down")
	var inputC = Input.get_axis("PLACEHOLDER", "CHARGE!!")
	if Input.is_action_pressed("Left"):
		sprite.play("walk left")
	elif Input.is_action_pressed("Right"):
		sprite.play("walk right")
	elif Input.is_action_pressed("Up"):
		sprite.play("walk up")
	elif Input.is_action_pressed("Down"):
		sprite.play("walk down")
	elif input == Vector2.ZERO:
		sprite.stop()
	velocity = input * speed
	if inputC == 1:
		sprite.speed_scale = 2
		speed = 400
	else:
		get_child(1).speed_scale = 1
		speed = 250
	move_and_slide()
