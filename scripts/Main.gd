extends Node2D

var Ghost = preload("res://prefabs/Ghost.tscn")
var Player = preload("res://prefabs/Player.tscn")
var RunTree = preload("res://prefabs/RunTree.tscn")
var thePlayer: CharacterBody2D = null
var allGhost: Dictionary = {}
var runTree: Tree = null
const origine: Vector2 = Vector2(100, 100)
signal endRun()
signal startRun()


func _ready():
	Settings.GameSave = Func.LoadGame()
	runTree = RunTree.instantiate()
	connect('endRun', Callable(runTree, "_end_run"))
	runTree.connect('item_activated', Callable(self, "tree_item_activated"))
	runTree.connect('item_selected', Callable(self, "tree_item_selected"))
	add_child(runTree)
	var run = null
	for runKey in Settings.GameSave.runs:
		run = Settings.GameSave.runs[runKey].duplicate(true)
		allGhost[run.name] = Ghost.instantiate()
		allGhost[run.name].origine = origine
		allGhost[run.name].props = run
		connect('endRun', Callable(allGhost[run.name], "_end_run"))
		connect('startRun', Callable(allGhost[run.name], "_start_run"))
		add_child(allGhost[run.name])

func _on_start_pressed():
	thePlayer = Player.instantiate()
	if not Settings.GameSave.selected_run == null:
		thePlayer.props = Settings.GameSave.runs[Settings.GameSave.selected_run].duplicate(true)
	thePlayer.position = origine
	Settings.t0 = Time.get_ticks_msec()
	add_child(thePlayer)
	emit_signal('startRun')
	Settings.ActualRun.name = "run" + str(Settings.GameSave.last_child_id + 1)
	Settings.ActualRun.run = []

func _on_stop_pressed():
	thePlayer.queue_free()
	Settings.ActualRun.run.append({
		"timecode": Time.get_ticks_msec() - Settings.t0,
		"act_lst": {"down": false, "up": false, "left": false, "right": false},
		"position": [thePlayer.position.x, thePlayer.position.y],
		"path": "/".join(thePlayer.pathway)
	})
	Settings.GameSave.runs[Settings.ActualRun.name] = Settings.ActualRun.duplicate(true)
	Settings.GameSave.last_child_id += 1
	Settings.GameSave.last_child_name = "run" + str(Settings.GameSave.last_child_id)
	Settings.GameSave.selected_run = Settings.GameSave.last_child_name
	allGhost[Settings.GameSave.last_child_name] = Ghost.instantiate()
	allGhost[Settings.GameSave.last_child_name].origine = origine
	allGhost[Settings.GameSave.last_child_name].props = Settings.GameSave.runs[Settings.GameSave.last_child_name].duplicate(true)
	connect('endRun', Callable(allGhost[Settings.GameSave.last_child_name], "_end_run"))
	connect('startRun', Callable(allGhost[Settings.GameSave.last_child_name], "_start_run"))
	add_child(allGhost[Settings.GameSave.last_child_name])
	
	emit_signal("endRun")
	runTree.childs[Settings.GameSave.last_child_name].select(0)
	Func.SaveGame()
	Settings.t0 = 0

func _on_reset_pressed():
	Settings.ActualRun = {}
	Settings.GameSave = Settings.StartSave.duplicate(true)
	Func.SaveGame()
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_Show_pressed():
	Settings.t0 = Time.get_ticks_msec()
	emit_signal('startRun')

func tree_item_activated():
	print(runTree.get_selected())

func tree_item_selected():
	print('litem' + str(runTree.get_selected()))


