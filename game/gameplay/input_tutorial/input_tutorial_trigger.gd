class_name InputTutorialTrigger extends Area2D

@export var action_name: String

signal show_input(action: String)

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerBase:
		show_input.emit(action_name)
