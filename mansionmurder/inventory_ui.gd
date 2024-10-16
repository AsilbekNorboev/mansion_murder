extends CanvasLayer



@onready var clue_container = $ScrollContainer/TopLevelClueContainer

# Function to add a clue to the inventory UI
func add_clue(clue_data: Dictionary):
	var clue_scene = preload("res://clue_item.tscn")
	# Add the clue name as a Label
	var clue_item = clue_scene.instantiate()
	clue_item.set_data(clue_data)  # Pass clue data to the clue item

	# Add the clue item to the VBoxContain
	# Add the ClueItem to the ClueContainer inside the ScrollContainer
	clue_container.add_child(clue_item)
