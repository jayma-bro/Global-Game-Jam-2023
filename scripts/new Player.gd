extends CharacterBody2D


const antdelta: int = 960

@export var speed: float = 12.5

var act_lst: Dictionary = {"down": false, "up": false, "left": false, "right": false}
var props: Dictionary = Settings.BaseRun.duplicate(true)
var move: Vector2 = Vector2.ZERO
var t0: int = 0
var moving: bool = false
var pathway: PackedStringArray = []

func _ready():
	t0 = Settings.t0
	runTime()


func _process(delta: float):
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
	for action in props.run:
		await get_tree().create_timer(countdown(action.timecode)).timeout
		if moving:
			break
		pathway = action.path.split("/", false)
		act_lst = action.act_lst
		position = Vector2(action.position[0], action.position[1])
		Settings.ActualRun.run.append(action.duplicate(true))
		

func countdown(timeCode: float):
	return float((t0 + timeCode) - Time.get_ticks_msec())/1000

func _input(event: InputEvent):
	for action in ["ui_down", "ui_up", "ui_left", "ui_right"]:
		if event.is_action(action):
			if not moving:
				moving = true
				pathway.append(Settings.ActualRun.name)
				Settings.ActualRun.path = "/".join(pathway)
				act_lst = {"down": false, "up": false, "left": false, "right": false}
			if event.is_action_pressed(action):
				act_lst[action.substr(3,-1)] = true
			elif event.is_action_released(action):
				act_lst[action.substr(3,-1)] = false
			Settings.ActualRun.run.append({
				"timecode": Time.get_ticks_msec() - Settings.t0,
				"act_lst": act_lst.duplicate(true),
				"position": [position.x, position.y],
				"path": "/".join(pathway)
			})
