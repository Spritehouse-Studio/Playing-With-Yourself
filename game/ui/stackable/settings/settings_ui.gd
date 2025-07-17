## UI for modifying game settings
class_name SettingsUI extends StackableUI

## Child panel for adjust accessibility settings
@onready var accessibility_settings_panel: Control = $accessibility_settings_panel
## Child panel for adjust audio values
@onready var audio_settings_panel: Control = $audio_settings_panel
## Child panel for modifying input bindings
@onready var input_bindings_panel: Control = $input_bindings_panel
## Parent container of menu buttons list
@onready var margin_container: MarginContainer = $margin_container
@onready var menu_buttons: VBoxContainer = margin_container.get_node("menu_buttons")

func _on_back_button_pressed() -> void:
	hide()

func _on_accessibility_settings_button_pressed() -> void:
	stack(accessibility_settings_panel)

func _on_audio_settings_button_pressed() -> void:
	stack(audio_settings_panel)

func _on_input_bindings_button_pressed() -> void:
	stack(input_bindings_panel)

func _on_uis_emptied():
	hide()
