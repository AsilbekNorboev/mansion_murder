extends Control

var current_message_index: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tutorial_string(current_message_index)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_tutorial_string(string_index: int) -> void:
	var tutorial_message: String = ""
		
	$Button_Next.show()
	$Button_Previous.show()
		
	match string_index:
		1:
			$Button_Previous.hide()
			tutorial_message = "Message 1"
		2:
			tutorial_message = "Message 2"
		3:
			tutorial_message = "Message 3"
			$Button_Next.hide()

	$Label_Tutorial.text = tutorial_message

func _on_button_next_pressed() -> void:
	current_message_index += 1
	get_tutorial_string(current_message_index)	


func _on_button_previous_pressed() -> void:
	current_message_index -= 1
	get_tutorial_string(current_message_index)	

func _on_button_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Tutorial_Demo/tutorial_demo.tscn")
