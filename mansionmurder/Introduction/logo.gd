extends CanvasLayer

# Specify the exact path to your scene
const NEXT_SCENE = "res://Introduction/main_menu.tscn"

# Transition settings
@export var fade_duration: float = 0.8 # Duration of fade in/out
@export var wait_time: float = 2.5  # Time to wait before changing scenes

@onready var color_rect = ColorRect.new()

func _ready():
	# Ensure this layer persists during scene changes
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Setup full-screen color rect for fade effect
	color_rect.color = Color.BLACK
	color_rect.size = get_viewport().get_visible_rect().size
	color_rect.anchors_preset = Control.PRESET_FULL_RECT
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(color_rect)
	
	# Start with fade in
	color_rect.modulate.a = 1.0
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 0.0, fade_duration)
	
	# Setup timer for scene change
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = wait_time
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _on_timer_timeout():
	# Prepare the next scene
	var next_scene_resource = ResourceLoader.load(NEXT_SCENE, "PackedScene")
	
	# Fade out and prepare for scene change
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 1.0, fade_duration)
	tween.tween_callback(func():
		# Instantiate the scene
		var next_scene_instance = next_scene_resource.instantiate()
		
		# Remove all current scene children
		var current_scene = get_tree().current_scene
		current_scene.queue_free()
		
		# Add the new scene to the scene tree
		get_tree().root.add_child(next_scene_instance)
		get_tree().current_scene = next_scene_instance
	)
