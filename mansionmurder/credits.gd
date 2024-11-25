extends CanvasLayer

#waits a few seconds to allow the sound effect of the button to play
func wait(seconds: float) -> void:
	OS.delay_msec(seconds * 1000)

func _on_return_pressed() -> void:
	$ButtonClick.play()
	wait(.5)
	get_tree().change_scene_to_file("res://Introduction/main_menu.tscn")
