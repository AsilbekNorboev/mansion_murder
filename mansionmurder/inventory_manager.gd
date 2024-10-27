extends Node

var clue_inventory = []

func add_clue(clue_data: Dictionary):
	# Avoid duplicate clues
	if clue_data not in clue_inventory:
		clue_inventory.append(clue_data)

func get_inventory():
	return clue_inventory
