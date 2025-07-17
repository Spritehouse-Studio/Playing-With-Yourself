extends Node
## Manages the saving and loading of game data.

#region Constants
## Name of the file containing the save data, suffixed with a profile ID.
const SAVE_FILE_NAME: String = "data"
## The path to the file containing global game settings.
const SETTINGS_PATH: String = "user://settings.tres"
#endregion

#region Public variables
## The current settings instance.
var settings := Settings.new()
## The currently loaded save game data.
var save_data: SaveData
#endregion

#region Non-public variables
## The default save configuration if a new game is started.
var _default_save = preload("uid://b8toa1sc0aruw")
## The ID of the selected profile.
var _selected_profile_id: int = 0
#endregion

#region Getters/setters
## The location of the selected profile's save file.
var _save_path: String:
	get:
		return "user://%s%d.tres" % [SAVE_FILE_NAME, _selected_profile_id]
#endregion

#region Godot's built-in methods
func _init() -> void:
	settings = _load_settings()

func _on_tree_exiting() -> void:
	save_game()
#endregion


#region Public methods
## Load game data and settings from disk.
func load_game(profile_id: int = 0) -> void:
	_selected_profile_id = profile_id
	save_data = _load_game_data()
	
## Save game data and settings to disk.
func save_game() -> void:
	_save_game_data()
	_save_settings()
#endregion

#region Non-public methods
## Load game data from disk.
func _load_game_data() -> SaveData:
	if not ResourceLoader.exists(_save_path):
		print("No save data found, creating new save")
		return _default_save
	return load(_save_path)
	
## Load settings from disk.
func _load_settings() -> Settings:
	if not ResourceLoader.exists(SETTINGS_PATH):
		print("No settings found, creating new settings")
		return Settings.new()
	return load(SETTINGS_PATH)

## Save game data to disk.
func _save_game_data() -> void:
	if save_data == null:
		return
	ResourceSaver.save(save_data, _save_path)
	
## Save settings to disk
func _save_settings() -> void:
	ResourceSaver.save(settings, SETTINGS_PATH)

#endregion
