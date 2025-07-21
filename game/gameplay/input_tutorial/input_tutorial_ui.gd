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
	var event_index: int = -1
	action_label.text = action_name
	input_label.text = InputManager.name_input(action_name)
	animator.stop()
	animator.play("show")

func _on_show_timer_timeout() -> void:
	hide()
