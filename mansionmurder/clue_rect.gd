extends TextureRect

var clue_lines = []

signal clue_clicked


# Method to set the data for the clue item
func set_data(data: Dictionary, lines):
	# Set the name, description, and icon for the clue
	#$ClueName.text = data["name"]  # Assuming there's a Label node named ClueName
	$ClueLabel.text = data["description"]  # Assuming there's a Label node named ClueDescription
	$ClueImage.texture = data["icon"]  # Assuming there's a TextureRect node named ClueIcon
	clue_lines = lines 
	self.gui_input.connect(_on_gui_input)
	# Ensure the clue item has a consistent minimum size
	self.set_custom_minimum_size(Vector2(400, 150))  # Example size for each clue item


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Clue clicked!")  # Debugging
		emit_signal("clue_clicked", clue_lines)
