extends Area2D

# Exported variable to define the target position (or room)
@export var target_position: Vector2
@export var requires_key: bool = false  # Whether the door requires the key
var textbox_scene = preload("res://textbox.tscn")

func _ready():
	# Connect the body_entered signal to handle teleportation
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player":  # Replace "Player" with your player's node name
		if requires_key:
			var inventory = InventoryManager.get_inventory()
			print("Current inventory:", inventory)
			var has_key = false
			for item in inventory:
				if item.get("name", "") == "Knife":
					has_key = true
					break
			if has_key:
				body.global_position = target_position
			else:
				print("YOU NEED KEY")
				show_textbox("The door is locked. You need a key to open it.")
		else:
			body.global_position = target_position
		
func show_textbox(message: String):
	# Instantiate and add the textbox to the scene
	var textbox_instance = textbox_scene.instantiate()
	add_child(textbox_instance)
	#textbox_instance.z_index = 100  # Ensure it's rendered above other elements
	var text_container = textbox_instance.get_node("TextboxContainer")
	text_container.show_clue_container(false)  # Hide clue-specific UI if unused
	text_container.add_text(message)
	Global.is_dialog_active = true

	# Connect to the dialogue end signal if needed for cleanup
	text_container.next_dialogue.connect(_on_dialogue_end)

func _on_dialogue_end():
	# Cleanup if needed after the textbox closes
	Global.is_dialog_active = false
	Global.current_line_index = 0
	var textbox_instance = find_child("TextboxContainer", true, false)
	if textbox_instance:
		
		textbox_instance.hide_skip_label()
		textbox_instance.queue_free()
		get_tree().paused = false
