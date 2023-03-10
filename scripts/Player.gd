extends CharacterBody2D

var act_lst: Dictionary = {"down": false, "up": false, "left": false, "right": false}
var props: Dictionary = Settings.BaseRun.duplicate(true)
var move: Vector2 = Vector2.ZERO
var _target_move: Vector2 = Vector2.ZERO
var t0: int = 0
var moving: bool = false
var pathway: PackedStringArray = []

const MOVE_RATE: float = 0.05

func _ready():
	t0 = Settings.t0
	Settings.ActualRun.run = []
	Settings.ActualRun.run_path = []
	$ParticleTimer.wait_time = Settings.particlesTimeStep
	runTime()


func _process(delta: float):
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
	for action in props.run:
		await get_tree().create_timer(countdown(action.timecode)).timeout
		if moving:
			break
		pathway = action.path.split("/", false)
		act_lst = action.act_lst
		position = Vector2(action.position[0], action.position[1])
		Settings.ActualRun.run.append(action.duplicate(true))

func runPath():
	for run in props.run_path:
		if run.timecode <= Time.get_ticks_msec() - t0:
			Settings.ActualRun.run_path.append(run)
	await get_tree().create_timer(((int((float(Time.get_ticks_msec())/1000) / Settings.particlesTimeStep) + 1)
	* Settings.particlesTimeStep) - float(Time.get_ticks_msec())/1000).timeout
	$ParticleTimer.start()

func countdown(timeCode: float):
	return float((t0 + timeCode) - Time.get_ticks_msec())/1000

func _unhandled_input(event: InputEvent):
	for action in ["ui_down", "ui_up", "ui_left", "ui_right"]:
		if event.is_action(action):
			if not moving:
				moving = true
				runPath()
				pathway.append(Settings.ActualRun.id)
				Settings.ActualRun.path = "/".join(pathway)
				act_lst = {"down": false, "up": false, "left": false, "right": false}
			if event.is_action_pressed(action):
				act_lst[action.substr(3,-1)] = true
				Settings.ActualRun.run.append({
					"timecode": Time.get_ticks_msec() - t0,
					"act_lst": act_lst.duplicate(true),
					"position": [position.x, position.y],
					"move": [move.x, move.y],
					"path": "/".join(pathway)
				})
			elif event.is_action_released(action):
				act_lst[action.substr(3,-1)] = false
				Settings.ActualRun.run.append({
					"timecode": Time.get_ticks_msec() - t0,
					"act_lst": act_lst.duplicate(true),
					"position": [position.x, position.y],
					"move": [move.x, move.y],
					"path": "/".join(pathway)
				})



func _on_particle_timer_timeout():
	if props.run_path[-1].position[0] != position.x or props.run_path[-1].position[1] != position.y:
		Settings.ActualRun.run_path.append({'timecode': Time.get_ticks_msec() - t0, "position": [position.x, position.y]})
