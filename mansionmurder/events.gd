extends Node

signal room_entered(room)
signal puzzle_completed(puzzle1)

@onready var inventory_ui = $InventoryUI
@onready var clue_node_safe = $Rooms/Bedroom/Safe
@onready var settings_ui = $SettingsUI

# CLUES:
@onready var clue_deed = $Rooms/LivingRoom/Deed
@onready var clue_envelope = $Rooms/Kitchen/Envelope
@onready var clue_dirt = $Rooms/Kitchen/Dirt
@onready var clue_knife = $Rooms/LivingRoom/Knife
@onready var clue_safe = $Rooms/Bedroom/Safe
@onready var clue_necklace = $Rooms/Bedroom/Necklace
@onready var clue_diary = $Rooms/Bedroom/Diary
@onready var clue_gloves = $Rooms/Garden/gloves
@onready var clue_key = $Rooms/Garden/key

@onready var clue_scene = preload("res://clue.tscn").instantiate()


func new_game():
	print("game start")

func _ready():
	clue_scene.main_add_zoom_scene.connect(_on_normal_clue_clicked)

	# Print clue node info
	# print(clue_node_safe)

	# Add any existing inventory items to the UI
	for clue_data in InventoryManager.get_inventory():
		inventory_ui.add_clue(clue_data)
	
	var general_border_ui = $GeneralBorderUI
	general_border_ui.inventorybuttonpressed.connect(_on_inventory_button_pressed)
	general_border_ui.settingsbuttonpressed.connect(_on_settings_button_pressed)
	
	# Connect all clue nodes to the same click handler
	clue_node_safe.clue_clicked.connect(self._on_clue_clicked)
	clue_scene.clue_clicked.connect(self._on_clue_clicked)
	clue_deed.clue_clicked.connect(self._on_clue_clicked)
	clue_envelope.clue_clicked.connect(self._on_clue_clicked)
	clue_dirt.clue_clicked.connect(self._on_clue_clicked)
	clue_knife.clue_clicked.connect(self._on_clue_clicked)
	clue_safe.clue_clicked.connect(self._on_clue_clicked)
	clue_necklace.clue_clicked.connect(self._on_clue_clicked)
	clue_diary.clue_clicked.connect(self._on_clue_clicked)
	clue_gloves.clue_clicked.connect(self._on_clue_clicked)
	clue_key.clue_clicked.connect(self._on_clue_clicked)

	# Initially hide the inventory UI
	$InventoryUI.visible = false

func _on_inventory_button_pressed():
	# Toggle visibility: if it's visible, hide it; if it's hidden, show it
	$InventoryUI.visible = not $InventoryUI.visible

func _on_settings_button_pressed():
	$SettingsUI.visible = not $SettingsUI.visible

func _on_clue_clicked(clue_data):
	# Add the clue to the inventory UI
	print("Clue clicked with data:", clue_data)
	
	if clue_data not in InventoryManager.get_inventory():
		InventoryManager.add_clue(clue_data)  # Add to inventory manager
		inventory_ui.add_clue(clue_data)  # Add to UI immediately

		# Call the function to hide the clue after it's clicked
		hide_clue(clue_data)

func hide_clue(clue_data):
	# Check if the clue is a node and hide it
	if clue_data is Node:
		clue_data.queue_free()  # This removes the clue from the scene
	else:
		print("Error: Clue data is not a node!")

func _on_normal_clue_clicked():
	print("Zoom launched in main")
	clue_scene.add_zoom_scene()

	# Adding the zoom scene as a child to main
	# new_zoom_node.connect("add_zoom_scene")
	# Assigning variable for ease
	# var main_zoom_scene = clue_scene.zoom_scene
	# Instantiating the clue scene and grabbing the specified zoom image from it
	# main_zoom_scene = load(clue_scene.zoom_image).instantiate()
	#
	# new_zoom_node = main_zoom_scene
	# Adding the zoom scene as a child to main
	# new_zoom_node.connect("add_zoom_scene")
	# new_zoom_node.add_zoom_scene()
