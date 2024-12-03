extends CanvasLayer

var volume := 100


#waits a few seconds to allow the sound effect of the button to play
func wait(seconds: float) -> void:
	OS.delay_msec(seconds * 1000)
	

func _on_exit_game_pressed() -> void:
	$ButtonClick.play()
	wait(.5)
	get_tree().quit()


func _on_return_pressed() -> void:
	$ButtonClick.play()
	wait(.5)
	get_tree().change_scene_to_file("res://Introduction/main_menu.tscn")


func _on_mute_button_toggled(toggled_on: bool) -> void:
	# If toggled_on is true, mute the audio; otherwise, unmute
	if toggled_on:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
		print("Audio muted")
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
		print("Audio unmuted")
