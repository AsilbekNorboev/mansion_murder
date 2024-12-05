extends CanvasLayer

# Constants
const CHAR_RATE = 0.075

# Nodes
@onready var textbox_container = $TextboxContainer
@onready var start_symbol = $TextboxContainer/MarginContainer/HBoxContainer/Start
@onready var end_symbol = $TextboxContainer/MarginContainer/HBoxContainer/End
@onready var label = $TextboxContainer/MarginContainer/HBoxContainer/Text
@onready var skip_label = $SkipLabel
@onready var animated_sprite = $Sprite
@onready var winlose_text = $"Game Title"
#buttons
@onready var replay_game_button = $"Replay Game"
@onready var exit_game_button = $"Exit Game"
@onready var return_button = $Return
@onready var guilty_button = $Guilty
@onready var innocent_button = $Innocent

@onready var guilty_selected = 0

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
	#get_tree().paused
	_hide_textbox()
	_detect_NPC()

	# Start displaying the first queued dialogue
	_display_text()
	animated_sprite.animation = "idle"
	animated_sprite.play()

func _detect_NPC():
	var npc_clue_list = []
	
	#CHEF CONDITIONS
	if (self.name == "chef_accused"):
		npc_clue_list = _detect_NPC_text("res://chefdialogue.gd")
		_queue_text("Detective: Chef, remind me, where were you at 9:32 PM?")
		_queue_text("Chef Sordanio: 9:32 PM? I was in the kitchen, cutting fish for tomorrow’s special. The music was blasting, and I was chopping so loud, I wouldn’t have heard a thing if someone walked in.")
		
		if "Knife" in npc_clue_list:
			_queue_text("Detective: The knife used in the murder came from your kitchen. How do you explain that?")
			_queue_text("Chef Sordanio: Yeah, the knife’s from my kitchen, but I didn’t use it. I was focused on cutting fish and had the music cranked up. I didn’t hear or see anything out of the ordinary.")
			_queue_text("Detective: You're telling the truth. You’re not the killer.")
			
		else:
			_queue_text("Detective: I don't have the full story...I need more evidence")
			_return()
		
	#GARDENER CONDITIONS
	if (self.name == "gardener_accused"):
		npc_clue_list = _detect_NPC_text("res://gardenerdialogue.gd")
		_queue_text("Detective: Gardener Jones, remind me again, where were you at 9:32 PM?")
		_queue_text("Gardener James: I was in the kitchen, dropping off some fresh produce for the Chef. He was busy cutting fish and had his music blasting. I didn't want to disturb him, so I ducked inside, left the basket, and went back to the garden.")
		
		if "Dirt" in npc_clue_list:
			_queue_text("Detective: Fresh produce? Then explain the dirt we found in the kitchen—the same dirt from your boots.")
			_queue_text("Gardener James: The dirt’s from my boots, alright. I must’ve tracked it in when I delivered the basket. But that’s it—I didn’t do anything else. I didn’t kill him")
			
		if "Gloves" in npc_clue_list:
			_queue_text("Detective: The bloody gloves found in your garden—they match the ones used in the murder. Care to explain how they got there?.")
			_queue_text("Those gloves? They’re not mine. Look at the size—they’re too small. They must belong to a woman.")
			
		if "Gloves" in npc_clue_list and "Dirt" in npc_clue_list:
			#dirt
			_queue_text("Detective: Fresh produce? Then explain the dirt we found in the kitchen—the same dirt from your boots.")
			_queue_text("Gardener James: The dirt’s from my boots, alright. I must’ve tracked it in when I delivered the basket. But that’s it—I didn’t do anything else. I didn’t kill him")
			#gloves
			_queue_text("Detective: The bloody gloves found in your garden—they match the ones used in the murder. Care to explain how they got there?.")
			_queue_text("Those gloves? They’re not mine. Look at the size—they’re too small. They must belong to a woman.")
			
			_make_final_accusation()
			if (guilty_selected == 2):
				_display_text()
				_queue_text("Detective: You're telling the truth. You’re not the killer.")
				print("you're not the killer")
			if (guilty_selected == 1):
				_wrong_guess()
			
		else:
			_queue_text("Detective: I don't have the full story...I need more evidence")
			_return()
		
	#MAID CONDITIONS
	if (self.name == "maid_accused"):
		npc_clue_list = _detect_NPC_text("res://maiddialogue.gd")
		_queue_text("Detective: Maid Bertha, remind me again, where were you at 9:32 PM?")
		_queue_text("Maid Bertha: 9:32 PM? I was in the bedroom, just cleaning up. You know, tidying up the sheets, putting things in order, just like I told you.")
		
		if "Gloves" in npc_clue_list:
			_queue_text("Detective: Maid Bertha, the bloody gloves used in the murder were found at the scene. They belonged to you, didn’t they?")
			_queue_text("Maid Bertha: I don’t know. I don’t even know how they ended up there. Someone must have taken them... but I didn’t do it. You have to believe me.")
			
		if "Diary" in npc_clue_list:
			_queue_text("Detective:  The confession of the affair. It was your secret, wasn’t it? Did you kill him to keep it hidden?")
			_queue_text("Maid Bertha: I was part of the affair, yes. I won’t deny that. But I never saw any letter, and I didn’t kill him!")
			_queue_text("Detective: But you had the motive. You didn’t want the truth to come out.")
			_queue_text("Maid Bertha: I was scared of what might happen if people found out, but I swear, I didn’t hurt him! I loved him... as foolish as that might sound now. But I would never kill him.")
			
		if "Gloves" in npc_clue_list and "Diary" in npc_clue_list:
			_make_final_accusation()
			if (guilty_selected == 2):
				_queue_text("Detective: The gloves, the affair... it all points to you. But something’s not adding up.")
				_queue_text("Maid Bertha: Because I didn’t do it! I loved him, but I would never hurt him.")
				_queue_text("Detective: You're telling the truth. You’re not the killer.")
			if (guilty_selected == 1):
				_wrong_guess()

		else:
			_queue_text("Detective: I don't have the full story...I need more evidence")
			_return()


	#WIFE CONDITIONS
	if (self.name == "wife_accused"):
		npc_clue_list = _detect_NPC_text("res://wifedialogue.gd")
		_queue_text("You: Mrs. Burmingham, remind me again, where were you at 9:32 PM?")
		_queue_text("Wife: I was in the study, of course, writing thank-you notes for the charity auction. Such a pity—those notes will never be mailed now, will they?")
		
		if "Gloves" in npc_clue_list:
			_queue_text("Detective: Mrs. Burmingham, the bloody gloves used in the murder were yours. What do you have to say about that?")
			_queue_text("Mrs. Burmingham: What? Gloves? Those were the maid’s, weren’t they? I—I don’t know how they got there. Maybe she left them behind when she was cleaning up? I didn’t—")
			_queue_text("Detective: You took the maid’s gloves to frame her. You used them to make it look like she did it, didn’t you?")
			
		if "Diary" in npc_clue_list:
			_queue_text("Detective: And what about the letter? The ripped-up confession of the affair? That’s your motive, isn’t it?")
			_queue_text("Mrs. Burmingham: That letter... that was my husband’s. I didn’t want to read it, but when I did, I couldn’t just sit there and do nothing. He had an affair with her... with the maid...!")
			_queue_text("Detective: You tore up the letter. You didn’t want anyone to know the truth.")	
			
		if "Gloves" in npc_clue_list and "Diary" in npc_clue_list:
			_make_final_accusation()
			if (guilty_selected == 1):
				_queue_text("Detetcive: So you tore up the letter, stole the maid's gloves, and left them in the garden to incriminate the gardener. It was you all along.")
				_queue_text("Mrs. Burmingham: I didn’t know what else to do. I was... so angry. So hurt. But I never meant for it to go this far.")
				_queue_text("Detective: But it did, didn’t it? And now, we know the truth.")
				
				_queue_text("Mrs. Burmingham: Yes, you've caught me...")
				#you guessed right! Game ends.
				_right_guess()
			if (guilty_selected == 2):
				_queue_text("Of course I'm innocent! What a crude accusation...")
		
		else:
			_queue_text("Detective: I don't have the full story...I need more evidence")
			_return()
		

func _wrong_guess():
	exit_game_button.show()
	_return()
	winlose_text.text = ("You Lost!")

func _right_guess():
	exit_game_button.show()
	replay_game_button.show()
	winlose_text.text = ("You Won!")

func _return():
	return_button.show()
	
func _make_final_accusation():
	print("making final accusation")
	guilty_button.show()
	innocent_button.show()
	return_button.show()

	
func _detect_NPC_text(dialogue_path):
	var npcdialog = load(dialogue_path).new()
	var dialog_dictionary = npcdialog.dialog_dictionary
	var clue_list = []
	var dialog = ""
	for clue_data_index in range(InventoryManager.get_inventory().size()-1, -1, -1):
		var clue_name = InventoryManager.get_inventory()[clue_data_index]["name"]
		if clue_name == "defult_interogate":
			continue
		if clue_name in dialog_dictionary.keys():
			clue_list.append(clue_name)
	
	npcdialog.queue_free()
	return clue_list

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
					emit_signal("dialogue_finished")
					print("finsihed")
				else:
					print("reading")
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
	$"Replay Game".reset_game()

func _on_exit_game_pressed() -> void:
	$ButtonClick.play()
	wait(.5)
	get_tree().quit()

func _on_return_pressed() -> void:
	$ButtonClick.play()
	wait(.5)
	get_tree().change_scene_to_file("res://main.tscn")


func _on_guilty_pressed() -> void:
	$ButtonClick.play()
	wait(.5)
	print("GUILTY")
	guilty_selected = 1
	print(guilty_selected)


func _on_innocent_pressed() -> void:
	$ButtonClick.play()
	wait(.5)
	print("INNOCENT")
	guilty_selected = 2
	print(guilty_selected)
