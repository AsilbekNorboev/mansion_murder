extends MarginContainer

@onready var textbox_container = $"."
@onready var label = $Panel/MarginContainer/HBoxContainer/Label

func _ready():
	hide_textbox()
			
func hide_textbox():
	label.text = ""
	textbox_container.hide()
	
func show_textbox():
	textbox_container.show()
	
func add_text(lines):
	label.text = lines
	show_textbox()
	
