class_name InputTutorialUI extends MarginContainer

@onready var animator: AnimationPlayer = $animator
@onready var input_container: HBoxContainer = $input_container
@onready var action_label: Label = input_container.get_node("action")
@onready var input_label: Label = input_container.get_node("panel/margin_container/input_label")

func _process(_delta: float) -> void:
	if get_tree().paused:
		hide()
	else:
		show()

func show_input(action_name: String) -> void:
	var input_events: Array[InputEvent] = InputMap.action_get_events(action_name)
	var event_index: int = -1
	var input_name: String = ""
	if InputManager.input_type is InputEventKey:
		event_index = input_events.find_custom(func(event): return event is InputEventKey)
		if event_index >= 0:
			var input_event: InputEventKey = input_events[event_index]
			input_name = input_event.as_text().replace(" (Physical)", "")
	elif InputManager.input_type is InputEventMouseButton:
		event_index = input_events.find_custom(func(event): return event is InputEventMouseButton)
		if event_index >= 0:
			var input_event: InputEventMouseButton = input_events[event_index]
			input_name = input_event.as_text()
			match input_event.button_index:
				MOUSE_BUTTON_LEFT:
					input_name = "LMB"
				MOUSE_BUTTON_RIGHT:
					input_name = "RMB"
				MOUSE_BUTTON_MIDDLE:
					input_name = "MMB"
	elif InputManager.input_type is InputEventJoypadButton:
		event_index = input_events.find_custom(func(event): return event is InputEventJoypadButton)
		if event_index >= 0:
			var input_event: InputEventJoypadButton = input_events[event_index]
			input_name = input_event.as_text()
			match input_event.button_index:
				JOY_BUTTON_DPAD_UP:
					input_name = "D-Pad Up"
				JOY_BUTTON_DPAD_DOWN:
					input_name = "D-Pad Down"
				JOY_BUTTON_DPAD_LEFT:
					input_name = "D-Pad Left"
				JOY_BUTTON_DPAD_RIGHT:
					input_name = "D-Pad Right"
				JOY_BUTTON_A:
					input_name = "A"
				JOY_BUTTON_B:
					input_name = "B"
	action_label.text = action_name
	input_label.text = input_name
	animator.stop()
	animator.play("show")

func _on_show_timer_timeout() -> void:
	hide()
