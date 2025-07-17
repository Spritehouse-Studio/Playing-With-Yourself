class_name Tracker extends ActorComponentBase

@export_node_path("GroundMover") var _mover_node_path: NodePath
@export_node_path("Jumper") var _jumper_node_path: NodePath

func _ready() -> void:
	_actor_root.animator.animation_changed.connect(_on_animation_changed)

func _on_animation_changed(animation_name: String) -> void:
	pass
