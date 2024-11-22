extends CanvasLayer

@onready var buttons = $GridContainer.get_children()
@onready var result_label: Label = $ResultLabel
@onready var word_label: Label = $WordLabel
@onready var start_button: Button = $Button
@onready var hint: Label = $Hint
@onready var instructions: Label = $Instructions
@onready var exit_label: Label = $ExitMessage
@onready var grid: GridContainer = $GridContainer

const SIZE = 5  # Word length
const MAX_ROWS = 5  # Maximum attempts
const WORDLE = "PIZZA"  # Correct answer

var wordle: String = ""
var index = 0  # Position of button text to be updated
var latest_row_index = 0
var row_filled = false
var current_row = 0  # Keep track of which row is being filled

# Called when the node enters the scene tree for the first time.
func _ready():
	$GridContainer.visible = false# Hide the grid and buttons initially
	$Instructions.visible = false
	$Instructions2.visible = false
	$Instructions3.visible = false  # Hide instructions initially
	$Hint.visible = false 
	$Button.text = "start"# Hide hint initially
	$Button.visible = true # Show the start button
	$WordLabel.visible = false  # Show the word label\
	print("we readuuu")
	

func _on_button_pressed() -> void:
	print("button clicked")
	$ButtonClick.play()
	start_game()
	
# Start the game and initialize the interface
func start_game():
	print("game started")
	$WordLabel.visible = true
	$GridContainer.visible = true
	$Instructions.visible = true
	$Instructions2.visible = true
	$Instructions3.visible = true
	$Button.visible = false
	$Hint.visible = true
	index = 0
	row_filled = false
	latest_row_index = 0
	current_row = 0
	$ResultLabel.visible = false
	$ExitMessage.visible = false # Hide the exit message
	$WordLabel.text = ""  # Reset the word label
	$ResultLabel.text = ""  # Reset the result label
	print("Wordle: ", wordle)
	# Reset button styles
	for button in buttons:
		init_button_styles(button)


func _input(event):
	# Check for ESC key to pause/unpause the game
	#if event is InputEventKey and event.is_pressed() and event.keycode == KEY_ESCAPE:
		
		#self.visible = false

	if event is InputEventKey and event.is_pressed():
		if event.keycode >= KEY_A and event.keycode <= KEY_Z:
			handle_letter_input(char(event.keycode))

	if Input.is_action_pressed("back"):
		handle_backspace()

	if Input.is_action_pressed("enter"):
		handle_enter()

func initialize_puzzle():
	# Initialize button styles and other game setup
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

func update_button_style(button: Button, bg_color: Color):
	var style = button.get_theme_stylebox("normal")
	style.bg_color = bg_color
	button.add_theme_stylebox_override("normal", style)

func handle_letter_input(letter: String):
	if not row_filled:
		buttons[index].text = letter
		index += 1

		if index % SIZE == 0:
			row_filled = true

func handle_backspace():
	if index > latest_row_index:
		index -= 1
		buttons[index].text = ""
		row_filled = false

func handle_enter():
	if row_filled:
		var won = check_win()
		latest_row_index = index
		row_filled = false
		current_row += 1

		if not won and current_row >= MAX_ROWS:
			check_loss()

func check_win() -> bool:
	var entered_text = ""
	for button in buttons.slice(latest_row_index, latest_row_index + SIZE):
		entered_text += button.text
	print("Entered Text:", entered_text)

	var idx = 0
	for button in buttons.slice(latest_row_index, latest_row_index + SIZE):
		if entered_text[idx] == WORDLE[idx]:
			update_button_style(button, Color.SEA_GREEN)
		elif entered_text[idx] in WORDLE:
			update_button_style(button, Color.CHOCOLATE)
		else:
			update_button_style(button, Color.CRIMSON)
		idx += 1

	if entered_text == WORDLE:
		$ResultLabel.visible = true
		$ResultLabel.text = "Puzzle Solved!"
		word_label.text = "Correct Word: " + WORDLE
		$GridContainer.visible = false# Hide the grid and buttons initially
		$Instructions.visible = false
		$Instructions2.visible = false
		$Instructions3.visible = false  # Hide instructions initially
		$Hint.visible = false 
		$ExitMessage.visible = true
		return true

	return false

func check_loss():
	$ResultLabel.text = "You Lost!"
	$ResultLabel.visible = true
	$ExitMessage.visible = true
	word_label.text = "try again"
	_ready()
 # Hide the puzzle layer



func _on_button_2_pressed() -> void:
	print("") # Replace with function body.
