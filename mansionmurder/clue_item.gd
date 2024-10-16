extends TextureRect

# Method to set the data for the clue item
func set_data(data: Dictionary):
	# Set the name, description, and icon for the clue
	#$ClueName.text = data["name"]  # Assuming there's a Label node named ClueName
	$Label.text = data["description"]  # Assuming there's a Label node named ClueDescription
	$TextureRect.texture = data["icon"]  # Assuming there's a TextureRect node named ClueIcon

	# Ensure the clue item has a consistent minimum size
	self.set_custom_minimum_size(Vector2(690, 100))  # Example size for each clue item
