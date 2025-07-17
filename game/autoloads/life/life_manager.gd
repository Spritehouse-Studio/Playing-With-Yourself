extends Timer

signal life_started(lifetime: float)
signal time_changed_sec(time: int)
signal max_time_changed(max_time: int)
signal life_over

var lives_spent: int = 0

var current_sec: int

func _ready() -> void:
	timeout.connect(_on_life_timer_timeout)

func reset() -> void:
	GhostManager.tracking = false
	SessionManager.reload()

func _process(_delta: float) -> void:
	if current_sec - time_left >= 1:
		current_sec = ceil(time_left)
		time_changed_sec.emit(current_sec)

func start_life(lifetime: float) -> void:
	current_sec = ceil(lifetime)
	start(lifetime)
	life_started.emit(lifetime)

func add_time(time: float) -> void:
	var new_time: float = time_left + time
	if new_time > wait_time:
		current_sec = ceil(new_time)
		max_time_changed.emit(current_sec)
	start(new_time)

func _on_life_timer_timeout() -> void:
	reset()
	life_over.emit()
	lives_spent += 1
