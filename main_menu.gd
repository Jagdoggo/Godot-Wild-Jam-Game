extends Control

@onready var text_edit: TextEdit = $VBoxContainer/TextEdit

func _ready() -> void:
	if Global.dungeon_level == 10:
		get_child(0).visible = false
		get_child(1).visible = true
	else:
		get_child(0).visible = true
		get_child(1).visible = false

func _on_play_pressed() -> void:
	if text_edit.text != "":
		Global.dungeon_level = int(text_edit.text)-1
	get_tree().change_scene_to_file("res://castle.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
