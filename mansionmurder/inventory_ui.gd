extends CanvasLayer

@onready var clue_container = $ScrollContainer/ClueContainer
@onready var exit_button = $ExitButton

func add_clue(clue_data: Dictionary):
	print("Adding clue to inventory:", clue_data)

	var clue_scene = preload("res://clue_item.tscn")  # Path to your clue item scene
	var clue_item = clue_scene.instantiate()  # Instance the clue item scene

	# Assuming your clue item scene has a method to set data
	clue_item.set_data(clue_data)  # Pass c
	clue_container.add_child(clue_item)


func _on_exit_button_pressed() -> void:
	print("exit button pressed")
	$ButtonClick.play()
	self.visible = false


func _on_switch_button_pressed() -> void:
	$ButtonClick.play()
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
