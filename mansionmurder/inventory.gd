# inventory.gd
extends Node

@export var clues: Array[Resource] = []

# Adds a clue to the inventory
func add_clue(clue: Resource):
	clues.append(clue)
	display_clue(clue)

# Displays the clue in the UI
func display_clue(clue: Resource):
	var clue_ui = preload("res://ClueUI.tscn").instantiate()
	clue_ui.get_node("ClueName").text = clue.clue_name
	clue_ui.get_node("ClueDescription").text = clue.clue_description
	clue_ui.get_node("ClueIcon").texture = clue.clue_icon
	$ClueContainer.add_child(clue_ui)
