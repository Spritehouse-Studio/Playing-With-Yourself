extends Timer

signal life_started(lifetime: float)
signal time_changed_sec(time: int)
signal max_time_changed(max_time: int)
signal life_over

var lives_spent: int = 0

var current_sec: int
var max_time: float

func _ready() -> void:
	timeout.connect(_on_life_timer_timeout)

func _process(_delta: float) -> void:
	if current_sec - time_left >= 1:
		current_sec = ceil(time_left)
		time_changed_sec.emit(current_sec)

func start_life(lifetime: float) -> void:
	max_time = lifetime
	current_sec = ceil(lifetime)
	start(lifetime)
	life_started.emit(lifetime)

func add_time(time: float) -> void:
	var new_time: float = time_left + time
	if new_time > wait_time:
		current_sec = ceil(new_time)
		max_time = new_time
		max_time_changed.emit(max_time)
	start(new_time)

func reload() -> void:
	lives_spent += 1

func _on_life_timer_timeout() -> void:
	await get_tree().create_timer(1).timeout
	life_over.emit()
	SessionManager.reload()
