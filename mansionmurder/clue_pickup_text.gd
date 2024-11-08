extends Control

# Function to show the message and hide the textbox after a delay
func show_message(message: String, display_time: float) -> void:
	$Label.text = message  # Set the message text
	self.visible = true  # Make the textbox visible

	# Wait for the display time using await
	await get_tree().create_timer(display_time).timeout
	queue_free()

	# Clean
