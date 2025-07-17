## An object where the player may save their game
class_name SavePoint extends Area2D

## The name of this save point that will be displayed in the fast travel menu
@export var save_point_name: String

## The player prefab to instantiate on load
var player_prefab: PackedScene = preload("uid://bx46gngy5shiy")

## The root of the level scene that this save point is located in
@onready var level_root: BaseLevel = get_owner()
@onready var player_offset: Node2D = $player_offset

## The data associated with this save point
var data: SavePointData

## Load this save point as the last save
func reload() -> void:
	var player: PlayerBase = player_prefab.instantiate()
	player.global_position = player_offset.global_position
	level_root.add_child(player)
	level_root.camera.set_target(player)
	var health: HealthManager = player.get_node("health_manager")
	if is_instance_valid(health):
		health.died.connect(level_root._on_player_death)

## Save the current point
func _save() -> void:
	var current_scene: PackedScene = load(get_tree().current_scene.scene_file_path)
	SessionManager.save(current_scene, get_path())


func _on_body_entered(body: Node2D) -> void:
	if body is PlayerBase:
		_save()
