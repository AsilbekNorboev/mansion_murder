extends Area2D

# Preload the puzzle scene
var puzzle_scene = preload("res://puzzle1.tscn")  # Make sure to use the correct path
@onready var collision_shape = $CollisionShape2D

func _input(event):
	if Input.is_action_pressed("click"):
		# Check if the mouse click is within the object’s bounds
		var global_mouse_position = get_viewport().get_camera_2d().get_global_mouse_position()
		var local_mouse_position = to_local(global_mouse_position)  # Convert to local coordinates
		#print("Mouse Position:", global_mouse_position)
		if collision_shape.shape:
			if collision_shape.shape is RectangleShape2D:
				var rect = Rect2(collision_shape.position - (collision_shape.shape.extents), collision_shape.shape.extents * 2)
				if rect.has_point(local_mouse_position):
					print("You clicked on Clue")
					get_tree().change_scene_to_file("res://Puzzle1.tscn")  # Load the puzzle scene
