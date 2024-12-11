extends CanvasLayer

# Loads textbox scene to use its functions later
var textbox_scene = preload("res://textbox.tscn").instantiate()
var textappear = textbox_scene.get_node("TextboxContainer")
var deputytalksprite = textappear.get_node("Dialogue Sprites/Deputy Dialogue Sprite")
var accusation_menu = preload("res://accusation_menu.tscn").instantiate()
@onready var start_game_button = $"Start Game"

@onready var dialog = $Dialogue
var active_lines = []

var text_node


func _ready():
	start_game_button.hide()
	_dialog_start()

# On click, add text from the array to populate the textbox scene
func _dialog_start():
	#play sprite animation
	deputytalksprite.animation = "idle"
	deputytalksprite.play()
	deputytalksprite.show()
	# Play audio when the Deputy starts talking
	$DeputyTalking.play()
		
	print("dialogue starting")
			
	add_child(textbox_scene)
	print("textbox scene added")
					
	text_node = textbox_scene.get_node("TextboxContainer")
	
	active_lines = get_default(InventoryManager.get_inventory(), dialog.dialog_dictionary)
	#add dialogue textbox
	text_node.add_text(active_lines[Global.current_line_index])
	Global.is_dialog_active = true
	textappear.next_dialogue.connect(self._populate_dialogue)
	if (Global.current_line_index > 0):
		_populate_dialogue()

func get_default(inventory_list, dialog_dictionary):
	return dialog_dictionary[""]


func _dialog_end(textappear):
	# Hide the textbox
	Global.is_dialog_active = false
	Global.current_line_index = 0
	textappear.hide_textbox()
	# Remove the instantiated textbox from current room scene
	remove_child(textbox_scene)
	start_game_button.show()
	
func _populate_dialogue():
	print("populating dialogue")
	if Global.current_line_index <= active_lines.size():
		Global.current_line_index += 1
		print("next dialogue")
	# If current line is the last, show the clue container
	if (Global.current_line_index == active_lines.size()-1):
		textappear.show_clue_container(true)
		
	if Global.current_line_index >= active_lines.size():
		_dialog_end(textappear)
		print("end of dialogue")
	else:
		textappear.add_text(active_lines[Global.current_line_index])
		
##waits a few seconds to allow the sound effect of the button to play
func wait(seconds: float) -> void:
	OS.delay_msec(seconds * 1000)
	
func _on_start_game_pressed() -> void:
	$ButtonClick.play()
	wait(.5)
	get_tree().change_scene_to_file("res://main.tscn")
