extends CharacterBody2D

@export var speed : float = 250

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var stamina_bar: ProgressBar = $"Stamina Bar"

var inputC : bool
var stamina : float = 100
var ran_out_of_stamina : bool = false

func _physics_process(delta: float) -> void:
	var input = Input.get_vector("Left","Right","Up","Down")
	inputC = Input.is_action_pressed("CHARGE!!")
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
	if ran_out_of_stamina:
		stamina += delta * 8
		inputC = false
	else:
		if not inputC:
			stamina += delta * 16
	if inputC:
		stamina += -delta * 64
		sprite.speed_scale = 2
		speed = 400
	else:
		get_child(1).speed_scale = 1
		if ran_out_of_stamina:
			speed = 100
		else:
			speed = 250
	if stamina > 100:
		stamina = 100
		ran_out_of_stamina = false
	if stamina < 0:
		stamina = 0
		ran_out_of_stamina = true
	stamina_bar.value = stamina
	move_and_slide()
