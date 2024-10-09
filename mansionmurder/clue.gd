extends Sprite2D

var textbox_scene = load("res://textbox.tscn")


func _input(event):
	if Input.is_action_pressed("click"):
		if get_rect().has_point(to_local(event.position)):
			print("You clicked on Clue")
			var textbox = textbox_scene.instantiate()
			add_child(textbox)
