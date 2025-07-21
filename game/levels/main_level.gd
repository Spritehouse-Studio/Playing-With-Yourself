class_name MainLevel extends Node2D

## The music track played in this level
@export var music_track: MusicTrack

#region Available nodes on ready
## The level's camera.
@onready var camera: GameCamera = $game_camera
@onready var floors_parent: Node2D = $floors
@onready var input_tutorial_ui: InputTutorialUI = $canvas_layer/container/input_tutorial_ui

var floor_prefabs: Dictionary[int, PackedScene] = {
	1: preload("uid://bwn1xmu0jd7ui"),
	2: preload("uid://ckibcofsagymc"),
	3: preload("uid://dfi5ntjsjflc6"),
	4: preload("uid://b0j08uviep4xm")
}
#endregion

#region Godot's built-in methods
func _ready() -> void:
	_play_music()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
#endregion

#region Non-public methods
## Set up the game camera for this specific level.
func _setup_camera(tile_map: TileMapLayer)  -> void:
	# Set camera limits
	var tile_rect: Rect2i = tile_map.get_used_rect()
	var tile_size: int = tile_map.tile_set.tile_size.x
	var scaled_rect := Rect2i(tile_rect.position * tile_size, tile_rect.size * tile_size)
	camera.limit_left = scaled_rect.position.x
	camera.limit_right = scaled_rect.end.x
	camera.limit_bottom = scaled_rect.end.y

## Play the level's music track if it exists
func _play_music() -> void:
	if music_track:
		AudioManager.play_music(music_track)
#endregion

func _on_player_death() -> void:
	if not LifeManager.is_stopped():
		LifeManager.stop()
		await get_tree().create_timer(1).timeout
		SessionManager.reload()

func load_floor(floor_number: int) -> void:
	if not floor_prefabs.has(floor_number):
		return
	var floor: Floor = floor_prefabs[floor_number].instantiate()
	floors_parent.add_child(floor)
	floor.load_floor.connect(load_floor.call_deferred)
	floor.unload_floor.connect(unload_floor.call_deferred)
	for input_trigger in floor.input_triggers:
		input_trigger.show_input.connect(show_input_tutorial)
	_setup_camera(floor.tile_map)

func show_input_tutorial(action: String) -> void:
	input_tutorial_ui.show_input(action)

func unload_floor(floor_number: int) -> void:
	for child in floors_parent.get_children():
		if child is Floor and child.floor_number == floor_number:
			child.queue_free()
