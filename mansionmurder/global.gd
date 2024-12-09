extends Node

#global value to determine who you've met
var NPC = "test NPC"
var suspect_list = []
var is_dialog_active = false
var is_narrator_dialog_active = false
var current_line_index = 0
var first_clue_found = false
var first_suspect_found = false
signal inventory_button_pressed
signal suspects_button_pressed
signal chef_button_pressed
signal wife_button_pressed
signal gardener_button_pressed
signal maid_button_pressed

signal removing_self
