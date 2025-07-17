class_name HealthManager extends TrackedComponent
## Allows the attached actor to take and recover from damage caused by weapons.

#region Exported properties
## The maximum health value that this actor may have.
@export var max_health: float = 10
## The object that is spawned when the actor dies.
@export var corpse_scene: PackedScene
## Path to node that will make the actor flash on hit.
@export_node_path("Flasher") var _flasher_node_path: NodePath
## The color to flash the actor when it is hit,
@export_color_no_alpha var hit_flash_color := Color.RED
## Path to node that will handle recoiling on hit.
@export_node_path("Recoiler") var _recoiler_node_path: NodePath
#endregion

#region Available nodes on ready
@onready var _hurt_box: CollisionShape2D = get_node_or_null("hurt_box")
@onready var _flasher: Flasher = get_node_or_null(_flasher_node_path)
@onready var _recoiler: Recoiler = get_node_or_null(_recoiler_node_path)
#endregion

#region Signals
## Emitted when the actor takes damage from an attack.
signal took_damage(damage_amount: float)
## Emitted when the actor dies.
signal died
## Emitted when the actor heals damage.
signal healed(heal_amount: float)
#endregion

#region Public variables
## The actor's current health points value.
var current_health: float
#endregion

#region Non_-public variables
## The last attack that the actor was hit by.
var _last_attack: AttackBase
#endregion

#region Getters/setters
## Whether the actor should be immune to incoming damage.
var invincible: bool:
	set(value):
		_hurt_box.set_disabled(value)
#endregion

func _ready() -> void:
	current_health = max_health
	super._ready()

#region Public methods
## Cause damage to the actor.
func take_damage(attack: AttackBase) -> void:
	_last_attack = attack
	if invincible:
		return
	var damage: float = attack.damage
	current_health = max(current_health - damage, 0)
	if is_instance_valid(_flasher):
		_flasher.flash(hit_flash_color, 0.5, 0, 0.25, 0.25)
	if is_instance_valid(_recoiler):
		_recoiler.start_recoil(attack.angle, attack.force)
	took_damage.emit(damage)
	if current_health <= 0:
		_die()

## Add health to the actor.
func add_health(heal_amount: float) -> void:
	current_health = min(current_health + heal_amount, max_health)
#endregion

func load_event(value: Variant) -> void:
	_die()

#region Non-public methods
func _die() -> void:
	save_event(true)
	died.emit()
	if corpse_scene != null:
		var corpse: Node2D = corpse_scene.instantiate()
		corpse.global_position = _actor_root.global_position
		actor_owner.add_child(corpse)
	_actor_root.queue_free()
#endregion

#region Signal callbacks
func _on_area_entered(area: CollisionObject2D) -> void:
	# Prevent the same attack from hitting again
	if area is AttackBase and area != _last_attack:
		take_damage(area)
#endregion
