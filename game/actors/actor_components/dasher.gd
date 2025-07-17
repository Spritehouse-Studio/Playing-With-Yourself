class_name Dasher extends ActorComponentBase
## Allows the attached actor to dash in a given direction.

#region Exported properties
## The speed at which the actor will dash at.
@export var dash_speed: float = 800
## The length of time that the actor will be dashing for.
@export var dash_duration: float = 0.15
## The duration immediately after a dash before another dash may be performed again.
@export var dash_cooldown: float = 0.75
@export var _input_controller_node_path: NodePath
#endregion

#region Available nodes on ready
@onready var _input_controller: InputController = get_node_or_null(_input_controller_node_path)
#endregion

#region Signals
signal dash_ended
signal dash_recharged
#endregion

#region Non-public variables
var _can_dash: bool
#endregion

#region Public methods
## Dash in a provided direction.
func dash(direction: float) -> void:
	if not _can_dash:
		return
	_can_dash = true
	var normalized_direction: float = sign(direction)
	_actor_root.velocity.x = normalized_direction * dash_speed
	_input_controller.disabled = true
	await get_tree().create_timer(dash_duration).timeout
	dash_ended.emit()
	_input_controller.enabled = false
	await get_tree().create_timer(dash_cooldown).timeout
	_can_dash = false
	dash_recharged.emit()
#endregion
