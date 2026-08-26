extends CharacterBody2D

@export var speed : float = 100
@export var damage : float = 25
@export var target : CharacterBody2D
@export var kill_particles : PackedScene
@export var player_dist : float = 40

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area: Area2D = $"Attack Area"
@onready var ray_cast_2d: RayCast2D = $RayCast2D

var status : Status
var health : float = 8

var is_sidestep : bool = false
var sidestep_vel : Vector2

enum Status {
	Moving,
	Attacking
}

func _physics_process(_delta: float) -> void:
	if global_position.distance_to(target.global_position) < player_dist and status == Status.Moving:
		status = Status.Attacking
		animated_sprite_2d.play("attack")
	else:
		velocity = global_position.direction_to(target.global_position) * speed
		ray_cast_2d.rotation = global_position.angle_to_point(target.position)
		var is_colliding = ray_cast_2d.is_colliding()
		if is_colliding and !is_sidestep:
			var arr = [velocity.x,velocity.y]
			var dir = arr.find(arr.min())
			match dir:
				0:
					sidestep_vel = velocity.rotated(deg_to_rad(-90))
				1:
					sidestep_vel = velocity.rotated(deg_to_rad(90))
			is_sidestep = true
			$Line2D.set_point_position(1,sidestep_vel * 10)
		if is_sidestep:
			if !is_colliding:
				is_sidestep = false
			else:
				velocity = sidestep_vel
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
			if body.name == "Player" and !body.invincible:
				body.health -= damage
				body.invincible = true
				body.invincible_timer.start()

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
