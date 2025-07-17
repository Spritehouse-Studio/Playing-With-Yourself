# meta-name: Brawler script template
# meta-description: Basic script template for the Brawler game
# meta-default: true
class_name _CLASS_ extends _BASE_

#region Constants
const MY_CONST: float = 1
#endregion

#region Exported properties
@export var exported_var: bool = true
#endregion

#region Available nodes on ready
@onready var my_node: Node = get_node_or_null("my_node_path")
#endregion

#region Signals
signal my_signal(param1: int)
#endregion

#region Public variables
var my_public_var: float
#endregion

#region Non-public variables
var _my_private_var: float
#endregion

#region Getters/setters
var get_set_value: bool:
	get:
		print("Get")
		return true
	set(value):
		print("Set: ", value)
#endregion

#region Godot's built-in methods
func _ready() -> void:
	super._ready()
#endregion

#region Public methods
func my_public_method(param1: float, param2: bool = true) -> void:
	pass
#endregion

#region Non-public methods
func _my_private_method(param1: float, param2: bool = true) -> void:
	pass
#endregion

#region Signal callbacks
func _on_node_signal(_signal_param: Vector2) -> void:
	pass
#endregion
