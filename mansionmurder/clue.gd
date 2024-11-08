extends Area2D

var cursor = preload("res://art/pointer.png")		
# Exported variables for customizing each clue
@export var clue_name: String = "Example Clue"
@export var lines: Array[String] = []
@export var clue_texture: Texture
@export var zoom_image_path: String = ""  # Optional zoom image path
@export var clue_description: String = ""
@onready var collision_shape = $CollisionShape2D
@onready var clue_sprite = $Sprite2D  # Image to display the clue

# Instance variables
var textbox_scene = preload("res://textbox.tscn")
var is_dialog_active = false
var current_line_index = 0

# Signals for clue interactions
signal clue_clicked(clue_data)
signal main_add_zoom_scene

func _ready():
	# Set the texture and other properties when the clue is added to the scene
	_setup_clue_image()
	set_process_input(true)

func _setup_clue_image():
	# Set the clue's sprite to the given texture if it exists
	if clue_texture:
		clue_sprite.texture = clue_texture
	else:
		print("Warning: No texture set for clue ", clue_name)

func _input(event):
	if event.is_action_pressed("click"):
		var global_mouse_position = get_viewport().get_camera_2d().get_global_mouse_position()
		var local_mouse_position = to_local(global_mouse_position)  # Convert to local coordinates

		# Check if collision_shape is valid and has a shape
		if collision_shape and collision_shape.shape:
			if collision_shape.shape is RectangleShape2D:
				var rect = Rect2(collision_shape.position - (collision_shape.shape.extents), collision_shape.shape.extents * 2)
				if rect.has_point(local_mouse_position):
					print("Clicked on Clue: ", clue_name)
					emit_signal("clue_clicked", {
						"name": clue_name,
						"description": clue_description,
						"icon": clue_texture
						})
					_dialog_start()
					_show_zoom_image()
		else:
			print("Warning: CollisionShape2D is null or does not have a shape.")

# Starts the dialog for this clue
func _dialog_start():
	if is_dialog_active or not lines:
		return
	
	# Instantiate and set up the textbox
	var textbox_instance = textbox_scene.instantiate()
	add_child(textbox_instance)
	var text_container = textbox_instance.get_node("TextboxContainer")
	text_container.add_text(lines[current_line_index])
	is_dialog_active = true

# Ends the dialog for this clue
func _dialog_end(textbox_instance):
	is_dialog_active = false
	current_line_index = 0
	textbox_instance.queue_free()  # Remove the dialog box from the scene
	queue_free()


func _unhandled_input(event):
	if event.is_action_pressed("dialogue_next") and is_dialog_active:
		current_line_index += 1
		#var textbox_instance = get_node("TextboxContainer")
		var textbox_instance = find_child("TextboxContainer", true, false)
		if current_line_index >= lines.size():
			_dialog_end(textbox_instance)
		else:
			textbox_instance.add_text(lines[current_line_index])

# Show zoom image if specified
func _show_zoom_image():
	if zoom_image_path:
		var zoom_scene_instance = load(zoom_image_path).instantiate()
		add_child(zoom_scene_instance)
		emit_signal("main_add_zoom_scene")
	else:
		print("No zoom image set for clue ", clue_name)

# Function to set up the clue's properties dynamically
func set_clue_data(data: Dictionary):
	clue_name = data.get("name", clue_name)
	lines = data.get("lines", lines)
	clue_texture = data.get("texture", clue_texture)
	zoom_image_path = data.get("zoom_image", zoom_image_path)
	clue_description = data.get("description", clue_description)  # Added for description
	_setup_clue_image()


#change cursor when hovering over
func _on_mouse_entered() -> void:
		Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW, Vector2(16,16))


func _on_mouse_exited() -> void:
		Input.set_custom_mouse_cursor(null)
