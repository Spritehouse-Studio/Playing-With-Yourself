class_name Interactable extends Area2D

@onready var animator: AnimationPlayer = $animator

signal interacted(interactor: ActorBase)

func interact(interactor: ActorBase) -> void:
	interacted.emit(interactor)
