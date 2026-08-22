extends Control

@export var mainMenuScene : PackedScene
var finished = 0

@onready var menu: VBoxContainer = $VBoxContainer
@onready var ending_cutscene: AnimatedSprite2D = $"Control/Ending Cutscene"

func _ready() -> void:
	ending_cutscene.frame = 90

func _on_ending_cutscene_animation_finished() -> void:
	print("slav")
	ending_cutscene.frame = 90
	finished = 1
	menu.visible = true

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_packed(mainMenuScene)

func _on_big_timer_timeout() -> void:
	ending_cutscene.frame = 0
	ending_cutscene.play()


func _process(delta: float) -> void:
	if finished == 1:
		if Input.is_action_just_pressed("Action"):
			_on_texture_button_pressed()
