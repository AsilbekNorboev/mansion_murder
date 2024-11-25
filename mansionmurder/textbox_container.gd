extends MarginContainer

@onready var textbox_container = $"."
@onready var label = $OutlinePanel/MarginContainer/HBoxContainer/Label
@onready var maincontainer = $".."
@onready var clue_container: VBoxContainer = $OutlinePanel/ScrollContainer/ClueContainer
@onready var scroll_container: ScrollContainer = $OutlinePanel/ScrollContainer
@onready var margin_container: MarginContainer = $OutlinePanel/MarginContainer
@onready var h_box_container: HBoxContainer = $OutlinePanel/MarginContainer/HBoxContainer
@onready var player_options_label: Label = $OutlinePanel/PlayerOptionsLabel


signal _on_clue_clicked_text
signal next_dialogue

func add_clue(clue_data: Dictionary, lines):
	print("Adding clue to inventory:", clue_data)

	var clue_rect = preload("res://clue_rect.tscn")  # Path to your clue item scene
	var clue_item = clue_rect.instantiate()  # Instance the clue item scene	
	clue_item.clue_clicked.connect(_on_clue_clicked)

	# Assuming your clue item scene has a method to set data
	clue_item.set_data(clue_data, lines)  # Pass c
	clue_container.add_child(clue_item)
	
func _on_clue_clicked(lines):
	emit_signal("_on_clue_clicked_text", lines)

func clear_clues():
	for child in clue_container.get_children():
		clue_container.remove_child(child)

func show_clue_container(visible):
	if visible and clue_container.get_child_count():
		player_options_label.show()
		scroll_container.show()
		scroll_container.size.x = 320
		margin_container.size.x = 760
		
	else:
		player_options_label.hide()
		scroll_container.hide()
		scroll_container.size.x = 0
		margin_container.size.x = 1085

func initialize_margin_container():
	margin_container.size.x = 300	

func _ready():
	hide_textbox()
			
func hide_textbox():
	label.text = ""
	textbox_container.hide()
	get_tree().paused = false

	
func show_textbox():
	textbox_container.show()
	#lock character movement until the dialogue ends
	get_tree().paused = true

func add_text(line):
	$NextDialogueSfx.play()	
	label.text = line
	show_textbox()
	
func hide_skip_label():
	maincontainer.get_node("SkipLabel").hide()

func narrator_text_color():
	#change color of narration text
	($OutlinePanel/MarginContainer/HBoxContainer/Label).modulate = Color(0.467, 0.353, 0.106)

#play next dialogue
func _unhandled_input(event):
	if event.is_action_pressed("dialogue_next") and (Global.is_dialog_active or Global.is_narrator_dialog_active):
		print("key detected")
		print("current line index: ",Global.current_line_index)
		emit_signal("next_dialogue")
