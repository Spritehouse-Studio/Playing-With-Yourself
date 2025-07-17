class_name Facer extends TrackedComponent
## Component that controls the direction that the attached actor is facing.

#region Godot's built-in methods
func _process(delta: float) -> void:
	_update_direction()
#endregion

#region Public methods
## Face a target object.
func face(target: Node2D) -> void:
	var actor_x: float = _actor_root.global_position.x
	var target_x: float = target.global_position.x
	var scale_x: float = _actor_root.transform.x.x
	if actor_x > target_x and scale_x > 0 or actor_x < target_x and scale_x < 0:
		_flip()
#endregion

#region Non-public methods
## Flip the actor's scale.
func _flip() -> void:
	_actor_root.transform.x.x *= -1

func _update_direction() -> void:
	var movement_x: float = _actor_root.velocity.x
	var scale_x: float = _actor_root.transform.x.x
	if movement_x < 0 and scale_x > 0 or movement_x > 0 and scale_x < 0:
		_flip()
#endregion
