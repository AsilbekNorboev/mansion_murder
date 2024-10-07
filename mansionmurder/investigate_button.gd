extends Button

var cursor = preload("res://art/pointer.png")

func _on_investigate_clicked() -> void:
	Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW, Vector2(16,16))

#func _input(event):
	#if event is InputEventMouseMotion:
		#if get_global_mouse_position().x >= 512:
			#Input.set_custom_mouse_cursor(null)
		#else:
			#Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW, Vector2(16,16))
