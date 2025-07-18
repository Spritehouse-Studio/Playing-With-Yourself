## A set of clips to play at random
class_name RandomAudio extends Resource

## A list of clips to choose from
@export var clips: Array[AudioStream] = []

## Play a random clip
func play_random(position: Vector2, pitch_min: float = 1, pitch_max: float = 1) -> void:
	AudioManager.play_audio(clips[randi() % len(clips)], position, pitch_min, pitch_max)
