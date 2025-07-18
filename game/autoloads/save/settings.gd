class_name Settings extends Resource
## Represents a settings file on the user's disk.

#region Exported propeties
## Input actions mapped to their key/mouse and joypad events.
@export var input_events: Dictionary = {}
## The overall master volume.
@export var master_volume: float = 1
## Volume of music in-game.
@export var music_volume: float = 0
## Volume of sound effects in-game.
@export var sfx_volume: float = 1
## The amount of screen shake.
@export var screen_shake_intensity: float = 1
#endregion
