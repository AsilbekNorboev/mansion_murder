extends Area2D

# Exported variable to define the target position (or room)
@export var target_position: Vector2

func _ready():
	# Connect the body_entered signal to handle teleportation
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player":  # Replace "Player" with your player's node name
		body.global_position = target_position
