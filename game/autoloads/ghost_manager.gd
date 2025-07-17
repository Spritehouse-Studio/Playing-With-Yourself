extends Node2D

var ghost_prefab: PackedScene = preload("uid://t7ypauv6ao1y")

class GhostEvent:
	var frame: int
	var values: Dictionary[String, Variant]
	var ghost_position: Vector2
	var scene: String

class GhostEvents:
	var events: Array[GhostEvent]

var all_ghost_events: Array[GhostEvents]
var ghosts: Array[Ghost]

var player_life_frame_index: int

func update_frame_index() -> void:
	player_life_frame_index = Engine.get_frames_drawn()

func reload() -> void:
	update_frame_index()
	ghosts.clear()
	for child in get_children():
		if child is Ghost:
			child.queue_free()
	_create_ghosts()
	_create_new_ghost_events()

func reset() -> void:
	all_ghost_events.clear()

func _create_new_ghost_events() -> void:
	var player: PlayerBase = get_tree().get_first_node_in_group("players")
	if is_instance_valid(player):
		var ghost_events := GhostEvents.new()
		all_ghost_events.append(ghost_events)

func _create_ghosts() -> void:
	if len(all_ghost_events) <= 0:
		return
	var player: PlayerBase = get_tree().get_first_node_in_group("players")
	for ghost_index in range(0, len(all_ghost_events)):
		var ghost: Ghost = ghost_prefab.instantiate()
		for child in ghost.get_children():
			if child is TrackedComponent:
				child.ghost_index = ghost_index
		if is_instance_valid(player):
			ghost.global_position = player.global_position
			ghost.transform.x.x = player.transform.x.x
		add_child(ghost)
		ghosts.append(ghost)
