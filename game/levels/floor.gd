class_name Floor extends Node2D

@export var floor_number: int
@export_node_path("SavePoint") var load_save_point_node_path: NodePath
@export_node_path("SavePoint") var unload_save_point_node_path: NodePath

@onready var _load_save_point: SavePoint = get_node_or_null(load_save_point_node_path)
@onready var _unload_save_point: SavePoint = get_node_or_null(unload_save_point_node_path)
@onready var tile_map: TileMapLayer = $tile_map

func _ready() -> void:
	if is_instance_valid(_load_save_point) and \
		not _load_save_point.saved.is_connected(_on_load_save_point_saved):
		_load_save_point.saved.connect(_on_load_save_point_saved)
	if is_instance_valid(_unload_save_point) and \
		not _unload_save_point.saved.is_connected(_on_unload_save_point_saved):
		_unload_save_point.saved.connect(_on_unload_save_point_saved)

signal load_floor(floor_number: int)
signal unload_floor(floor_number: int)

func _on_load_save_point_saved() -> void:
	load_floor.emit(floor_number + 1)

func _on_unload_save_point_saved() -> void:
	unload_floor.emit(floor_number - 1)
