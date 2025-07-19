class_name AttackBase extends Area2D
## Base script for all weapon attacks.

#region Exported properties
## The amount of damage that the attack deals.
@export var damage: float = 5
## The angle in radians that an actor hit by this attack will recoil towards.
@export var angle: float = 0
## The amount of force that the attack applies to an actor it hits.
@export var force: float = 0
## Whether the attack should be parented to the actor when spawned.
@export var parent_to_actor: bool = false
@export var attack_audio: AudioStream
#endregion

@onready var animator: AnimationPlayer = $animator

#region Public methods
## Play the attack animation and allow it to damage other actors.
func activate() -> void:
	if is_instance_valid(animator):
		if animator.has_animation("attack"):
			animator.play("attack");
		else:
			animator.play(animator.current_animation)

func play_audio() -> void:
	if attack_audio != null:
		AudioManager.play_audio(attack_audio, global_position, 0.75, 1.25)
#endregion
	
