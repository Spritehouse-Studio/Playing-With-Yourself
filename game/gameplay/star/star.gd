class_name Star extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerBase:
		SessionManager.win_game()
		queue_free()
