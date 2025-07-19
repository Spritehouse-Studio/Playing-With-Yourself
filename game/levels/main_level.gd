class_name MainLevel extends Node2D

## The music track played in this level
@export var music_track: MusicTrack

#region Available nodes on ready
## The level's camera.
@onready var camera: GameCamera = $game_camera
## The level's tile map. 
@onready var tile_map: TileMapLayer = $tile_map
#endregion

#region Godot's built-in methods
func _ready() -> void:
	_setup_camera()
	_play_music()
#endregion

#region Non-public methods
## Set up the game camera for this specific level.
func _setup_camera()  -> void:
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
	if not LifeManager.is_stopped():
		LifeManager.stop()
		await get_tree().create_timer(1).timeout
		SessionManager.reload()
