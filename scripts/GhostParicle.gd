extends Node2D

var timecode: int = 0

func _selected_ghost(isSelected):
	if isSelected:
		modulate = Color(1.0, 0.0, 0.0, 1.0)
		z_index = 10
	else:
		modulate = Color( 1.0, 1.0, 1.0, 1.0)
		z_index = 0

func _start_run():
	visible = false
	modulate = Color( 1.0, 1.0, 1.0, 1.0)
	$Timer.wait_time = float(timecode)/1000
	$Timer.start()

func _end_run():
	visible = true

func _on_timer_timeout():
	visible = true
