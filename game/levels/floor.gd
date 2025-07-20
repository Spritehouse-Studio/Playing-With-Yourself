class_name Floor extends Node2D

@export var floor_number: int
@export_node_path var last_save_point_node_path: NodePath

@onready var _last_save_point: SavePoint = get_node_or_null(last_save_point_node_path)
@onready var tile_map: TileMapLayer = $tile_map

func _ready() -> void:
	if is_instance_valid(_last_save_point) and \
		not _last_save_point.saved.is_connected(_on_last_save_point_saved):
		_last_save_point.saved.connect(_on_last_save_point_saved)

signal load_floor(floor_number: int)
signal unload_floor(floor_number: int)

func _on_last_save_point_saved() -> void:
	load_floor.emit(floor_number + 1)
	unload_floor.emit(floor_number - 1)
