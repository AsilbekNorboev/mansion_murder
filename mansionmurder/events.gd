extends Node


signal room_entered(room)

func new_game():
	print("game start")
	#$Audio.play()


func _ready():
	var general_border_ui = $GeneralBorderUI
	general_border_ui.inventorybuttonpressed.connect(_on_inventory_button_pressed)
	$InventoryUI.visible = false


func _on_inventory_button_pressed():
	# Toggle visibility: if it's visible, hide it; if it's hidden, show it
	$InventoryUI.visible = not $InventoryUI.visible
