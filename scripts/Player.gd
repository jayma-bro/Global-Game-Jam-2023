extends CharacterBody2D


@export var speed: float = 12.5

var props: Dictionary = {}
var move: Vector2 = Vector2.ZERO
var antdelta: float = 960
var act_lst: Dictionary = {"down": false, "up": false, "left": false, "right": false}
var start: bool = false
var follow: bool = true
var deltaCum: float = 0

func _ready():
	if props.fullRun.is_empty() and props.name == "loop0":
		Settings.ActualRun = {"run": [], "fullRun": [], "childs": {}, "name": "loop0"}
	else:
		Settings.GameSave.last_child_id += 1
		Settings.GameSave.last_child_name = "loop" + String(Settings.GameSave.last_child_id)
		Settings.ActualRun = {"run": [], "fullRun": [], "childs": {}, "name": Settings.GameSave.last_child_name}

func _process(delta: float):
	if start:
		if (not props.fullRun.is_empty()) and follow:
			deltaCum += delta * 1000
			if deltaCum >= props.fullRun[0].timecode:
				inputGive(props.fullRun.pop_front())
		Move(delta)

func inputGive(input):
	act_lst[input.action] = input.action_type

func Move(delta: float):
	move.x = int(act_lst.right) - int(act_lst.left)
	move.y = int(act_lst.down) - int(act_lst.up)
	move = move.normalized()
	move *= speed
	set_velocity(move * delta * antdelta)
	set_up_direction(Vector2.UP)
	move_and_slide()

func _input(event: InputEvent):
	if Settings.t0 > 0: # est-ce que le timer à commencer ?
		if follow:
			for action in ["ui_down", "ui_up", "ui_left", "ui_right"]:
				if event.is_action_pressed(action):
					var timecode = Time.get_ticks_msec() - Settings.t0
					var insert = false
					for run_action in range(Settings.GameSave.childs[props.name].run.size()):
						if Settings.GameSave.childs[props.name].run[run_action].timecode > timecode:
							Settings.GameSave.childs[props.name].run.insert(run_action, {"timecode": timecode, "action": action.substr(3,-1),"action_type": true, "position": [position.x, position.y], "split": true, "branch": Settings.ActualRun.name})
							Settings.ActualRun.fullRun.append_array(Settings.GameSave.childs[props.name].run.slice(0, run_action, 1, true))
							insert = true
							break
					if not insert:
						Settings.GameSave.childs[props.name].run.append({"timecode": timecode, "action": action.substr(3,-1),"action_type": true, "position": [position.x, position.y], "split": true, "branch": Settings.ActualRun.name})
					act_lst = {"down": false, "up": false, "left": false, "right": false}
					act_lst[action.substr(3,-1)] = true
					follow = false
		else:
			for action in ["ui_down", "ui_up", "ui_left", "ui_right"]:
				if event.is_action_pressed(action):
					Settings.ActualRun.run.append({"timecode": Time.get_ticks_msec() - Settings.t0, "action": action.substr(3,-1),"action_type": true, "position": [position.x, position.y], "split": false})
					act_lst[action.substr(3,-1)] = true
				if event.is_action_released(action):
					Settings.ActualRun.run.append({"timecode": Time.get_ticks_msec() - Settings.t0, "action": action.substr(3,-1),"action_type": false, "position": [position.x, position.y], "split": false})
					act_lst[action.substr(3,-1)] = false
