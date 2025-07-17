class_name FreeOnAudioFinish extends Node2D
## Component that frees the attached actor when an animation is finished.

#region Exported properties
@export_node_path("AudioStreamPlayer2D") var _audio_player_node_path: NodePath
#endregion

@onready var _audio_player: AudioStreamPlayer2D = get_node_or_null(_audio_player_node_path)

#region Godot's built-in methods
func _ready() -> void:
	if is_instance_valid(_audio_player):
		_audio_player.finished.connect(_on_audio_finished)
#endregion

#region Signal callbacks
func _on_audio_finished() -> void:
	get_owner().queue_free()
#endregion
