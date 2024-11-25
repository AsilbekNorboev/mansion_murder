extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#waits a few seconds to allow the sound effect of the button to play
func wait(seconds: float) -> void:
	OS.delay_msec(seconds * 1000)
	
#BUTTONS------------------------------------
func _on_start_game_pressed() -> void:
	$ButtonClick.play()
	wait(.5)
	get_tree().change_scene_to_file("res://Introduction/introduction.tscn")


func _on_options_pressed() -> void:
	$ButtonClick.play()
	wait(.5)
	get_tree().change_scene_to_file("res://settings_ui.tscn")


func _on_exit_pressed() -> void:
	$ButtonClick.play()
	wait(.5)
	get_tree().quit()


func _on_credits_pressed() -> void:
	$ButtonClick.play()
	wait(.5)
	get_tree().change_scene_to_file("res://credits.tscn")
