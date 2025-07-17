class_name TargetManager extends ActorComponentBase
## Manages combat targets of an attached actor.

#region Constants
const MY_CONST: float = 1
#endregion

#region Exported properties
@export_node_path var _facer_node_path: NodePath
@export_node_path var _weapon_node_path: NodePath
#endregion

#region Available nodes on ready
@onready var _facer: Facer = get_node_or_null(_facer_node_path)
@onready var _weapon: WeaponWielder = get_node_or_null(_weapon_node_path)
#endregion

#region Signals
signal my_signal(param1: int)
#endregion

#region Public variables
var my_public_var: float
#endregion

#region Non-public variables
var _current_target: ActorBase
#endregion

#region Getters/setters
## The maximum distance that the actor may engage a target from.
var _max_engage_distance: float:
	get:
		if is_instance_valid(_weapon):
			return _weapon.weapon_modifier.engage_distance
		return 0
#endregion

#region Godot's built-in methods
func _ready() -> void:
	super._ready()
#endregion

#region Public methods
## Engage in combat with an opponent actor.
func engage(target: ActorBase) -> void:
	_current_target = target
	if is_instance_valid(_facer):
		_facer.face(_current_target)
	
#endregion

#region Non-public methods
func _my_private_method(param1: float, param2: bool = true) -> void:
	pass
#endregion

#region Signal callbacks
func _on_node_signal(_signal_param: Vector2) -> void:
	pass
#endregion
