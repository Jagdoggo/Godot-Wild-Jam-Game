extends Area2D

var spriteCount
var touching = 0
	
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	var inputX = Input.get_axis("Left", "Right")
	var inputY = Input.get_axis("Up", "Down")
	position.x += inputX * 250 * delta
	position.y += inputY * 250 * delta
	if inputX == -1:
		get_child(0).visible = false
		get_child(1).visible = true
		get_child(2).visible = false
		get_child(3).visible = false
		spriteCount = 1
	elif inputX == 1:
		get_child(0).visible = true
		get_child(1).visible = false
		get_child(2).visible = false
		get_child(3).visible = false
		spriteCount = 2
	if inputY == -1:
		get_child(0).visible = false
		get_child(1).visible = false
		get_child(2).visible = false
		get_child(3).visible = true
		spriteCount = 3
	elif inputY == 1:
		get_child(0).visible = false
		get_child(1).visible = false
		get_child(2).visible = true
		get_child(3).visible = false
		spriteCount = 4

func _on_area_entered(area: Area2D) -> void:
	if spriteCount == 1 && touching == 0:
		position.x += 1

func _on_area_exited(area: Area2D) -> void:
	pass
