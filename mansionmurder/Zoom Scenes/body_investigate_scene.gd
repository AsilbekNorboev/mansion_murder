extends Node2D

func _input(event):
	# Check for ESC key to return to the Living Room scene
	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_ESCAPE:
		get_tree().change_scene_to_file("res://main.tscn")  # Switch to Living Room scene


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")  # Switch to Living Room scene
