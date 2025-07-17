extends Button

@export var click_sound: AudioStream

func _on_pressed() -> void:
	AudioManager.play_audio(click_sound)
