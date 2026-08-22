extends Control

@onready var text_edit: TextEdit = $VBoxContainer/TextEdit
@onready var back: AnimatedSprite2D = $Control/back

func _ready() -> void:
	back.frame = Global.dungeon_level+1

func _on_play_pressed() -> void:
	if text_edit.text != "":
		Global.dungeon_level = int(text_edit.text)-1
	get_tree().change_scene_to_file("res://castle.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
