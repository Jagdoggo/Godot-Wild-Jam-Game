extends Control

func _on_button_pressed() -> void:
	Global.dungeon_level += 1
	print(Global.dungeon_level)
	get_tree().change_scene_to_file("res://castle.tscn")
