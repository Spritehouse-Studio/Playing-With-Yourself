class_name BaseLevel extends Node2D
## Base class for all levels in the game.

## The music track played in this scene
@export var music_track: MusicTrack

#region Available nodes on ready
## The level's camera.
@onready var camera: GameCamera = get_node_or_null("game_camera")
## The level's tile map.
@onready var tile_map: TileMapLayer = get_node_or_null("tile_map")
#endregion

#region Godot's built-in methods
func _ready() -> void:
	_open_uis()
	_setup_camera()
	_play_music()
	LifeManager.start_life(30)
#endregion

#region Public methods
## Load the save point in this scene
func load_save_point(save_point_data: SavePointData) -> void:
	var save_points: Array[Node] = get_tree().get_nodes_in_group("save_points")
	for save_point in save_points:
		if save_point is SavePoint and save_point.equals(save_point_data.save_position):
			save_point.load_save(save_point_data)
			return
#endregion

#region Non-public methods
func _open_uis() -> void:
	UIManager.open_ui(LifeTimerUI)

## Set up the game camera for this specific level.
func _setup_camera() -> void:
	if camera == null: 
		return
	camera.enabled = true
	if tile_map == null:
		return
	# Set camera limits
	var tile_rect: Rect2i = tile_map.get_used_rect()
	var tile_size: int = tile_map.tile_set.tile_size.x
	var scaled_rect := Rect2i(tile_rect.position * tile_size, tile_rect.size * tile_size)
	camera.limit_left = scaled_rect.position.x
	camera.limit_right = scaled_rect.end.x
	camera.limit_top = scaled_rect.position.y
	camera.limit_bottom = scaled_rect.end.y

## Play the level's music track if it exists
func _play_music() -> void:
	if music_track:
		AudioManager.play_music(music_track)
#endregion

func _on_player_death() -> void:
	await get_tree().create_timer(1).timeout
	LifeManager.reset()
