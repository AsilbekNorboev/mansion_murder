extends CanvasLayer

# Specify the exact path to your scene
const NEXT_SCENE = "res://Introduction/main_menu.tscn"

# Transition settings
@export var fade_duration: float = 0.8  # Duration of fade in/out
@export var wait_time: float = 2.5  # Time to wait before changing scenes
@onready var color_rect = ColorRect.new()
@onready var audio_player = AudioStreamPlayer.new()

func _ready():
	# Ensure this layer persists during scene changes
	process_mode = Node.PROCESS_MODE_ALWAYS

	# Setup full-screen color rect for fade effect
	color_rect.color = Color.BLACK
	color_rect.size = get_viewport().get_visible_rect().size
	color_rect.anchors_preset = Control.PRESET_FULL_RECT
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(color_rect)

	# Setup audio player
	audio_player.stream = preload("res://audio/mixkit-unlock-game-notification-253.wav")
	add_child(audio_player)

	# Start with fade in
	color_rect.modulate.a = 1.0
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 0.0, fade_duration)

	# Setup a timer to delay the sound by 1 second
	var audio_delay_timer = Timer.new()
	add_child(audio_delay_timer)
	audio_delay_timer.wait_time = 1.0  # Delay audio by 1 second
	audio_delay_timer.one_shot = true
	audio_delay_timer.timeout.connect(_on_audio_timeout)
	audio_delay_timer.start()

	# Setup timer for scene change
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = wait_time
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _on_audio_timeout():
	# Play audio during the fade-in transition after the delay
	audio_player.volume_db = -10  # Set initial volume
	audio_player.play()
	var audio_fade_tween = create_tween()
	audio_fade_tween.tween_property(audio_player, "volume_db", 0, fade_duration)

func _on_timer_timeout():
	# Prepare the next scene
	var next_scene_resource = ResourceLoader.load(NEXT_SCENE, "PackedScene")

	# Fade out and prepare for scene change
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 1.0, fade_duration)

	# Fade out audio during the transition
	var audio_fade_tween = create_tween()
	audio_fade_tween.tween_property(audio_player, "volume_db", -30, fade_duration)

	# Transition to the next scene
	tween.tween_callback(func():
		# Instantiate the scene
		var next_scene_instance = next_scene_resource.instantiate()

		# Remove all current scene children
		var current_scene = get_tree().current_scene
		current_scene.queue_free()

		# Add the new scene to the scene tree
		get_tree().root.add_child(next_scene_instance)
		get_tree().current_scene = next_scene_instance

		# Stop audio after the transition
		audio_player.stop()
	)
