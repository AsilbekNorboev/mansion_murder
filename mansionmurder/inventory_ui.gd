extends CanvasLayer


@onready var clue_container = $ScrollContainer/ClueContainer

# Function to add a clue to the inventory UI
func add_clue(clue_data: Dictionary):
	var clue_scene = preload("res://clue_item.tscn")  # Path to your clue item scene
	var clue_item = clue_scene.instantiate()  # Instance the clue item scene

	# Assuming your clue item scene has a method to set data
	clue_item.set_data(clue_data)  # Pass c
	clue_container.add_child(clue_item)
