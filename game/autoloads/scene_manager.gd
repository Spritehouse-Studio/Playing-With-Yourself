## Manages loading and unloading of scenes
extends Node

## All loaded scenes, including ones not currently attached to the scene tree
var loaded_scenes: Array[BaseLevel]

var current_scene: String:
	get:
		return get_tree().current_scene.name

## Generic scene change function
func change_scene(scene: PackedScene) -> void:
	var fader: Fader = UIManager.open_ui(Fader)
	await fader.faded_in
	get_tree().change_scene_to_packed(scene)
	fader.close()
	await fader.faded_out

## Change to a new scene from one door to another
func change_scene_transition(scene: PackedScene, transition_name: String, enter_scale: float) -> void:
	var fader: BaseUI = UIManager.open_ui(Fader)
	await fader.faded_in
	get_tree().change_scene_to_packed(scene)
	await get_tree().process_frame
	var transitions = get_tree().get_nodes_in_group("transitions").filter(func(transition): 
		return transition.name == transition_name)
	if len(transitions) > 0 and transitions[0] is SceneTransition:
		transitions[0].enter_from(enter_scale)
	fader.close()
	await fader.faded_out
