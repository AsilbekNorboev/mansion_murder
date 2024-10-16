extends Sprite2D

signal clue_clicked(clue_data)

# The clue's properties (icon, name, description) 
var clue_name = "Painting"
var clue_description = "A bloody safe case found in the safe."
var clue_icon = preload("res://art/Clues/safe.png") # Replace with the actual path to your clue's icon

var clue_data = {
		"name": clue_name,
		"description": clue_description,
		"icon": clue_icon
	}

func _input(event):
	if Input.is_action_pressed("click"):
		if get_rect().has_point(to_local(event.position)):
			print("You clicked on Clue")
			emit_signal("clue_clicked",clue_data)
