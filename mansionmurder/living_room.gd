extends Node2D

func _on_player_detector_body_entered(body: Node2D) -> void:
	Events.room_entered.emit(self)

#piano makes sound on click
func _on_piano_button_pressed() -> void:
	$Piano.play() # Replace with function body.

#you can't leave yet message plays
func _on_entrance_door_button_pressed() -> void:
	$"Colliders/Lower Wall Collider/EntranceDoorButton"._dialog_start()
