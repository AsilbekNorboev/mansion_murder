extends Control

func _ready():
	print("active menu")
	#add_NPC_Container()

func add_NPC_Container():
	get_tree().call_group("Suspects", "met_character")
	if (Global.NPC != ("test NPC")):
		if (Global.NPC == "Wife"):
			$ScrollContainer/NPCContainer/Wife.show()
		if (Global.NPC == "Gardener"):
			$ScrollContainer/NPCContainer/Gardener.show()
		if (Global.NPC == "Chef"):
			$ScrollContainer/NPCContainer/Chef.show()
		if (Global.NPC == "Maid"):
			$ScrollContainer/NPCContainer/Maid.show()		
		#var new_filepath = ("$ScrollContainer/NPCContainer/") + (Global.NPC)
		#print(new_filepath)
		#new_filepath.hide()
		
#waits a few seconds to allow the sound effect of the button to play
func wait(seconds: float) -> void:
	OS.delay_msec(seconds * 1000)
	
func _on_chef_button_pressed() -> void:
	$ButtonClick.play()
	wait(.5)
	get_tree().change_scene_to_file("res://Accusation Scenes/chef_accused.tscn")

func _on_gardener_button_pressed() -> void:
	$ButtonClick.play()
	wait(.5)
	get_tree().change_scene_to_file("res://Accusation Scenes/gardener_accused.tscn")

func _on_wife_button_pressed() -> void:
	$ButtonClick.play()
	wait(.5)
	get_tree().change_scene_to_file("res://Accusation Scenes/wife_accused.tscn")

func _on_maid_button_pressed() -> void:
	$ButtonClick.play()
	wait(.5)
	get_tree().change_scene_to_file("res://Accusation Scenes/maid_accused.tscn")
