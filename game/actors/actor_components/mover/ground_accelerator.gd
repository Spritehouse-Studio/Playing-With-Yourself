class_name GroundAccelerator extends GroundMover
## Allows the actor to accelerate into and decelerate from motion on the ground.

#region Exported properties
## The rate at which the actor accelerates, in pixels per second.
@export var acceleration_rate: float = 500
## The rate at which the actor decelerates, in pixels per second.
@export var deceleration_rate: float = 1200
#endregion

#region Non-public variables
var _target_velocity_x: float
#endregion

#region Godot's built-in methods
func _process(delta: float) -> void:
	if _target_velocity_x > 0 and velocity_x > 0 or \
		_target_velocity_x < 0 and velocity_x < 0:
		# Accelerate	 to top speed
		_accelerate(delta)
	elif _target_velocity_x > 0 and velocity_x < 0 or \
		_target_velocity_x < 0 and velocity_x > 0:
		# Decelerate in the other direction	
		_decelerate(delta)
	elif abs(velocity_x) > 0 and abs(_target_velocity_x) <= 0:
		# Delecerate to a stop
		_decelerate(delta)
	elif abs(velocity_x) <= 0 and _target_velocity_x != 0:
		# Accelerate from a stop
		_accelerate(delta)
#endregion

#region Public methods
func move(direction: float) -> void:
	_target_velocity_x = sign(direction) * movement_speed
#endregion

#region Non-public methods
func _accelerate(delta: float) -> void:
	var next_velocity_x: float = velocity_x + sign(_target_velocity_x) * acceleration_rate * delta
	if _target_velocity_x > 0:
		velocity_x = min(next_velocity_x, _target_velocity_x)
	elif _target_velocity_x < 0:
		velocity_x = max(next_velocity_x, _target_velocity_x)
	else:
		velocity_x = next_velocity_x

func _decelerate(delta: float) -> void:
	var next_velocity_x: float = velocity_x - current_direction_x * deceleration_rate * delta
	if current_direction_x > 0:
		velocity_x = max(next_velocity_x, 0)
	elif current_direction_x < 0:
		velocity_x = min(next_velocity_x, 0)
#endregion
