class_name Boss extends ActorBase

@onready var attack_timer: Timer = $attack_timer
@onready var ground_marker: Marker2D = $ground_marker
@onready var hand_animator: AnimationPlayer = $hand/hand_animator

var lightning_prefab: PackedScene = preload("uid://b2buj8qsslq8w")

func summon_lightning() -> void:
	var player: PlayerBase = get_tree().get_first_node_in_group("players")
	hand_animator.play("attack")
	if is_instance_valid(player):
		var lightning: AttackBase = lightning_prefab.instantiate()
		add_child(lightning)
		lightning.global_position = Vector2(player.global_position.x, ground_marker.global_position.y)
		lightning.activate()

func _on_begin_fight_range_body_entered(body: Node2D) -> void:
	attack_timer.start()

func _on_attack_timer_timeout() -> void:
	summon_lightning()
	attack_timer.start()
