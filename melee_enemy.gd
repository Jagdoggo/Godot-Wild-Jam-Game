extends CharacterBody2D

@export var speed : float = 100
@export var damage : float = 25
@export var target : CharacterBody2D
@export var kill_particles : PackedScene

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area: Area2D = $"Attack Area"

var status : Status
var health : float = 8

var frame = 0

enum Status {
	Moving,
	Attacking
}

func _physics_process(_delta: float) -> void:
	frame += 1
	if frame >= 0:
		frame = 0
		navigation_agent_2d.target_position = target.global_position
	if navigation_agent_2d.is_navigation_finished() and status == Status.Moving:
		status = Status.Attacking
		animated_sprite_2d.play("attack")
	else:
		velocity = global_position.direction_to(navigation_agent_2d.get_next_path_position()) * speed
	if target.global_position.distance_squared_to(global_position) > 60000:
		velocity = Vector2.ZERO
	if status == Status.Moving:
		if velocity == Vector2.ZERO:
			animated_sprite_2d.play("idle")
		elif abs(velocity.x) > abs(velocity.y):
			if velocity.x > 0:
				animated_sprite_2d.play("walk right")
			else:
				animated_sprite_2d.play("walk left")
		else:
			if velocity.y > 0:
				animated_sprite_2d.play("walk down")
			else:
				animated_sprite_2d.play("walk up")
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func _on_animated_sprite_2d_animation_finished() -> void:
	if status == Status.Attacking:
		status = Status.Moving

func _on_animated_sprite_2d_frame_changed() -> void:
	if animated_sprite_2d.animation == "attack" and animated_sprite_2d.frame == 14:
		for body in attack_area.get_overlapping_bodies():
			if body.name == "Player":
				body.health -= damage

func _on_ram_area_body_entered(body: Node2D) -> void:
	if body.name == "Player" and body.inputC:
		health -= body.damage
		var particles = kill_particles.instantiate()
		particles.position = position
		get_parent().add_child(particles)
		particles.emitting = true
		if health <= 0:
			queue_free()
