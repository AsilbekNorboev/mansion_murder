extends Area2D

# Reference to AnimatedSprite2D
@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	# Play the "Idle" animation when the scene starts
	animated_sprite.play("Idle")
