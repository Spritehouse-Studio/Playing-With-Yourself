## A transition from or into another scene
class_name SceneTransition extends Area2D

## The UID of the scene that this door transitions to when entered
@export var target_scene_uid: String

## The name of the door that this door leads to in the next scene
@export var target_transition_name: String
	
## The direction the player should walk, jump, or fall when entering from the target door
@export_enum("left", "right", "up", "down") var enter_direction = "left"

## The door's collision shape
@onready var collision: CollisionShape2D = $collision
## The root of the level scene that contains this door
@onready var level_root: BaseLevel = get_owner()
## The target for the player to reach upon entering from this door
@onready var target: Marker2D = $target
@onready var player_offset: Marker2D = $player_offset

var player_prefab: PackedScene = preload("uid://bx46gngy5shiy")

## Walk the player from this door into the scene
func enter_from(enter_scale: float) -> void:
	#var scene_change_event := GhostManager.GhostEvent.new()
	#scene_change_event.time = GhostManager.current_time
	#scene_change_event.type = "scene_change"
	#scene_change_event.value = SceneManager.current_scene
	#scene_change_event.ghost_position = player_offset.global_position
	#GhostManager.last_ghost_events.append(scene_change_event)
	
	var player: PlayerBase = player_prefab.instantiate()
	player.global_position = player_offset.global_position
	collision.disabled = true
	level_root.add_child(player)
	
	#StateManager.force_update()
	
	player.disable_input = true
	var health: HealthManager = player.get_node("health_manager")
	if is_instance_valid(health):
		health.died.connect(level_root._on_player_death)
	level_root.camera.set_target(player)
	match enter_direction:
		"left", "right":
			var target_x = target.global_position.x
			var mover: GroundMover = player.get_node("mover")
			if is_instance_valid(mover):
				mover.move_to(target_x)
				await mover.reached_destination
		"up":
			player.transform.x.x *= enter_scale
			while not player.is_on_floor(): 
				await get_tree().process_frame
		# The enter direction for a door is the target door's direction, not its own, so a target 
		# direction of "down" would mean the player enters this door from the bottom and must jump out
		"down":
			var target_diff_x: float = abs(target.global_position.x - global_position.x)
			var target_pos := Vector2(global_position.x + target_diff_x * enter_scale, target.global_position.y)
			var jumper: Jumper = player.get_node("jumper")
			if is_instance_valid(jumper):
				jumper.jump_to(target_pos)
			while not player.is_on_floor(): 
				await get_tree().process_frame
	collision.disabled = false
	player.disable_input = false

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerBase:
		UIManager.close_all_uis()
		body.disable_input = true
		if enter_direction == "left" or enter_direction == "right":
			var direction: float = global_position.x - body.global_position.x
			var mover: GroundMover = body.get_node("mover")
			if is_instance_valid(mover):
				mover.move(direction)
		var target_scene: PackedScene = load(target_scene_uid)
		SceneManager.change_scene_transition(target_scene, target_transition_name, body.transform.x.x)
