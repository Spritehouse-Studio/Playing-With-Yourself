class_name Lever extends Interactable

@onready var offset: Marker2D = $offset

var toggled: bool

func interact(interacting: ActorBase) -> void:
	var grounder: Grounder = interacting.get_node("grounder")
	if is_instance_valid(grounder):
		if grounder.is_airborne:
			return
	if not toggled:
		pull(interacting)
	else:
		release(interacting)

func pull(interacting: ActorBase) -> void:
	interacting.animated = false
	toggled = true
	animator.play("pull")
	interacting.global_position = offset.global_position
	interacting.transform.x.x = offset.transform.x.x
	interacting.animator.play("lever_pull")
	if interacting is PlayerBase:
		interacting.disable_input = true
	interacting.velocity.x = 0
	await animator.animation_finished
	super.interact(interacting)

func release(interacting: ActorBase) -> void:
	animator.play("release")
	interacting.animator.play("lever_release")
	if interacting is PlayerBase:
		await interacting.animator.animation_finished
		interacting.disable_input = false
	interacting.animated = true
	toggled = false
	super.interact(interacting)
