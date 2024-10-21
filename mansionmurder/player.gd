extends CharacterBody2D

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

func _ready():
	add_to_group("players")
	#screen_size = get_viewport_rect().size
	pass

func _physics_process(delta: float) -> void:
	var velocity = Vector2.ZERO # The player's movement vector.
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		
		# Determine the direction and play the corresponding animation
		if velocity.y < 0:  # Moving up
			$AnimatedSprite2D.play("up")  # Face right (normal scale)
		elif velocity.y > 0:  # Moving down
			$AnimatedSprite2D.play("up")  # Face right (normal scale)
		elif velocity.x < 0:  # Moving left
			$AnimatedSprite2D.play("walk")
			$AnimatedSprite2D.scale.x = -0.18  # Flip horizontally for left
		elif velocity.x > 0:  # Moving right
			$AnimatedSprite2D.play("walk")
			$AnimatedSprite2D.scale.x = 0.18  # Normal scale for right
	else:
		$AnimatedSprite2D.stop()

	self.velocity = velocity
	move_and_slide() # No arguments required

	# Uncomment if you want to clamp position to screen boundaries
	# position = position.clamp(Vector2.ZERO, screen_size)
