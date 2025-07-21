extends Node

var input_type: InputEvent

func _ready() -> void: 
	input_type = InputMap.action_get_events("Attack")[0]

func _input(event: InputEvent) -> void:
	if event is InputEventKey or \
		event is InputEventJoypadButton:
		input_type = event
