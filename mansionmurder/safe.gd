extends Sprite2D

# Preload the puzzle scene
var puzzle_scene = preload("res://puzzle1.tscn")  # Make sure to use the correct path

func _input(event):
	if Input.is_action_pressed("click"):
		# Check if the mouse click is within the object’s bounds
		if get_rect().has_point(to_local(event.position)):
			print("You clicked on Clue")
			# Switch to the puzzle scene
			get_tree().change_scene_to_file("res://Puzzle1.tscn")  # Load the puzzle scene
