extends ColorRect  # Use ColorRect to block inputs

func _ready():
	# Initially, make the blocker invisible and ignore mouse events
	visible = false
	mouse_filter = Control.MouseFilter.Ignore  # Ignore the input when not blocking

# Function to toggle visibility and input blocking
func toggle_blocker(state: bool):
	visible = state
	if visible:
		mouse_filter = Control.MouseFilter.Block  # Block mouse events when visible
	else:
		mouse_filter = Control.MouseFilter.Ignore  # Allow mouse events when invisible
