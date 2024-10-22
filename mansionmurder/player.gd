extends CharacterBody2D

@export var speed = 400  # Player movement speed
@onready var animated_sprite = $AnimatedSprite2D  # Reference to AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var velocity = Vector2.ZERO  # Player's movement vector

	# Handling movement input
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		animated_sprite.play("walk")
		animated_sprite.flip_h = false  # Face right

	elif Input.is_action_pressed("move_left"):
		velocity.x -= 1
		animated_sprite.play("walk")
		animated_sprite.flip_h = true  # Flip the sprite horizontally to face left

	elif Input.is_action_pressed("move_down"):
		velocity.y += 1
		animated_sprite.play("up")  # Play "up" animation for vertical movement

	elif Input.is_action_pressed("move_up"):
		velocity.y -= 1
		animated_sprite.play("up")  # Play "up" animation for vertical movement

	# If there's movement, normalize the velocity and apply speed
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	else:
		animated_sprite.stop()  # Stop animation if not moving

	self.velocity = velocity
	move_and_slide()  # Move the player based on the calculated velocity
