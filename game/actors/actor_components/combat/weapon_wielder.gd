## Component that allows the attached actor to attack with a weapon.
class_name WeaponWielder extends TrackedComponent

#region Exported properties
## The scene of the attack to spawn when attacking.
@export var attack_scene: PackedScene
## Collision layer to be applied to spawned attacks.
@export_flags_2d_physics var collision_layer: int
## Collision mask to be applied to spawned attacks.
@export_flags_2d_physics var collision_mask: int
## Changes properties of spawned attacks.
@export var weapon_modifier: WeaponModifier
#endregion

#region Public methods
func load_event(value: Variant) -> void:
	super.load_event(value)
	attack()

## Attack with the currently-wielded weapon.
func attack() -> void:
	save_event(true)
	_actor_root.animated = false
	_actor_root.animator.play("attack")
	if _actor_root is PlayerBase:
		_actor_root.disable_input = true
	var mover: GroundMover = _actor_root.get_node("mover")
	if is_instance_valid(mover):
		mover.stop.call_deferred()
	if attack_scene != null:
		var attack: AttackBase = attack_scene.instantiate()
		attack.collision_layer = collision_layer
		attack.collision_mask = collision_mask
		if attack.parent_to_actor:
			if _actor_root.direction < 0:
				attack.angle = atan2(sin(attack.angle), -cos(attack.angle))
			_actor_root.add_child(attack)
		else:
			attack.global_position = _actor_root.global_position
			#actor_owner.add_child(attack)
		attack.activate()
	await _actor_root.animator.animation_finished
	_actor_root.animated = true
	if _actor_root is PlayerBase:
		_actor_root.disable_input = false
#endregion
