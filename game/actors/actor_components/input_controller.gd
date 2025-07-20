class_name InputController extends ActorComponentBase
## Component that makes this actor be controlled by keyboard/gamepad inputs

#region Exported properties
## The duration that the actor will be allowed to float mid-air for before being unable to jump.
@export var coyote_time: float = 0.1
## The duration that a jump will be buffered for
@export var jump_buffer_time: float = 0.1
@export_node_path("Facer") var _facer_node_path: NodePath
@export_node_path("Grounder") var _grounder_node_path: NodePath
@export_node_path("GroundMover") var _mover_node_path: NodePath
@export_node_path("HealthManager") var _health_manager_node_path: NodePath
@export_node_path("Interactor") var _interactor_node_path: NodePath
@export_node_path("Jumper") var _jumper_node_path: NodePath
@export_node_path("WeaponWielder") var _weapon_node_path: NodePath
#endregion

#region Available nodes on ready
@onready var _facer: Facer = get_node_or_null(_facer_node_path)
@onready var _grounder: Grounder = get_node_or_null(_grounder_node_path)
@onready var _health_manager: HealthManager = get_node_or_null(_health_manager_node_path)
@onready var _mover: GroundMover = get_node_or_null(_mover_node_path)
@onready var _interactor: Interactor = get_node_or_null(_interactor_node_path)
@onready var _jumper: Jumper = get_node_or_null(_jumper_node_path)
@onready var _weapon: WeaponWielder = get_node_or_null(_weapon_node_path)
#endregion

#region Non-public variables
## Keeps track of the duration that the actor has been floating mid-air for.
var _coyote_timer: float = INF
## Keeps track of the duration that the jump buffer has been active for.
var _jump_buffer_timer: float = INF
var _started_jump: bool
var _disabled: bool = false
#endregion

#region Getters/setters
## Whether the component should be processing inputs.
var disabled: bool:
	get:
		return _disabled
	set(value):
		_disabled = value
		if is_instance_valid(_mover):
			_mover.stop()
		_jump_buffer_timer = INF
		_started_jump = false
	
## Whether the actor can perform a jump.
var _can_jump: bool:
	get:
		return _coyote_timer <= coyote_time or _actor_root.is_on_floor()

## Whether a jump is currently buffered
var _jump_buffered: bool:
	get:
		return _jump_buffer_timer <= jump_buffer_time
#endregion

#region Godot's built-in methods
func _ready() -> void:
	super._ready()
	if is_instance_valid(_jumper):
		_jumper.landed.connect(_on_land)

func _process(delta: float) -> void:
	_update_coyote_time(delta)
	if not disabled:
		_update_attack()
		_update_jump(delta)
		_update_movement()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and is_instance_valid(_interactor):
		_interactor.try_interact()
	elif event.is_action_pressed("reload"):
		if is_instance_valid(_health_manager):
			_health_manager._die()
		SessionManager.reload()
#endregion

#region Non-public methods
func _update_attack() -> void:
	if is_instance_valid(_weapon):
		if Input.is_action_just_pressed("attack"):
			_weapon.attack()

func _update_coyote_time(delta: float) -> void:
	if is_instance_valid(_grounder) and _grounder.is_airborne and not _started_jump:
		if _coyote_timer <= coyote_time:
			_grounder.pause_gravity = true
			_coyote_timer += delta
		elif _coyote_timer == INF:
			_grounder.pause_gravity = false
			_coyote_timer = 0

func _update_jump(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		if _can_jump:
			_do_jump()
		_jump_buffer_timer = 0
	elif Input.is_action_just_released("jump"):
		_jump_buffer_timer = INF
		if is_instance_valid(_jumper) and not _jumper.is_falling:
			_jumper.end_jump()
	if _jump_buffer_timer <= jump_buffer_time:
		_jump_buffer_timer += delta

func _update_movement() -> void:
	if is_instance_valid(_mover):
		var movement_x: float = Input.get_axis("move_left", "move_right")
		_mover.move(movement_x)

func _on_land(_landing_speed: float) -> void:
	_started_jump = false
	if _jump_buffered:
		_do_jump()
	_coyote_timer = INF

func _do_jump() -> void:
	_started_jump = true
	if is_instance_valid(_jumper):
		_jumper.jump()
#endregion
