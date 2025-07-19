class_name MovingPlatform extends Path2D

@export var animation_duration: float = 1
@export var move_on_start: bool = true

@onready var _animator: AnimationPlayer = $animator
@onready var follower: PathFollow2D = $follower

func _ready() -> void:
	var move_anim: Animation = _animator.get_animation("move")
	_animator.play("move", -1, move_anim.length / animation_duration)
	if not move_on_start:
		_animator.speed_scale = 0

#func _exit_tree() -> void:
	#StateManager.save_state(get_path(), _animator.speed_scale)
#
#func load_state(value: float) -> void:
	#_animator.speed_scale = value

func start_moving() -> void:
	_animator.speed_scale = 1

func toggle_movement() -> void:
	if _animator.speed_scale > 0:
		_animator.speed_scale = 0
	else:
		_animator.speed_scale = 1
