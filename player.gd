extends CharacterBody2D

@export var speed : float = 250
@export var damage : float = 1
@export var cheating : bool = false

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var stamina_bar: ProgressBar = $"Camera2D/Stamina Bar"
@onready var health_bar: ProgressBar = $"Camera2D/Health Bar"
@onready var camera_2d: Camera2D = $Camera2D
@onready var flicker_timer: Timer = $"Flicker Timer"
@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var invincible_timer: Timer = $"Invincible Timer"
@onready var main_music: AudioStreamPlayer2D = $"Main Music"
@onready var castle_number: Label = $"Camera2D/Castle Number"

var inputC : bool
var stamina : float = 100
var health : float = 100
var ran_out_of_stamina : bool = false
var bar_pos_stam : Vector2
var bar_pos_health : Vector2
var invincible : bool = false
var was_playing : bool

func _ready() -> void:
	bar_pos_stam = stamina_bar.position
	bar_pos_health = health_bar.position

func _physics_process(delta: float) -> void:
	if cheating:
		health = 100
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
		health += delta * 2
		inputC = false
	else:
		if not inputC:
			stamina += delta * 16
			health += delta * (4 + Global.dungeon_level / 2)
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
	if stamina > 50:
		ran_out_of_stamina = false
	if health > 100:
		health = 100
	if stamina < 0:
		stamina = 0
		ran_out_of_stamina = true
	if health <= 0:
		get_tree().reload_current_scene()
	stamina_bar.value = stamina
	health_bar.value = health
	move_and_slide()

func _process(delta: float) -> void:
	castle_number.text = "Castle number: " + str(Global.dungeon_level + 1)
	if was_playing != (get_viewport().get_camera_2d() == camera_2d):
		main_music.playing = get_viewport().get_camera_2d() == camera_2d
	if get_viewport().get_camera_2d():
		stamina_bar.position = get_viewport().get_camera_2d().get_screen_center_position() - global_position + bar_pos_stam
		health_bar.position = get_viewport().get_camera_2d().get_screen_center_position() - global_position + bar_pos_health
	was_playing = get_viewport().get_camera_2d() == camera_2d

func _on_flicker_timer_timeout() -> void:
	point_light_2d.hide()
	await get_tree().create_timer(0.25).timeout
	point_light_2d.show()
	flicker_timer.start(randf_range(0,10))

func _on_invincible_timer_timeout() -> void:
	invincible = false
