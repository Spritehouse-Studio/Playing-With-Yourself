class_name Recoiler extends ActorComponentBase
## Component that causes the attached actor to reel from attacks and other forces.

#region Exported properties
## The duration that recoil will affect the actor for.
@export var recoil_damp_time: float = 0.5
#endregion

#region Godot's built-in methods
func _process(delta: float) -> void:
	if _recoil_vector.sign() == _damping_vector.sign():
		_actor_root.global_position += _recoil_vector
		_recoil_vector -= _damping_vector * delta
#endregion

#region Non-public variables
var _damping_vector: Vector2
var _recoil_vector: Vector2
#endregion

#region Public methods
## Begin making the actor recoil.
func start_recoil(angle: float, force: float) -> void:
	var normalized_recoil_vector := Vector2(cos(angle), sin(angle))
	_recoil_vector = normalized_recoil_vector * force
	_damping_vector = _recoil_vector / recoil_damp_time
#endregion
