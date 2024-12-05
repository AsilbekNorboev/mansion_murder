extends CharacterBody2D

@export var speed = 200 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
# Reference to the walking sound node
@onready var walk_sound = $AudioStreamPlayer2D
@onready var detection_area: Area2D = $DetectionArea  # Reference to the player's detection area

func _ready():
	add_to_group("players")
	detection_area.area_entered.connect(_on_detection_area_area_entered)
	detection_area.area_exited.connect(_on_detection_area_area_exited)


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
		if not walk_sound.playing: # Start walking sound if not already playing
			walk_sound.play()
	else:
		$AnimatedSprite2D.animation = "idle" # Switch to idle if no movement
		$AnimatedSprite2D.play()
		if walk_sound.playing: # Stop walking sound if the player is idle
			walk_sound.stop()

	# Apply movement and update position
	self.velocity = velocity
	move_and_slide()

func _on_detection_area_area_entered(area: Area2D) -> void:
		print("Detected area:", area.name)
		print("inside nearby_objects:", Global.nearby_objects)
		if area.is_in_group("NPCs"):
			print("Player is near an NPC!")
			Global.nearby_objects.append(area.name)


func _on_detection_area_area_exited(area: Area2D) -> void:
	Global.nearby_objects.erase(area.name)
