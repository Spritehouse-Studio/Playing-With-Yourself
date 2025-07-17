class_name Parrier extends ActorComponentBase
## Component that allows the attached actor to parry incoming attacks.

#region Exported properties
## The window of time after parrying in which an attack is perfected parried.
@export var _perfect_parry_time: float = 1.0 / 8
## Path to the health manager to set invincible when parrying an attack.
@export_node_path("HealthManager") var _health_manager_node_path: NodePath
## Path to the recoiler component to push the actor away during a parry.
@export_node_path("Recoiler") var _recoiler_node_path: NodePath
#endregion

#region Available nodes on ready
@onready var _health_manager: HealthManager = get_node_or_null(_health_manager_node_path)
@onready var _recoiler: Recoiler = get_node_or_null(_recoiler_node_path)
#endregion

#region Non-public methods
## Parry an incoming attack.
func _parry(attack: AttackBase) -> void:
	if is_instance_valid(_health_manager):
		_health_manager.invincible = true
	if is_instance_valid(_recoiler):
		_recoiler.start_recoil(attack.angle, attack.force)
#endregion

#region Signal callbacks
func _on_body_entered(body: CollisionObject2D) -> void:
	if body is ParriableAttack:
		_parry(body)
#endregion
