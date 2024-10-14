extends Sprite2D

var textbox_scene = preload("res://textbox.tscn").instantiate()

var textappear = textbox_scene.get_node("TextboxContainer")

const lines:Array[String] = [
	"A painting of a young woman.",
	"It looks old."
]

var current_line_index = 0

func _input(event):
	if Input.is_action_pressed("click"):
		if get_rect().has_point(to_local(event.position)):
			print("You clicked on Clue")
			add_child(textbox_scene)
			textappear.add_text(lines[current_line_index])
