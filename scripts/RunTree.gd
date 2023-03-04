extends Tree
var childs: Dictionary = {}

func _ready():
	load_tree()


func _end_run():
	clear()
	childs = {}
	load_tree()

func load_tree():
	var run = null
	var path: Array = []
	for runKey in Settings.GameSave.runs:
		run = Settings.GameSave.runs[runKey].duplicate(true)
		path = run.path.split('/', false)
		if len(path) <= 1 :
			childs[run.id] = create_item()
		else:
			childs[run.id] = create_item(childs[path[-2]])
		childs[run.id].set_text(0, run.name)
		childs[run.id].set_metadata(0, {"id": run.id, "name": run.name})
	
