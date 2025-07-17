class_name MoverBase extends ActorComponentBase
## Base component for controlling the attached actor's movements.

#region Exported properties
## The rate in pixels per second that the actor moves.
@export var movement_speed: float = 250
#endregion

#region Getters/setters
## The vector of the actor's movement.
var movement_vector: Vector2:
	get:
		return _actor_root.velocity
## Whether the actor is currently moving.
var in_motion: bool:
	get:
		return movement_vector.length() > 0
#endregion

var _may_move: bool = true
var may_move: bool:
	get:
		return _may_move
	set(value):
		_may_move = value
		if not value:
			reset_all_motion()

#region Public methods
## Reset all movement.
func reset_all_motion() -> void:
	reset_motion_x()
	reset_motion_y()

## Reset horizontal movement to 0.
func reset_motion_x() -> void:
	_actor_root.velocity.x = 0

## Reset vertical movement to 0.
func reset_motion_y() -> void:
	_actor_root.velocity.y = 0
#endregion
