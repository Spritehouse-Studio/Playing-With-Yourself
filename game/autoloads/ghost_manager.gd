extends Node2D

var ghost_prefab: PackedScene = preload("uid://t7ypauv6ao1y")

class GhostEvent:
	var time: float
	var type: String
	var value: Variant
	var ghost_position: Vector2

class GhostEvents:
	var events: Array[GhostEvent]

var all_ghost_events: Array[GhostEvents]
var ghosts: Array[Ghost]

var current_time: float

var last_ghost_events: Array[GhostEvent]:
	get:
		return all_ghost_events[len(all_ghost_events) - 1].events

var player: PlayerBase:
	get:
		return get_tree().get_first_node_in_group("players")

func _process(delta: float) -> void:
	current_time += delta

func reset_time() -> void:
	current_time = 0

func reload() -> void:
	reset_time()
	_reload_ghosts()
	_create_ghost()
	_create_new_ghost_events()
	#_initial_scene_load()

func reset() -> void:
	all_ghost_events.clear()
	ghosts.clear()
	for child in get_children():
		if child is Ghost:
			child.queue_free()

#func _initial_scene_load() -> void:
	#var scene_change_event := GhostEvent.new()
	#scene_change_event.time = current_time
	#scene_change_event.type = "scene_change"
	#scene_change_event.value = SceneManager.current_scene
	#if is_instance_valid(player):
		#scene_change_event.ghost_position = player.global_position
	#last_ghost_events.append(scene_change_event)

func _create_new_ghost_events() -> void:
	if is_instance_valid(player):
		var ghost_events := GhostEvents.new()
		all_ghost_events.append(ghost_events)

func _create_ghost() -> void:
	if len(all_ghost_events) <= 0:
		return
	var ghost: Ghost = ghost_prefab.instantiate()
	ghost.ghost_index = len(ghosts)
	add_child(ghost)
	ghosts.append(ghost)

func _reload_ghosts() -> void:
	for ghost in ghosts:
		ghost.reload()
