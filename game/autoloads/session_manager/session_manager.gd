extends Node2D

var first_scene: PackedScene = preload("uid://d3k4bi03gjyyn")
var reload_audio: AudioStream = preload("uid://b7w54l64tu6cs")

@onready var animator: AnimationPlayer = $animator
@onready var win_text: Label = $canvas_layer/win_text

var last_saved_scene: PackedScene
var last_save_point_path: String

var camera: GameCamera:
	get:
		if get_tree().current_scene is BaseLevel:
			return get_tree().current_scene.camera
		return null

func _ready() -> void:
	var viewport_texture: ViewportTexture = get_viewport().get_texture()
	$canvas_layer/blur.texture = ImageTexture.create_from_image(viewport_texture.get_image())

func _process(delta: float) -> void:
	if is_instance_valid(camera):
		global_position = camera.global_position - camera.offset

func reset() -> void:
	last_saved_scene = first_scene
	await SceneManager.change_scene(last_saved_scene)
	var save_point: SavePoint = get_tree().get_first_node_in_group("save_points")
	if is_instance_valid(save_point):
		last_save_point_path = save_point.get_path()
		save_point.reload()
	GhostManager.reset()
	GhostManager.reload()
	LifeManager.start_life(30)
	AudioManager.play_audio(reload_audio, save_point.global_position)

func reload() -> void:
	await SceneManager.change_scene(last_saved_scene)
	var save_point: SavePoint = get_tree().root.get_node_or_null(last_save_point_path)
	if is_instance_valid(save_point):
		save_point.reload()
	GhostManager.reload()
	LifeManager.reload()
	LifeManager.start_life(30)
	AudioManager.play_audio(reload_audio, save_point.global_position)

func save(current_scene: PackedScene, save_point_path: String) -> void:
	last_saved_scene = current_scene
	last_save_point_path = save_point_path

func win_game() -> void:
	animator.play("win")
	LifeManager.paused = true
	await get_tree().create_timer(5).timeout
	SceneManager.go_to_main_menu()
