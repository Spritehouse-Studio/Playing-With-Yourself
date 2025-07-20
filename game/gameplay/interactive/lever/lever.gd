class_name Lever extends Interactable

@onready var offset: Marker2D = $offset

var toggle_sound: AudioStream = preload("uid://7aervxbp12sf")

var toggled: bool
var pulling_actor: ActorBase

func _process(delta: float) -> void:
	if is_instance_valid(pulling_actor):
		pulling_actor.global_position = offset.global_position

func interact(interacting: ActorBase) -> void:
	if is_instance_valid(pulling_actor) and pulling_actor != interacting:
		return
	if not interacting.is_on_floor():
		return
	if not toggled:
		pull(interacting)
	else:
		release(interacting)

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
	AudioManager.play_audio(toggle_sound, global_position, 0.75, 1.25)
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
	AudioManager.play_audio(toggle_sound, global_position, 0.75, 1.25)
	toggled = false
	pulling_actor = null
	super.interact(interacting)
