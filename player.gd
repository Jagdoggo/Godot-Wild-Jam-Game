extends CharacterBody2D

@export var speed : float = 250
@export var damage : float = 1

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var stamina_bar: ProgressBar = $"Camera2D/Stamina Bar"
@onready var health_bar: ProgressBar = $"Camera2D/Health Bar"
@onready var camera_2d: Camera2D = $Camera2D

var inputC : bool
var stamina : float = 100
var health : float = 100
var ran_out_of_stamina : bool = false
var bar_pos_stam : Vector2
var bar_pos_health : Vector2

func _ready() -> void:
	bar_pos_stam = stamina_bar.position
	bar_pos_health = health_bar.position

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
			health += delta * 2
	if inputC:
		stamina += -delta * 64
		sprite.speed_scale = 2
		speed = 400
	else:
		sprite.speed_scale = 1
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
	if health <= 0:
		get_tree().reload_current_scene()
	stamina_bar.value = stamina
	health_bar.value = health
	move_and_slide()

func _process(delta: float) -> void:
	stamina_bar.position = camera_2d.get_screen_center_position() - global_position + bar_pos_stam
	health_bar.position = camera_2d.get_screen_center_position() - global_position + bar_pos_health
