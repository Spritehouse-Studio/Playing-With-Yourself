class_name Ghost extends ActorBase

var ghost_index: int

var current_event_index: int
var finished_playing: bool
#@onready var current_scene: String = scene_change_events[0].value

#var scene_change_events: Array[GhostManager.GhostEvent]:
	#get:
		#return GhostManager.all_ghost_events[ghost_index].events.filter(func(ev: GhostManager.GhostEvent):
			#return ev.type == "scene_change")

#var current_scene_event: GhostManager.GhostEvent:
	#get:
		#if len(scene_change_events) <= 0 or current_event_index >= len(scene_change_events):
			#return null
		#return scene_change_events[current_event_index]

var tracked_components: Array[Node]:
	get:
		return get_children().filter(func(child): 
			return child is TrackedComponent)

#func _process(delta: float) -> void:
	#super._process(delta)
	#_check_enable()

#func _check_enable() -> void:
	#if finished_playing:
		#if tracked_components.all(func(component): return component.finished_playing):
			#print("ALL DONE")
			#disable()
		#return
	#if current_scene == SceneManager.current_scene:
		#enable()
	#else:
		#disable()
	#if current_scene_event == null:
		#return
	#if GhostManager.current_time >= current_scene_event.time:
		#global_position = current_scene_event.ghost_position
		#current_scene = current_scene_event.value
		#if current_event_index < len(scene_change_events):
			#current_event_index += 1
		#else:
			#finished_playing = true

func reload() -> void:
	current_event_index = 0
	finished_playing = false
	animated = true
	enable()
	for child in tracked_components:
		child.reload()

func disable() -> void:
	if visible:
		hide()
		for child in get_children():
			child.set_process_mode(Node.PROCESS_MODE_DISABLED)

func enable() -> void:
	if not visible:
		for child in get_children():
			child.set_process_mode(Node.PROCESS_MODE_INHERIT)
		show()
