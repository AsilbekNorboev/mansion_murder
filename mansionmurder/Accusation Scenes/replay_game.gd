extends Button
@onready var inventory = preload("res://InventoryUI.tscn").instantiate()

func reset_game():
	print("resetting stats")
	Global.suspect_list.clear()
	inventory.clear_all_clues()
	get_tree().change_scene_to_file("res://main.tscn")

	
