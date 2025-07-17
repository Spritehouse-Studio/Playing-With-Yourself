class_name Shaker extends Node
## Component that shakes an object.

#region Exported properties
## Path to the node that will be shaked.
@export_node_path("Node2D") var _shake_target_node_path: NodePath
## The duration between each shake.
@export var shake_interval: float = 0.025
#endregion

#region Available nodes on ready
@onready var _shake_target: Node2D = get_node_or_null(_shake_target_node_path)
#endregion

#region Non-public variables
## The position of the object before it began shaking.
var _original_position: Vector2
## The amount of shake to remove every frame.
var _unshake_amount: float
## Whether to shake along the x-axis.
var _shake_horizontally: bool
## Whether to shake along the y-axis.
var _shake_vertically: bool
## The current shake vector applied to the object.
var _current_shake_vector: Vector2
## The current amount of shake applied to the object.
var _current_shake_magnitude: float
## The current time that the object has been offset for during a shake.
var _current_shake_time: float
## Whether to shake the object in place.
var _shake_in_place: bool
#endregion

#region Godot's built-in methods
func _ready() -> void:
	if _shake_target == null:
		_shake_target = get_owner()

func _process(delta: float) -> void:
	if _current_shake_magnitude > 0:
		_current_shake_time += delta
		if _current_shake_time >= shake_interval:
			update_shake()
	elif _shake_in_place and _shake_target.global_position.distance_to(_original_position) > 1:
		_shake_target.global_position = _original_position
#endregion

#region Public methods
## Begin object shake in all directions.
func shake(amount: float, duration: float, in_place: bool = false) -> void:
	_shake_internal(amount, duration, in_place)
	_shake_horizontally = true
	_shake_vertically = true

## Shake object only along the x-axis.
func shake_x(amount: float, duration, in_place: bool = false) -> void:
	_shake_internal(amount, duration, in_place)
	_shake_horizontally = true
	_shake_vertically = false

## Shake object only along the y-axis.
func shake_y(amount: float, duration, in_place: bool = false) -> void:
	_shake_internal(amount, duration, in_place)
	_shake_horizontally = false
	_shake_vertically = true
#endregion

#region Non-public methods
## Set shake values.
func _shake_internal(amount: float, duration, in_place: bool = false) -> void:
	_original_position = _shake_target.global_position
	_current_shake_magnitude = amount
	if _shake_horizontally:
		_current_shake_vector.x = 1
	if _shake_vertically:
		_current_shake_vector.y = 1
	_unshake_amount = amount / duration
	_shake_in_place = in_place

## Update the current object shake.
func update_shake() -> void:
	if _shake_horizontally and _shake_vertically:
		_current_shake_vector = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * _current_shake_magnitude
	if _shake_horizontally and not _shake_vertically:
		_current_shake_vector.x = _current_shake_magnitude * -sign(_current_shake_vector.x)
	elif not _shake_horizontally and _shake_vertically:
		_current_shake_vector.y = _current_shake_magnitude * -sign(_current_shake_vector.y)
	if _shake_in_place:
		_shake_target.global_position = _original_position + _current_shake_vector
	else:
		_shake_target.global_position += _current_shake_vector
	_current_shake_magnitude -= _unshake_amount * _current_shake_time
	_current_shake_time = 0
#endregion
