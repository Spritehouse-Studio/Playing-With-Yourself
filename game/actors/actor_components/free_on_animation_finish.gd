class_name FreeOnAnimationFinish extends Node2D
## Component that frees the attached actor when an animation is finished.

#region Exported properties
@export_node_path("AnimationPlayer") var _animator_node_path: NodePath
## The name of the animation to check for before the actor is freed.
@export var animation_name: String
#endregion

@onready var _animator: AnimationPlayer = get_node_or_null(_animator_node_path)

#region Godot's built-in methods
func _ready() -> void:
	if is_instance_valid(_animator):
		_animator.animation_finished.connect(_on_animation_finished)
#endregion

#region Signal callbacks
func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == animation_name:
		get_owner().queue_free()
#endregion
