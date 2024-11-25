extends Node

@onready var clue_script = $".."

# Instance variables
var textbox_scene = preload("res://textbox.tscn")
var current_line_index = 0
var narrator_lines
var textbox_instance
# Signals for clue interactions
signal clue_clicked(clue_data)
	
# Starts the dialog for this clue
func narrator_dialog_start():
	print("narration dialogue start")
	#lock character movement until the dialogue ends
	get_tree().paused = true
	narrator_lines = clue_script.narrator_lines

	# Instantiate and set up the textbox
	Global.is_narrator_dialog_active = true
	
	# Instantiate and set up the textbox
	var textbox_instance = textbox_scene.instantiate()
	add_child(textbox_instance)
	#textbox_active.emit()
	var text_container = textbox_instance.get_node("TextboxContainer")
	text_container.show_clue_container(false)
	text_container.next_dialogue.connect(self._populate_narrator_dialogue)
	text_container.narrator_text_color()
	
	if Global.current_line_index >= narrator_lines.size():
		_narrator_dialog_end(text_container)
		print("end of narration dialogue")
	else:
		text_container.add_text(narrator_lines[current_line_index])


# Ends the dialog for this clue
func _narrator_dialog_end(textbox_instance):
	Global.is_narrator_dialog_active = false
	textbox_instance.hide_skip_label()

	#Remove the dialog box from the scene
	textbox_instance.queue_free() 
	#unlock character movement when the dialogue ends
	get_tree().paused = false
	
	#Remove clue from scene
	print("removing clue from scene")
	$".."._remove_clue()
	
#on pressing dialog next 
func _populate_narrator_dialogue():
	var textbox_instance = find_child("TextboxContainer", true, false)
	
	print("number of lines: ", narrator_lines.size())
	if Global.current_line_index <= narrator_lines.size():
		Global.current_line_index += 1
		print("next narrator dialogue")
		
	if Global.current_line_index >= narrator_lines.size():
		_narrator_dialog_end(textbox_instance)
	else:
		textbox_instance.add_text(narrator_lines[Global.current_line_index])
