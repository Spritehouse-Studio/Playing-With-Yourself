class_name Interactor extends TrackedComponent

@onready var interact_area: Area2D = $interact_area

var interactable: Interactable

var can_interact: bool:
	get:
		return is_instance_valid(interactable)

func _process(delta: float) -> void:
	_update_interactable()
	super._process(delta)

func load_event(value: Variant) -> void:
	try_interact()

func try_interact() -> void:
	if can_interact:
		save_event(true)
		interactable.interact(_actor_root)

func _update_interactable() -> void:
	for area in interact_area.get_overlapping_areas():
		if area is Interactable:
			interactable = area
			return
	interactable = null
