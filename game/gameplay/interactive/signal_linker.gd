class_name SignalLinker extends Node

@export_node_path var _signal_owner_node_path: NodePath
@export_node_path var _function_owner_node_path: NodePath
@export var _signal_trigger_name: String
@export var _triggered_function_name: String

@onready var _signal_owner: Node = get_node_or_null(_signal_owner_node_path)
@onready var _function_owner: Node = get_node_or_null(_function_owner_node_path)

func _ready() -> void:
	if is_instance_valid(_signal_owner):
		if _signal_owner.has_signal(_signal_trigger_name):
			if _function_owner.has_method(_triggered_function_name):
				_signal_owner.connect(_signal_trigger_name, func(_args): _function_owner.call(_triggered_function_name))
