class_name ActorComponentBase extends Node2D
## Represents a component that can be added to an actor to control its behavior.

#region Exported properties
## The path of the actor's root node.
@export_node_path("ActorBase") var _root_node_path: NodePath
#endregion

#region Available nodes on ready
## The actor's body to be affected by gravity.
@onready var _actor_root: ActorBase = get_node_or_null(_root_node_path)
#endregion

#region Godot's built-in methods
func _ready() -> void:
	# If actor root is not defined, default to the owner of this scene
	if not is_instance_valid(_actor_root):
		_actor_root = get_owner()
#endregion
