extends Node2D

var GhostParticle = preload("res://prefabs/GhostParicle.tscn")

var props: Dictionary = {}
var origine: Vector2 = Vector2.ZERO
var particles: Array = []
var selection: bool = false
signal selectedGhost(isSelected)

func _ready():
	for run in props.run_path:
		particles.append(GhostParticle.instantiate())
		particles[-1].position.x = run.position[0]
		particles[-1].position.y = run.position[1]
		particles[-1].timecode = run.timecode
		connect('selectedGhost', Callable(particles[-1], "_selected_ghost"))
		find_parent('Main').connect('startRun', Callable(particles[-1], "_start_run"))
		find_parent('Main').connect('endRun', Callable(particles[-1], "_end_run"))
		add_child(particles[-1])


func _end_run():
	$GhostRun.visible = false
	
func _start_run():
	$GhostRun.start_run()

func _selected_run(runName):
	if runName == props.id:
		selected()
		selection = true
	elif selection:
		deselected()
		selection = false
	
func selected():
	emit_signal("selectedGhost", true)
func deselected():
	emit_signal("selectedGhost", false)
