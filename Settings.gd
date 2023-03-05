extends Node

var t0: int = 0

const origine: Vector2 = Vector2.ZERO
const particlesTimeStep: float = 0.05

var BaseRun: Dictionary = {
	"id": "0",
	"run": [],
	"run_path": [{
		'timecode': 1,
		'position': [origine.x, origine.y]
	}],
	"name": "run 0",
	"path": "run 0"
}

var StartSave: Dictionary = {
	"runs": {},
	"last_child_id": "0",
	"selected_run": null
}

var GameSave: Dictionary = {}

var ActualRun: Dictionary = {}
