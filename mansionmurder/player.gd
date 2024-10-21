extends CharacterBody2D

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

func _ready():
	add_to_group("players")
	pass
	#screen_size = get_viewport_rect().size
	#position = Global.spawn_position


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
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	#position += velocity * delta
	self.velocity = velocity
	move_and_slide() # No arguments required

	#move_and_slide()

	#position = position.clamp(Vector2.ZERO, screen_size)
