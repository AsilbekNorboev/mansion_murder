extends Button

# Exported variables for customizing each clue
@export var lines: Array[String] = []

# Instance variables
var textbox_scene = preload("res://textbox.tscn")

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

	textbox_instance.queue_free() 
	#unlock character movement when the dialogue ends
	get_tree().paused = false
