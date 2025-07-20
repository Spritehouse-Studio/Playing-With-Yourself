class_name TimePickup extends Node2D

@export var time_gain_sec: float = 10
@export_range(0, 32) var float_range_y: float = 8
@export_range(0, 4) var float_duration_sec: float = 1

@onready var _pickup_area: Area2D = $pickup_area
@onready var _hands_offset: Node2D = _pickup_area.get_node_or_null("hands_offset")
@onready var _minute_hand: Sprite2D = _hands_offset.get_node_or_null("minute_hand")
@onready var _second_hand: Sprite2D = _hands_offset.get_node_or_null("second_hand")

var pickup_audio: AudioStream = preload("uid://ct1bborkgvmkf")

var float_tween: Tween

var signed_range: float:
	get:
		return float_range_y / 2

var float_direction_duration_sec: float:
	get:
		return float_duration_sec / 2

func _ready() -> void:
	_minute_hand.rotation_degrees = time_gain_sec / 2
	_second_hand.rotation_degrees = fmod(time_gain_sec, 60) * 6
	
	_pickup_area.position.y = randf_range(-signed_range, signed_range)
	var directions: Array[int] = [-1, 1]
	var direction: int = directions[randi() % len(directions)]
	var end_y: float = direction * signed_range
	var initial_float_duration: float = float_direction_duration_sec * abs(_pickup_area.position.y - end_y) / signed_range
	float_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	float_tween.tween_property(_pickup_area, "position:y", end_y, initial_float_duration).from_current()
	float_tween.finished.connect(_reflect_float)

func _reflect_float() -> void:
	float_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	var next_direction: int = -sign(_pickup_area.position.y)
	var next_target_y: float = next_direction * signed_range
	float_tween.tween_property(_pickup_area, "position:y", next_target_y, float_direction_duration_sec).from_current()
	float_tween.finished.connect(_reflect_float)

func _on_pickup_area_body_entered(body: Node2D) -> void:
	if body is PlayerBase:		
		AudioManager.play_audio(pickup_audio, global_position)
		LifeManager.add_time(time_gain_sec)
		queue_free()
