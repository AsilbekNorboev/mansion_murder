extends CanvasLayer

@onready var buttons = $GridContainer.get_children()  # Assuming buttons are direct children

const CORRECT_CODE = "05-05-50"  # Correct combination code
const CODE_LENGTH: int = 8        # Total length of the code (including "-")
var current_button_index: int = 0  # Index of the currently selected button

func _ready():
	$GridContainer.visible = false# Hide the grid and buttons initially
	$Instruction.visible = false
	$Hint.visible = false 
	$Button.text = "start"# Hide hint initially
	$Button.visible = true # Show the start button
	$CodeLabel.text = "Unlock the code using the clues collected"
	$CodeLabel.visible = true # Show the word label
	$ResultLabel.visible = true
	$Header.visible = true
	$ExitMessage.visible = true

func start_game():
	$CodeLabel.visible = false
	$GridContainer.visible = true
	$Instruction.visible = true
	$Button.visible = false
	$Hint.visible = true
	$ResultLabel.visible = false
	$ExitMessage.visible = true # Hide the exit message
	# Initialize buttons
	for i in range(buttons.size()):
		if i == 2 or i == 5:  # Button 3 and Button 6 (index 2 and 5)
			buttons[i].text = "-"  # Set these buttons to "-"
		else:
			buttons[i].text = "0"  # Set all other buttons to "0"
	
	current_button_index = 0  # Reset selected button index
	update_button_selection()  # Update selection on reset

func _input(event):
	# Check for ESC key to return to the Living Room scene
	#if event is InputEventKey and event.is_pressed() and event.keycode == KEY_ESCAPE:
		#self.visible = false # Switch to Living Room scene
	
		
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
		$CodeLabel.text = "Correct Code is 05-05-50"
		$ResultLabel.text = "Sucess"
		$CodeLabel.visible = true
		$GridContainer.visible = false
		$Instruction.visible = false
		$ResultLabel.visible = true
	else:
		$ResultLabel.text = "Incorrect code. Try again."
		_ready()
		

func _on_button_pressed() -> void:
	start_game()


func _on_button_2_pressed() -> void:
	print("")
