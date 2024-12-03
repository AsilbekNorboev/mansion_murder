extends CanvasLayer

@onready var clue_container = $ScrollContainer/ClueContainer
@onready var exit_button = $ExitButton


func _on_exit_button_pressed() -> void:
	print("exit button pressed")
	$ButtonClick.play()
	self.visible = false
	get_tree().paused = false


func _on_switch_button_pressed() -> void:
	$InventoryOpenSfx.play()
	#on click, accusation menu will populate with new suspects you've met
	$AccusationMenu.add_NPC_Container()
	if $SwitchButton.text == "Inventory":
		$AccusationMenu.visible = false
		$ScrollContainer/ClueContainer.visible = true
		$SwitchButton.text = "Suspects"
	else:
		$AccusationMenu.visible = true
		$ScrollContainer/ClueContainer.visible = false
		$SwitchButton.text = "Inventory"
