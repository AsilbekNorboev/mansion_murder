extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.room_entered.connect(func(room):
		var room_center_maker = room.get_node("Marker2D")
		global_position = room_center_maker.global_position)
