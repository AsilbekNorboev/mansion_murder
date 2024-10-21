extends Node2D
var spawn_position = Vector2.ZERO 

func _on_player_detector_body_entered(body: Node2D) -> void:
	Events.room_entered.emit(self)
