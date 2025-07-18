class_name PlayerBase extends ActorBase

@export_node_path("HealthManager") var _health_manager_node_path: NodePath
@export_node_path("InputController") var _input_controller_node_path: NodePath

@onready var health_manager: HealthManager = get_node_or_null(_health_manager_node_path)
@onready var input_controller: InputController = get_node_or_null(_input_controller_node_path)

var _disable_input: bool = false

var disable_input: bool:
	get:
		return _disable_input
	set(value):
		_disable_input = value
		if is_instance_valid(input_controller):
			input_controller.disabled = value

func _ready() -> void:
	if is_instance_valid(health_manager):
		LifeManager.life_over.connect(health_manager._die)
