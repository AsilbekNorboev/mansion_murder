extends CanvasLayer
signal investigate
signal inventorybuttonpressed

func _on_investigate_button_pressed():
	$InvestigateButton.modulate = Color("#000000")
	await get_tree().create_timer(0.2).timeout
	$InvestigateButton.modulate = Color("#ffffff")
	investigate.emit()
	


func _on_inventory_button_pressed() -> void:
	$InventoryButton.modulate = Color("#000000")
	await get_tree().create_timer(0.2).timeout
	$InventoryButton.modulate = Color("#ffffff")
	inventorybuttonpressed.emit()
