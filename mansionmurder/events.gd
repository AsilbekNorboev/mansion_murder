extends Node

signal room_entered(room)
signal puzzle_completed(puzzle1)

@onready var inventory_ui = $InventoryUI
@onready var suspects_ui =  preload("res://SuspectsUI.tscn").instantiate()
@onready var settings_ui = $SettingsUI

@onready var chef_accused_scene = preload("res://Accusation Scenes/chef_accused.tscn")
@onready var gardener_accused_scene = preload("res://Accusation Scenes/gardener_accused.tscn")
@onready var wife_accused_scene = preload("res://Accusation Scenes/wife_accused.tscn")
@onready var maid_accused_scene = preload("res://Accusation Scenes/maid_accused.tscn")

var textbox_scene = preload("res://textbox.tscn")
var accusation_scene
signal inventory_button_pressed

# CLUES:
#@onready var clue_deed = $Rooms/LivingRoom/Deed
#@onready var clue_envelope = $Rooms/Kitchen/Envelope
@onready var clue_dirt = $Rooms/Kitchen/Dirt
@onready var clue_knife = $Rooms/LivingRoom/Knife
#@onready var clue_necklace = $Rooms/Bedroom/Necklace
@onready var clue_diary = $Rooms/Bedroom/Diary
@onready var clue_gloves = $Rooms/Garden/gloves
@onready var clue_key = $Rooms/Garden/toolbox/Sprite2D2/key

@onready var clue_scene = preload("res://clue.tscn").instantiate()

var first_clue_found = false

# Preload clue sound effect
var clue_sound = preload("res://audio/ClueSFX.wav")

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
	#clue_envelope.clue_clicked.connect(self._on_clue_clicked)
	clue_dirt.clue_clicked.connect(self._on_clue_clicked)
	clue_knife.clue_clicked.connect(self._on_clue_clicked)
	#clue_necklace.clue_clicked.connect(self._on_clue_clicked)
	clue_diary.clue_clicked.connect(self._on_clue_clicked)
	clue_gloves.clue_clicked.connect(self._on_clue_clicked)
	clue_key.clue_clicked.connect(self._on_clue_clicked)

	# Initially hide the inventory UI
	inventory_ui.visible = false
	#connects the border buttons pressed signal to the corresonding button scenes
	var general_border_ui = $GeneralBorderUI
	general_border_ui.inventorybuttonpressed.connect(_on_inventory_button_pressed)
	general_border_ui.settingsbuttonpressed.connect(_on_settings_button_pressed)
	general_border_ui.suspectsbuttonpressed.connect(_on_suspects_button_pressed)
	
	Global.chef_button_pressed.connect(_on_chef_button_pressed)
	Global.wife_button_pressed.connect(_on_wife_button_pressed)
	Global.maid_button_pressed.connect(_on_maid_button_pressed)
	Global.gardener_button_pressed.connect(_on_gardener_button_pressed)

	Global.removing_self.connect(_on_removing_accusation_scene)
	
func _on_clue_clicked(clue_data):
	# Play clue sound
	play_clue_sound()

	# Add the clue to the inventory UI
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
		
#makes the ineventory screen visible
func _on_inventory_button_pressed():
	# Toggle visibility: if it's visible, hide it; if it's hidden, show it
	inventory_ui.visible = not inventory_ui.visible
	Global.emit_signal("inventory_button_pressed")

#makes the settings screen visible
func _on_settings_button_pressed():
	if (settings_ui.visible):
		#disable character movement while in settings
		get_tree().paused = false
		settings_ui.visible = not settings_ui.visible
	else:
		settings_ui.visible = not settings_ui.visible
		get_tree().paused = true

#makes the suspects screen visible
func _on_suspects_button_pressed():
	if ($SuspectsUI.visible):
		#disable character movement while in settings
		get_tree().paused = true
		$SuspectsUI.visible = not $SuspectsUI.visible
	else:
		$SuspectsUI.visible = not $SuspectsUI.visible
		get_tree().paused = false
	
func _on_chef_button_pressed() -> void:
	var accusation_scene = chef_accused_scene.instantiate()
	$"Accusation Scenes".add_child(accusation_scene)
	print(accusation_scene.get_path())

func _on_gardener_button_pressed() -> void:
	var accusation_scene = gardener_accused_scene.instantiate()
	$"Accusation Scenes".add_child(accusation_scene)
	print(accusation_scene.get_path())

func _on_wife_button_pressed() -> void:
	var accusation_scene = wife_accused_scene.instantiate()
	$"Accusation Scenes".add_child(accusation_scene)
	print(accusation_scene.get_path())

	
func _on_maid_button_pressed() -> void:
	var accusation_scene = maid_accused_scene.instantiate()
	$"Accusation Scenes".add_child(accusation_scene)
	print(accusation_scene.get_path())

func _on_removing_accusation_scene():
	print("removing accusation scene")
	
	if (get_node("Accusation Scenes/chef_accused")):
		get_node("Accusation Scenes/chef_accused").queue_free()
	if (get_node("Accusation Scenes/maid_accused")):
			get_node("Accusation Scenes/maid_accused").queue_free()
	if (get_node("Accusation Scenes/gardener_accused")):
		get_node("Accusation Scenes/gardener_accused").queue_free()
	if (get_node("Accusation Scenes/wife_accused")):
			get_node("Accusation Scenes/wife_accused").queue_free()
	else:
		print("node not found")
