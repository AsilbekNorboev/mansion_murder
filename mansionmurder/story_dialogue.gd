extends Control

@onready var textbox: CanvasLayer = $textbox

@onready var textappear = textbox.get_node("TextboxContainer")
@onready var chef_sprite = textappear.get_node("Dialogue Sprites/Chef Dialogue Sprite")
@onready var wife_sprite = textappear.get_node("Dialogue Sprites/Wife Dialogue Sprite")
@onready var gardener_sprite = textappear.get_node("Dialogue Sprites/Gardener Dialgoue Sprite")
@onready var deputy_sprite = textappear.get_node("Dialogue Sprites/Deputy Dialogue Sprite")
@onready var maid_sprite = textappear.get_node("Dialogue Sprites/Maid Dialogue Sprite")
@onready var detective_sprite = textappear.get_node("Dialogue Sprites/Detective Dialogue Sprite")
var npc_lines_list = []
var current_npc_index = 0
var current_line_index = -1

signal next_dialogue


func show_dialogue(local_npc_list):
	npc_lines_list = local_npc_list
	step_through_npc_list()

func get_sprite(sprite_name):
	if sprite_name == "Wife":
		return wife_sprite
	if sprite_name == "Chef":
		return chef_sprite	
	if sprite_name == "Gardener":
		return gardener_sprite	
	if sprite_name == "Deputy":
		return deputy_sprite	
	if sprite_name == "Maid":
		return maid_sprite
	if sprite_name == "Detective":
		return detective_sprite	
		
		
func show_npc_sprite(sprite_name):
	var current_sprite = get_sprite(sprite_name)
	# Toggle visibility of overlay
	textappear.get_node("Overlay").show()
	# Toggle visibility of text sprites
	current_sprite.animation = "idle"
	current_sprite.play()
	current_sprite.show()
	#chef_audio_player.play()

func hide_npc_sprites(sprite_name):
	var current_sprite = get_sprite(sprite_name)
	# Toggle visibility of overlay
	textappear.get_node("Overlay").hide()
	# Toggle visibility of text sprites
	current_sprite.stop()
	current_sprite.hide()
	#chef_audio_player.stop()
		
	
		
func step_through_npc_list():
	var npc_count = len(npc_lines_list)
	var current_lines_count = len(npc_lines_list[current_npc_index])

	if current_line_index == current_lines_count:
		# This is the last line in current npc
		if current_npc_index == npc_count:
			# Close
			_dialog_end()
			return
		else: 
			current_npc_index += 1
			current_line_index = 0
	else:
		# Increment Line for Current NPC
		current_line_index += 1
	
	var npc_dict = npc_lines_list[current_npc_index] # Get the dictionary at the current index
	var sprite_name = npc_dict.keys()[0] # Get the single key in the dictionary
	var npc_line = npc_dict[sprite_name][current_line_index] # Access the value (a list) and get the current line
	
	populate_text(npc_line)
	show_npc_sprite(sprite_name)
	
	
func _dialog_end():
	# Remove the instantiated textbox from current room scene
	remove_child(textbox)

func populate_text(line):
	textappear.add_text(line)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process_input(true)
	textappear.hide_textbox()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_introduction_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("dialogue_next"):
		print("Dialogue next pressed")
		step_through_npc_list()
