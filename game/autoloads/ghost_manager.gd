extends Node

var ghost_prefab: PackedScene = preload("res://game/actors/ghost/ghost.tscn")

class GhostComponentData:
	var timeline: Array[float] = []
	var values: Array[Variant] = []

class GhostData:
	var component_data: Dictionary[String, GhostComponentData]

var ghost_data: Array[GhostData] = []

var ghosts: Array[Ghost] = []

var tracking: bool = false

func reset() -> void:
	ghost_data.clear()
	ghosts.clear() 

func create_ghost_data(player: PlayerBase) -> void:
	var data := GhostData.new()
	for child in player.get_children():
		if child is TrackedComponent:
			child.ghost_index = len(ghost_data)
			data.component_data[child.get_script().get_global_name()] = GhostComponentData.new()
	ghost_data.append(data)

func create_ghosts() -> void:
	var player: PlayerBase = get_tree().get_first_node_in_group("players")
	for ghost_index in range(0, len(ghost_data) - 1):
		var ghost: Ghost = ghost_prefab.instantiate()
		for child in ghost.get_children():
			if child is TrackedComponent:
				child.ghost_index = ghost_index
		ghosts.append(ghost)
		if is_instance_valid(player):
			ghost.global_position = player.global_position
			ghost.transform.x.x = player.transform.x.x
			player.get_parent().add_child.call_deferred(ghost)
