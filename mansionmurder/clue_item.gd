extends TextureRect

# Declare member variables
var clue_name: String
var clue_description: String
var clue_icon: Texture

# Method to set the data for the clue item
func set_data(data: Dictionary):
	clue_name = data["name"]
	clue_description = data["description"]
	clue_icon = data["icon"]
	
	# Update UI elements
	#$ClueName.text = clue_name  # Assuming there's a Label node named ClueName
	$Label.text = clue_description  # Assuming there's a Label node named ClueDescription
	$TextureRect.texture = clue_icon  # Assuming there's a TextureRect node named ClueIcon
	self.set_custom_minimum_size(Vector2(690, 100))
