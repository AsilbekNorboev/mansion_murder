extends Control

func _ready():
	# Add a check or connect if you are using a signal for updates
	if Global.has_signal("npc_added"):
		Global.npc_added.connect(_on_npc_added)
	Global.inventory_button_pressed.connect(_on_inventory_button_pressed)
	Global.suspects_button_pressed.connect(_on_suspects_button_pressed)

		
func _on_suspects_button_pressed():
	add_NPC_Container()
	
func _on_inventory_button_pressed():
	add_NPC_Container()
	
func add_NPC_Container():
	#get_tree().call_group("Suspects", "met_character")
	if (Global.NPC != ("test NPC")):
			if (Global.NPC == "Wife"):
				$NPCContainer/Wife.show()
			if (Global.NPC == "Gardener"):
				$NPCContainer/Gardener.show()
			if (Global.NPC == "Chef"):
				$NPCContainer/Chef.show()
			if (Global.NPC == "Maid"):
				$NPCContainer/Maid.show()		
		#var new_filepath = ("$ScrollContainer/NPCContainer/") + (Global.NPC)
		#new_filepath.hide()
func _on_npc_added(npc_name: String):
	print("NPC added: ", npc_name)
	add_NPC_Container()
#waits a few seconds to allow the sound effect of the button to play
func wait(seconds: float) -> void:
	OS.delay_msec(seconds * 1000)
	
func _on_chef_button_pressed() -> void:
	$ButtonClick.play()
	wait(.5)
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Accusation Scenes/chef_accused.tscn")

func _on_gardener_button_pressed() -> void:
	$ButtonClick.play()
	wait(.5)
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Accusation Scenes/gardener_accused.tscn")

func _on_wife_button_pressed() -> void:
	$ButtonClick.play()
	wait(.5)
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Accusation Scenes/wife_accused.tscn")

func _on_maid_button_pressed() -> void:
	$ButtonClick.play()
	wait(.5)
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Accusation Scenes/maid_accused.tscn")
