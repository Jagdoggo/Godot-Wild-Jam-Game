extends CharacterBody2D

@export var speed : float = 100
@export var damage : float = 25
@export var target : CharacterBody2D
@export var kill_particles : PackedScene
@export var arrow_scene : PackedScene

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area: Area2D = $"Attack Area"

var status : Status
var health : float = 4

var frame = 0

enum Status {
	Moving,
	Attacking
}

func _physics_process(_delta: float) -> void:
	frame += 1
	if frame >= 10:
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
	if animated_sprite_2d.animation == "attack":
		var arrow = arrow_scene.instantiate()
		arrow.rotation = deg_to_rad(180)+global_position.angle_to_point(target.position)
		add_child(arrow)
		status = Status.Moving

func _on_ram_area_body_entered(body: Node2D) -> void:
	if body.name == "Player" and body.inputC:
		health -= body.damage
		var particles = kill_particles.instantiate()
		particles.position = position
		get_parent().add_child.call_deferred(particles)
		particles.emitting = true
		if health <= 0:
			particles.kill = true
			queue_free()
