class_name Door extends StaticBody2D

#@export_node_path("Lever") var _activate_lever_node_path: NodePath

@export var open_sound: AudioStream
@export var close_sound: AudioStream

#@onready var _activate_lever: Lever = get_node_or_null(_activate_lever_node_path)

@onready var closed_sprite: Sprite2D = $closed_sprite
@onready var open_sprite: Sprite2D = $open_sprite
@onready var collision: CollisionShape2D = $collision

var closed: bool = true

#func _ready() -> void:
	#if is_instance_valid(_activate_lever):
		#_activate_lever.interacted.connect(_on_lever_toggled)

func _open() -> void:
	closed_sprite.hide()
	open_sprite.show()
	AudioManager.play_audio(open_sound, global_position)
	collision.disabled = true
	closed = false

func _close() -> void:
	closed_sprite.show()
	open_sprite.hide()
	AudioManager.play_audio(close_sound, global_position)
	collision.disabled = false
	closed = true

func toggle() -> void:
	if closed:
		_open()
	else:
		_close()
