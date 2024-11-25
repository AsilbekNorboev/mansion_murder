extends Area2D

var cursor = preload("res://art/pointer.png")		
# Exported variables for customizing each clue
@export var display_time: float = 2.0  # Time to show the textbox
@export var offset: Vector2 = Vector2(0, -50)  # Offset to position the textbox above the clue

@export var clue_name: String = "Example Clue"
@export var lines: Array[String] = []
@export var narrator_lines: Array[String] = []
@export var clue_texture: Texture
@export var zoom_image_path: String = ""  # Optional zoom image path
@export var clue_description: String = ""
@onready var collision_shape = $CollisionShape2D
@onready var clue_sprite = $Sprite2D  # Image to display the clue

# Instance variables
var textbox_scene = preload("res://textbox.tscn")
var clue_pickup_text_scene = preload("res://clue_pickup_text.tscn")

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
					_dialog_start()
					#_show_zoom_image()
					show_clue_pickup_text()
					Input.set_custom_mouse_cursor(null)
					print("Clicked on Clue: ", clue_name)
					emit_signal("clue_clicked", {
						"name": clue_name,
						"description": clue_description,
						"icon": clue_texture
						})
					
		else:
			print("Warning: CollisionShape2D is null or does not have a shape.")
			
func show_clue_pickup_text():
	var clue_pickup_text_instance = clue_pickup_text_scene.instantiate()
	get_tree().root.add_child(clue_pickup_text_instance)
	clue_pickup_text_instance.z_index = 100 
	
	# Get the viewport size
	var viewport_size = get_viewport().size

	# Calculate the top-right position
	var camera_pos = get_viewport().get_camera_2d().global_position
	print("camera pos: ", camera_pos)

	# Set the position
	clue_pickup_text_instance.position = Vector2(camera_pos.x+255,camera_pos.y-430)
	print("clue pickup pos: ",clue_pickup_text_instance.position)

	await clue_pickup_text_instance.show_message("Item has been picked up", display_time)
	
# Starts the dialog for this clue
func _dialog_start():
	if Global.is_dialog_active or not lines:
		return
	# Instantiate and set up the textbox
	print("dialogue starting: ", Global.current_line_index)
	var textbox_instance = textbox_scene.instantiate()
	add_child(textbox_instance)
	var text_container = textbox_instance.get_node("TextboxContainer")
	text_container.show_clue_container(false)
	text_container.add_text(lines[Global.current_line_index])
	Global.is_dialog_active = true
	text_container.next_dialogue.connect(self._populate_dialogue)
	if (Global.current_line_index > 0):
		_populate_dialogue()

	
func _populate_dialogue():
	var text_container = find_child("TextboxContainer", true, false)
	print("number of lines: ", lines.size())
	if Global.current_line_index <= lines.size():
		Global.current_line_index += 1
		print("next dialogue")
		
	if Global.current_line_index >= lines.size():
		_dialog_end(text_container)
		print("end of dialogue")
		
	else:
		text_container.add_text(lines[Global.current_line_index])


# Ends the dialog for this clue
func _dialog_end(textbox_instance):
	Global.is_dialog_active = false
	Global.current_line_index = 0
	textbox_instance.hide_skip_label()

	if narrator_lines:
		$"Narrator Text".narrator_dialog_start()
		textbox_instance.queue_free() 
	#Remove the dialog box from the scene
	else:
		textbox_instance.queue_free() 
		#unlock character movement when the dialogue ends
		get_tree().paused = false
		#clue must have a description to be removed from scene (for the deadbody)
		if (clue_description != ""):
			#Remove clue from scene
			_remove_clue()

func _remove_clue():
	queue_free()
# Show zoom image if specified
#func _show_zoom_image():
	#if zoom_image_path:
		#var zoom_scene_instance = load(zoom_image_path).instantiate()
		#add_child(zoom_scene_instance)
		#emit_signal("main_add_zoom_scene")
	#else:
		#print("No zoom image set for clue ", clue_name)

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
