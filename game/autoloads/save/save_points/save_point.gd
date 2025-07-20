## An object where the player may save their game
class_name SavePoint extends Area2D
	
## The player prefab to instantiate on load
var player_prefab: PackedScene = preload("uid://bx46gngy5shiy")

## The root of the level scene that this save point is located in
@onready var floor_root: Floor = get_owner()
@onready var level_root: MainLevel = floor_root.get_parent().get_parent()
@onready var player_offset: Node2D = $player_offset

signal saved

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
	saved.emit()
	SessionManager.save(floor_root.floor_number, get_path())

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerBase:
		_save()
