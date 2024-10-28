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
			tutorial_message = "Welcome to Mansion Murder! 
			As the detective, it's up to you to solve the chilling murder at Birmingham Mansion. 
			Explore the estate, interrogate suspects, gather clues, and crack the case before the killer strikes again!"
		2:
			tutorial_message = "Controls:
				Move around the mansion using the Arrow Keys or WASD.
				Click to interact with objects and examine your surroundings.
				Interrogate suspects by selecting dialogue options.
				Use your inventory to manage items and clues.
				Before you begin, talk to the chief detective to start your investigation
				Keep track of evidence—anything could crack the case!"
		3:
			tutorial_message = "Ready to Begin?\nThe mystery of Birmingham Mansion awaits!\nExplore the rooms, gather clues, and solve the murder.\nAre you ready to put your detective skills to the test?\nStep into the case and begin your journey—good luck, Detective!"
			$Button_Next.hide()

	$Label_Tutorial.text = tutorial_message

func _on_button_next_pressed() -> void:
	current_message_index += 1
	get_tutorial_string(current_message_index)	


func _on_button_previous_pressed() -> void:
	current_message_index -= 1
	get_tutorial_string(current_message_index)	

func _on_button_start_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
	#get_tree().change_scene_to_file("res://Tutorial_Demo/tutorial_demo.tscn")
