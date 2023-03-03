extends Node2D

var props: Dictionary = {}
var origine: Vector2 = Vector2.ZERO


func _end_run():
	$GhostRun.visible = false
	
func _start_run():
	$GhostRun.start_run()
