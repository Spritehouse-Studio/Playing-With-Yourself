class_name TrackedComponent extends ActorComponentBase

var ghost_index: int
var current_event_index: int

var component_name: String:
	get:
		return get_script().get_global_name()

var events: Array[GhostManager.GhostEvent]:
	get:
		return GhostManager.all_ghost_events[ghost_index].events.filter(func(ev: GhostManager.GhostEvent): 
			return ev.values.has(component_name))

var num_events: int:
	get:
		return events.size()

func _process(delta: float) -> void:
	if _actor_root is Ghost:
		if num_events <= 0 or current_event_index >= num_events:
			return
		var event: GhostManager.GhostEvent = events[current_event_index]
		if Engine.get_frames_drawn() - GhostManager.player_life_frame_index >= event.frame:
			_actor_root.global_position = event.ghost_position
			load_event(event.values[component_name])
			current_event_index += 1

func save_event(value: Variant) -> void:
	if _actor_root is PlayerBase:
		var event := GhostManager.GhostEvent.new()
		event.frame = Engine.get_frames_drawn() - GhostManager.player_life_frame_index
		event.values[get_script().get_global_name()] = value
		event.ghost_position = _actor_root.global_position
		event.scene = get_tree().current_scene.name
		GhostManager.all_ghost_events[GhostManager.ghosts.size()].events.append(event)

func load_event(value: Variant) -> void:
	pass
