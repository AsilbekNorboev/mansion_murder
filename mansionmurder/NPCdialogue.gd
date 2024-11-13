extends Area2D

var cursor = preload("res://art/dialogueicon.png")

#loads textbox scene to use its functions later
var textbox_scene = preload("res://textbox.tscn").instantiate()
var textappear = textbox_scene.get_node("TextboxContainer")
var current_line_index = 0

var is_dialog_active = false

var lines = []

@onready var dialog = $Dialogue
@onready var animated_sprite = $AnimatedSprite2D # Reference to the AnimatedSprite2D node
@onready var collision_shape = $CollisionShape2D


func _ready():
	# Start playing the idle animation as soon as the NPC is ready
	animated_sprite.animation = "idle"
	animated_sprite.play()
	
func _input_event(viewport, event, shape_idx):
	if Input.is_action_pressed("click"):
		print("you clicked the ", self.name)
		_dialog_start()


#on click, add text from the array to populate the textbox scene
func _dialog_start():
	if is_dialog_active:
		return
	if not dialog:
		return
		
	lines = get_lines(InventoryManager.get_inventory(), dialog.dialog_dictionary)
	
	if not lines:
		return
	if (textbox_scene.find_parent("*") == null):
		add_child(textbox_scene)
		textappear.add_text(lines[current_line_index])
		is_dialog_active = true
	
			
func _dialog_end():
	#hide the textbox
	is_dialog_active = false
	current_line_index = 0
	textappear.hide_textbox()
	#remove the instantiated textbox from current room scene
	remove_child(textbox_scene)

	
func _unhandled_input(event):
	if( event.is_action_pressed("dialogue_next") && is_dialog_active):
		current_line_index += 1
		#if there is no more text left in array, end the dialog
		if current_line_index >= lines.size():
			_dialog_end()
		#if there is more text left, display the next line of text
		else:
			textappear.add_text(lines[current_line_index])
			
			
func get_lines(inventory_list, dialog_dictionary):
	for clue_index in range(inventory_list.size()-1, -1, -1):
		if not dialog_dictionary.has(inventory_list[clue_index].name):
			continue
		return dialog_dictionary[inventory_list[clue_index].name]
				
	return dialog_dictionary[""]

#change cursor when hovering over
func _on_mouse_entered() -> void:
		Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW, Vector2(16,16))

func _on_mouse_exited() -> void:
		Input.set_custom_mouse_cursor(null)
