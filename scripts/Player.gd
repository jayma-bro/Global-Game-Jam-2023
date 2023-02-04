extends KinematicBody2D


export var speed: float = 12.5

var move: Vector2 = Vector2.ZERO
var antdelta: float = 960

func _process(delta):
	move(delta)

func move(delta):
	move.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	move.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	move *= speed
	move_and_slide(move * delta * antdelta, Vector2.UP)
