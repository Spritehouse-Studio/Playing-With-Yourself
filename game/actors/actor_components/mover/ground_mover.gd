class_name GroundMover extends TrackedComponent
## Component that controls movement on the ground.

#region Exported properties
## The rate in pixels per second that the actor moves.
@export var movement_speed: float = 250
@export var footstep_audio: RandomAudio
#endregion

@export_node_path("Grounder") var _grounder_node_path: NodePath

@onready var _grounder: Grounder = get_node_or_null(_grounder_node_path)

#region Signals
## Emitted when the actor has reached its destination point.
signal reached_destination(current_x: float)
#endregion

#region Getters/setters
## The normalized direction of the actor's motion
var current_direction_x: float:
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
	move(value)

## Move the actor.
func move(direction: float) -> void:
	var x: float = sign(direction) * movement_speed
	if is_instance_valid(_grounder) and _grounder.is_grounded:
		if abs(direction) > 0:
			_actor_root.try_play_animation("move")
		else:
			_actor_root.try_play_animation("idle")
	if x != velocity_x:
		save_event(direction)
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
		footstep_audio.play_random(0.75, 1.25)
#endregion
