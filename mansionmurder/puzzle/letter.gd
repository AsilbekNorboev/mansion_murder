extends Area2D

# Preload the puzzle scene
var puzzle_scene = preload("res://letter_puzzle.tscn")  # Ensure the path is correct
@onready var collision_shape = $CollisionShape2D
var puzzle_instance: CanvasLayer = null

func _ready():
	# Ensure the puzzle isn't visible when the scene starts
	puzzle_instance = null

func _input(event):
	if Input.is_action_pressed("click"):
		# Check if the mouse click is within the object’s bounds
		var global_mouse_position = get_viewport().get_camera_2d().get_global_mouse_position()
		var local_mouse_position = to_local(global_mouse_position)  # Convert to local coordinates
		
		if collision_shape.shape:
			if collision_shape.shape is RectangleShape2D:
				var rect = Rect2(collision_shape.position - (collision_shape.shape.extents), collision_shape.shape.extents * 2)
				if rect.has_point(local_mouse_position):
					# Toggle the puzzle visibility
					if puzzle_instance == null:
						# Instantiate the puzzle scene if it's not already
						puzzle_instance = puzzle_scene.instantiate()
						get_parent().add_child(puzzle_instance)
						puzzle_instance.visible = true
						# Pause the game when puzzle is shown
						get_tree().paused = true
						
					if puzzle_instance != null and puzzle_instance.visible == false :# If the puzzle is visible, hide it
						# Unpause the game when puzzle is hidden
						get_tree().paused = true
						puzzle_instance.visible = true

	# Listen for the ESC key to close the puzzle
	if event.is_action_pressed("exit"):  # "ui_cancel" is mapped to ESC by default
		if puzzle_instance != null and puzzle_instance.visible:
			# Hide the puzzle when ESC is pressed
			puzzle_instance.visible = false
			# Unpause the game when the puzzle is closed
			get_tree().paused = false
			
