extends Node

signal room_entered(room)
signal puzzle_completed(puzzle1)

@onready var inventory_ui = $InventoryUI
@onready var clue_node_safe = $Rooms/Bedroom/Safe 
@onready var settings_ui = $SettingsUI

@onready var clue_scene = preload("res://clue.tscn").instantiate()

#@onready var zoom_current_node =  get_tree().current_scene.scene_file_path

#empty node
#@onready var new_zoom_node = $Rooms

func new_game():
	print("game start")

func _ready():
	
	clue_scene.main_add_zoom_scene.connect(_on_normal_clue_clicked)

	#print(clue_node_safe)
	for clue_data in InventoryManager.get_inventory():
		inventory_ui.add_clue(clue_data)
	var general_border_ui = $GeneralBorderUI
	general_border_ui.inventorybuttonpressed.connect(_on_inventory_button_pressed)
	general_border_ui.settingsbuttonpressed.connect(_on_settings_button_pressed)
	clue_node_safe.clue_clicked.connect(self._on_clue_clicked)
	clue_scene.clue_clicked.connect(self._on_clue_clicked)

	#clue_scene.connect("normal_clue_clicked", new_zoom_node, "_on_normal_clue_clicked")
	
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


func _on_normal_clue_clicked():
	print("zoom launched in main")
	
	clue_scene.add_zoom_scene()


	#adding the zoom scene as a child to main
	#new_zoom_node.connect("add_zoom_scene")
	#assinging variable for ease
	#var main_zoom_scene = clue_scene.zoom_scene
	##instantiating the clue scene and grabbing the specified zoom image from it
	#main_zoom_scene = load(clue_scene.zoom_image).instantiate()
	#
	#new_zoom_node = main_zoom_scene
	##adding the zoom scene as a child to main
	#new_zoom_node.connect("add_zoom_scene")
	#new_zoom_node.add_zoom_scene()
#
