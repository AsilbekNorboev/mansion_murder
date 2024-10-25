extends Sprite2D

signal clue_clicked(clue_data)

var clue_name = "Knife"
var clue_description = "A bloody safe found in the safe."
var clue_icon = preload("res://art/Clues/safe.png") # Replace with actual path

func _input(event):
	if Input.is_action_pressed("click"):
		if get_rect().has_point(to_local(event.position)):
			print("You clicked on Clue")
			emit_signal("clue_clicked", {
				"name": clue_name,
				"description": clue_description,
				"icon": clue_icon
			})
