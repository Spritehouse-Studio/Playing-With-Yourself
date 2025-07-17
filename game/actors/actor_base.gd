class_name ActorBase extends CharacterBody2D
## Base class for all characters, including the player and NPCs.

#region Child nodes
## The main physics collider of the actor's body.
@onready var body_collider: Node2D = get_node_or_null("collider")
## Controls all animations for the actor.
@onready var animator: AnimationPlayer = get_node_or_null("animator")
## The primary sprite of the actor.
@onready var main_sprite: Sprite2D = get_node_or_null("main_sprite")
#endregion

#region Getters/setters
## The direction that the actor is facing; greater than 0 is right, less than 0 is left.
var direction: float:
	get:	
		return transform.x.x

var animated: bool = true
#endregion

#region Godot's built-in methods
func _process(delta: float) -> void:
	move_and_slide()
#endregion

#region Public methods
func get_component(component_type: Variant) -> ActorComponentBase:
	for child in get_children():
		if is_instance_of(child, component_type):
			return child as ActorComponentBase
	return null

# Try to play an animation.
func try_play_animation(animation_name: StringName) -> void:
	if animated and animator.has_animation(animation_name):
		animator.play(animation_name)
#endregion
