class_name Grounder extends ActorComponentBase
## Component that reports the actor's grounded state.

#region Exported properties
## The number of ray casts to cast to the ground to determine grounded state.
@export_range(2, 5) var _ground_ray_cast_count: int
## The distance in pixels that each ground ray will cast for to check for a grounded state.
@export var _ground_ray_cast_length: float = 4
## Multiplier that affects how severely the actor is affected by gravity.
@export var mass_scale: float = 1
## Path to the node providing collisions to the actor body.
@export_node_path("CollisionShape2D") var _physics_collider_node_path: NodePath
## The collision layers that each ground ray cast will collide with.
@export_flags_2d_physics var _ground_ray_cast_collision_mask: int = 0b0000000000000010
@export var terminal_velocity: float = 1200
#endregion

#region Available nodes on ready
@onready var _physics_collider: CollisionShape2D = get_node_or_null(_physics_collider_node_path)
#endregion

#region Public variables
var pause_gravity: bool:
	set(value):
		if value:
			_actor_root.velocity.y = 0
#endregion

#region Non-public variables
var _ground_ray_casts: Array[RayCast2D]
#endregion

#region Getters/setters
## Whether the actor is currently on the ground.
var is_grounded: bool:
	get:
		for ray in _ground_ray_casts:
			ray.force_raycast_update()
			if ray.is_colliding():
				return true
		return false

## Whether the actor is currently in the air.
var is_airborne: bool:
	get:
		return not is_grounded
#endregion

#region Godot's built-in methods
func _ready() -> void:
	super._ready()
	_create_ground_ray_casts()

func _process(delta: float) -> void:
	if is_airborne and not pause_gravity:
		_apply_gravity(delta)
#endregion

#region Non-public methods
func _create_ground_ray_casts() -> void:
	if not is_instance_valid(_physics_collider):
		return
	var shape_rect: Rect2 = _physics_collider.shape.get_rect()
	var shape_start: Vector2 = shape_rect.position
	var shape_end: Vector2 = shape_rect.end
	var current_x: float = shape_start.x + 2
	var end_x: float = shape_end.x - 2
	var y: float = shape_end.y
	var shape_width: float = end_x - current_x
	var step: float = shape_width / (_ground_ray_cast_count - 1)
	while current_x <= end_x:
		var ground_ray_cast := RayCast2D.new()
		ground_ray_cast.add_exception(_actor_root)
		ground_ray_cast.enabled = true
		ground_ray_cast.collision_mask = _ground_ray_cast_collision_mask
		ground_ray_cast.position = Vector2(current_x, y)
		ground_ray_cast.target_position = GravityUtilities.scaled_gravity_vector.normalized() * (_ground_ray_cast_length + 1)
		_physics_collider.add_child(ground_ray_cast)
		_ground_ray_casts.append(ground_ray_cast)
		current_x += step

func _apply_gravity(delta: float) -> void:
	_actor_root.velocity.y = min(
		_actor_root.velocity.y + GravityUtilities.scaled_gravity_vector.y * mass_scale * delta,
		terminal_velocity)
#endregion
