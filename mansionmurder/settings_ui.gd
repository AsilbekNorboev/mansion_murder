extends Control

var volume := 100

func _ready():
	$MarginContainer/VBoxContainer/Volume.value = volume
	_update_audio_volumes()
func _on_volume_value_changed(value: float) -> void:
	volume = value
	_update_audio_volumes()

func _on_mute_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0, toggled_on)


func _update_audio_volumes():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), lerp(-40, 0, volume / 100.0))
