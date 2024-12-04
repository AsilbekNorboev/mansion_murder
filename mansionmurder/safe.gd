extends Area2D
# Preload the puzzle scene
@onready var collision_shape = $CollisionShape2D
@onready var safe_puzzle = $Safe_puzzle  # Assuming safe_puzzle is a child node
@onready var buttons =$Safe_puzzle/GridContainer.get_children()  # Assuming buttons are direct children
var game_openned: bool = false
var game_won: bool = false
const CORRECT_CODE = "05-05-50"  # Correct combination code
const CODE_LENGTH: int = 8        # Total length of the code (including "-")
var current_button_index: int = 0  # Index of the currently selected button

func _ready():
	# Ensure the puzzle is not visible at the start
	$Safe_puzzle.visible = false
	$Sprite2D2.visible = false
	$Safe_puzzle.set_process(false)
	$Sprite2D2/gloves.position = Vector2(-1480000000.273, -8800000000.098)

func start_game():
	$Safe_puzzle/CodeLabel.visible = false
	$Safe_puzzle/GridContainer.visible = true
	$Safe_puzzle/Instruction.visible = true
	$Safe_puzzle/Button.visible = false
	$Safe_puzzle/Hint.visible = true
	$Safe_puzzle/ResultLabel.visible = false
	$Safe_puzzle/ExitMessage.visible = true # Hide the exit message
	# Initialize buttons
	for i in range(buttons.size()):
		if i == 2 or i == 5:  # Button 3 and Button 6 (index 2 and 5)
			buttons[i].text = "-"  # Set these buttons to "-"
		else:
			buttons[i].text = "0"  # Set all other buttons to "0"
	
	current_button_index = 0  # Reset selected button index
	update_button_selection()  # Update selection on reset




func game_open():
	hide_safe()
	if (game_won == true) and (game_openned == true):
		game_won_state()
	elif (game_won == false) and (game_openned == true):
		game_openned_state()
	elif (game_won == false) and (game_openned == false):
		ready_state()
	else:
		ready_state()
	
	
	
	
func _input(event):
	# Handle mouse click to toggle the puzzle
	if Input.is_action_just_pressed("click"):
		var global_mouse_position = get_viewport().get_camera_2d().get_global_mouse_position()
		var local_mouse_position = to_local(global_mouse_position)  # Convert to local coordinates

		if collision_shape.shape and collision_shape.shape is RectangleShape2D:
			var rect = Rect2(collision_shape.position - collision_shape.shape.extents, collision_shape.shape.extents * 2)
			if rect.has_point(local_mouse_position):
				$Sprite2D.visible = false
				if !$Safe_puzzle:
					$Sprite2D2.visible = true
					get_tree().paused = true
				else:
					$Safe_puzzle.set_process_input(true)
					$Sprite2D2.visible = false
					$Safe_puzzle.visible = true
					$Safe_puzzle.set_process(true)
					game_open()
					get_tree().paused = true
					
	if safe_puzzle == null:
		if event.is_action_pressed("ui_cancel"):
			$Sprite2D2.visible = false
			$Sprite2D.visible = true
			get_tree().paused = false
	else:
		if $Safe_puzzle.visible  == true:
			if event.is_action_pressed("ui_cancel"):
				$Safe_puzzle.visible = false
				$Sprite2D2.visible = false
				$Sprite2D2/gloves.position = Vector2(-1480000000.273, -8800000000.098)
				$Sprite2D.visible = true
				get_tree().paused = false
			if event.is_action_pressed("ui_up"):
				increment_number()
			elif event.is_action_pressed("ui_down"):
				decrement_number()
			elif event.is_action_pressed("ui_left"):
				navigate_left()
			elif event.is_action_pressed("ui_right"):
				navigate_right()
			elif event.is_action_pressed("ui_accept"):
				check_code()  # Check the code when confirmed
		



func increment_number():
	match current_button_index:
		0:  # Button 1 - Month's first digit (0 or 1)
			update_button_value(0, 1)
		1:  # Button 2 - Month's second digit
			if int(buttons[0].text) == 0:
				update_button_value(1, 9)  # 01-09
			else:
				update_button_value(0, 2)  # 10-12
		3:  # Button 3 - Day's first digit
			update_button_value(0, 3)
		4:  # Button 4 - Day's second digit
			if int(buttons[3].text) < 3:
				update_button_value(0, 9)  # 01-29 for typical months
			else:
				update_button_value(0, 1)  # 30 or 31
		6, 7:  # Year slots (each digit 0-9)
			update_button_value(0, 9)

func decrement_number():
	match current_button_index:
		0:  # Button 1 - Month's first digit (0 or 1)
			update_button_value(0, 1, true)
		1:  # Button 2 - Month's second digit
			if int(buttons[0].text) == 0:
				update_button_value(1, 9, true)  # 01-09
			else:
				update_button_value(0, 2, true)  # 10-12
		3:  # Button 3 - Day's first digit
			update_button_value(0, 3, true)
		4:  # Button 4 - Day's second digit
			if int(buttons[3].text) < 3:
				update_button_value(0, 9, true)  # 01-29 for typical months
			else:
				update_button_value(0, 1, true)  # 30 or 31
		6, 7:  # Year slots (each digit 0-9)
			update_button_value(0, 9, true)

func update_button_value(min_val: int, max_val: int, decrement: bool=false):
	var current_value = int(buttons[current_button_index].text)
	current_value += -1 if decrement else 1
	if current_value < min_val:
		current_value = max_val
	elif current_value > max_val:
		current_value = min_val
	buttons[current_button_index].text = str(current_value)

func navigate_left():
	if current_button_index > 0:
		current_button_index -= 1
		update_button_selection()

func navigate_right():
	if current_button_index < buttons.size() - 1:
		current_button_index += 1
		update_button_selection()

func update_button_selection():
	# Clear previous selections
	for i in range(buttons.size()):
		buttons[i].modulate = Color(1, 1, 1)  # Reset all to white (normal color)
	# Highlight the currently selected button
	buttons[current_button_index].modulate = Color(0.5, 0.5, 1)  # Change color to indicate selection


func check_code():
	var entered_code = ""
	for button in buttons:
		entered_code += button.text  # Collect the text from each button

	if entered_code == CORRECT_CODE:
		game_won = true
		game_won_state()
		$Sprite2D2/gloves.set_process(true)
	else:
		$Safe_puzzle/ResultLabel.text = "Incorrect code. Try again."
		await get_tree().create_timer(1.0).timeout
		ready_state()

func ready_state():
	$Safe_puzzle/ColorRect.visible = true
	$Safe_puzzle/GridContainer.visible = false# Hide the grid and buttons initially
	$Safe_puzzle/Instruction.visible = false
	$Safe_puzzle/Hint.visible = false 
	$Safe_puzzle/Button.text = "start"# Hide hint initially
	$Safe_puzzle/Button.visible = true # Show the start button
	$Safe_puzzle/CodeLabel.text = "Unlock the code using the clues collected"
	$Safe_puzzle/CodeLabel.visible = true # Show the word label
	$Safe_puzzle/ResultLabel.visible = true
	$Safe_puzzle/Header.visible = true
	$Safe_puzzle/ExitMessage.visible = true
	

func game_openned_state():
	get_tree().paused = false
	$Safe_puzzle.visible = true
	$Safe_puzzle/CodeLabel.visible = false
	$Safe_puzzle/GridContainer.visible = true
	$Safe_puzzle/Instruction.visible = true
	$Safe_puzzle/Button.visible = false
	$Safe_puzzle/Hint.visible = true
	$Safe_puzzle/ResultLabel.visible = false
	$Safe_puzzle/ExitMessage.visible = true 
	print("can you see me")

func game_won_state():
	$Safe_puzzle/CodeLabel.text = "Correct Code is 05-05-50"
	$Safe_puzzle/ResultLabel.text = "Sucess"
	$Safe_puzzle/CodeLabel.visible = true
	$Safe_puzzle/GridContainer.visible = false
	$Safe_puzzle/Instruction.visible = false
	$Safe_puzzle/ResultLabel.visible = true
	await get_tree().create_timer(1.0).timeout
	$Safe_puzzle.queue_free()
	if !$Sprite2D2/gloves:
		$Sprite2D2.visible = true
	else:
		show_clue()
	
	
func show_clue():
	$Safe_puzzle.visible = false
	$Sprite2D2/gloves.position = Vector2(-89.11, -111.502)
	$Safe_puzzle.visible = false
	$Sprite2D2.visible = true
	$Sprite2D2/gloves.visible = true
	
func hide_safe():
	$Sprite2D.visible = false
	$CollisionShape2D.visible = false


func _on_button_pressed() -> void:
	start_game()
	game_openned = true
	
func _on_button_2_pressed() -> void:
	print("")


func _on_buttonblock_pressed() -> void:
	print("")
