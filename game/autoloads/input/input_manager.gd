extends Node

var input_type: InputEvent

func _ready() -> void: 
	input_type = InputMap.action_get_events("Attack")[0]

func _input(event: InputEvent) -> void:
	if event is InputEventKey or \
		event is InputEventJoypadButton:
		input_type = event

func name_input(action_name: String, input_event_type: InputEvent = input_type) -> String:
	var input_events: Array[InputEvent] = InputMap.action_get_events(action_name)
	if input_event_type is InputEventKey:
		var event_index: int = input_events.find_custom(func(event): return event is InputEventKey)
		if event_index >= 0:
			var input_event: InputEventKey = input_events[event_index]
			return OS.get_keycode_string(input_event.physical_keycode)
	elif input_event_type is InputEventMouseButton:
		var event_index: int = input_events.find_custom(func(event): return event is InputEventMouseButton)
		if event_index >= 0:
			var input_event: InputEventMouseButton = input_events[event_index]
			match input_event.button_index:
				MOUSE_BUTTON_LEFT:
					return "LMB"
				MOUSE_BUTTON_RIGHT:
					return "RMB"
				MOUSE_BUTTON_MIDDLE:
					return "MMB"
			return input_event.as_text()
	elif input_event_type is InputEventJoypadMotion:
		var event_index: int = input_events.find_custom(func(event): return event is InputEventJoypadMotion)
		if event_index >= 0:
			var input_event: InputEventJoypadMotion = input_events[event_index]
			match input_event.axis:
				JOY_AXIS_LEFT_X:
					if input_event.axis_value < 0:
						return "Joystick Left"
					elif input_event.axis_value > 0:
						return "Joystick Right"
				JOY_AXIS_LEFT_Y:
					if input_event.axis_value < 0:
						return "Joystick Down"
					elif input_event.axis_value > 0:
						return "Joystick Up"
			return input_event.as_text()
	elif input_event_type is InputEventJoypadButton:
		var event_index: int = input_events.find_custom(func(event): return event is InputEventJoypadButton)
		if event_index >= 0:
			var input_event: InputEventJoypadButton = input_events[event_index]
			match input_event.button_index:
				JOY_BUTTON_DPAD_UP:
					return "D-Pad Up"
				JOY_BUTTON_DPAD_DOWN:
					return "D-Pad Down"
				JOY_BUTTON_DPAD_LEFT:
					return "D-Pad Left"
				JOY_BUTTON_DPAD_RIGHT:
					return "D-Pad Right"
				JOY_BUTTON_A:
					var gamepad_name: String = Input.get_joy_name(0).to_lower()
					if gamepad_name.contains("xbox"):
						return "A"
					elif gamepad_name.contains("ps"):
						return "X"
					return "A"
				JOY_BUTTON_B:
					var gamepad_name: String = Input.get_joy_name(0).to_lower()
					if gamepad_name.contains("xbox"):
						return "B"
					elif gamepad_name.contains("ps"):
						return "Circle"
					return "B"
				JOY_BUTTON_X:
					var gamepad_name: String = Input.get_joy_name(0).to_lower()
					if gamepad_name.contains("xbox"):
						return "X"
					elif gamepad_name.contains("ps"):
						return "Square"
					return "X"
				JOY_BUTTON_Y:
					var gamepad_name: String = Input.get_joy_name(0).to_lower()
					if gamepad_name.contains("xbox"):
						return "Y"
					elif gamepad_name.contains("ps"):
						return "Triangle"
					return "Y"
			return input_event.as_text()
	return "???"
