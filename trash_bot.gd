extends Sprite2D

@export var player : CharacterBody2D
@export var frame_delay : int = 50
@export var EndCutscene : PackedScene

@onready var arm_rotation: Node2D = $"Arm Rotation"
@onready var camera_2d: Camera2D = $Camera2D
@onready var hit_timer: Timer = $"Hit Timer"
@onready var death_line: Area2D = $"Line Rotation/Death Line"
@onready var line_rotation: Node2D = $"Line Rotation"
@onready var line_cooldown: Timer = $"Line Cooldown"
@onready var line_timer: Timer = $"Line Timer"
@onready var music: AudioStreamPlayer2D = $Music
@onready var hit_indicator: Sprite2D = $"Hit Indicator"

var last_positions : Array[Vector2]
var running : bool = false
var line : bool = false
var can_be_lined : bool = true
var health : float = 5
var hit : int = 0

signal start

func _process(delta: float) -> void:
	line_timer.paused = !running
	death_line.visible = line
	death_line.monitoring = line and can_be_lined
	last_positions.append(player.position)
	if last_positions.size() == frame_delay:
		last_positions.remove_at(0)
		line_rotation.rotation = global_position.angle_to_point(last_positions[0]) + deg_to_rad(180)
	if can_be_lined and death_line.overlaps_body(player):
		line_cooldown.start()
		can_be_lined = false
		player.health -= 25
	if running:
		arm_rotation.rotation_degrees += 300 * delta

func _on_detect_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		health = 5
		music.play()
		start.emit()
		running = true
		camera_2d.global_position = player.position
		camera_2d.zoom = Vector2(2,2)
		player.camera_2d.enabled = false
		camera_2d.enabled = true
		var tween = get_tree().create_tween()
		tween.tween_property(camera_2d,"position",Vector2.ZERO,3)
		var tween2 = get_tree().create_tween()
		tween2.tween_property(camera_2d,"zoom",Vector2.ONE,3)

func _on_ram_area_body_entered(body: Node2D) -> void:
	if body.name == "Player" and body.inputC and running and hit_indicator.visible:
		hit = 0
		hit_indicator.hide()
		body.health = 100
		health -= 1
		hit_timer.start()
		running = false
		modulate = Color.RED
		if health <= 0:
			queue_free()

func _on_death_zone_body_entered(body: Node2D) -> void:
	if body.name == "Player" and running:
		body.health -= 50

func _on_hit_timer_timeout() -> void:
	player.health = 100
	modulate = Color.WHITE
	running = true

func _on_line_timer_timeout() -> void:
	hit += 1
	if hit == 2:
		hit_indicator.show()
	line = !line

func _on_line_cooldown_timeout() -> void:
	can_be_lined = true
