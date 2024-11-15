extends MarginContainer

@onready var textbox_container = $"."
@onready var label = $Panel/MarginContainer/HBoxContainer/Label
@onready var maincontainer = $".."

func _ready():
	hide_textbox()
			
func hide_textbox():
	label.text = ""
	textbox_container.hide()
	
func show_textbox():
	textbox_container.show()
	
func add_text(lines):
	$NextDialogueSfx.play()	
	label.text = lines
	show_textbox()
	
func hide_skip_label():
	maincontainer.get_node("SkipLabel").hide()
