class_name TrackedComponent extends ActorComponentBase

var current_event_index: int

var component_name: String:
	get:
		return get_script().get_global_name()

var events: Array[GhostManager.GhostEvent]:
	get:
		if _actor_root is not Ghost or _actor_root.ghost_index >= len(GhostManager.all_ghost_events):
			return []
		return GhostManager.all_ghost_events[_actor_root.ghost_index].events.filter(func(ev: GhostManager.GhostEvent): 
			return ev.type == component_name)

var num_events: int:
	get:
		return len(events)

var current_event: GhostManager.GhostEvent:
	get:
		if num_events <= 0 or current_event_index >= num_events:
			return null
		return events[current_event_index]

var next_event: GhostManager.GhostEvent:
	get:
		var next_event_index: int = current_event_index + 1
		if num_events <= 0 or next_event_index >= num_events:
			return null
		return events[next_event_index]

var finished_playing: bool

func _process(delta: float) -> void:
	if _actor_root is Ghost:
		if finished_playing:
			return
		if current_event !=  null:
			if GhostManager.current_time >= current_event.time:
				var new_pos: Vector2 = current_event.ghost_position
				var event_val: Variant = current_event.value
				#if next_event == null or GhostManager.current_time < next_event.time:
				_actor_root.global_position = new_pos
				load_event(event_val)
				if current_event_index < num_events - 1:
					current_event_index += 1
				else:
					finished_playing = true

func save_event(value: Variant) -> void:
	if _actor_root is PlayerBase:
		var event := GhostManager.GhostEvent.new()
		event.time = GhostManager.current_time
		event.type = component_name
		event.value = value
		event.ghost_position = _actor_root.global_position
		GhostManager.all_ghost_events[GhostManager.ghosts.size()].events.append(event)

func load_event(value: Variant) -> void:
	pass

func reload() -> void:
	current_event_index = 0
	finished_playing = false
