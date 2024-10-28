extends Node

signal room_entered(room)
signal puzzle_completed(puzzle1)

@onready var inventory_ui = $InventoryUI
@onready var clue_node_safe = $LivingRoom/Safe


func new_game():
	print("game start")

func _ready():
	print(clue_node_safe)
	for clue_data in InventoryManager.get_inventory():
		inventory_ui.add_clue(clue_data)
	var general_border_ui = $GeneralBorderUI
	general_border_ui.inventorybuttonpressed.connect(_on_inventory_button_pressed)
	clue_node_safe.clue_clicked.connect(self._on_clue_clicked)
	$InventoryUI.visible = false

func _on_inventory_button_pressed():
	# Toggle visibility: if it's visible, hide it; if it's hidden, show it
	$InventoryUI.visible = not $InventoryUI.visible

func _on_clue_clicked(clue_data):
	# Add the clue to the inventory UI
	print("Clue clicked with data:", clue_data)
	if clue_data not in InventoryManager.get_inventory():
		InventoryManager.add_clue(clue_data)  # Add to inventory manager
		inventory_ui.add_clue(clue_data)  # Add to UI immediately
