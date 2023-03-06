extends CharacterBody2D

var act_lst: Dictionary = {"down": false, "up": false, "left": false, "right": false}
var move: Vector2 = Vector2.ZERO
var _target_move: Vector2 = Vector2.ZERO
var t0: int = 0
const MOVE_RATE: float = 0.05


func _ready():
	visible = false

func start_run():
	visible = true
	position = get_parent().origine
	t0 = Settings.t0
	runTime()

func _physics_process(delta: float):
	Move(delta)

func Move(delta: float):
	_target_move.x = int(act_lst.right) - int(act_lst.left)
	_target_move.y = int(act_lst.down) - int(act_lst.up)
	_target_move = _target_move.normalized()
	move = lerp(
		move,
		_target_move * Settings.speed,
		MOVE_RATE * delta * Settings.antdelta
	)
	set_velocity(move * delta * Settings.antdelta)
	set_up_direction(Vector2.UP)
	move_and_slide()

func runTime():
	for action in get_parent().props.run:
		await get_tree().create_timer(countdown(action.timecode)).timeout
		act_lst = action.act_lst
		position = Vector2(action.position[0], action.position[1])
		
func countdown(timeCode: float):
	return float((t0 + timeCode) - Time.get_ticks_msec())/1000
