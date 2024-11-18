extends CanvasLayer

# Constants
const CHAR_RATE = 0.075

# Nodes
@onready var textbox_container = $TextboxContainer
@onready var start_symbol = $TextboxContainer/MarginContainer/HBoxContainer/Start
@onready var end_symbol = $TextboxContainer/MarginContainer/HBoxContainer/End
@onready var label = $TextboxContainer/MarginContainer/HBoxContainer/Text
@onready var replay_game_button = $"Replay Game"
@onready var exit_game_button = $"Exit Game"
@onready var skip_label = $SkipLabel


@onready var animated_sprite = $Sprite

# Signals
signal dialogue_finished

# Enums
enum State {
	READY,
	READING,
	FINISHED
}

# Variables
var state: State = State.READY
var text_queue: Array = []
var tween: Tween

# Initialization
func _ready():
	_hide_textbox()
	replay_game_button.hide()
	_detect_NPC()

	# Start displaying the first queued dialogue
	_display_text()
	animated_sprite.animation = "idle"
	animated_sprite.play()

func _detect_NPC():
	if (self.name == "chef_accused"):
		_queue_text("I didn't do anything, you've got the wrong guy!")
		
	if (self.name == "gardener_accused"):
		_queue_text("I'm not a killer, I'm a gardener.")
		
	if (self.name == "maid_accused"):
		_queue_text("I am the maid, I'm innocent!")
		
	if (self.name == "wife_accused"):
		_queue_text("I am the killer! You caught me :(")

func _process(delta):
	match state:
		State.READING:
			if Input.is_action_just_pressed("dialogue_next"):
				_finish_dialogue()
		State.FINISHED:
			if Input.is_action_just_pressed("dialogue_next"):
				if text_queue.is_empty():
					_hide_textbox()
					change_state(State.READY)
					skip_label.hide()
					replay_game_button.show()
					emit_signal("dialogue_finished")
				else:
					change_state(State.READY)  # Prepare to load the next line
					_display_text()  # Display the next dialogue line

# Public Functions
func _queue_text(new_text: String):
	text_queue.push_back(new_text)

# Private Functions
func _hide_textbox():
	start_symbol.text = ""
	end_symbol.text = ""
	label.text = ""
	label.visible_ratio = 0
	textbox_container.hide()

func _show_textbox():
	start_symbol.text = "*"
	textbox_container.show()

func _display_text():
	if state != State.READY or text_queue.is_empty():
		return
	
	var current_text = text_queue.pop_front()
	label.text = current_text
	label.visible_ratio = 0  # Reset visible ratio for the new text
	_show_textbox()
	change_state(State.READING)

	# Create a new tween for each dialogue line
	tween = create_tween()  # Create a new tween
	tween.tween_property(label, "visible_ratio", 1, current_text.length() * CHAR_RATE)
	tween.finished.connect(_on_Tween_tween_completed)

func _finish_dialogue():
	# Stop all animations on the tween
	if tween and tween.is_running():
		tween.stop()
	label.visible_ratio = 1
	end_symbol.text = "v"
	change_state(State.FINISHED)

# State Management
func change_state(next_state: State):
	state = next_state

# Handle Tween Completion
func _on_Tween_tween_completed(object, key):
	end_symbol.text = "v"
	change_state(State.FINISHED)

#waits a few seconds to allow the sound effect of the button to play
func wait(seconds: float) -> void:
	OS.delay_msec(seconds * 1000)
	
func _on_replay_game_pressed() -> void:
	$ButtonClick.play()
	wait(.5)
	get_tree().change_scene_to_file("res://main.tscn")

func _on_exit_game_pressed() -> void:
	$ButtonClick.play()
	wait(.5)
	get_tree().quit()
