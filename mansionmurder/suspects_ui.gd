extends CanvasLayer

@onready var clue_container = $ScrollContainer/ClueContainer
@onready var exit_button = $ExitButton

func _on_exit_button_pressed() -> void:
	print("exit button pressed")
	$ButtonClick.play()
	self.visible = false
	get_tree().paused = false
