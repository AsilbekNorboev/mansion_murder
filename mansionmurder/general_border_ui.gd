extends CanvasLayer
signal investigate
signal inventorybuttonpressed
signal settingsbuttonpressed
@onready var arrow = $Arrow
#var accusation_menu = preload("res://accusation_menu.tscn").instantiate()

func _ready() -> void:
	arrow.visible = false
	_check_first_clue_found()

func _check_first_clue_found() -> void:
	while not Global.first_clue_found:
		await get_tree().create_timer(0.1).timeout  # Wait 0.1 seconds before rechecking

	# First clue found; show the arrow
	arrow.visible = true
#func _on_investigate_button_pressed():
	#$InvestigateButton.modulate = Color("#000000")
	#await get_tree().create_timer(0.2).timeout
	#$InvestigateButton.modulate = Color("#ffffff")
	#investigate.emit()
	#
func _on_inventory_button_pressed() -> void:
	arrow.visible = false
	$InventoryButton.modulate = Color("#000000")
	await get_tree().create_timer(0.2).timeout
	$InventoryButton/rustleSFX.play()
	$InventoryButton.modulate = Color("#ffffff")
	inventorybuttonpressed.emit()
	get_tree().paused = true #who added this
	#accusation_menu.add_NPC_Container()

func _on_settings_button_pressed() -> void:
	$SettingsButton/ButtonClick.play()
	$SettingsButton.modulate = Color("#000000")
	await get_tree().create_timer(0.2).timeout
	$SettingsButton.modulate = Color("#ffffff")
	settingsbuttonpressed.emit()
