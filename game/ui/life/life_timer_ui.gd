class_name LifeTimerUI extends BaseUI

@onready var life_progress_bar: ProgressBar = $margin_container/life_progress
@onready var life_time_label: Label = life_progress_bar.get_node_or_null("lifetime_label")

func _ready() -> void:
	LifeManager.life_started.connect(_on_life_started)
	LifeManager.time_changed_sec.connect(_on_time_changed)
	LifeManager.max_time_changed.connect(_on_max_time_changed)

func _process(_delta: float) -> void:
	_update_progress()

func _on_time_changed(time: int) -> void:
	_update_time_label(time)

func _on_life_started(lifetime: float) -> void:
	life_progress_bar.max_value = lifetime
	_update_progress()
	_update_time_label(lifetime)

func _update_progress() -> void:
	life_progress_bar.value = LifeManager.time_left

func _update_time_label(time: float) -> void:
	var time_sec: int = floor(time)
	var seconds: float = time_sec % 60
	var minutes: float = int(time / 60) % 60
	life_time_label.text = "%d:%02d" % [minutes, seconds]

func _on_max_time_changed(max_time: float) -> void:
	life_progress_bar.max_value = max_time
	_update_time_label(max_time)
