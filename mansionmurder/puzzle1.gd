extends Node2D

@onready var buttons = $GridContainer.get_children()
@onready var menu = $Menu
@onready var label:Label = $Menu/ResultLabel
@onready var word_label:Label = $Menu/WordLabel

const SIZE = 5
const MAX_ROWS = 5

var wordle:String = ""
var index = 0 # Position of button text to be updated
var latest_row_index = 0
var row_filled = false
var current_row = 0  # Keep track of which row is being filled

# Called when the node enters the scene tree for the first time.
func _ready():
	reset_game()

func _input(event):
	# Check for ESC key to return to the Living Room scene
	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_ESCAPE:
		get_tree().change_scene_to_file("res://main.tscn")  # Switch to Living Room scene
	
	# Don't start game until menu is visible
	if menu.visible:
		return
	

		
	if event is InputEventKey and event.is_pressed():
		if event.keycode >= KEY_A and event.keycode <= KEY_Z:
			var letter = char(event.keycode)
			print("Letter:", letter)
			
			if not row_filled:
				buttons[index].text = letter
				index += 1

				if index != 0 and index % SIZE == 0:
					row_filled = true
			
	if Input.is_action_pressed("back"):
		if index > latest_row_index:
			index -= 1
			buttons[index].text = ""
			row_filled = false

	if Input.is_action_pressed("enter"):
		# Only check win when an entire row is filled
		if row_filled:
			# Check for win before checking for loss
			var won = check_win()

			latest_row_index = index
			row_filled = false
			current_row += 1  # Move to the next row

			# If the player hasn't won and all rows are filled, check for loss
			if not won and current_row >= MAX_ROWS:
				check_loss()

func reset_game():
	index = 0
	row_filled = false
	latest_row_index = 0
	current_row = 0
	word_label.text = ""
	label.text = ""
	wordle = get_random_wordle()
	print("Wordle: ", wordle)
	for button in buttons:
		init_button_styles(button)

func init_button_styles(b: Button):
	b.text = ""
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0, 0, 0, 0)
	style.border_color = Color.DIM_GRAY
	style.border_width_bottom = 2
	style.border_width_top = 2
	style.border_width_left = 2
	style.border_width_right = 2
	b.add_theme_stylebox_override("normal", style)

func update_button_style(button:Button, bg_color:Color):
	var style = button.get_theme_stylebox("normal")
	style.bg_color = bg_color
	button.add_theme_stylebox_override("normal", style)

func get_random_wordle():
	var file = FileAccess.open("res://wordle-list.txt", FileAccess.READ)
	var content = file.get_as_text(true)
	var lines = content.split("\n")
	var new_lines = []
	for line in lines:
		if line.length() == 0 or line == "" or line.strip_edges() == "":
			continue
		else:
			new_lines.append(line)
	randomize()
	return new_lines.pick_random().to_upper()

func check_win() -> bool:
	# Extract text from the last filled row
	var entered_text = ""
	for button in buttons.slice(latest_row_index, latest_row_index + SIZE):
		entered_text += button.text
	print("Entered Text:", entered_text)
	
	var idx = 0
	# Update button colors based on comparison with the wordle
	for button in buttons.slice(latest_row_index, latest_row_index + SIZE):
		if entered_text[idx] == wordle[idx]:
			update_button_style(button, Color.SEA_GREEN)
		elif entered_text[idx] in wordle:
			update_button_style(button, Color.CHOCOLATE)
		else:
			update_button_style(button, Color.CRIMSON)
		idx += 1
	
	# Check win condition
	if entered_text == wordle:
		label.text = "Unlocked!!"
		word_label.text = "Correct Word: " + entered_text
		menu.show()
		return true

	return false

func check_loss():
	# If we've filled all rows and haven't won, the player loses
	if index == buttons.size():
		label.text = "You Lost!"
		word_label.text = "Correct Word: " + wordle
		menu.show()

func _on_button_pressed():
	menu.hide()
	reset_game()
