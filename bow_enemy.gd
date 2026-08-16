extends CharacterBody2D

@export var speed : float = 100
@export var target : CharacterBody2D

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

func _physics_process(_elta: float) -> void:
	navigation_agent_2d.target_position = target.position
	velocity = global_position.direction_to(navigation_agent_2d.get_next_path_position()) * speed
	move_and_slide()
