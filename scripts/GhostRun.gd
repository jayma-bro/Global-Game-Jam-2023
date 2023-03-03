extends CharacterBody2D


const antdelta: int = 960

@export var speed: float = 12.5

var act_lst: Dictionary = {"down": false, "up": false, "left": false, "right": false}
var move: Vector2 = Vector2.ZERO
var t0: int = 0


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
	move.x = int(act_lst.right) - int(act_lst.left)
	move.y = int(act_lst.down) - int(act_lst.up)
	move = move.normalized()
	move *= speed
	set_velocity(move * delta * antdelta)
	set_up_direction(Vector2.UP)
	move_and_slide()

func runTime():
	for action in get_parent().props.run:
		await get_tree().create_timer(countdown(action.timecode)).timeout
		act_lst = action.act_lst
		position = Vector2(action.position[0], action.position[1])
		
func countdown(timeCode: float):
	return float((t0 + timeCode) - Time.get_ticks_msec())/1000
