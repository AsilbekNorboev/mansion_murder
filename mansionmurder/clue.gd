extends Sprite2D

#loads textbox scene to use its functions later
var textbox_scene = preload("res://textbox.tscn").instantiate()
var textappear = textbox_scene.get_node("TextboxContainer")
var current_line_index = 0

var is_dialog_active = false

@export var lines:Array[String] = []

func _input(event):
	if Input.is_action_pressed("click"):
		if get_rect().has_point(to_local(event.position)):
			_dialog_start()
			print("You clicked on Clue")
			
			
			
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

		
	
			
		#_dialog_start()
	
