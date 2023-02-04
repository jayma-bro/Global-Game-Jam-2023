extends Node2D

var Ghost = preload("res://prefabs/Ghost.tscn")
var GhostPath = preload("res://prefabs/GhostPath.tscn")
var Player = preload("res://prefabs/Player.tscn")
var thePlayer: KinematicBody2D = null
var firstGhost: KinematicBody2D = null
var last_child: String = ""

func _ready():
	Settings.GameSave = Func.LoadGame()
	thePlayer = Player.instance()
	thePlayer.props = Settings.GameSave.childs[Settings.GameSave.last_child_name].duplicate(true)
	thePlayer.position = Vector2(100, 100)
	last_child = Settings.GameSave.last_child_name
	add_child(thePlayer)

func _on_start_pressed():
	if not Settings.GameSave.childs.loop0.run.empty():
		firstGhost = Ghost.instance()
		firstGhost.props = Settings.GameSave.childs.loop0.duplicate(true)
		firstGhost.position = Vector2(100, 100)
		add_child(firstGhost)
		firstGhost.connect("newChild", self, "_newChild")
	Settings.t0 = Time.get_ticks_msec()
	thePlayer.start = true

func _newChild(lastPosition, name, action, timecode):
	var newGhost = Ghost.instance()
	newGhost.props = Settings.GameSave.childs[name].duplicate(true)
	newGhost.position = Vector2(lastPosition[0], lastPosition[1])
	newGhost.lastAction = action
	newGhost.deltaCum = timecode
	add_child(newGhost)
	
	

func _on_stop_pressed():
	Settings.ActualRun.fullRun.append_array(Settings.ActualRun.run)
	Settings.GameSave.childs[Settings.ActualRun.name] = Settings.ActualRun.duplicate(true)
	Func.SaveGame()


func _on_reset_pressed():
	Settings.GameSave = Settings.StartSave.duplicate(true)
	Func.SaveGame()
