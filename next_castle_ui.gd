extends Control

func _on_button_pressed() -> void:
	Global.dungeon_level += 1
	print(Global.dungeon_level)
	get_tree().change_scene_to_file("res://castle.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Action"):
		_on_button_pressed()
