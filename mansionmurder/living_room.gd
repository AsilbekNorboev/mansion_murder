extends Node2D

func _on_player_detector_body_entered(body: Node2D) -> void:
	Events.room_entered.emit(self)


func _on_piano_button_pressed() -> void:
	$Piano.play() # Replace with function body.
