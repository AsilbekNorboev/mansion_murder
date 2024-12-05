extends CanvasLayer
#signal investigate
signal inventorybuttonpressed
signal settingsbuttonpressed
signal suspectsbuttonpressed
@onready var arrow = $Arrow
@onready var suspectsUI = preload("res://SuspectsUI.tscn").instantiate()

func _ready() -> void:
	arrow.visible = false
	_check_first_clue_found()

func _check_first_clue_found() -> void:
	while not Global.first_clue_found:
		await get_tree().create_timer(0.1).timeout  # Wait 0.1 seconds before rechecking

	# First clue found; show the arrow
	arrow.visible = true

func _on_inventory_button_pressed() -> void:
	arrow.visible = false
	$InventoryButton.modulate = Color("#000000")
	await get_tree().create_timer(0.2).timeout
	$InventoryButton/rustleSFX.play()
	$InventoryButton.modulate = Color("#ffffff")
	inventorybuttonpressed.emit()
	get_tree().paused = !get_tree().paused

func _on_settings_button_pressed() -> void:
	$SettingsButton/ButtonClick.play()
	$SettingsButton.modulate = Color("#000000")
	await get_tree().create_timer(0.2).timeout
	$SettingsButton.modulate = Color("#ffffff")
	settingsbuttonpressed.emit()

func _on_suspects_button_pressed() -> void:
	#on click, accusation menu will populate with new suspects you've met
	suspectsUI.get_node("AccusationMenu").add_NPC_Container()
	$SuspectsButton/ButtonClick.play()
	suspectsbuttonpressed.emit()
	print("suspects button emitted")
	get_tree().paused = !get_tree().paused
	
