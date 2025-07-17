extends Node

#region Getters/setters
var _gravity_vector: Vector2:
	get:
		return ProjectSettings.get_setting("physics/2d/default_gravity_vector")

var _gravity_factor: float:
	get:
		return ProjectSettings.get_setting("physics/2d/default_gravity")

## The default gravity vector multiplied by the default gravity value.
var scaled_gravity_vector: Vector2:
	get:
		return _gravity_vector * _gravity_factor

## The amount of force applied by gravity.
var gravity_force: float:
	get:
		return scaled_gravity_vector.length()

## The angle of the gravity vector in radians.
var gravity_angle: float:
	get:
		return atan2(_gravity_vector.y, _gravity_vector.x)
#endregion
