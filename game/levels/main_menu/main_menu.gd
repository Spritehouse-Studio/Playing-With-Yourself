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

func _init() -> void:
	SaveManager.load_game(0)

func _ready() -> void:
	SessionManager.animator.play("RESET")
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
