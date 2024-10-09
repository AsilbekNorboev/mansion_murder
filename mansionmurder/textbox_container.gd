extends MarginContainer

@onready var textbox_container = $"."
@onready var label = $Panel/MarginContainer/HBoxContainer/Label

func _ready():
	hide_textbox()
	add_text("A painting of a young woman.")

func _process(delta):
	if Input.is_action_just_pressed("dialogue_next"):
		print("next dialogue")
		hide_textbox()
			
func hide_textbox():
	label.text = ""
	textbox_container.hide()
	
func show_textbox():
	textbox_container.show()
	
func add_text(next_text):
	label.text = next_text
	show_textbox()
	
