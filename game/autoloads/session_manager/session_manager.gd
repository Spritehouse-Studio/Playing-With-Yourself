extends Node2D

var main_scene: PackedScene = preload("uid://vtvlbu4ris7r")
var reload_audio: AudioStream = preload("uid://6e6plymqvghr")

@onready var animator: AnimationPlayer = $animator
@onready var win_text: Label = $canvas_layer/win_text

var current_save_point_path: String
var current_floor: int

var session_duration: float

var camera: GameCamera:
	get:
		if get_tree().current_scene is MainLevel:
			return get_tree().current_scene.camera
		return null

func _ready() -> void:
	var viewport_texture: ViewportTexture = get_viewport().get_texture()
	$canvas_layer/blur.texture = ImageTexture.create_from_image(viewport_texture.get_image())

func _process(delta: float) -> void:
	session_duration += delta
	if is_instance_valid(camera):
		global_position = camera.global_position - camera.offset

func reset() -> void:
	save(1, "/root/main_level/floors/floor1/contents/start")
	reload()
	GhostManager.reset()

func reload() -> void:
	await SceneManager.change_scene(main_scene)
	var current_scene: MainLevel = get_tree().current_scene
	if is_instance_valid(current_scene):
		current_scene.load_floor(current_floor)
		var current_save_point: SavePoint = get_node_or_null(current_save_point_path)
		if is_instance_valid(current_save_point):
			current_save_point.reload()
	GhostManager.reload()
	LifeManager.reload()
	LifeManager.start_life(15)
	AudioManager.play_audio(reload_audio, global_position)

func save(floor_number: int, save_point_path: String) -> void:
	current_floor = floor_number
	current_save_point_path = save_point_path

func win_game() -> void:
	animator.play("win")
	LifeManager.paused = true
	await get_tree().create_timer(5).timeout
	var num_ghosts: int = len(GhostManager.ghosts)
	var score: int = floor(session_duration / 3000 + 100000 / num_ghosts)
	if SaveManager.save_data == null or score > SaveManager.save_data.high_score:
		SaveManager.save_data = SaveData.new()
		SaveManager.save_data.high_score = score
		SaveManager.save_data.num_ghosts = num_ghosts
		SaveManager.save_data.time = session_duration
		SaveManager.save_game()
	SceneManager.go_to_main_menu()
