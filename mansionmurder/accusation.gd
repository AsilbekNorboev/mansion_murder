extends Control

func _on_chef_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Accusation Scenes/chef_accused.tscn")

func _on_gardener_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Accusation Scenes/gardener_accused.tscn")

func _on_wife_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Accusation Scenes/wife_accused.tscn")

func _on_maid_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Accusation Scenes/maid_accused.tscn")
