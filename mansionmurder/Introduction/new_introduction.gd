extends Control

@onready var story_dialogue: Control = $StoryDialogue
var local_npc_list = [
		{"Deputy": 
			["Deputy Statement 1",
			 "Deputy Statement 2",
			 "Deputy Statement 3"]},
		
		{"Detective": 
			["Detective Statment 1",
			"Detective Statment 2"]},
			
		{"Wife": 
			["Wife Statment 1"]}	
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	story_dialogue.show_dialogue(local_npc_list)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
		
