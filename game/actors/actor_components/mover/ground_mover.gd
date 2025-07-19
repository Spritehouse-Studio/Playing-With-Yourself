class_name GroundMover extends TrackedComponent
## Component that controls movement on the ground.

#region Exported properties
## The rate in pixels per second that the actor moves.
@export var movement_speed: float = 250
@export var footstep_audio: RandomAudio
#endregion

#region Signals
## Emitted when the actor has reached its destination point.
signal reached_destination(current_x: float)
#endregion

#region Getters/setters
## The normalized direction of the actor's motion
var current_direction_x: int:
	get:
		return sign(_actor_root.velocity.x)
## The actor's velocity on the horizontal axis.
var velocity_x: float:
	get:
		return _actor_root.velocity.x
	set(value):
		_actor_root.velocity.x = value
#endregion

#region Public methods
func load_event(value: Variant) -> void:
	super.load_event(value)
	move(value)

## Move the actor.
func move(direction: float) -> void:
	var normalized_dir: int = sign(direction)
	var x: float = normalized_dir * movement_speed
	if x != velocity_x and not _actor_root.is_on_wall():
		save_event(normalized_dir)
	velocity_x = x

## Move horizontally to a particular point.
func move_to(target_x: float) -> void:
	var direction: float =  target_x - _actor_root.global_position.x
	move(direction)
	while direction < 0 and _actor_root.global_position.x > target_x or \
		direction > 0 and _actor_root.global_position.x < target_x:
			await get_tree().process_frame
	reached_destination.emit(_actor_root.global_position.x)

func stop() -> void:
	velocity_x = 0

func _play_footstep() -> void:
	if footstep_audio != null:
		footstep_audio.play_random(global_position, 0.75, 1.25)
#endregion
