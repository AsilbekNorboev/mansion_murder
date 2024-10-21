extends Area2D

@onready var animation_player = $AnimatedSprite2D  # Path to the AnimationPlayer node

func _ready():
	# Play the idle animation as soon as the game starts, looping infinitely
	animation_player.play("Idle")
