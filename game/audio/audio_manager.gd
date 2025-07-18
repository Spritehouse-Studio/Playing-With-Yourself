## Manages game audio and music
extends Node

## The volume in decibels at which audio is not perceived
const AUDIO_OFF_DB: float = -60

## The prefab to instantiate when playing a one shot clip
@export var audio_player_prefab: PackedScene

## Parent of all spawned generic audio players
@onready var audio_players: Node = $audio_players
## Parent of all spawned music players
@onready var music_players: Node = $music_players
## The audio stream player of the current music track, fades out to next music player
@onready var current_music_player: AudioStreamPlayer = music_players.get_node("current_music_player")
## The audio stream player of the next music track, fades in from current music player
@onready var next_music_player: AudioStreamPlayer = music_players.get_node("next_music_player")

## The currently playing music track
var current_track: MusicTrack

## The currently running tween for adjusting volume fade between music tracks
var volume_tween: Tween
	
## Music volume combined with master volume
var music_volume: float:
	get:
		return remap(SaveManager.settings.master_volume * SaveManager.settings.music_volume, 0.0, 1.0, AUDIO_OFF_DB, 0)
	
## SFX volume combined with master volume
var sfx_volume: float:
	get:
		return remap(SaveManager.settings.master_volume * SaveManager.settings.sfx_volume, 0.0, 1.0, AUDIO_OFF_DB, 0)

func _ready() -> void:
	update_music_volume()

## Play a one shot audio clip
func play_audio(audio: AudioStream, position: Vector2, pitch_min: float = 1, pitch_max: float = 1) -> void:
	var audio_player: AudioStreamPlayer2D = audio_player_prefab.instantiate()
	audio_player.volume_db = sfx_volume
	audio_player.pitch_scale = randf_range(pitch_min, pitch_max)
	audio_player.stream = audio
	audio_player.global_position = position
	audio_players.add_child(audio_player)
	audio_player.play()

## Play a music track, fading out from the current track into the new track
func play_music(track: MusicTrack, fade_time: float = 2, immediate: bool = false) -> void:
	# Immediately play music if nothing is currently playing (or if immediate specified)
	current_track = track
	if not current_music_player.stream or immediate:
		current_music_player.set_stream(track.audio)
		current_music_player.play()
		return
	# Don't fade in and out of the same music track
	elif current_music_player.stream and track.audio.resource_path == current_music_player.stream.resource_path:
		return
	next_music_player.set_stream(track.audio)
	if volume_tween and volume_tween.is_running():
		volume_tween.kill()
	volume_tween = create_tween()
	volume_tween.finished.connect(on_volume_tween_finished)
	next_music_player.play(current_music_player.get_playback_position())
	volume_tween.tween_property(current_music_player, "volume_db", AUDIO_OFF_DB, fade_time) \
		.from(music_volume) \
		.set_trans(Tween.TRANS_EXPO) \
		.set_ease(Tween.EASE_IN)
	volume_tween.parallel().tween_property(next_music_player, "volume_db", music_volume, fade_time) \
		.from(AUDIO_OFF_DB) \
		.set_trans(Tween.TRANS_EXPO) \
		.set_ease(Tween.EASE_OUT)

## Stop the currently playing music
func stop_music() -> void:
	current_music_player.stop()
	current_music_player.stream = null
	next_music_player.stop()
	next_music_player.stream = null
	current_track = null

## Update the current music volume
func update_music_volume() -> void:
	current_music_player.volume_db = music_volume

func _on_current_music_player_finished() -> void:
	current_music_player.play()

func _on_next_music_player_finished() -> void:
	next_music_player.play()

## Callback for when the volume tween finishes
func on_volume_tween_finished() -> void:
	current_music_player.set_stream(current_track.audio)
	current_music_player.play(next_music_player.get_playback_position())
	current_music_player.set_volume_db(music_volume)
	next_music_player.stop()
