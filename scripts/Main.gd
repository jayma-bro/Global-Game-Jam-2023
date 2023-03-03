extends Node2D

var Ghost = preload("res://prefabs/new Ghost.tscn")
var GhostPath = preload("res://prefabs/GhostPath.tscn")
var Player = preload("res://prefabs/new Player.tscn")
var RunTree = preload("res://prefabs/RunTree.tscn")
var thePlayer: CharacterBody2D = null
var firstGhost: CharacterBody2D = null
const origine: Vector2 = Vector2(100, 100)
var tree: Tree = null
signal endRun()


func _ready():
	Settings.GameSave = Func.LoadGame()
	tree = RunTree.instantiate()
	connect('endRun', Callable(tree, "_end_run"))
	add_child(tree)

func _on_start_pressed():
#	if not Settings.GameSave.childs.loop0.run.is_empty():
#		firstGhost = Ghost.instantiate()
#		firstGhost.props = Settings.GameSave.childs.loop0.duplicate(true)
#		firstGhost.position = origine
#		add_child(firstGhost)
#		firstGhost.connect("newChild",Callable(self,"_newChild"))
	thePlayer = Player.instantiate()
	if not Settings.GameSave.runs.is_empty():
		thePlayer.props = Settings.GameSave.runs[Settings.GameSave.last_child_name].duplicate(true)
	thePlayer.position = origine
	Settings.t0 = Time.get_ticks_msec()
	add_child(thePlayer)
	for run in Settings.GameSave.runs:
		firstGhost = Ghost.instantiate()
		firstGhost.position = origine
		firstGhost.props = Settings.GameSave.runs[run]
		add_child(firstGhost)
	Settings.ActualRun.name = "run" + str(Settings.GameSave.last_child_id + 1)
	Settings.ActualRun.run = []

#func _newChild(lastPosition, name, action, timecode):
#	var newGhost = Ghost.instantiate()
#	newGhost.props = Settings.GameSave.childs[name].duplicate(true)
#	newGhost.position = Vector2(lastPosition[0], lastPosition[1])
#	newGhost.lastAction = action
#	newGhost.deltaCum = timecode
#	add_child(newGhost)
	
	

func _on_stop_pressed():
	thePlayer.queue_free()
	Settings.GameSave.runs[Settings.ActualRun.name] = Settings.ActualRun.duplicate(true)
	Settings.GameSave.last_child_id += 1
	Settings.GameSave.last_child_name = "run" + str(Settings.GameSave.last_child_id)
	Func.SaveGame()
	emit_signal("endRun")
	Settings.t0 = 0
#	Settings.ActualRun.fullRun.append_array(Settings.ActualRun.run)

func _on_reset_pressed():
	Settings.ActualRun = {}
	Settings.GameSave = Settings.StartSave.duplicate(true)
	Func.SaveGame()
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
#	Settings.GameSave = Settings.StartSave.duplicate(true)
#	Func.SaveGame()


func _on_Show_pressed():
	Settings.t0 = Time.get_ticks_msec()
	for run in Settings.GameSave.runs:
		firstGhost = Ghost.instantiate()
		firstGhost.position = origine
		firstGhost.props = Settings.GameSave.runs[run]
		add_child(firstGhost)






