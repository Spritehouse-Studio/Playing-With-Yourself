class_name Star extends Area2D

var pickup_audio: AudioStream = preload("uid://ct1bborkgvmkf")

func _ready() -> void:
	$animator.play("spin")

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerBase:
		AudioManager.play_audio(pickup_audio, global_position)
		SessionManager.win_game()
		queue_free()
