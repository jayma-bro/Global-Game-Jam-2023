extends Node2D

var Ghost = preload("res://prefabs/Ghost.tscn")
var Player = preload("res://prefabs/Player.tscn")
var RunTree = preload("res://prefabs/RunTree.tscn")
var thePlayer: CharacterBody2D = null
var allGhost: Dictionary = {}
var runTree: Tree = null
signal endRun()
signal startRun()
signal selectedRun(runName: String)


func _ready():
	Settings.GameSave = Func.LoadGame()
	runTree = RunTree.instantiate()
	connect('endRun', Callable(runTree, "_end_run"))
	runTree.connect('item_selected', Callable(self, "tree_item_selected"))
	add_child(runTree)
	var run = null
	for runKey in Settings.GameSave.runs:
		new_ghost(Settings.GameSave.runs[runKey].duplicate(true))
	if Settings.GameSave.selected_run != null:
		runTree.childs[Settings.GameSave.selected_run].select(0)

func _on_start_pressed():
	thePlayer = Player.instantiate()
	if Settings.GameSave.selected_run != null:
		print(Settings.GameSave.selected_run)
		thePlayer.props = Settings.GameSave.runs[Settings.GameSave.selected_run].duplicate(true)
	thePlayer.position = Settings.origine
	Settings.t0 = Time.get_ticks_msec()
	Settings.ActualRun.id = str(int(Settings.GameSave.last_child_id) + 1)
	Settings.ActualRun.name = "run " + str(int(Settings.GameSave.last_child_id) + 1)
	add_child(thePlayer)
	emit_signal('startRun')

func _on_stop_pressed():
	thePlayer.queue_free()
	Settings.ActualRun.run.append({
		"timecode": Time.get_ticks_msec() - Settings.t0,
		"act_lst": {"down": false, "up": false, "left": false, "right": false},
		"position": [thePlayer.position.x, thePlayer.position.y],
		"path": "/".join(thePlayer.pathway)
	})
	Settings.GameSave.runs[Settings.ActualRun.id] = Settings.ActualRun.duplicate(true)
	Settings.GameSave.last_child_id = str(int(Settings.GameSave.last_child_id) + 1)
	Settings.GameSave.selected_run = Settings.GameSave.last_child_id
	new_ghost(Settings.GameSave.runs[Settings.GameSave.last_child_id].duplicate(true))
	
	emit_signal("endRun")
	runTree.childs[Settings.GameSave.last_child_id].select(0)
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

func tree_item_selected():
	Settings.GameSave.selected_run = runTree.get_selected().get_metadata(0).id
	emit_signal("selectedRun", Settings.GameSave.selected_run)

func new_ghost(run):
	allGhost[run.id] = Ghost.instantiate()
	allGhost[run.id].origine = Settings.origine
	allGhost[run.id].props = run
	connect('endRun', Callable(allGhost[run.id], "_end_run"))
	connect('startRun', Callable(allGhost[run.id], "_start_run"))
	connect('selectedRun', Callable(allGhost[run.id], "_selected_run"))
	add_child(allGhost[run.id])
	


