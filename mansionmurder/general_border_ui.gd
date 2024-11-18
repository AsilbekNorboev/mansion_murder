extends CanvasLayer
signal investigate
signal inventorybuttonpressed
signal settingsbuttonpressed
#var accusation_menu = preload("res://accusation_menu.tscn").instantiate()

func _on_investigate_button_pressed():
	$InvestigateButton.modulate = Color("#000000")
	await get_tree().create_timer(0.2).timeout
	$InvestigateButton.modulate = Color("#ffffff")
	investigate.emit()
	
func _on_inventory_button_pressed() -> void:
	$InventoryButton.modulate = Color("#000000")
	await get_tree().create_timer(0.2).timeout
	$InventoryButton/rustleSFX.play()
	$InventoryButton.modulate = Color("#ffffff")
	inventorybuttonpressed.emit()
	#accusation_menu.add_NPC_Container()

func _on_settings_button_pressed() -> void:
	$SettingsButton/ButtonClick.play()
	$SettingsButton.modulate = Color("#000000")
	await get_tree().create_timer(0.2).timeout
	$SettingsButton.modulate = Color("#ffffff")
	settingsbuttonpressed.emit()
