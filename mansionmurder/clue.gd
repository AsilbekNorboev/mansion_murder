extends Area2D

#loads textbox scene to use its functions later
var textbox_scene = preload("res://textbox.tscn").instantiate()
var textappear = textbox_scene.get_node("TextboxContainer")
var current_line_index = 0

var is_dialog_active = false

@export var lines:Array[String] = []

@export_global_file("*.png") var zoom_image
@onready var collision_shape = $CollisionShape2D


	
func _input(event):
	if Input.is_action_pressed("click"):
		var global_mouse_position = get_viewport().get_camera_2d().get_global_mouse_position()
		var local_mouse_position = to_local(global_mouse_position)  # Convert to local coordinates
		#print("Mouse Position:", global_mouse_position)
		if collision_shape.shape:
			if collision_shape.shape is RectangleShape2D:
				var rect = Rect2(collision_shape.position - (collision_shape.shape.extents), collision_shape.shape.extents * 2)
				if rect.has_point(local_mouse_position):
					print("You clicked on Clue")
					_dialog_start()
					print("You clicked on Clue")
		#if get_rect().has_point(to_local(event.position)):
			#_dialog_start()
			#print("You clicked on Clue")				
			
#on click, add text from the array to populate the textbox scene
func _dialog_start():
	if is_dialog_active:
		return
	add_child(textbox_scene)
	textappear.add_text(lines[current_line_index])
	is_dialog_active = true

func _dialog_end():
	#hide the textbox
	is_dialog_active = false
	current_line_index = 0
	textappear.hide_textbox()
	
func _unhandled_input(event):
		
	if( event.is_action_pressed("dialogue_next") && is_dialog_active):
		current_line_index += 1
		#if there is no more text left in array, end the dialog
		if current_line_index >= lines.size():
			_dialog_end()
		#if there is more text left, display the next line of text
		else:
			textappear.add_text(lines[current_line_index])

func _zoom_image():
	if (zoom_image):
		print("zoom image exists")
