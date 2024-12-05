extends Area2D

var cursor = preload("res://art/dialogueicon.png")

# Loads textbox scene to use its functions later
var textbox_scene = preload("res://textbox.tscn").instantiate()
var textappear = textbox_scene.get_node("TextboxContainer")
var current_line_index = 0
var cheftalksprite = textappear.get_node("Dialogue Sprites/Chef Dialogue Sprite")
var wifetalksprite = textappear.get_node("Dialogue Sprites/Wife Dialogue Sprite")
var gardenertalksprite = textappear.get_node("Dialogue Sprites/Gardener Dialgoue Sprite")
var deputytalksprite = textappear.get_node("Dialogue Sprites/Deputy Dialogue Sprite")
var maidtalksprite = textappear.get_node("Dialogue Sprites/Maid Dialogue Sprite")
var is_dialog_active = false
var accusation_menu = preload("res://accusation_menu.tscn").instantiate()
signal npc_added

var active_lines = []

@onready var dialog = $Dialogue
@onready var animated_sprite = $AnimatedSprite2D # Reference to the AnimatedSprite2D node
@onready var collision_shape = $CollisionShape2D

var met_this_character = false

# Declare the AudioStreamPlayer for the Wife and Deputy
@onready var wife_audio_player = AudioStreamPlayer.new()
@onready var deputy_audio_player = AudioStreamPlayer.new()
@onready var chef_audio_player = AudioStreamPlayer.new()
@onready var gardener_audio_player = AudioStreamPlayer.new()
@onready var maid_audio_player = AudioStreamPlayer.new()


func _ready():
	# Start playing the idle animation as soon as the NPC is ready
	animated_sprite.animation = "idle"
	animated_sprite.play()
	
	# Load the Wife's audio clip and set its volume
	wife_audio_player.stream = preload("res://audio/NPCnoises/wife_crying.mp3")
	wife_audio_player.volume_db = 10  # Increase the volume by 10 dB (adjust as needed)
	add_child(wife_audio_player)  # Add the audio player to the scene
	
	# Load the Deputy's audio clip and set its volume
	deputy_audio_player.stream = preload("res://audio/NPCnoises/deputy_talking.mp3")  # Replace with actual file path
	deputy_audio_player.volume_db = 10  # Increase the volume by 10 dB (adjust as needed)
	add_child(deputy_audio_player)  # Add the audio player to the scene

	chef_audio_player.stream = preload("res://audio/NPCnoises/chef_talking.mp3")  # Replace with actual file path
	chef_audio_player.volume_db = 10  # Increase the volume by 10 dB (adjust as needed)
	add_child(chef_audio_player)  # Add the audio player to the scene

	gardener_audio_player.stream = preload("res://audio/NPCnoises/gardener_talking.mp3") 
	gardener_audio_player.volume_db = -5  # Decrease the volume by 5 dB (adjust as needed)
	add_child(gardener_audio_player)  # Add the audio player to the scene

	maid_audio_player.stream = preload("res://audio/NPCnoises/maid_talking.mp3") 
	maid_audio_player.volume_db = -5  # Decrease the volume by 5 dB (adjust as needed)
	add_child(maid_audio_player)  # Add the audio player to the scene

func _input_event(viewport, event, shape_idx):
	if Input.is_action_pressed("click"):
		print("you clicked the ", self.name)
		_dialog_start()
		met_character()

# On click, add text from the array to populate the textbox scene
func _dialog_start():
	current_line_index = 0
	# Lock character movement until the dialogue ends
	get_tree().paused = true
	if is_dialog_active:
		return
	if not dialog:
		return
	# Toggle visibility of overlay
	textappear.get_node("Overlay").show()
	# Toggle visibility of text sprites
	if (self.name == "Chef"):
		cheftalksprite.animation = "idle"
		cheftalksprite.play()
		cheftalksprite.show()
		chef_audio_player.play()
		# If they're not already in the suspect list...
		if not self.name in Global.suspect_list:
			met_this_character = true

	if (self.name == "Wife"):
		wifetalksprite.animation = "idle"
		wifetalksprite.play()
		wifetalksprite.show()
		# Play audio when the Wife starts talking
		wife_audio_player.play()
		# If they're not already in the suspect list...
		if not self.name in Global.suspect_list:
			met_this_character = true

	if (self.name == "Deputy"):
		deputytalksprite.animation = "idle"
		deputytalksprite.play()
		deputytalksprite.show()
		# Play audio when the Deputy starts talking
		deputy_audio_player.play()

	if (self.name == "Gardener"):
		gardenertalksprite.animation = "idle"
		gardenertalksprite.play()
		gardenertalksprite.show()
		gardener_audio_player.play()
		if not self.name in Global.suspect_list:
			met_this_character = true

	if (self.name == "Maid"):
		maidtalksprite.animation = "idle"
		maidtalksprite.play()
		maidtalksprite.show()
		maid_audio_player.play()
		if not self.name in Global.suspect_list:
			met_this_character = true

	active_lines = get_default(InventoryManager.get_inventory(), dialog.dialog_dictionary)
	
	if not active_lines:
		return
	if (textbox_scene.find_parent("*") == null):
		add_child(textbox_scene)
		textappear.show_clue_container(false)
		textappear._on_clue_clicked_text.connect(_on_clue_clicked)
		textappear.clear_clues()
		for clue_data_index in range(InventoryManager.get_inventory().size()-1, -1, -1):
			var clue_name = InventoryManager.get_inventory()[clue_data_index]["name"]
			if clue_name in dialog.dialog_dictionary.keys():
				textappear.add_clue(InventoryManager.get_inventory()[clue_data_index], dialog.dialog_dictionary[clue_name])
		textappear.add_text(active_lines[current_line_index])
		is_dialog_active = true

func _on_clue_clicked(lines):
	active_lines = lines
	current_line_index = 0
	textappear.add_text(active_lines[current_line_index])
	textappear.show_clue_container(false)

func _dialog_end():
	# Unlock character movement when the dialogue ends
	get_tree().paused = false
	# Hide the textbox
	is_dialog_active = false
	current_line_index = 0
	textappear.hide_textbox()
	# Remove the instantiated textbox from current room scene
	remove_child(textbox_scene)

func _unhandled_input(event):
	if event.is_action_pressed("dialogue_next") and is_dialog_active:
		current_line_index += 1
		# If current line is the last, show the clue container
		if current_line_index == active_lines.size()-1:
			textappear.show_clue_container(true)
		# If there is no more text, end the dialog
		if current_line_index == active_lines.size():
			_dialog_end()
		# Otherwise, show the next line of text
		else:
			textappear.add_text(active_lines[current_line_index])

func get_default(inventory_list, dialog_dictionary):
	return dialog_dictionary[""]

# Change cursor when hovering over
func _on_mouse_entered() -> void:
	Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW, Vector2(16,16))

# Reset cursor back to default
func _on_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(null)

# Detect which NPCs you've met
func met_character():
	if (Global.suspect_list.size() >= 4):
		pass
	if not self.name in Global.suspect_list:
		print("I am not in the suspect list already")
		if (met_this_character == true):    
			Global.NPC = self.name
			print("Met ", Global.NPC)
			# Add them to the suspect list
			Global.suspect_list.push_back(Global.NPC)
			print(Global.NPC, " has been added to the suspect list")
			print(Global.suspect_list)
			emit_signal("npc_added", Global.NPC)
	else:
		Global.NPC = self.name
