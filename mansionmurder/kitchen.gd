extends Node2D

var cursor = preload("res://art/pointer.png")		
@onready var fridge_interior = self.get_node("Colliders/Back Wall/Fridge/fridge inside")

func _on_player_detector_body_entered(body: Node2D) -> void:
	Events.room_entered.emit(self)

func _input(event):
	if event.is_action_pressed("exit") and (fridge_interior.visible == true) :
		_on_exit_pressed()

func _on_fish_button_pressed() -> void:
	$FishFlop.play()


func _on_knife_button_pressed() -> void:
	$"Colliders/Back Wall/KnifeButton"._dialog_start()
	

func _on_fridge_pressed() -> void:
	fridge_interior.visible = true
	$"Colliders/Back Wall/exit".visible = true
	if (fridge_interior.visible == true):
		get_tree().paused = true

	
func _on_drawer_pressed() -> void:
	$"Colliders/Back Wall/drawer/drawer_inside".visible = true
	$"Colliders/Back Wall/drawer/card".visible = true
	$"Colliders/Back Wall/exit".visible = true
	$"Colliders/Back Wall/drawer/Shopping_list".visible = true

func _on_exit_pressed() -> void:
	get_tree().paused = false
	$"Colliders/Back Wall/drawer/drawer_inside".visible = false
	fridge_interior.visible = false
	$"Colliders/Back Wall/exit".visible = false
	$"Colliders/Back Wall/drawer/card".visible = false
	$"Colliders/Back Wall/drawer/Shopping_list".visible = false


func _on_fridge_mouse_entered() -> void:
	Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW, Vector2(16,16))

func _on_fridge_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(null)


func _on_drawer_mouse_entered() -> void:
	Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW, Vector2(16,16))


func _on_drawer_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(null)
