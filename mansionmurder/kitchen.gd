extends Node2D

func _on_player_detector_body_entered(body: Node2D) -> void:
	Events.room_entered.emit(self)


func _on_fish_button_pressed() -> void:
	$FishFlop.play()


func _on_knife_button_pressed() -> void:
	$"Colliders/Back Wall/KnifeButton"._dialog_start()
	
