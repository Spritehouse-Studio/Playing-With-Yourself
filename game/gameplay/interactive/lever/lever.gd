class_name Lever extends Interactable

@onready var offset: Marker2D = $offset

var toggled: bool
var pulling_actor: ActorBase

func _process(delta: float) -> void:
	if is_instance_valid(pulling_actor):
		pulling_actor.global_position = offset.global_position

func interact(interacting: ActorBase) -> void:
	var grounder: Grounder = interacting.get_node("grounder")
	if is_instance_valid(grounder):
		if grounder.is_airborne:
			return
	if not toggled:
		pull(interacting)
	else:
		release(interacting)

func load_state(value: bool) -> void:
	toggled = value
	interact(null)

func pull(interacting: ActorBase) -> void:
	pulling_actor = interacting
	interacting.animated = false
	toggled = true
	animator.play("pull")
	if is_instance_valid(interacting):
		interacting.global_position = offset.global_position
		interacting.transform.x.x = offset.transform.x.x
		interacting.animator.play("lever_pull")
		if interacting is PlayerBase:
			interacting.disable_input = true
		interacting.velocity.x = 0
	await animator.animation_finished
	#if interacting is PlayerBase:
		#StateManager.save_state(get_path(), true)
	super.interact(interacting)

func release(interacting: ActorBase) -> void:
	animator.play("release")
	if is_instance_valid(interacting):
		interacting.animator.play("lever_release")
		await interacting.animator.animation_finished
		if interacting is PlayerBase:
			interacting.disable_input = false
			#StateManager.save_state(get_path(), false)
		interacting.animated = true
	toggled = false
	pulling_actor = null
	super.interact(interacting)
