extends CharacterBody2D

@export var speed = 200 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

func _ready():
	add_to_group("players")
	pass

func _physics_process(delta: float) -> void:
	var velocity = Vector2.ZERO # The player's movement vector.
	
	# Handle player movement and direction
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		$AnimatedSprite2D.flip_h = false # Ensure the sprite faces right
		$AnimatedSprite2D.animation = "walk" # Set the walking animation
	elif Input.is_action_pressed("move_left"):
		velocity.x -= 1
		$AnimatedSprite2D.flip_h = true # Flip the sprite to face left
		$AnimatedSprite2D.animation = "walk" # Set the walking animation

	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		$AnimatedSprite2D.animation = "down" # Set the downward animation
	elif Input.is_action_pressed("move_up"):
		velocity.y -= 1
		$AnimatedSprite2D.animation = "up" # Set the upward animation

	# Normalize velocity if player is moving
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play() # Play the current animation
	else:
		$AnimatedSprite2D.animation = "idle" # Switch to idle if no movement
		$AnimatedSprite2D.play()

	# Apply movement and update position
	self.velocity = velocity
	move_and_slide()
