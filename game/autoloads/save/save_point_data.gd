class_name SavePointData extends Resource
## Represents a save point that the player may save or load their game from.

#region Exported properties
## The name of the save point.
@export var save_point_name: String
## The UID of the scene that the save point is located in
@export var save_scene_uid_path: String
## The position of the save point.
@export var save_position: Vector2
#endregion

#region Public methods
## Whether another save point data is equal to this one
func equals(other: SavePointData) -> bool:
	return save_point_name == other.save_point_name and \
		save_scene_uid_path == other.save_scene_uid_path
#endregion
