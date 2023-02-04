extends KinematicBody2D

export var speed: float = 12.5

var props: Dictionary = {}
var deltaCum: float = 0

var move: Vector2 = Vector2.ZERO
var antdelta: float = 960
var act_lst: Dictionary = {"down": false, "up": false, "left": false, "right": false}
var lastAction: String = ""

signal newChild(lastPosition, name, action, timecode)

func _ready():
	if lastAction != "":
		act_lst[lastAction] == true


func _process(delta):
	if not props.run.empty():
		deltaCum += delta * 1000
		Move(delta)
		if deltaCum >= props.run[0].timecode:
			inputGive(props.run.pop_front())

func inputGive(input):
	if input.split:
		emit_signal("newChild", input.position, input.branch, input.action, input.timecode)
	else:
		act_lst[input.action] = input.action_type

func Move(delta: float):
	move.x = int(act_lst.right) - int(act_lst.left)
	move.y = int(act_lst.down) - int(act_lst.up)
	move = move.normalized()
	move *= speed
	move_and_slide(move * delta * antdelta, Vector2.UP)
