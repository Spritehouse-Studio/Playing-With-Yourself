class_name GameCamera extends Camera2D
## Custom camera controller featuring tracking targets and keeping them in frame.

## Data structure used for storing the min and max values for each axis.
class TargetRanges:
	## The minimum position value for all targets along the x-axis.
	var min_x: float
	## The maximum position value for all targets along the x-axis.
	var max_x: float
	## The minimum position value for all targets along the y-axis.
	var min_y: float
	## The maximum position value for all targets along the y-axis.
	var max_y: float

#region Constants
## The amount of pixels to pad the camera framing of all targets with.
const BASE_TARGET_FRAME_PADDING: int = 320
#endregion

#region Exported properties
## The base zoom factor.
@export var base_zoom: float = 1
## The speed at which the camera lerps to its targets.
@export var tracking_speed: float = 5
## A list of targets to track.
@export var targets: Array[Node2D] = []
## The maximum distance that the camera has to be from its target position before it stops tracking.
@export var end_tracking_threshold: float = 10
#endregion

#region Available nodes on ready
## Controls camera shake.
@onready var _shaker: Shaker = get_node_or_null("shaker")
## The area outside of which the camera will start tracking its targets.
@onready var _dead_zone: Area2D = get_node_or_null("dead_zone")
## The collider bounds for the dead zone.
@onready var _dead_zone_shape: CollisionShape2D = _dead_zone.get_node_or_null("shape")
## The root window containing this camera.
@onready var _root_window: Window = get_tree().get_root()

#region Public variables
## Whether the camera is tracking.
var tracking: bool
#endregion

#region Non-public variables
## Backing field for the locked variable.
var _locked_backing_field: bool
#endregion

#region Getters/setters
## Whether the camera is locked to a position.
var locked: bool:
	get:
		return _locked_backing_field
	set(value):
		_locked_backing_field = value
		tracking = not value

var _target_padding: Vector2:
	get:
		return Vector2(BASE_TARGET_FRAME_PADDING / zoom.x, BASE_TARGET_FRAME_PADDING / zoom.y)

var _targets_invalid: bool:
	get:
		return targets.any(func(target): return not is_instance_valid(target))

var _target_position: Vector2:
	get:
		if _targets_invalid:
			return global_position
		var center_x: float = _target_ranges.min_x + (_target_ranges.max_x - _target_ranges.min_x) / 2
		var center_y: float = _target_ranges.min_y + (_target_ranges.max_y - _target_ranges.min_y) / 2
		return Vector2(center_x, center_y)

var _target_ranges: TargetRanges:
	get:
		if _targets_invalid:
			return null
		var target_ranges := TargetRanges.new()
		target_ranges.min_x = targets.reduce(func(x: float, target: Node2D):
			var left_edge: float = target.global_position.x - _target_padding.x
			return left_edge if left_edge < x else x,
		INF)
		target_ranges.max_x = targets.reduce(func(x, target):
			var right_edge: float = target.global_position.x + _target_padding.x
			return right_edge if right_edge > x else x,
		-INF)
		target_ranges.min_y = targets.reduce(func(y, target): 
			var top_edge: float = target.global_position.y - _target_padding.y
			return top_edge if top_edge < y else y,
		INF)
		target_ranges.max_y = targets.reduce(func(y, target):
			var bottom_edge: float = target.global_position.y + _target_padding.y
			return bottom_edge if bottom_edge > y else y,
		-INF)
		return target_ranges

var _target_zoom: float:
	get:
		if len(targets) <= 1:
			return base_zoom
		var x_range: float = _target_ranges.max_x - _target_ranges.min_x + 2 * BASE_TARGET_FRAME_PADDING
		var y_range: float = _target_ranges.max_y - _target_ranges.min_y + 2 * BASE_TARGET_FRAME_PADDING
		var zoom_factor: float = min(_root_window.size.x / x_range, _root_window.size.x / y_range, base_zoom)
		return zoom_factor
#endregion

#region Godot's built-in methods
func _ready() -> void:
	zoom = Vector2.ONE * base_zoom

func _process(delta: float) -> void:
	#for target in targets:
		#if not is_instance_valid(target):
			#targets.erase(target)
	var dead_zone_size: Vector2 = _dead_zone_shape.get_shape().get_rect().size
	var rect := Rect2(global_position - dead_zone_size / 2, dead_zone_size)
	if not locked and not rect.has_point(_target_position):
		tracking = true
	if tracking:
		_track(delta)
#endregion

#region Public methods
## Add a target for this camera to track
func add_target(target: Node2D, immediate: bool = true, recursive: bool = false) -> void:
	targets.append(target)
	if recursive:
		for child in target.get_children():
			if child is Node2D:
				add_target(child, immediate, recursive)
	if immediate:
		global_position = _target_position
		zoom = Vector2.ONE * _target_zoom
		tracking = false

## Set a single target for the camera
func set_target(target: Node2D, recursive: bool = false) -> void:
	targets.clear()
	add_target(target, true, recursive)

## Shake the camera
func shake(amount: float, duration: float, x: bool = true, y: bool = true) -> void:
	if is_instance_valid(_shaker):
		if x and y:
			_shaker.shake(amount * SaveManager.settings.screen_shake_intensity, duration)
		elif x and not y:
			_shaker.shake_x(amount * SaveManager.settings.screen_shake_intensity, duration)
		elif not x and y:
			_shaker.shake_y(amount * SaveManager.settings.screen_shake_intensity, duration)
#endregion

#region Non-public methods
## Track targets
func _track(delta: float) -> void:
	if global_position.distance_to(_target_position) <= end_tracking_threshold:
		tracking = false
	global_position = global_position.lerp(_target_position, tracking_speed * delta)
	zoom = zoom.lerp(Vector2.ONE * _target_zoom, tracking_speed * delta)
#endregion
