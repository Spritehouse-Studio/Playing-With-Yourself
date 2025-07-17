class_name MovingPlatform extends Path2D

@export var animation_duration: float = 1
@export var move_on_start: bool = true

@onready var _animator: AnimationPlayer = $animator

func _ready() -> void:
	if move_on_start:
		start_moving()

func start_moving() -> void:
	if is_instance_valid(_animator):
		var move_anim: Animation = _animator.get_animation("move")
		_animator.play("move", -1, move_anim.length / animation_duration)

func toggle_movement() -> void:
	if not _animator.is_playing():
		start_moving()
	elif _animator.speed_scale > 0:
		_animator.speed_scale = 0
	else:
		_animator.speed_scale = 1
