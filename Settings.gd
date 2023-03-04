extends Node

var t0: int = 0

const origine: Vector2 = Vector2(100, 100)
const particlesTimeStep: float = 0.05

var BaseRun: Dictionary = {
	"run": [],
	"run_path": [{
		'timecode': 1,
		'position': [origine.x, origine.y]
	}],
	"name": "run0",
	"path": "run0"
}

var StartSave: Dictionary = {
	"runs": {},
	"last_child_id": 0,
	"last_child_name": "run0",
	"selected_run": null
}

var GameSave: Dictionary = {}

var ActualRun: Dictionary = {}
