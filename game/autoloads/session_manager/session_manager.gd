extends Node

var first_scene: PackedScene = preload("uid://d3k4bi03gjyyn")

var last_saved_scene: PackedScene
var last_save_point_path: String

func reset() -> void:
	last_saved_scene = first_scene
	await SceneManager.change_scene(last_saved_scene)
	var save_point: SavePoint = get_tree().get_first_node_in_group("save_points")
	if is_instance_valid(save_point):
		last_save_point_path = save_point.get_path()
		save_point.reload()
	GhostManager.reset()
	GhostManager.reload()

func reload() -> void:
	await SceneManager.change_scene(last_saved_scene)
	var save_point: SavePoint = get_tree().root.get_node_or_null(last_save_point_path)
	if is_instance_valid(save_point):
		save_point.reload()
	GhostManager.reload()

func save(current_scene: PackedScene, save_point_path: String) -> void:
	last_saved_scene = current_scene
	last_save_point_path = save_point_path
