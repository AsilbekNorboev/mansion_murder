extends Button

var cursor = preload("res://art/pointer.png")

func _on_investigate_clicked() -> void:
	Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW, Vector2(16,16))
