extends Camera2D

const MIN_ZOOM: float = 0.8
const MAX_ZOOM: float = 2.0
const ZOOM_INCREMENT: float = 0.05
const ZOOM_RATE: float = 0.05

var _target_zoom: float = 1.0

func _physics_process(delta: float) -> void:
	zoom = lerp(
		zoom,
		_target_zoom * Vector2.ONE,
		ZOOM_RATE * delta * Settings.antdelta
	)
	set_physics_process(not is_equal_approx(zoom.x, _target_zoom))

func zoom_in() -> void:
	_target_zoom = max(_target_zoom - (ZOOM_INCREMENT * _target_zoom), MIN_ZOOM)
	set_physics_process(true)

func zoom_out() -> void:
	_target_zoom = min(_target_zoom + (ZOOM_INCREMENT * _target_zoom), MAX_ZOOM)
	set_physics_process(true)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				zoom_in()
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				zoom_out()
