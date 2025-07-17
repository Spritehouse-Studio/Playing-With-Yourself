class_name Flasher extends ActorComponentBase
## Component that controls color flashing of an attached actor.

#region Public variables
## Whether the object is flashing
var is_flashing: bool
#endregion

#region Non-public variables
## The duration that the flash will increase to the starting flash color and amount
var _ramp_up_time: float
## The duration that the maximum flash amount should hold for before ramping down.
var _flash_on_time: float
## The duration that the flash will fade out to transparent
var _ramp_down_time: float
## The highest flash amount value to ramp up to or ramp down from 
var _peak_flash_amount: float
## The current time ramping up to the flash color
var _current_ramp_up_time: float
## The current time that the maximum flash amount has been held for.
var _current_flash_on_time: float
## The current time ramping down to transparent
var _current_ramp_down_time: float
#endregion

#region Getters/setters
## The material of the actor
var _actor_material: ShaderMaterial:
	get:
		return _actor_root.material
#endregion

#region Godot's built-in methods
func _process(delta: float) -> void:
	if _current_ramp_up_time < _ramp_up_time:
		var flash_amount: float = remap(_current_ramp_up_time / _ramp_up_time, 0.0, 1.0, 0.0, _peak_flash_amount)
		_actor_material.set_shader_parameter("intensity", flash_amount)
		_current_ramp_up_time += delta
	elif _current_flash_on_time < _flash_on_time:
		_actor_material.set_shader_parameter("intensity", _peak_flash_amount)
		_current_flash_on_time += delta
	elif _current_ramp_down_time < _ramp_down_time:
		var flash_amount: float = remap(_current_ramp_down_time / _ramp_down_time, 1.0, 0.0, 0.0, _peak_flash_amount)
		_actor_material.set_shader_parameter("intensity", flash_amount)
		_current_ramp_down_time += delta
	elif is_flashing:
		stop()
#endregion

#region Public methods
## Flash a color for a duration of time
func flash(color := Color.WHITE, new_peak_flash_amount: float = 1.0, new_ramp_up_time: float = 0.0, new_flash_on_time: float = 0.0, new_ramp_down_time: float = 0.25) -> void:
	stop()
	_actor_material.set_shader_parameter("color_a", color)
	_peak_flash_amount = new_peak_flash_amount
	_ramp_up_time = new_ramp_up_time
	if _ramp_up_time <= 0:
		_actor_material.set_shader_parameter("intensity", _peak_flash_amount)
	_flash_on_time = new_flash_on_time
	_ramp_down_time = new_ramp_down_time
	if _ramp_down_time <= 0:
		stop()
		return
	_current_ramp_up_time = 0.0
	_current_flash_on_time = 0.0
	_current_ramp_down_time = 0.0
	is_flashing = true

## Restore object's color to its original state
func stop() -> void:
	_actor_material.set_shader_parameter("intensity", 0.0)
	is_flashing = false
#endregion
