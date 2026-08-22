extends Control

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		if visible:
			_on_resume_pressed()
		else:
			get_tree().paused = true
			visible = true
	if Input.is_action_just_pressed("Action"):
		_on_resume_pressed()

func _on_resume_pressed() -> void:
	get_tree().paused = false
	visible = false

func _on_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
