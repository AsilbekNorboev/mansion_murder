extends CanvasLayer

func _on_investigate_button_pressed():
	$InvestigateButton.modulate = Color("#000000")
	await get_tree().create_timer(0.2).timeout
	$InvestigateButton.modulate = Color("#ffffff")
	
