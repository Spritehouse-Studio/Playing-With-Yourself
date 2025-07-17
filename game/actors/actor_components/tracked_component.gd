class_name TrackedComponent extends ActorComponentBase

var ghost_index: int

var current_time: float = 0

var current_timeline_index: int = 0

func _process(delta: float) -> void:
	current_time += delta	
	if _actor_root is Ghost:
		var component_data = GhostManager.ghost_data[ghost_index].component_data[get_script().get_global_name()]
		var timeline_size: int = len(component_data.timeline)
		if timeline_size <= 0 or current_timeline_index >= timeline_size:
			return
		var time: float = component_data.timeline[current_timeline_index]
		if current_time >= time:
			load_event(component_data.values[current_timeline_index])
			current_timeline_index += 1

func save_event(value: Variant) -> void:
	if _actor_root is PlayerBase:
		GhostManager.ghost_data[ghost_index].component_data[get_script().get_global_name()].timeline.append(current_time)
		GhostManager.ghost_data[ghost_index].component_data[get_script().get_global_name()].values.append(value)

func load_event(value: Variant) -> void:
	pass
