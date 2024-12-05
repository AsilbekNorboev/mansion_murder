extends Node

signal room_entered(room)
signal puzzle_completed(puzzle1)

@onready var inventory_ui = $InventoryUI
@onready var suspects_ui =  preload("res://SuspectsUI.tscn").instantiate()
@onready var clue_node_safe = $Rooms/Bedroom/Safe
@onready var settings_ui = $SettingsUI
signal inventory_button_pressed
#signal suspects_button_pressed

# CLUES:
@onready var clue_deed = $Rooms/LivingRoom/Deed
@onready var clue_envelope = $Rooms/Kitchen/Envelope
@onready var clue_dirt = $Rooms/Kitchen/Dirt
@onready var clue_knife = $Rooms/LivingRoom/Knife
#@onready var clue_safe = $Rooms/Bedroom/Safe
@onready var clue_necklace = $Rooms/Bedroom/Necklace
@onready var clue_diary = $Rooms/Bedroom/Diary
@onready var clue_gloves = $Rooms/Garden/gloves
@onready var clue_key = $Rooms/Garden/toolbox/Sprite2D2/key

@onready var clue_scene = preload("res://clue.tscn").instantiate()

var first_clue_found = false

# Preload clue sound effect
var clue_sound = preload("res://audio/mixkit-casino-bling-achievement-2067.wav")  # Replace with your sound file path

# Add an AudioStreamPlayer for sound effects
var audio_player: AudioStreamPlayer

func _ready():
	$BackgroundLoop.play()
	
	# Add an AudioStreamPlayer node if not added in the editor
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	audio_player.stream = clue_sound  # Assign the sound effect

	# Connect all clue nodes to the same click handler
	clue_scene.clue_clicked.connect(self._on_clue_clicked)
	clue_envelope.clue_clicked.connect(self._on_clue_clicked)
	clue_dirt.clue_clicked.connect(self._on_clue_clicked)
	clue_knife.clue_clicked.connect(self._on_clue_clicked)
	clue_necklace.clue_clicked.connect(self._on_clue_clicked)
	clue_diary.clue_clicked.connect(self._on_clue_clicked)
	clue_gloves.clue_clicked.connect(self._on_clue_clicked)
	clue_key.clue_clicked.connect(self._on_clue_clicked)

	# Initially hide the inventory UI
	$InventoryUI.visible = false

func _on_clue_clicked(clue_data):
	# Play clue sound
	play_clue_sound()

	# Add the clue to the inventory UI
	print("Clue clicked with data:", clue_data)
	
	if clue_data not in InventoryManager.get_inventory():
		if !Global.first_clue_found:
			Global.first_clue_found = true
			#show_first_clue_message()
		InventoryManager.add_clue(clue_data)  # Add to inventory manager
		inventory_ui.add_clue(clue_data)  # Add to UI immediately

		# Call the function to hide the clue after it's clicked
		hide_clue(clue_data)

func play_clue_sound():
	if audio_player and audio_player.stream:
		audio_player.play()

func hide_clue(clue_data):
	# Check if the clue is a node and hide it
	if clue_data is Node:
		clue_data.queue_free()  # This removes the clue from the scene
	else:
		print("Error: Clue data is not a node!")
