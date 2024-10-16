extends Node

signal room_entered(room)
signal puzzle_completed(puzzle1)

@onready var inventory_ui = $InventoryUI
@onready var clue_node = $AddClue
@onready var clue_node2 = $AddClue2

func _on_clue_clicked(clue_data):
	# Add the clue to the inventory UI
	inventory_ui.add_clue(clue_data)
	

func new_game():
	print("game start")


func _ready():
	clue_node.clue_clicked.connect(self._on_clue_clicked)
	clue_node2.clue_clicked.connect(self._on_clue_clicked)
	var general_border_ui = $GeneralBorderUI
	general_border_ui.inventorybuttonpressed.connect(_on_inventory_button_pressed)
	$InventoryUI.visible = false


func _on_inventory_button_pressed():
	# Toggle visibility: if it's visible, hide it; if it's hidden, show it
	$InventoryUI.visible = not $InventoryUI.visible
