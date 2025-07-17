class_name Jumper extends TrackedComponent
## Component that allows the attached actor to jump.

#region Exported properties
## The height in pixels of the actor at the highest point of their jump.
@export var jump_apex_height: float = 400
## Path to an actor's Grounder component.
@export_node_path("Grounder") var _grounder_node_path: NodePath
@export var jump_audio: AudioStream
@export var land_audio: AudioStream
#endregion

#region Available nodes on ready
## Component queried for grounded state.
@onready var _grounder: Grounder = get_node_or_null(_grounder_node_path)
#endregion

#region Signals
## Emitted when the actor lands on the ground.
signal landed(landing_speed: float)
#endregion

#region Non-public variables
var _current_jump_speed: float
#endregion

#region Getters/setters
## Whether the actor is currently falling down.
var is_falling: bool:
	get:
		return _actor_root.velocity.y > 0
#endregion

#region Godot's built-in methods
func _process(delta: float) -> void:
	_update_airborne_animation()
	_update_landing()
	super._process(delta)
#endregion

#region Public methods
## Start a jump.
func jump(height: float = jump_apex_height) -> void:
	if not is_instance_valid(_grounder):
		return
	var jump_angle: float = GravityUtilities.gravity_angle + PI
	var height_x: float = height * cos(jump_angle)
	var height_y: float = height * sin(jump_angle)
	var jump_x_squared: float = 2 * _grounder.mass_scale * GravityUtilities.scaled_gravity_vector.x * height_x
	var jump_y_squared: float = 2 * _grounder.mass_scale * GravityUtilities.scaled_gravity_vector.y * height_y
	var jump_x: float = sign(jump_x_squared) * sqrt(abs(jump_x_squared))
	var jump_y: float = sign(jump_y_squared) * sqrt(abs(jump_y_squared))
	var jump_vector := Vector2(jump_x, jump_y)
	_actor_root.velocity = jump_vector
	if jump_audio != null:
		AudioManager.play_audio(jump_audio)
	save_event(true)

## Jump from the actor's starting position to a target position
func jump_to(target_position: Vector2) -> void:
	var diff = target_position - global_position
	_actor_root.velocity.x = diff.x
	# Sorry, not doing Runge-Kutta for this shit
	_actor_root.velocity.y = -sqrt(abs(2 * GravityUtilities.gravity_force * _grounder.mass_scale * diff.y))
	await landed
	_actor_root.velocity.x = 0

## End the current jump.
func end_jump() -> void:
	_actor_root.velocity.y = 0
	save_event(false)

func load_event(value: Variant) -> void:
	var do_jump = value as bool
	if do_jump:
		jump()
	else:
		end_jump()
#endregion

#region Non-public methods
func _update_airborne_animation() -> void:
	if is_instance_valid(_grounder) and not _grounder.is_grounded:
		if _actor_root.velocity.y > 0:
			_actor_root.try_play_animation("fall")
		elif _actor_root.velocity.y < 0:
			_actor_root.try_play_animation("jump")

func _update_landing() -> void:
	if is_instance_valid(_grounder):
		if _grounder.is_grounded:
			if _current_jump_speed > 0:
				if land_audio != null:
					AudioManager.play_audio(land_audio)
				landed.emit(_current_jump_speed)
				_current_jump_speed = 0
		elif not _actor_root.is_on_floor():
			_current_jump_speed = _actor_root.velocity.y
#endregion
