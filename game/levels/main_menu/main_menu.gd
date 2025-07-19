## The game's main menu
class_name MainMenu extends Control

## Parent container of menu buttons list
@onready var margin_container: MarginContainer = $margin_container
## The button to exit the game
@onready var exit_button: Button = margin_container.get_node("menu_buttons/exit_button")
## Warning for whether the player really wants to exit the game
@onready var exit_warning: VBoxContainer = $exit_warning
## UI for changing game settings
@onready var settings_ui: Control = $settings_ui

@onready var high_score_panel: Panel = $high_score_panel
@onready var score_entries: VBoxContainer = high_score_panel.get_node("margin_container/score_entries")
@onready var high_score_label: Label = score_entries.get_node("high_score_label")
@onready var time_label: Label = score_entries.get_node("time_label")
@onready var num_ghosts_label: Label = score_entries.get_node("num_ghosts_label")

func _init() -> void:
	SaveManager.load_game(0)

func _ready() -> void:
	SessionManager.animator.play("RESET")
	GhostManager.reset()
	AudioManager.stop_music()
	if OS.get_name() == "Web":
		exit_button.hide()

func _on_start_button_pressed() -> void:
	SessionManager.reset()

func _on_settings_button_pressed() -> void:
	margin_container.hide()
	settings_ui.show()

func _on_exit_button_pressed() -> void:
	margin_container.hide()
	exit_warning.show()

func _on_settings_ui_hidden():
	margin_container.show()

func _on_exit_warning_quit_canceled() -> void:
	exit_warning.hide()
	margin_container.show()

func _on_exit_warning_quit_confirmed() -> void:
	get_tree().quit()

func _on_high_score_button_pressed() -> void:
	high_score_panel.show()
	if SaveManager.save_data == null:
		high_score_label.text = "No high score recorded. Try finishing a game!"
		return
	high_score_label.text = "High Score: %d" % SaveManager.save_data.high_score
	var time_sec: int = floor(SaveManager.save_data.time)
	var seconds: float = time_sec % 60
	var minutes: float = int(SaveManager.save_data.time / 60) % 60
	time_label.text = "Time: %d:%02d" % [minutes, seconds]
	num_ghosts_label.text = "Ghosts: %d" % SaveManager.save_data.num_ghosts

func _on_back_button_pressed() -> void:
	high_score_panel.hide()
