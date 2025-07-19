extends Node

class NodeState:
	var time: float
	var value: Variant

class NodeStates:
	var state_timeline: Array[NodeState]
	var current_state_index: int

class LevelState:
	var node_states: Dictionary[String, NodeStates]

var level_states: Array[LevelState]

var current_run: int

var current_time: float

var active_level_state := LevelState.new()

func _process(delta: float) -> void:
	current_time += delta
	check_update()

func check_update() -> void:
	for level_state_index in range(0, len(level_states)):
		var level_state: LevelState = level_states[level_state_index]
		for node_path in level_state.node_states:
			var node_states: NodeStates = level_state.node_states[node_path]
			if node_states.current_state_index >= len(node_states.state_timeline):
				continue
			var current_node_state: NodeState = node_states.state_timeline[node_states.current_state_index]
			var next_state_index: int = node_states.current_state_index + 1
			if current_time >= current_node_state.time and \
				(next_state_index >= len(node_states.state_timeline) - 1 or \
				current_time < node_states.state_timeline[next_state_index].time):
				load_event(node_path, level_state_index)
				level_states[level_state_index].node_states[node_path].current_state_index += 1

func force_update() -> void:
	for level_state_index in range(0, len(level_states)):
		var level_state: LevelState = level_states[level_state_index]
		for node_path in level_state.node_states:
			var node_states: NodeStates = level_state.node_states[node_path]
			var last_index: int = node_states.current_state_index - 1
			if last_index >= len(node_states.state_timeline):
				continue
			var last_node_state: NodeState = node_states.state_timeline[last_index]
			var node: Node = get_tree().root.get_node_or_null(node_path)
			if is_instance_valid(node):
				print("LOAD ", node_path, ":\t\t", last_node_state.value)
				node.load_state(last_node_state.value)

func reload() -> void:
	current_time = 0
	for node_path in active_level_state.node_states:
		active_level_state.node_states[node_path].current_state_index = 0
	level_states.append(active_level_state)
	active_level_state = LevelState.new()

func reset_runs() -> void:
	current_run = 0
	current_time = 0
	level_states.clear()

func next_run() -> void:
	current_run += 1

func save_state(node_path: String, value: Variant) -> void:
	if not active_level_state.node_states.has(node_path):
		var new_node_states := NodeStates.new()
		active_level_state.node_states[node_path] = new_node_states
	var node_states: NodeStates = active_level_state.node_states[node_path]
	var node_state := NodeState.new()
	node_state.time = current_time
	node_state.value = value
	active_level_state.node_states[node_path].state_timeline.append(node_state)
	active_level_state.node_states[node_path].current_state_index += 1

func load_event(node_path: String, level_state_index: int) -> void:
	var node: Node = get_tree().root.get_node_or_null(node_path)
	if is_instance_valid(node):
		var node_states: NodeStates = level_states[level_state_index].node_states[node_path]
		node.load_state(node_states.state_timeline[node_states.current_state_index].value)
