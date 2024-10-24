extends Area2D

@onready var animated_sprite = $AnimatedSprite2D # Reference to the AnimatedSprite2D node

func _ready():
	# Start playing the idle animation as soon as the NPC is ready
	animated_sprite.animation = "idle"
	animated_sprite.play()
